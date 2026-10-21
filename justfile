# Justfile para el Proyecto Integrador IV — MoviGo
# Automatización de tareas para Documentación e Informe (Typst), Diapositivas (Typst) y API REST.

# Mostrar lista de comandos disponibles
default:
    @just --list

# ==============================================================================
# DOCUMENTACIÓN (TYPST)
# ==============================================================================

# Compilar el documento de investigación a PDF (una sola vez)
build-doc:
    typst compile document/main.typ document/document.pdf
    @echo "✅ Documento generado con éxito en document/document.pdf"

# Compilar en modo observador en tiempo real (Live Reload, < 30ms)
watch-doc:
    typst watch document/main.typ document/document.pdf

# Mostrar metadatos, páginas y tamaño del PDF generado
info-doc:
    @pdfinfo document/document.pdf 2>/dev/null || echo "⚠️  No se encontró el PDF. Ejecuta 'just build-doc' primero."

# Listar todas las fuentes del sistema reconocidas por Typst
fonts-doc:
    typst fonts

# ==============================================================================
# SLIDES (TYPST)
# ==============================================================================

# Compilar las diapositivas a PDF (16:9)
build-slides:
    typst compile --root . slides/main.typ slides/slides.pdf
    @echo "✅ Diapositivas generadas con éxito en slides/slides.pdf"

# Compilar diapositivas en modo observador en tiempo real (Live Reload)
watch-slides:
    typst watch --root . slides/main.typ slides/slides.pdf

# Mostrar metadatos y páginas del PDF de diapositivas
info-slides:
    @pdfinfo slides/slides.pdf 2>/dev/null || echo "⚠️  No se encontró el PDF. Ejecuta 'just build-slides' primero."

# Compilar tanto el documento como las diapositivas
build-all: build-doc build-slides
    @echo "🎉 Todo compilado con éxito (informe y diapositivas)."

# ==============================================================================
# API REST & DATOS (MOVIGO)
# ==============================================================================

# Verificar conectividad con la API REST pública de MoviGo
api-check:
    @curl -s -o /dev/null -w "Estado HTTP: %{http_code}\n" http://4.157.251.192:8000/docs && echo "✅ API REST accesible en http://4.157.251.192:8000" || echo "❌ No se pudo conectar a la API"

# Consultar el recuento total de registros en los endpoints de MoviGo
api-status:
    @python3 -c "import urllib.request, json; base = 'http://4.157.251.192:8000/movigo'; [print(f'• /{ep:<12} -> {json.loads(urllib.request.urlopen(f\"{base}/{ep}?limit=1\").read().decode(\"utf-8\")).get(\"total\", 0):>6} registros') for ep in ['zonas', 'usuarios', 'conductores', 'campanas', 'clima', 'viajes', 'telemetria']]"

# Actualizar el archivo de datos document/data/zonas.json desde la API en vivo
fetch-zones:
    @python3 -c "import urllib.request, json; data = json.loads(urllib.request.urlopen('http://4.157.251.192:8000/movigo/zonas?limit=50').read().decode('utf-8')); json.dump(data['items'], open('document/data/zonas.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2); print('✅ Actualizado document/data/zonas.json con', len(data['items']), 'zonas urbanas')"

# ==============================================================================
# LIMPIEZA
# ==============================================================================

# Eliminar artefactos generados (PDFs compilados)
clean:
    rm -f document/*.pdf slides/*.pdf
    @echo "🧹 Limpieza completada"
