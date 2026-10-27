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

echo "📦 Conectando a Azure Database for PostgreSQL (${PGHOST})..."

run_duckdb pipeline/data/analytics.duckdb <<EOF
INSTALL postgres;
LOAD postgres;
ATTACH 'dbname=${PGDATABASE} host=${PGHOST} port=${PGPORT} user=${PGUSER} password=${PGPASSWORD} sslmode=${PGSSLMODE}' AS azure_pg (TYPE POSTGRES, READ_ONLY);

-- Tablas Dimensionales y de Hechos en Inglés
CREATE OR REPLACE TABLE fct_viajes AS SELECT * FROM azure_pg.analytics.fct_viajes;
CREATE OR REPLACE TABLE dim_zones AS SELECT * FROM azure_pg.analytics.dim_zones;
CREATE OR REPLACE TABLE dim_quadrants AS SELECT * FROM azure_pg.analytics.dim_quadrants;
CREATE OR REPLACE TABLE dim_weather AS SELECT * FROM azure_pg.analytics.dim_weather;
CREATE OR REPLACE TABLE dim_users AS SELECT * FROM azure_pg.analytics.dim_users;
CREATE OR REPLACE TABLE dim_drivers AS SELECT * FROM azure_pg.analytics.dim_drivers;
CREATE OR REPLACE TABLE dim_campaigns AS SELECT * FROM azure_pg.analytics.dim_campaigns;

-- Eliminar tablas anteriores si existían como tablas en DuckDB para permitir vistas
DROP TABLE IF EXISTS dim_zonas;
DROP TABLE IF EXISTS dim_clima;
DROP TABLE IF EXISTS dim_conductores;
DROP TABLE IF EXISTS dim_campanias;
DROP TABLE IF EXISTS dim_usuarios;
DROP TABLE IF EXISTS dim_cuadrantes;

-- Vistas espejo en español para retrocompatibilidad total con Typst y scripts de análisis
CREATE OR REPLACE VIEW dim_zonas AS SELECT 
    sk_zone AS sk_zona, zone_id AS id_zona, zone_name AS nombre_zona, district AS distrito,
    socioeconomic_stratum AS estrato_socioeconomico, stratum_level AS nivel_estrato,
    latitude AS latitud, longitude AS longitud, coverage_radius_km AS radio_cobertura_km,
    base_flag_drop_fare AS tarifa_base_bajada_bandera
FROM dim_zones;

CREATE OR REPLACE VIEW dim_clima AS SELECT 
    sk_weather AS sk_clima, date AS fecha, precipitation_mm AS precipitacion_mm,
    avg_channel_runoff_mm AS escorrentia_cauces_mm, max_channel_runoff_mm AS escorrentia_maxima_mm,
    temperature_c AS temperatura_c, congestion_index AS indice_congestion, sky_condition AS condicion_cielo,
    has_rain AS tiene_lluvia, has_rain AS hubo_lluvia, precipitation_category AS categoria_precipitacion,
    rain_intensity AS intensidad_lluvia, congestion_level AS nivel_congestion, has_flooded_roads AS hubo_inundacion
FROM dim_weather;

CREATE OR REPLACE VIEW dim_conductores AS SELECT 
    sk_driver AS sk_conductor, driver_id AS id_conductor, name AS nombre, vehicle_id AS id_vehiculo,
    service_type AS tipo_servicio, vehicle_model AS modelo_vehiculo, vehicle_year AS anio_vehiculo,
    license_plate AS placa, fuel_type AS tipo_combustible, fuel_efficiency_km_l AS rendimiento_combustible_kml,
    initial_odometer_km AS odometro_inicial_km, average_rating AS calificacion_promedio,
    acceptance_rate_pct AS tasa_aceptacion_pct, status AS estado, is_active AS es_activo
FROM dim_drivers;

CREATE OR REPLACE VIEW dim_campanias AS SELECT 
    sk_campaign AS sk_campania, campaign_id AS id_campania, target_zone_id AS id_zona_objetivo,
    bonus_name AS nombre_bono, budget_cost_nio AS costo_presupuesto_nio, online_hours_increase AS incremento_horas_conexion,
    cost_per_online_hour_nio AS costo_por_hora_conexion, incentive_type AS tipo_incentivo,
    start_date AS fecha_inicio, end_date AS fecha_fin, duration_days AS duracion_dias,
    status AS estado, is_active AS es_activa
FROM dim_campaigns;

CREATE OR REPLACE VIEW dim_usuarios AS SELECT 
    sk_user AS sk_usuario, user_id AS id_usuario, name AS nombre, phone AS telefono,
    preferred_payment_method AS metodo_pago_preferido, prefers_cash AS prefiere_efectivo,
    average_rating AS calificacion_promedio, registration_date AS fecha_registro
FROM dim_users;

CREATE OR REPLACE VIEW dim_cuadrantes AS SELECT 
    sk_quadrant AS sk_cuadrante, quadrant_id AS id_cuadrante, sk_zone AS sk_zona, zone_id AS id_zona,
    district AS distrito, quadrant_code AS codigo_cuadrante, quadrant_name AS nombre_cuadrante,
    grid_row AS fila_cuadricula, grid_col AS columna_cuadricula, lat_min, lat_max, lon_min, lon_max,
    mean_altitude_masl AS altitud_msnm, flood_risk AS riesgo_inundacion, main_drainage_channels AS cauces_principales
FROM dim_quadrants;

CREATE OR REPLACE VIEW fct_trips AS SELECT * FROM fct_viajes;

CHECKPOINT;
EOF

echo "✅ Snapshot completado exitosamente en: ${DB_FILE}"
echo "📊 Tamaño del snapshot: $(du -h "${DB_FILE}" | cut -f1)"
