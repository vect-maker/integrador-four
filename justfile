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

# Crear entorno virtual local con uv (Python 3.14) para LSP y linters
setup-env:
    uv venv --python 3.14 .venv
    uv pip install -r pipeline/requirements.txt
    @echo "✅ Entorno virtual (.venv) listo con uv (Python 3.14) para soporte LSP y linters."

# Ejecutar extracción de datos desde los 7 endpoints de MoviGo a Parquet
pipeline-fetch:
    cd pipeline && python3 fetcher.py

# Ejecutar pipeline en BD: carga del esquema DDL (destroy block) y datos Parquet
pipeline-load:
    cd pipeline && python3 loader.py

# Ejecutar comandos de dbt Core (ej. `just dbt debug`, `just dbt run`, `just dbt test`)
dbt *args="debug":
    exec dbt {{ args }} --project-dir pipeline/dbt --profiles-dir pipeline/dbt
