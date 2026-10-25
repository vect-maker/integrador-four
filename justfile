# Justfile para el Proyecto Integrador IV — MoviGo
# Automatización de tareas para Documentación & Diapositivas (Typst), Datos, API REST y Pipeline ELT.

set dotenv-load
export PATH := justfile_directory() + "/.venv/bin:" + env('PATH')

# Mostrar lista de comandos disponibles
default:
    @just --list

# ==============================================================================
# DOCUMENTACIÓN & DIAPOSITIVAS (TYPST EN typst/)
# ==============================================================================

# Compilar tanto el documento como las diapositivas
build-all: build-doc build-slides
    @echo "🎉 Proyecto Typst completo compilado (document.pdf y slides.pdf)."

# Compilar el documento de investigación a PDF
build-doc:
    typst compile typst/document.typ typst/document.pdf
    @echo "✅ Documento generado en typst/document.pdf"

# Compilar el documento en modo observador en tiempo real (Live Reload, < 30ms)
watch-doc:
    typst watch typst/document.typ typst/document.pdf

# Mostrar metadatos y páginas del documento
info-doc:
    @pdfinfo typst/document.pdf 2>/dev/null || echo "⚠️  No se encontró typst/document.pdf. Ejecuta 'just build-doc' primero."

# Compilar las diapositivas a PDF (16:9)
build-slides:
    typst compile typst/slides.typ typst/slides.pdf
    @echo "✅ Diapositivas generadas en typst/slides.pdf"

# Compilar diapositivas en modo observador en tiempo real (Live Reload)
watch-slides:
    typst watch typst/slides.typ typst/slides.pdf

# Mostrar metadatos y páginas de las diapositivas
info-slides:
    @pdfinfo typst/slides.pdf 2>/dev/null || echo "⚠️  No se encontró typst/slides.pdf. Ejecuta 'just build-slides' primero."

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
    podman run --rm -it \
        --env-file .env \
        -e DBT_PROFILES_DIR=. \
        -v ./pipeline/dbt:/usr/app/dbt:z \
        -w /usr/app/dbt \
        ghcr.io/dbt-labs/dbt-postgres:latest \
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

# Hidratar datasets agregados en typst/data a partir de DuckDB y análisis
hydrate-data:
    @bash pipeline/hydrate_paper_data.sh

# Abrir CLI interactivo en el snapshot local de DuckDB
duckdb:
    duckdb pipeline/data/analytics.duckdb

# Ejecutar una consulta SQL en el snapshot local de DuckDB
duckdb-sql query:
    duckdb -dark-mode pipeline/data/analytics.duckdb -c "{{ query }}"
