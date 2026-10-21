# Proyecto Integrador IV — MoviGo (Managua)

Este repositorio contiene el proyecto integrador de Ingeniería en Ciencia de Datos enfocado en la **Evaluación del Esquema de Tarificación Dinámica y Optimización Territorial del Servicio de Transporte Selectivo MoviGo en el Municipio de Managua**, analizando sensibilidad de demanda, equilibrio numérico, mitigación de cancelaciones y equidad socio-espacial.

---

## 📁 Estructura del Repositorio

El repositorio separa claramente la **documentación y presentación académica** (contenida íntegramente en [`typst/`](./typst)) del futuro pipeline de ingeniería de datos (Python, dbt, PostgreSQL):

```text
integrador-four/
├── typst/                  # Módulo unificado de Typst (documento + diapositivas)
│   ├── document.typ        # Entrada del informe de investigación -> typst/document.pdf
│   ├── slides.typ          # Entrada de las diapositivas de defensa -> typst/slides.pdf
│   ├── metadata.typ        # Metadatos compartidos (autores, ORCID, tutor, institución)
│   ├── references.bib      # Bibliografía compartida BibTeX (@alonsomora2017, etc.)
│   ├── assets/             # Recursos gráficos compartidos (unan-logo.jpg, judc-logo.png)
│   ├── data/               # Datos compartidos consumidos por informe y diapositivas
│   │   └── zonas.json      # Catálogo de zonas urbanas y tarifas base de Managua
│   ├── document/           # Estructura del documento académico
│   │   ├── template.typ    # Plantilla de informe (portada, márgenes, estilos, callouts)
│   │   └── chapters/       # 7 capítulos modulares (01_contexto.typ a 07_metodologia.typ)
│   └── slides/             # Estructura de las diapositivas de defensa
│       ├── template.typ    # Plantilla Touying (tarjetas, métricas, flujos)
│       └── 01_cover.typ... # 11 diapositivas modulares con notas de defensa
├── justfile                # Automatización de tareas (build, watch, API, datos)
├── README.md               # Documentación general del repositorio
└── movigo_information.md   # Especificación de la API REST sintética de MoviGo
```

---

## 🚀 Inicio Rápido

### Automatización con `just` (Recomendado)
El proyecto incluye un [`justfile`](./justfile) con atajos para todas las tareas:

```bash
just                  # Ver lista de todos los comandos disponibles

# Compilación Completa Typst
just build-all        # Compila typst/document.pdf y typst/slides.pdf

# Documento de Investigación (Typst)
just build-doc        # Compilar el PDF del informe (typst/document.pdf)
just watch-doc        # Live reload del informe en tiempo real (< 30ms)
just info-doc         # Ver páginas y metadatos del PDF del informe

# Diapositivas de Presentación (Typst)
just build-slides     # Compilar las diapositivas (typst/slides.pdf)
just watch-slides     # Live reload de las diapositivas en tiempo real
just info-slides      # Ver metadatos y páginas de las diapositivas

# Datos Compartidos y API
just api-check        # Verificar conectividad con la API REST pública
just api-status       # Conteo en vivo de registros en los 7 endpoints de MoviGo
just fetch-zones      # Actualizar typst/data/zonas.json desde la API en vivo

# Limpieza
just clean            # Limpiar PDFs compilados en typst/
```
