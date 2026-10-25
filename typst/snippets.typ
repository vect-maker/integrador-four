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

CREATE TABLE viajes (
    id_viaje INT PRIMARY KEY,
    id_usuario INT NOT NULL REFERENCES usuarios(id_usuario),
    id_conductor INT REFERENCES conductores(id_conductor),
    id_zona_origen INT NOT NULL REFERENCES zonas_urbanas(id_zona),
    id_zona_destino INT NOT NULL REFERENCES zonas_urbanas(id_zona),
    multiplicador_dinamico DECIMAL(4,2) NOT NULL CHECK (multiplicador_dinamico >= 1.00),
    tarifa_final DECIMAL(8,2) NOT NULL CHECK (tarifa_final >= 0),
    estado_viaje VARCHAR(25) NOT NULL 
        CHECK (estado_viaje IN ('completado', 'cancelado_usuario', 'cancelado_conductor', 'no_asignado'))
);
CREATE INDEX idx_viajes_solicitud ON viajes(fecha_hora_solicitud);
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
      - name: viajes
        columns:
          - name: id_viaje
            tests: [unique, not_null]
          - name: multiplicador_dinamico
            tests: [not_null]
```

// 5. Esquema en Estrella: Modelo atómico de hechos fct_viajes con llaves MD5
#let snippet-fct-viajes = ```sql
-- pipeline/dbt/models/marts/fct_viajes.sql: Modelo de hechos y llaves subrogadas MD5
with viajes as (
    select * from {{ ref('stg_viajes') }}
)
select
    -- Llave primaria subrogada (MD5)
    md5(cast(id_viaje as text)) as sk_viaje,
    id_viaje,
    -- Llaves foráneas conformadas subrogadas (MD5)
    md5(cast(id_zona_origen as text)) as sk_zona_origen,
    md5(cast(id_zona_destino as text)) as sk_zona_destino,
    case when id_conductor is not null then md5(cast(id_conductor as text)) else null end as sk_conductor,
    md5(cast(id_usuario as text)) as sk_usuario,
    md5(cast(fecha_solicitud as text)) as sk_clima,
    -- Métricas de tarificación dinámica y estado de cancelación
    tarifa_base, multiplicador_dinamico, tiene_surge, tarifa_final, sobrecosto_surge_nio,
    estado_viaje, es_cancelado, es_cancelado_usuario, tiempo_espera_minutos
from viajes
```

// 6. Calidad Dimensional: Pruebas de integridad referencial y dominios en dbt
#let snippet-marts-models = ```yaml
# pipeline/dbt/models/marts/_marts__models.yml: Pruebas de integridad referencial y calidad
version: 2
models:
  - name: fct_viajes
    columns:
      - name: sk_viaje
        tests: [unique, not_null]
      - name: sk_zona_origen
        tests:
          - not_null
          - relationships:
              to: ref('dim_zonas')
              field: sk_zona
      - name: sk_clima
        tests:
          - not_null
          - relationships:
              to: ref('dim_clima')
              field: sk_clima
      - name: es_cancelado
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
