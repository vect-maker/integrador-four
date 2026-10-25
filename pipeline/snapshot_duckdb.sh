#!/usr/bin/env bash
set -euo pipefail

# Script para generar un snapshot local columnar en DuckDB a partir de Azure PostgreSQL
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Cargar variables de entorno si existen
if [ -f "${ROOT_DIR}/.env" ]; then
    set -a
    # shellcheck disable=SC1091
    source "${ROOT_DIR}/.env"
    set +a
fi

DB_FILE="${ROOT_DIR}/pipeline/data/analytics.duckdb"
mkdir -p "${ROOT_DIR}/pipeline/data"

echo "📦 Conectando a Azure Database for PostgreSQL (${PGHOST})..."

duckdb -dark-mode "${DB_FILE}" <<EOF
INSTALL postgres;
LOAD postgres;
ATTACH 'dbname=${PGDATABASE} host=${PGHOST} port=${PGPORT} user=${PGUSER} password=${PGPASSWORD} sslmode=${PGSSLMODE}' AS azure_pg (TYPE POSTGRES, READ_ONLY);

CREATE OR REPLACE TABLE fct_viajes AS SELECT * FROM azure_pg.analytics.fct_viajes;
CREATE OR REPLACE TABLE dim_zonas AS SELECT * FROM azure_pg.analytics.dim_zonas;
CREATE OR REPLACE TABLE dim_clima AS SELECT * FROM azure_pg.analytics.dim_clima;
CREATE OR REPLACE TABLE dim_usuarios AS SELECT * FROM azure_pg.analytics.dim_usuarios;
CREATE OR REPLACE TABLE dim_conductores AS SELECT * FROM azure_pg.analytics.dim_conductores;
CREATE OR REPLACE TABLE dim_campanias AS SELECT * FROM azure_pg.analytics.dim_campanias;

CHECKPOINT;
EOF

echo "✅ Snapshot completado exitosamente en: ${DB_FILE}"
echo "📊 Tamaño del snapshot: $(du -h "${DB_FILE}" | cut -f1)"
