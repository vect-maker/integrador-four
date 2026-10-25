#!/usr/bin/env bash
set -euo pipefail

# Data Hydration Script (Data-to-Document)
# Executes analytical queries over local DuckDB and exports structured JSON datasets to typst/data/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

DB_FILE="${ROOT_DIR}/pipeline/data/analytics.duckdb"
SQL_DIR="${SCRIPT_DIR}/sql/hydration"
OUTPUT_DIR="${ROOT_DIR}/typst/data"

mkdir -p "${OUTPUT_DIR}"

# 1. Clean existing data files in output directory to prevent clutter
echo "🧹 Cleaning previous data artifacts in ${OUTPUT_DIR}..."
find "${OUTPUT_DIR}" -maxdepth 1 -type f \( -name "*.csv" -o -name "*.json" \) -delete

# 2. Verify that local database snapshot exists; if not, create it from Azure PostgreSQL
if [ ! -f "${DB_FILE}" ]; then
    echo "⚠️  Local analytics snapshot (${DB_FILE}) not found."
    echo "🔄 Running initial snapshot from Azure PostgreSQL..."
    bash "${SCRIPT_DIR}/snapshot_duckdb.sh"
fi

echo "📊 Hydrating analytical JSON datasets from DuckDB into typst/data/..."

duckdb -dark-mode "${DB_FILE}" <<EOF
-- 1. General Operational KPIs
COPY (
$(cat "${SQL_DIR}/01_general_kpis.sql")
) TO '${OUTPUT_DIR}/general_kpis.json' (FORMAT JSON, ARRAY TRUE);

-- 2. Cancellations by Hour
COPY (
$(cat "${SQL_DIR}/02_cancellations_by_hour.sql")
) TO '${OUTPUT_DIR}/cancellations_by_hour.json' (FORMAT JSON, ARRAY TRUE);

-- 3. Cancellations by Socioeconomic Stratum
COPY (
$(cat "${SQL_DIR}/03_cancellations_by_stratum.sql")
) TO '${OUTPUT_DIR}/cancellations_by_stratum.json' (FORMAT JSON, ARRAY TRUE);

-- 4. Cancellations by Weather and Rainfall
COPY (
$(cat "${SQL_DIR}/04_cancellations_by_weather.sql")
) TO '${OUTPUT_DIR}/cancellations_by_weather.json' (FORMAT JSON, ARRAY TRUE);

-- 5. Incentive Campaigns for Knapsack Optimization
COPY (
$(cat "${SQL_DIR}/05_campaigns_optimization.sql")
) TO '${OUTPUT_DIR}/campaigns_optimization.json' (FORMAT JSON, ARRAY TRUE);

-- 6. Territorial and Base Fare Zones Catalog
COPY (
$(cat "${SQL_DIR}/06_zones_catalog.sql")
) TO '${OUTPUT_DIR}/zones.json' (FORMAT JSON, ARRAY TRUE);
EOF

echo ""
echo "✅ Hydration completed successfully."
echo "📁 Single-format datasets generated in ${OUTPUT_DIR}:"
echo "--------------------------------------------------------------------------------"
ls -lh "${OUTPUT_DIR}"/*.json
echo "--------------------------------------------------------------------------------"
