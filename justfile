# Justfile para el Proyecto Integrador IV — MoviGo
# Automatización de tareas para Documentación & Diapositivas (Typst), Datos, API REST y Pipeline ELT.

set dotenv-load
export PATH := justfile_directory() + "/.venv/bin:" + env('PATH')

# ==============================================================================
# CONFIGURACIÓN Y CONSTANTES DE CONTENEDORES (PODMAN)
# ==============================================================================
TYPST_IMAGE         := "ghcr.io/typst/typst:latest"
DBT_IMAGE           := "ghcr.io/dbt-labs/dbt-postgres:latest"
export DUCKDB_IMAGE := "docker.io/duckdb/duckdb:latest"

# Mostrar lista de comandos disponibles
default:
    @just --list

# ==============================================================================
# DOCUMENTACIÓN & DIAPOSITIVAS (TYPST MEDIANTE CONTENEDOR OFICIAL CON PODMAN)
# ==============================================================================

# Ejecutar comando de Typst en Podman (reutilizado por todas las recetas de compilación)
typst *args="--help":
    @mkdir -p doc/output "$HOME/.cache/typst"
    podman run --rm -i \
        -v ".:/workspace:Z" \
        -v "/usr/share/fonts:/usr/share/fonts:ro" \
        -v "$HOME/.cache/typst:/root/.cache/typst:Z" \
        -w /workspace \
        {{ TYPST_IMAGE }} \
        {{ args }}

# Compilar tanto el documento como las diapositivas
build-all: build-doc build-slides
    @echo "🎉 Proyecto Typst completo compilado (doc/output/document.pdf y doc/output/slides.pdf)."

# Compilar el documento de investigación a PDF
build-doc:
    @just typst compile typst/document.typ doc/output/document.pdf
    @echo "✅ Documento generado en doc/output/document.pdf"

# Compilar el documento en modo observador en tiempo real (Live Reload)
watch-doc:
    just typst watch typst/document.typ doc/output/document.pdf

# Compilar las diapositivas a PDF (16:9)
build-slides:
    @just typst compile typst/slides.typ doc/output/slides.pdf
    @echo "✅ Diapositivas generadas en doc/output/slides.pdf"

# Compilar diapositivas en modo observador en tiempo real (Live Reload)
watch-slides:
    just typst watch typst/slides.typ doc/output/slides.pdf

# Configurar entorno virtual local (.venv) instalando uv automáticamente si no existe y dependencias
setup-env:
    @bash -c '\
        if ! command -v uv &> /dev/null; then \
            echo "⚠️  uv no está instalado en el sistema. Instalando uv automáticamente..."; \
            curl -LsSf https://astral.sh/uv/install.sh | sh; \
            export PATH="$$HOME/.local/bin:$$HOME/.cargo/bin:$$PATH"; \
        fi; \
        echo "🔧 Creando entorno virtual local (.venv)..."; \
        uv venv --clear .venv; \
        echo "📦 Instalando dependencias de pipeline/requirements.txt en .venv..."; \
        uv pip install -r pipeline/requirements.txt; \
        echo "✅ Entorno virtual (.venv) listo y verificado con todas las dependencias científicas."; \
    '

# Ejecutar extracción de datos desde los 7 endpoints de MoviGo a Parquet (ejecución directa en .venv)
pipeline-fetch:
    .venv/bin/python pipeline/fetcher.py

# Ejecutar pipeline en BD: carga del esquema DDL y datos Parquet (ejecución directa en .venv)
pipeline-load:
    .venv/bin/python pipeline/loader.py

# Ejecutar comandos de dbt mediante el contenedor oficial de dbt Labs con Podman
dbt *args="debug":
    podman run --rm -i \
        --env-file .env \
        -e DBT_PROFILES_DIR=. \
        -v ./pipeline/dbt:/usr/app/dbt:z \
        -w /usr/app/dbt \
        {{ DBT_IMAGE }} \
        {{ args }}

# ==============================================================================
# ANALÍTICA LOCAL Y EXPLORACIÓN OLAP (DUCKDB)
# ==============================================================================

# Crear o refrescar snapshot local en DuckDB a partir de Azure PostgreSQL (marts)
duckdb-snapshot:
    @bash pipeline/snapshot_duckdb.sh

# Ejecutar script econométrico MCO (statsmodels, ANOVA, JSON e imágenes PNG)
run-econometrics:
    @.venv/bin/python pipeline/analysis/01_econometrics.py

# Ejecutar búsqueda de raíces numéricas (Bisección vs Newton-Raphson, JSON e imágenes PNG)
run-numerical:
    @.venv/bin/python pipeline/analysis/02_numerical_methods.py

# Ejecutar optimización de rutas (Teoría de Grafos y Dijkstra en red vial, JSON e imágenes PNG)
run-optimization:
    @.venv/bin/python pipeline/analysis/03_optimization.py

# Generar mapa geoespacial de densidad de orígenes de viajes (WGS84 y Basemap OSM)
run-spatial:
    @.venv/bin/python pipeline/analysis/04_spatial_density.py

# Ejecutar la suite completa de modelado computacional (Econometría, Métodos Numéricos y Optimización)
run-analysis: run-econometrics run-numerical run-optimization run-spatial
    @echo "🎉 Suite completa de análisis computacional ejecutada exitosamente."

# Hidratar datasets agregados en typst/data a partir de DuckDB y análisis
hydrate-data:
    @bash pipeline/hydrate_paper_data.sh

# Ejecutar auditoría estadística de distribuciones, outliers y colinealidad en DuckDB
check-data:
    @.venv/bin/python pipeline/analysis/data_distribution_check.py

# Ejecutar verificación de tipos estáticos con basedpyright (idéntico al LSP de Zed)
check-types:
    @uvx basedpyright pipeline/

# Abrir CLI interactivo en el snapshot local de DuckDB mediante Podman
duckdb *args="":
    @mkdir -p "$HOME/.duckdb"
    podman run --rm -it \
        -v ".:/workspace:Z" \
        -v "$HOME/.duckdb:/root/.duckdb:Z" \
        -w /workspace \
        {{ DUCKDB_IMAGE }} \
        /duckdb pipeline/data/analytics.duckdb {{ args }}

# Ejecutar una consulta SQL en el snapshot local de DuckDB mediante Podman
duckdb-sql query:
    @mkdir -p "$HOME/.duckdb"
    podman run --rm -i \
        -v ".:/workspace:Z" \
        -v "$HOME/.duckdb:/root/.duckdb:Z" \
        -w /workspace \
        {{ DUCKDB_IMAGE }} \
        /duckdb pipeline/data/analytics.duckdb -c "{{ query }}"
