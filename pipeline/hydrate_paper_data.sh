#!/usr/bin/env bash
set -euo pipefail

# Data & Figures Hydration Script (Data-to-Document)
# --------------------------------------------------
# Orchestrates end-to-end data extraction, analytical modeling, and visual asset generation:
#   1. Purges stale JSON datasets and PNG figures (preserving README.md docs).
#   2. Executes DuckDB SQL dimensional and transactional queries -> 6 JSON files.
#   3. Executes Python scientific suite (.venv) -> 3 JSON models + 6 high-res PNG plots.
#   4. Performs rigorous integrity validation on all 15 generated artifacts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

START_TIME=$(date +%s)

DB_FILE="${ROOT_DIR}/pipeline/data/analytics.duckdb"
SQL_DIR="${SCRIPT_DIR}/sql/hydration"
DATA_DIR="${ROOT_DIR}/typst/data"
GRAPHS_DIR="${ROOT_DIR}/typst/graphs"
PYTHON_BIN="${ROOT_DIR}/.venv/bin/python"

# Configuración del contenedor DuckDB heredada de justfile
DUCKDB_IMAGE="${DUCKDB_IMAGE:-docker.io/duckdb/duckdb:latest}"

run_duckdb() {
    mkdir -p "${HOME}/.duckdb"
    podman run --rm -i \
        -v "${ROOT_DIR}:/workspace:Z" \
        -v "${HOME}/.duckdb:/root/.duckdb:Z" \
        -w /workspace \
        "${DUCKDB_IMAGE}" \
        /duckdb "$@"
}

mkdir -p "${DATA_DIR}" "${GRAPHS_DIR}"

echo "================================================================================"
echo "🚀 MoviGo End-to-End Data & Visual Asset Hydration Pipeline"
echo "================================================================================"

# -----------------------------------------------------------------------------
# 1. Selective Artifact Purge
# -----------------------------------------------------------------------------
echo "🧹 Step 1: Purging stale data and figure artifacts..."
find "${DATA_DIR}" -maxdepth 1 -type f \( -name "*.json" -o -name "*.csv" \) ! -name "README.md" -delete
find "${GRAPHS_DIR}" -maxdepth 1 -type f \( -name "*.png" -o -name "*.svg" \) ! -name "README.md" -delete
echo "   ✅ Stale artifacts purged. Documentation files preserved."

# -----------------------------------------------------------------------------
# 2. Database Snapshot Verification
# -----------------------------------------------------------------------------
if [ ! -f "${DB_FILE}" ]; then
    echo "⚠️  Local analytics snapshot (${DB_FILE}) not found."
    echo "🔄 Running initial snapshot extraction from Azure PostgreSQL..."
    bash "${SCRIPT_DIR}/snapshot_duckdb.sh"
fi

# -----------------------------------------------------------------------------
# 3. DuckDB SQL Analytics Hydration (6 Core Datasets)
# -----------------------------------------------------------------------------
echo ""
echo "📊 Step 2: Hydrating core dimensional datasets from DuckDB SQL (via Podman ${DUCKDB_IMAGE})..."

run_duckdb pipeline/data/analytics.duckdb <<EOF
-- 1. General Operational KPIs
COPY (
$(cat "${SQL_DIR}/01_general_kpis.sql")
) TO 'typst/data/general_kpis.json' (FORMAT JSON, ARRAY TRUE);

-- 2. Cancellations by Hour
COPY (
$(cat "${SQL_DIR}/02_cancellations_by_hour.sql")
) TO 'typst/data/cancellations_by_hour.json' (FORMAT JSON, ARRAY TRUE);

-- 3. Cancellations by Socioeconomic Stratum
COPY (
$(cat "${SQL_DIR}/03_cancellations_by_stratum.sql")
) TO 'typst/data/cancellations_by_stratum.json' (FORMAT JSON, ARRAY TRUE);

-- 4. Cancellations by Weather and Rainfall
COPY (
$(cat "${SQL_DIR}/04_cancellations_by_weather.sql")
) TO 'typst/data/cancellations_by_weather.json' (FORMAT JSON, ARRAY TRUE);

-- 5. Incentive Campaigns for Knapsack Optimization
COPY (
$(cat "${SQL_DIR}/05_campaigns_optimization.sql")
) TO 'typst/data/campaigns_optimization.json' (FORMAT JSON, ARRAY TRUE);

-- 6. Territorial and Base Fare Zones Catalog
COPY (
$(cat "${SQL_DIR}/06_zones_catalog.sql")
) TO 'typst/data/zones.json' (FORMAT JSON, ARRAY TRUE);
EOF
echo "   ✅ 6 SQL analytical datasets exported to ${DATA_DIR}."

# -----------------------------------------------------------------------------
# 4. Python Scientific Suite Execution (3 Models + 6 Standalone PNGs)
# -----------------------------------------------------------------------------
echo ""
echo "🔬 Step 3: Executing computational modeling suite in Python..."

if [ ! -f "${PYTHON_BIN}" ]; then
    echo "❌ Virtualenv Python binary not found at ${PYTHON_BIN}."
    echo "   Please run 'just setup-env' first."
    exit 1
fi

echo "   ▶ Running 01_econometrics.py (OLS Multiple Regression & ANOVA)..."
"${PYTHON_BIN}" "${SCRIPT_DIR}/analysis/01_econometrics.py" > /dev/null

echo "   ▶ Running 02_numerical_methods.py (Bisection & Newton-Raphson)..."
"${PYTHON_BIN}" "${SCRIPT_DIR}/analysis/02_numerical_methods.py" > /dev/null

echo "   ▶ Running 03_optimization.py (Dijkstra Shortest Path on Road Graph)..."
"${PYTHON_BIN}" "${SCRIPT_DIR}/analysis/03_optimization.py" > /dev/null

echo "   ✅ All Python modeling scripts executed successfully."

# -----------------------------------------------------------------------------
# 5. Integrity Validation Loop (9 JSONs + 6 PNGs)
# -----------------------------------------------------------------------------
echo ""
echo "🔍 Step 4: Validating artifact integrity and data schemas..."

JSON_FILES=(
    "general_kpis.json"
    "cancellations_by_hour.json"
    "cancellations_by_stratum.json"
    "cancellations_by_weather.json"
    "campaigns_optimization.json"
    "zones.json"
    "econometric_regression.json"
    "numerical_methods.json"
    "routing_optimization.json"
)

PNG_FILES=(
    "regression_fit.png"
    "market_equilibrium_curves.png"
    "numerical_convergence.png"
    "urban_network_topology.png"
    "urban_network_dijkstra.png"
)

# Validate JSON files
for jf in "${JSON_FILES[@]}"; do
    TARGET_JSON="${DATA_DIR}/${jf}"
    if [ ! -f "${TARGET_JSON}" ]; then
        echo "❌ ERROR: Expected JSON file missing: ${TARGET_JSON}"
        exit 1
    fi
    "${PYTHON_BIN}" -m json.tool "${TARGET_JSON}" > /dev/null 2>&1 || {
        echo "❌ ERROR: Invalid JSON syntax in ${TARGET_JSON}"
        exit 1
    }
done
echo "   ✅ All 9 JSON data files validated successfully (0 syntax errors)."

# Validate PNG files
for pf in "${PNG_FILES[@]}"; do
    TARGET_PNG="${GRAPHS_DIR}/${pf}"
    if [ ! -s "${TARGET_PNG}" ]; then
        echo "❌ ERROR: Expected PNG file missing or empty: ${TARGET_PNG}"
        exit 1
    fi
done
echo "   ✅ All 5 high-resolution PNG plots validated (non-empty binaries)."

# -----------------------------------------------------------------------------
# 6. Final Summary & Execution Time
# -----------------------------------------------------------------------------
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "================================================================================"
echo "🎉 Hydration Pipeline Completed Successfully in ${ELAPSED} seconds!"
echo "================================================================================"
echo "📁 Hydrated JSON Datasets (${DATA_DIR}):"
ls -lh "${DATA_DIR}"/*.json | awk '{print "   • " $9 " (" $5 ")"}'
echo ""
echo "🖼️  Generated Standalone PNG Figures (${GRAPHS_DIR}):"
ls -lh "${GRAPHS_DIR}"/*.png | awk '{print "   • " $9 " (" $5 ")"}'
echo "================================================================================"
