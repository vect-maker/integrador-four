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
-- pipeline/raw_schema.sql: Esquema OLTP con restricciones de integridad
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
# pipeline/loader.py: Carga por lotes (chunksize 2,000) en Azure Database for PostgreSQL
engine = create_engine(
    f"postgresql+psycopg://{quote_plus(PGUSER)}:{quote_plus(PGPASSWORD)}"
    f"@{PGHOST}:{PGPORT}/{TARGET_DB}?sslmode=require"
)

df.to_sql(
    name=table_name,
    con=engine,
    schema="public",
    if_exists="append",
    index=False,
    chunksize=2000,
    method="multi",
)
```

// 4. Transformación: Definición de fuentes y pruebas automatizadas en dbt Core
#let snippet-dbt-sources = ```yaml
# pipeline/dbt/models/sources.yml: Fuentes transaccionales y calidad en dbt
version: 2
sources:
  - name: raw
    database: "{{ env_var('RAW_DB_NAME', 'raw') }}"
    schema: "{{ env_var('RAW_SCHEMA', 'public') }}"
    tables:
      - name: viajes
        columns:
          - name: id_viaje
            tests: [unique, not_null]
          - name: multiplicador_dinamico
            tests: [not_null]
```
