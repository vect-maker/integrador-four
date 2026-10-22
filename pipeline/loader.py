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
TARGET_DB = os.getenv("RAW_DB_NAME", os.getenv("PGDATABASE", "raw"))
TARGET_SCHEMA = os.getenv("RAW_SCHEMA", "public")
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


def reset_database(target_db: str = TARGET_DB, admin_db: str = ADMIN_DB) -> None:
    """Drop target database if it exists, then create a clean one."""
    print(f"Connecting to admin database '{admin_db}' on {PGHOST}...")
    engine = get_engine(admin_db)
    with engine.connect().execution_options(isolation_level="AUTOCOMMIT") as conn:
        print(f"Terminating any active connections to '{target_db}'...")
        conn.execute(
            text(
                """
                SELECT pg_terminate_backend(pid)
                FROM pg_stat_activity
                WHERE datname = :target_db AND pid <> pg_backend_pid();
                """
            ),
            {"target_db": target_db},
        )

        print(f"Dropping database '{target_db}' if it exists...")
        conn.execute(text(f'DROP DATABASE IF EXISTS "{target_db}" WITH (FORCE);'))

        print(f"Creating fresh database '{target_db}'...")
        conn.execute(text(f'CREATE DATABASE "{target_db}";'))

    engine.dispose()
    print(f"Database '{target_db}' created successfully.\n")


def load_schema(
    target_db: str = TARGET_DB, schema_file: Path | None = None
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
        print(f"Applying schema DDL from '{target_file.name}'...")
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
    # Reinicia completamente la base de datos de destino
    reset_database(TARGET_DB, ADMIN_DB)
    # Ejecuta el DDL de definición del esquema en public
    load_schema(TARGET_DB)
    # Inserta los datos desde los archivos Parquet en orden de dependencias FK
    load_parquet_data(TARGET_DB, schema=TARGET_SCHEMA)
    print("🎉 Base de datos raw reiniciada, migrada y cargada con éxito.")


if __name__ == "__main__":
    main()
