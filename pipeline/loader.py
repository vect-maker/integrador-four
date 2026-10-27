"""
MoviGo High-Throughput Database Loader
=========================================================
Carga por lotes (batch loading) de archivos Parquet hacia
la base de datos PostgreSQL (Azure) respetando el esquema
relacional en 3NF y restricciones de llaves foráneas.
"""

import argparse
import math
import os
import sys
import time
from datetime import timedelta
from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
import psycopg
import pyarrow.parquet as pq
from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine, text

sys.stdout.reconfigure(line_buffering=True)
load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_BATCH_SIZE = 25000

PGHOST = os.getenv("PGHOST")
PGPORT = os.getenv("PGPORT", "5432")
PGUSER = os.getenv("PGUSER")
PGPASSWORD = os.getenv("PGPASSWORD")
PGSSLMODE = os.getenv("PGSSLMODE", "require")

# Target database and schema to apply migrations and load raw data
ADMIN_DB = os.getenv("PGADMIN_DATABASE", "postgres")
TARGET_DB = os.getenv("RAW_DB_NAME", os.getenv("PGDATABASE", "postgres"))
TARGET_SCHEMA = os.getenv("RAW_SCHEMA", "raw")
RAW_DATA_DIR = Path(os.getenv("RAW_DATA_DIR", BASE_DIR / "data" / "raw"))

TABLES_TO_LOAD = [
    ("urban_zones.parquet", "urban_zones"),
    ("quadrants.parquet", "quadrants"),
    ("users.parquet", "users"),
    ("drivers.parquet", "drivers"),
    ("vehicles.parquet", "vehicles"),
    ("incentive_campaigns.parquet", "incentive_campaigns"),
    ("quadrant_weather.parquet", "quadrant_weather"),
    ("trips.parquet", "trips"),
    ("trip_payments.parquet", "trip_payments"),
    ("trip_ratings.parquet", "trip_ratings"),
    ("trip_cancellations.parquet", "trip_cancellations"),
    ("driver_telemetry.parquet", "driver_telemetry"),
    ("vehicle_maintenance.parquet", "vehicle_maintenance"),
]


def get_database_url(dbname: str) -> str:
    """Build a PostgreSQL connection URL for SQLAlchemy using psycopg 3."""
    user = quote_plus(PGUSER or "")
    password = quote_plus(PGPASSWORD or "")
    return (
        f"postgresql+psycopg://{user}:{password}@{PGHOST}:{PGPORT}/{dbname}"
        f"?sslmode={PGSSLMODE}"
    )


def get_psycopg_connection(dbname: str) -> psycopg.Connection:
    """Create a direct psycopg 3 connection for high-throughput batch operations."""
    return psycopg.connect(
        host=PGHOST,
        port=PGPORT,
        user=PGUSER,
        password=PGPASSWORD,
        dbname=dbname,
        sslmode=PGSSLMODE,
        autocommit=False,
    )


def get_engine(dbname: str) -> Engine:
    """Create a SQLAlchemy Engine for the specified database."""
    return create_engine(get_database_url(dbname))


def reset_schema(
    target_db: str = TARGET_DB, target_schema: str = TARGET_SCHEMA
) -> None:
    """Drop target schema if it exists and create a clean one."""
    print(
        f"Connecting to database '{target_db}' on {PGHOST} to reset schema '{target_schema}'..."
    )
    with get_psycopg_connection(target_db) as conn:
        conn.autocommit = True
        with conn.cursor() as cur:
            print(f"Resetting schema '{target_schema}' (DROP CASCADE + CREATE)...")
            cur.execute(f'DROP SCHEMA IF EXISTS "{target_schema}" CASCADE;')
            cur.execute(f'CREATE SCHEMA "{target_schema}";')
    print(f"Schema '{target_schema}' recreated successfully.\n")


def load_schema(
    target_db: str = TARGET_DB,
    target_schema: str = TARGET_SCHEMA,
    schema_file: Path | None = None,
) -> None:
    """Connect to target database and execute the raw database schema DDL directly."""
    target_file = (
        schema_file if schema_file is not None else BASE_DIR / "raw_schema.sql"
    )
    print(f"Connecting to database '{target_db}' on {PGHOST}...")
    sql_content = target_file.read_text(encoding="utf-8")
    with get_psycopg_connection(target_db) as conn:
        with conn.cursor() as cur:
            cur.execute(f'CREATE SCHEMA IF NOT EXISTS "{target_schema}";')
            cur.execute(f'SET search_path TO "{target_schema}", public;')
            print(
                f"Applying schema DDL from '{target_file.name}' into schema '{target_schema}'..."
            )
            cur.execute(sql_content)
        conn.commit()
    print(
        f"Raw database schema from '{target_file.name}' applied successfully (tables ready).\n"
    )


def _to_date_column(df: pd.DataFrame, column: str) -> None:
    """Safely convert a DataFrame column to date objects for SQL DATE compatibility."""
    if column in df.columns:
        res = pd.to_datetime(pd.Series(df[column]), format="ISO8601")
        if isinstance(res, pd.Series):
            df[column] = res.dt.date
        else:
            df[column] = res.date


def _to_datetime_column(df: pd.DataFrame, column: str) -> None:
    """Safely convert a DataFrame column to ISO8601 datetimes."""
    if column in df.columns:
        df[column] = pd.to_datetime(pd.Series(df[column]), format="ISO8601")


def prepare_dataframe(table_name: str, df: pd.DataFrame) -> pd.DataFrame:
    """Drop pandas index artifacts and apply explicit date/timestamp/FK casts."""
    index_cols = [c for c in df.columns if c.startswith("__index")]
    if index_cols:
        df = df.drop(columns=index_cols)

    if table_name == "users":
        _to_date_column(df, "registration_date")
    elif table_name == "incentive_campaigns":
        _to_date_column(df, "start_date")
        _to_date_column(df, "end_date")
    elif table_name == "quadrant_weather":
        _to_datetime_column(df, "recorded_at")
        _to_date_column(df, "date")
    elif table_name == "trips":
        _to_datetime_column(df, "requested_at")
        _to_datetime_column(df, "started_at")
        _to_datetime_column(df, "completed_at")
        if "driver_id" in df.columns:
            df["driver_id"] = df["driver_id"].astype("Int64")
    elif table_name == "driver_telemetry":
        _to_datetime_column(df, "recorded_at")
        if "telemetry_id" in df.columns:
            df = df.drop_duplicates(subset=["telemetry_id"], keep="first")
        if "trip_id" in df.columns:
            df["trip_id"] = df["trip_id"].astype("Int64")
    elif table_name == "vehicle_maintenance":
        _to_date_column(df, "service_date")

    return df


def _clean_batch_dict(table_name: str, pydict: dict, cols: list[str]) -> None:
    """Ensure integer nullable foreign keys are cleanly cast without floats/NaNs."""
    if table_name == "driver_telemetry" and "trip_id" in pydict:
        pydict["trip_id"] = [
            int(v)
            if v is not None and not (isinstance(v, float) and math.isnan(v))
            else None
            for v in pydict["trip_id"]
        ]
    elif table_name == "trips" and "driver_id" in pydict:
        pydict["driver_id"] = [
            int(v)
            if v is not None and not (isinstance(v, float) and math.isnan(v))
            else None
            for v in pydict["driver_id"]
        ]


def load_table_batches(
    conn: psycopg.Connection,
    file_path: Path,
    table_name: str,
    schema: str = TARGET_SCHEMA,
    batch_size: int = DEFAULT_BATCH_SIZE,
) -> int:
    """Load a Parquet file into PostgreSQL using high-speed COPY in discrete transactions."""
    pf = pq.ParquetFile(file_path)
    total_rows = pf.metadata.num_rows

    if total_rows == 0:
        print(f"[{table_name}] Archivo vacío, omitiendo.")
        return 0

    all_cols = [c for c in pf.schema_arrow.names if not c.startswith("__index")]
    cols_str = ", ".join([f'"{c}"' for c in all_cols])
    copy_sql = f'COPY "{schema}"."{table_name}" ({cols_str}) FROM STDIN'

    # Special handling for tables requiring in-memory deduplication
    if table_name == "driver_telemetry":
        table = pq.read_table(file_path)
        seen: set[int] = set()
        dedup_indices: list[int] = []
        for idx, tid in enumerate(table["telemetry_id"].to_pylist()):
            if tid not in seen:
                seen.add(tid)
                dedup_indices.append(idx)
        table = table.take(dedup_indices)
        total_rows = len(table)

        total_batches = math.ceil(total_rows / batch_size)
        loaded_rows = 0
        start_time = time.time()

        for batch_num in range(1, total_batches + 1):
            batch_start = (batch_num - 1) * batch_size
            batch_end = min(batch_start + batch_size, total_rows)
            slice_table = table.slice(batch_start, batch_end - batch_start)

            pydict = slice_table.to_pydict()
            _clean_batch_dict(table_name, pydict, all_cols)
            rows = zip(*[pydict[c] for c in all_cols])

            with conn.cursor() as cur:
                with cur.copy(copy_sql) as copy:
                    for row in rows:
                        copy.write_row(row)
            conn.commit()

            loaded_rows += len(slice_table)
            elapsed = time.time() - start_time
            speed = loaded_rows / elapsed if elapsed > 0 else 0
            remaining_rows = total_rows - loaded_rows
            eta_seconds = remaining_rows / speed if speed > 0 else 0
            eta_str = str(timedelta(seconds=int(eta_seconds)))
            elapsed_str = str(timedelta(seconds=int(elapsed)))
            pct = (loaded_rows / total_rows) * 100

            print(
                f"[{table_name}] Lote {batch_num}/{total_batches} ({pct:5.1f}%) | "
                f"{loaded_rows:,}/{total_rows:,} filas | {speed:,.0f} reg/s | "
                f"Tiempo: {elapsed_str} | ETA: {eta_str}",
                end="\r" if batch_num < total_batches else "\n",
                flush=True,
            )

        total_elapsed = time.time() - start_time
        avg_speed = loaded_rows / total_elapsed if total_elapsed > 0 else 0
        print(
            f"✅ Guardado '{schema}.{table_name}': {loaded_rows:,} filas en {total_batches} lotes "
            f"({total_elapsed:.2f}s, {avg_speed:,.0f} reg/s)\n"
        )
        return loaded_rows

    # Standard streaming batch loader
    total_batches = math.ceil(total_rows / batch_size)
    loaded_rows = 0
    start_time = time.time()

    batch_iter = pf.iter_batches(batch_size=batch_size, columns=all_cols)
    for batch_num, batch in enumerate(batch_iter, start=1):
        pydict = batch.to_pydict()
        _clean_batch_dict(table_name, pydict, all_cols)
        rows = zip(*[pydict[c] for c in all_cols])

        with conn.cursor() as cur:
            with cur.copy(copy_sql) as copy:
                for row in rows:
                    copy.write_row(row)
        conn.commit()

        loaded_rows += len(batch)
        elapsed = time.time() - start_time
        speed = loaded_rows / elapsed if elapsed > 0 else 0
        remaining_rows = total_rows - loaded_rows
        eta_seconds = remaining_rows / speed if speed > 0 else 0
        eta_str = str(timedelta(seconds=int(eta_seconds)))
        elapsed_str = str(timedelta(seconds=int(elapsed)))
        pct = (loaded_rows / total_rows) * 100

        print(
            f"[{table_name}] Lote {batch_num}/{total_batches} ({pct:5.1f}%) | "
            f"{loaded_rows:,}/{total_rows:,} filas | {speed:,.0f} reg/s | "
            f"Tiempo: {elapsed_str} | ETA: {eta_str}",
            end="\r" if batch_num < total_batches else "\n",
            flush=True,
        )

    total_elapsed = time.time() - start_time
    avg_speed = loaded_rows / total_elapsed if total_elapsed > 0 else 0
    print(
        f"✅ Guardado '{schema}.{table_name}': {loaded_rows:,} filas en {total_batches} lotes "
        f"({total_elapsed:.2f}s, {avg_speed:,.0f} reg/s)\n"
    )
    return loaded_rows


def load_parquet_data(
    target_db: str = TARGET_DB,
    data_dir: Path | None = None,
    schema: str = TARGET_SCHEMA,
    skip_if_populated: bool = True,
    batch_size: int = DEFAULT_BATCH_SIZE,
    only_table: str | None = None,
) -> None:
    """Load Parquet files into the target database in batches respecting FK constraints."""
    data_path = data_dir if data_dir is not None else RAW_DATA_DIR

    print(
        f"Iniciando carga de archivos Parquet desde '{data_path}' hacia '{schema}' en '{target_db}'..."
    )
    print(f"Tamaño de lote (batch size): {batch_size:,} registros\n")

    with get_psycopg_connection(target_db) as conn:
        for file_name, table_name in TABLES_TO_LOAD:
            if only_table and table_name != only_table:
                continue

            file_path = data_path / file_name
            if not file_path.exists():
                print(f"⚠️ Advertencia: Archivo '{file_path}' no existe, omitiendo.")
                continue

            if skip_if_populated:
                try:
                    with conn.cursor() as cur:
                        cur.execute(
                            f'SELECT count(*) FROM "{schema}"."{table_name}";'
                        )
                        res = cur.fetchone()
                        current_count = res[0] if res else 0
                        if current_count > 0:
                            print(
                                f"Tabla '{schema}.{table_name}' ya contiene {current_count:,} filas. Omitiendo."
                            )
                            continue
                except Exception:
                    pass

            print(f"Iniciando carga para: {table_name} ({file_name})")
            load_table_batches(
                conn=conn,
                file_path=file_path,
                table_name=table_name,
                schema=schema,
                batch_size=batch_size,
            )

    print("🎉 Todos los archivos Parquet fueron cargados con éxito.\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Carga por lotes de archivos Parquet a PostgreSQL"
    )
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Reinicia el esquema raw por completo (DROP CASCADE + DDL)",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=DEFAULT_BATCH_SIZE,
        help=f"Tamaño de lote para la carga (por defecto: {DEFAULT_BATCH_SIZE:,})",
    )
    parser.add_argument(
        "--only",
        type=str,
        default=None,
        help="Carga únicamente una tabla específica (ej: quadrant_weather)",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Carga los datos incluso si las tablas ya contienen registros",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    print("=" * 70)
    print("MoviGo 2024 High-Throughput Database Reconstruction Pipeline")
    print("=" * 70)
    print(f"Base de datos destino: {TARGET_DB} ({PGHOST}:{PGPORT})")
    print(f"Esquema de destino:    {TARGET_SCHEMA}")
    print(f"Tamaño de lote:        {args.batch_size:,} registros")
    print("=" * 70 + "\n")

    if args.reset:
        print("Opción --reset activada: Reiniciando esquema por completo...")
        reset_schema(TARGET_DB, TARGET_SCHEMA)
        load_schema(TARGET_DB, TARGET_SCHEMA)
    else:
        # Asegura que las tablas existan sin destruirlas si ya existen
        load_schema(TARGET_DB, TARGET_SCHEMA)

    load_parquet_data(
        target_db=TARGET_DB,
        schema=TARGET_SCHEMA,
        skip_if_populated=not (args.reset or args.force),
        batch_size=args.batch_size,
        only_table=args.only,
    )

    # Verificación final de registros
    print("=" * 70)
    print(f"Resumen de registros en '{TARGET_SCHEMA}':")
    print("=" * 70)
    with get_psycopg_connection(TARGET_DB) as conn:
        with conn.cursor() as cur:
            for _, table_name in TABLES_TO_LOAD:
                cur.execute(f'SELECT count(*) FROM "{TARGET_SCHEMA}"."{table_name}";')
                res = cur.fetchone()
                cnt = res[0] if res else 0
                print(f"  • {table_name:<25}: {cnt:>10,} filas")
    print("=" * 70)
    print(
        f"🎉 Esquema '{TARGET_SCHEMA}' en BD '{TARGET_DB}' reconstruido y verificado con éxito."
    )


if __name__ == "__main__":
    main()
