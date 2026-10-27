// Repositorio Central de Fragmentos de Código (Code Snippets)
// Utilizados en el Documento de Investigación y Diapositivas de MoviGo

// 1. Ingesta: Extracción paginada desde API REST y serialización Parquet
#let snippet-fetcher-parquet = ```python
# pipeline/fetcher.py: Paginación y serialización columnar Parquet
for i in range(num_batches):
    offset = i * MAX_LIMIT
    res = requests.get(f"{BASE_URL}{path}", params={"offset": offset, "limit": MAX_LIMIT}, timeout=30).json()
    items = res.get("items", [])
    if items:
        dfs.append(pd.DataFrame(items))

df = pd.concat(dfs, ignore_index=True)
df.to_parquet(RAW_FOLDER / filename, index=False)
```

// 2. Esquema DDL: Definición relacional y validaciones en PostgreSQL
#let snippet-raw-ddl = ```sql
-- pipeline/raw_schema.sql: Esquema OLTP en base de datos 'postgres'
CREATE SCHEMA IF NOT EXISTS raw;
SET search_path TO raw, public;

CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    driver_id INT REFERENCES drivers(driver_id),
    origin_quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    destination_quadrant_id INT NOT NULL REFERENCES quadrants(quadrant_id),
    requested_at TIMESTAMP NOT NULL,
    status VARCHAR(25) NOT NULL 
        CHECK (status IN ('completed', 'cancelled_by_user', 'cancelled_by_driver', 'unassigned')),
    distance_km DECIMAL(6,2) NOT NULL CHECK (distance_km >= 0)
);
CREATE INDEX idx_trips_requested_at ON trips(requested_at);
```

// 3. Cargador Cloud: Conexión cifrada e inserción por lotes en Azure PostgreSQL
#let snippet-loader-azure = ```python
# pipeline/loader.py: Carga por lotes (chunksize 2,000) en esquema 'raw'
engine = create_engine(
    f"postgresql+psycopg://{quote_plus(PGUSER)}:{quote_plus(PGPASSWORD)}"
    f"@{PGHOST}:{PGPORT}/{TARGET_DB}?sslmode=require"
)

df.to_sql(
    name=table_name,
    con=engine,
    schema="raw",
    if_exists="append",
    index=False,
    chunksize=2000,
    method="multi",
)
```

// 4. Transformación: Definición de fuentes y pruebas automatizadas en dbt Core
#let snippet-dbt-sources = ```yaml
# pipeline/dbt/models/staging/sources.yml: Fuentes transaccionales y calidad en dbt
version: 2
sources:
  - name: raw
    database: "{{ env_var('RAW_DB_NAME', 'postgres') }}"
    schema: "{{ env_var('RAW_SCHEMA', 'raw') }}"
    tables:
      - name: trips
        columns:
          - name: trip_id
            tests: [unique, not_null]
          - name: status
            tests: [not_null]
```

// 5. Esquema en Estrella: Modelo atómico de hechos fct_viajes con llaves MD5
#let snippet-fct-viajes = ```sql
-- pipeline/dbt/models/marts/fct_viajes.sql: Modelo de hechos y llaves subrogadas MD5
with trips as (select * from {{ ref('stg_trips') }}),
quadrants as (select * from {{ ref('stg_quadrants') }}),
payments as (select * from {{ ref('stg_trip_payments') }})
select
    -- Llave primaria subrogada (MD5)
    md5(cast(t.trip_id as text)) as sk_trip,
    t.trip_id,
    -- Llaves foráneas conformadas subrogadas (MD5)
    md5(cast(qo.zone_id as text)) as sk_zone_origin,
    md5(cast(qd.zone_id as text)) as sk_zone_destination,
    case when t.driver_id is not null then md5(cast(t.driver_id as text)) else null end as sk_driver,
    md5(cast(t.user_id as text)) as sk_user,
    md5(cast(t.request_date as text)) as sk_weather,
    -- Métricas de tarificación dinámica y estado de cancelación
    p.base_fare, p.surge_multiplier, p.has_surge, p.final_fare, p.surge_cost_nio,
    t.trip_status, t.is_cancelled, t.wait_time_minutes
from trips t
left join quadrants qo on t.origin_quadrant_id = qo.quadrant_id
left join quadrants qd on t.destination_quadrant_id = qd.quadrant_id
left join payments p on t.trip_id = p.trip_id
```

// 6. Calidad Dimensional: Pruebas de integridad referencial y dominios en dbt
#let snippet-marts-models = ```yaml
# pipeline/dbt/models/marts/_marts__models.yml: Pruebas de integridad referencial y calidad
version: 2
models:
  - name: fct_viajes
    columns:
      - name: sk_trip
        tests: [unique, not_null]
      - name: sk_zone_origin
        tests:
          - not_null
          - relationships:
              to: ref('dim_zones')
              field: sk_zone
      - name: sk_weather
        tests:
          - not_null
          - relationships:
              to: ref('dim_weather')
              field: sk_weather
      - name: is_cancelled
        tests:
          - not_null
```

// Figuras y Listados enumerados con título formal para documentos y artículos
#let fig-raw-ddl = figure(
  snippet-raw-ddl,
  caption: [Definición del esquema DDL relacional y restricciones de integridad (`raw_schema.sql`)],
)

#let fig-loader-azure = figure(
  snippet-loader-azure,
  caption: [Conexión cifrada e inserción por lotes en Azure Database for PostgreSQL (`loader.py`)],
)

#let fig-fct-viajes = figure(
  snippet-fct-viajes,
  caption: [Modelo de la tabla de hechos atómica en dbt Core con llaves subrogadas hash MD5 (`fct_viajes.sql`)],
)

#let fig-marts-models = figure(
  snippet-marts-models,
  caption: [Pruebas declarativas de integridad referencial foránea y calidad de datos en dbt (`_marts__models.yml`)],
)
