# Justfile para el Proyecto Integrador IV — MoviGo
# Automatización de tareas para Documentación & Diapositivas (Typst), Datos y API REST.

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

# Listar todas las fuentes del sistema reconocidas por Typst
fonts:
    typst fonts

# ==============================================================================
# API REST & DATOS (MOVIGO)
# ==============================================================================

# Verificar conectividad con la API REST pública de MoviGo
api-check:
    @curl -s -o /dev/null -w "Estado HTTP: %{http_code}\n" http://4.157.251.192:8000/docs && echo "✅ API REST accesible en http://4.157.251.192:8000" || echo "❌ No se pudo conectar a la API"

# Consultar el recuento total de registros en los endpoints de MoviGo
api-status:
    @python3 -c "import urllib.request, json; base = 'http://4.157.251.192:8000/movigo'; [print(f'• /{ep:<12} -> {json.loads(urllib.request.urlopen(f\"{base}/{ep}?limit=1\").read().decode(\"utf-8\")).get(\"total\", 0):>6} registros') for ep in ['zonas', 'usuarios', 'conductores', 'campanas', 'clima', 'viajes', 'telemetria']]"

# Actualizar el catálogo de zonas compartidas typst/data/zonas.json desde la API en vivo
fetch-zones:
    @python3 -c "import urllib.request, json; data = json.loads(urllib.request.urlopen('http://4.157.251.192:8000/movigo/zonas?limit=50').read().decode('utf-8')); json.dump(data['items'], open('typst/data/zonas.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2); print('✅ Actualizado typst/data/zonas.json con', len(data['items']), 'zonas urbanas')"

# ==============================================================================
# LIMPIEZA
# ==============================================================================

# Eliminar artefactos generados (PDFs compilados)
clean:
    rm -f typst/document.pdf typst/slides.pdf
    @echo "🧹 Limpieza completada"
