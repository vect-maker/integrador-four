import os
import time
from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine, text

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
BATCH_SIZE = 2000

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


def get_database_url(dbname: str) -> str:
    """Build a PostgreSQL connection URL for SQLAlchemy using psycopg 3."""
    user = quote_plus(PGUSER or "")
    password = quote_plus(PGPASSWORD or "")
    return (
        f"postgresql+psycopg://{user}:{password}@{PGHOST}:{PGPORT}/{dbname}"
        f"?sslmode={PGSSLMODE}"
    )


def get_engine(dbname: str) -> Engine:
    """Create a SQLAlchemy Engine for the specified database."""
    return create_engine(get_database_url(dbname))


def reset_schema(
    target_db: str = TARGET_DB, target_schema: str = TARGET_SCHEMA
) -> None:
    """Drop target schema if it exists and create a clean one."""
    print(f"Connecting to database '{target_db}' on {PGHOST} to reset schema '{target_schema}'...")
    engine = get_engine(target_db)
    with engine.connect().execution_options(isolation_level="AUTOCOMMIT") as conn:
        print(f"Resetting schema '{target_schema}' (DROP CASCADE + CREATE)...")
        conn.execute(text(f'DROP SCHEMA IF EXISTS "{target_schema}" CASCADE;'))
        conn.execute(text(f'CREATE SCHEMA "{target_schema}";'))
    engine.dispose()
    print(f"Schema '{target_schema}' recreated successfully.\n")


def load_schema(
    target_db: str = TARGET_DB,
    target_schema: str = TARGET_SCHEMA,
    schema_file: Path | None = None,
) -> None:
    """Connect to target database and execute the raw database schema DDL directly."""
    target_file = (
        schema_file
        if schema_file is not None
        else BASE_DIR / "raw_schema.sql"
    )
    print(f"Connecting to database '{target_db}' on {PGHOST}...")
    sql_content = target_file.read_text(encoding="utf-8")
    engine = get_engine(target_db)
    with engine.begin() as conn:
        conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{target_schema}";'))
        conn.execute(text(f'SET search_path TO "{target_schema}", public;'))
        print(f"Applying schema DDL from '{target_file.name}' into schema '{target_schema}'...")
        conn.execute(text(sql_content))
    engine.dispose()
    print(f"Raw database schema from '{target_file.name}' applied successfully (tables reset).\n")


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

    if table_name == "usuarios":
        _to_date_column(df, "fecha_registro")
    elif table_name == "campanas_incentivos":
        _to_date_column(df, "fecha_inicio")
        _to_date_column(df, "fecha_fin")
    elif table_name == "clima_cuadrantes":
        _to_date_column(df, "fecha")
    elif table_name == "viajes":
        _to_datetime_column(df, "fecha_hora_solicitud")
        _to_datetime_column(df, "fecha_hora_inicio")
        _to_datetime_column(df, "fecha_hora_fin")
        if "id_conductor" in df.columns:
            df["id_conductor"] = df["id_conductor"].astype("Int64")
    elif table_name == "telemetria_conductores":
        _to_datetime_column(df, "fecha_hora")

    return df


def load_parquet_data(
    target_db: str = TARGET_DB,
    data_dir: Path | None = None,
    schema: str = TARGET_SCHEMA,
) -> None:
    """Load Parquet files into the target database in batches respecting FK constraints."""
    data_path = data_dir if data_dir is not None else RAW_DATA_DIR
    engine = get_engine(target_db)

    # Tables to load in foreign-key dependency order
    tables_to_load = [
        ("zonas.parquet", "zonas_urbanas"),
        ("usuarios.parquet", "usuarios"),
        ("conductores.parquet", "conductores"),
        ("campanas.parquet", "campanas_incentivos"),
        ("clima.parquet", "clima_cuadrantes"),
        ("viajes.parquet", "viajes"),
        ("telemetria.parquet", "telemetria_conductores"),
    ]

    print(f"Loading Parquet files from '{data_path}' into schema '{schema}' of database '{target_db}'...")
    for file_name, table_name in tables_to_load:
        file_path = data_path / file_name
        if not file_path.exists():
            print(f"Warning: File '{file_path}' does not exist, skipping.")
            continue

        print(f"Loading '{file_name}' into table '{schema}.{table_name}'...")
        raw_df = pd.read_parquet(file_path)
        df = prepare_dataframe(table_name, raw_df)

        start_time = time.time()
        df.to_sql(
            name=table_name,
            con=engine,
            schema=schema,
            if_exists="append",
            index=False,
            chunksize=BATCH_SIZE,
            method="multi",
        )
        elapsed = time.time() - start_time
        print(f"  -> Inserted {len(df):,} rows into '{schema}.{table_name}' in {elapsed:.2f}s")

    engine.dispose()
    print("All Parquet data loaded successfully.\n")


def main() -> None:
    print(f"Iniciando pipeline de carga en BD '{TARGET_DB}' (esquema '{TARGET_SCHEMA}')...")
    # Reinicia completamente el esquema de destino
    reset_schema(TARGET_DB, TARGET_SCHEMA)
    # Ejecuta el DDL de definición del esquema en TARGET_SCHEMA
    load_schema(TARGET_DB, TARGET_SCHEMA)
    # Inserta los datos desde los archivos Parquet en orden de dependencias FK
    load_parquet_data(TARGET_DB, schema=TARGET_SCHEMA)
    print(f"🎉 Esquema '{TARGET_SCHEMA}' en BD '{TARGET_DB}' reiniciado, migrado y cargado con éxito.")


if __name__ == "__main__":
    main()
