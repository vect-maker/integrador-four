# Justfile para el Proyecto Integrador IV — MoviGo
# Automatización de tareas para Documentación (Typst), Presentación (Vite + Vue) y API REST.

# Mostrar lista de comandos disponibles
default:
    @just --list

# ==============================================================================
# DOCUMENTACIÓN (TYPST)
# ==============================================================================

# Compilar el documento de investigación a PDF (una sola vez)
build-doc:
    typst compile document/main.typ document/informe_movigo.pdf
    @echo "✅ Documento generado con éxito en document/informe_movigo.pdf"

# Compilar en modo observador en tiempo real (Live Reload, < 30ms)
watch-doc:
    typst watch document/main.typ document/informe_movigo.pdf

# Mostrar metadatos, páginas y tamaño del PDF generado
info-doc:
    @pdfinfo document/informe_movigo.pdf 2>/dev/null || echo "⚠️  No se encontró el PDF. Ejecuta 'just build-doc' primero."

# Listar todas las fuentes del sistema reconocidas por Typst
fonts-doc:
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

# Actualizar el archivo de datos document/data/zonas.json desde la API en vivo
fetch-zones:
    @python3 -c "import urllib.request, json; data = json.loads(urllib.request.urlopen('http://4.157.251.192:8000/movigo/zonas?limit=50').read().decode('utf-8')); json.dump(data['items'], open('document/data/zonas.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2); print('✅ Actualizado document/data/zonas.json con', len(data['items']), 'zonas urbanas')"

# ==============================================================================
# PRESENTACIÓN (SLIDES CON VITE + VUE 3)
# ==============================================================================

# Instalar dependencias de Node.js en la carpeta slides
slides-install:
    cd slides && npm install

# Iniciar servidor local de desarrollo de las diapositivas
slides-dev:
    cd slides && npm run dev

# Compilar las diapositivas para producción (generar carpeta dist)
slides-build:
    cd slides && npm run build

# Previsualizar la compilación de producción de las diapositivas
slides-preview:
    cd slides && npm run preview

# ==============================================================================
# LIMPIEZA
# ==============================================================================

# Eliminar artefactos generados (PDFs temporales y builds de slides)
clean:
    rm -f document/*.pdf
    rm -rf slides/dist
    @echo "🧹 Limpieza completada"
