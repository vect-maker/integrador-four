import argparse
import os
import time
from pathlib import Path
from urllib.parse import quote_plus

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine, text

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent

PGHOST = os.getenv("PGHOST")
PGPORT = os.getenv("PGPORT", "5432")
PGUSER = os.getenv("PGUSER")
PGPASSWORD = os.getenv("PGPASSWORD")
PGSSLMODE = os.getenv("PGSSLMODE", "require")

# Admin/maintenance database used to manage other databases
ADMIN_DB = os.getenv("PGADMIN_DATABASE", "postgres")
# Target database to reset and apply schema migrations
TARGET_DB = os.getenv("RAW_DB_NAME", "raw")
# Target schema for raw staging tables
TARGET_SCHEMA = os.getenv("RAW_SCHEMA", "raw_staging_movigo")


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


def apply_migrations(
    target_db: str = TARGET_DB, migration_file: Path | None = None
) -> None:
    """Connect to the target database and execute the schema migration directly."""
    target_file = (
        migration_file
        if migration_file is not None
        else BASE_DIR / "migrations" / "01_schema.sql"
    )
    print(f"Connecting to target database '{target_db}'...")
    sql_content = target_file.read_text(encoding="utf-8")
    engine = get_engine(target_db)
    with engine.begin() as conn:
        print(f"Applying schema migration from '{target_file}'...")
        conn.execute(text(sql_content))
    engine.dispose()
    print(f"Schema migration '{target_file}' applied successfully.\n")


def truncate_tables(target_db: str = TARGET_DB, schema: str = TARGET_SCHEMA) -> None:
    """Truncate all raw staging tables in MoviGo to ensure an idempotent reload."""
    tables = [
        "telemetria_conductores",
        "viajes",
        "auditoria_viajes",
        "clima_cuadrantes",
        "campanas_incentivos",
        "conductores",
        "usuarios",
        "zonas_urbanas",
    ]
    print(f"Truncating tables in database '{target_db}', schema '{schema}'...")
    engine = get_engine(target_db)
    with engine.begin() as conn:
        table_list = ", ".join(f'"{schema}"."{t}"' for t in tables)
        conn.execute(text(f"TRUNCATE TABLE {table_list} CASCADE;"))
    engine.dispose()
    print("Tables truncated successfully.\n")


def load_parquet_data(
    target_db: str = TARGET_DB,
    data_dir: Path | None = None,
    batch_size: int = 2000,
    truncate: bool = True,
    schema: str = TARGET_SCHEMA,
) -> None:
    """Load Parquet files into the target database in batches respecting FK constraints."""
    if truncate:
        truncate_tables(target_db, schema)

    data_path = data_dir if data_dir is not None else BASE_DIR / "data" / "raw"
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
        df = pd.read_parquet(file_path)

        # Drop internal pandas index artifacts if present
        clean_cols = [c for c in df.columns if not c.startswith("__index")]
        df = df[clean_cols]

        # Explicit date & timestamp casts for Postgres/psycopg compatibility
        if table_name == "usuarios":
            if "fecha_registro" in df.columns:
                df["fecha_registro"] = pd.to_datetime(
                    df["fecha_registro"], format="ISO8601"
                ).dt.date
        elif table_name == "campanas_incentivos":
            if "fecha_inicio" in df.columns:
                df["fecha_inicio"] = pd.to_datetime(
                    df["fecha_inicio"], format="ISO8601"
                ).dt.date
            if "fecha_fin" in df.columns:
                df["fecha_fin"] = pd.to_datetime(
                    df["fecha_fin"], format="ISO8601"
                ).dt.date
        elif table_name == "clima_cuadrantes":
            if "fecha" in df.columns:
                df["fecha"] = pd.to_datetime(
                    df["fecha"], format="ISO8601"
                ).dt.date
        elif table_name == "viajes":
            if "fecha_hora_solicitud" in df.columns:
                df["fecha_hora_solicitud"] = pd.to_datetime(
                    df["fecha_hora_solicitud"], format="ISO8601"
                )
            if "fecha_hora_inicio" in df.columns:
                df["fecha_hora_inicio"] = pd.to_datetime(
                    df["fecha_hora_inicio"], format="ISO8601"
                )
            if "fecha_hora_fin" in df.columns:
                df["fecha_hora_fin"] = pd.to_datetime(
                    df["fecha_hora_fin"], format="ISO8601"
                )
            if "id_conductor" in df.columns:
                df["id_conductor"] = df["id_conductor"].astype("Int64")
        elif table_name == "telemetria_conductores":
            if "fecha_hora" in df.columns:
                df["fecha_hora"] = pd.to_datetime(
                    df["fecha_hora"], format="ISO8601"
                )

        start_time = time.time()
        df.to_sql(
            name=table_name,
            con=engine,
            schema=schema,
            if_exists="append",
            index=False,
            chunksize=batch_size,
            method="multi",
        )
        elapsed = time.time() - start_time
        print(f"  -> Inserted {len(df):,} rows into '{schema}.{table_name}' in {elapsed:.2f}s")

    engine.dispose()
    print("All Parquet data loaded successfully.\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Database schema and Parquet data loader for MoviGo using SQLAlchemy"
    )
    parser.add_argument(
        "--schema-only",
        action="store_true",
        help="Reset DB and apply schema migrations only",
    )
    parser.add_argument(
        "--data-only",
        action="store_true",
        help="Load Parquet data into existing schema only",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=2000,
        help="Batch chunk size for inserting data (default: 2000)",
    )
    parser.add_argument(
        "--no-truncate",
        action="store_true",
        help="Do not truncate tables before loading data",
    )
    args = parser.parse_args()

    if args.schema_only:
        reset_database(TARGET_DB)
        apply_migrations(TARGET_DB)
    elif args.data_only:
        load_parquet_data(
            TARGET_DB,
            batch_size=args.batch_size,
            truncate=not args.no_truncate,
        )
    else:
        reset_database(TARGET_DB)
        apply_migrations(TARGET_DB)
        load_parquet_data(
            TARGET_DB,
            batch_size=args.batch_size,
            truncate=False,  # fresh DB doesn't need truncate
        )


if __name__ == "__main__":
    main()
