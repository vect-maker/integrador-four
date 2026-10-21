# Proyecto Integrador IV — MoviGo (Managua)

Este repositorio contiene el proyecto integrador de Ingeniería en Ciencia de Datos enfocado en la **Evaluación y Calibración del Esquema de Tarificación Dinámica del Servicio de Transporte Selectivo MoviGo en el Municipio de Managua**, analizando sensibilidad de demanda, equilibrio numérico, mitigación de cancelaciones y equidad socio-espacial.

---

## 📁 Estructura del Repositorio

El proyecto está diseñado bajo un paradigma **Typst-first**, eliminando dependencias de Node.js y compilando tanto el informe académico como las diapositivas de defensa directamente con Typst:

```text
integrador-four/
├── document/               # Documento académico de investigación en Typst
│   ├── main.typ            # Archivo raíz y orquestador del documento
│   ├── template.typ        # Plantilla académica (márgenes, tipografía, portada)
│   ├── references.bib      # Referencias bibliográficas BibTeX (@cachon2017, etc.)
│   ├── data/               # Datos locales consumidos por el documento (ej. zonas.json)
│   └── chapters/           # 7 capítulos modulares independientes
├── slides/                 # Diapositivas de defensa de avance en Typst (Touying)
│   ├── main.typ            # Entrada de la presentación (tema metropolis 16:9)
│   ├── template.typ        # Componentes reutilizables (tarjetas, métricas, flujos)
│   └── slides/             # 11 diapositivas modulares con notas de defensa y datos
├── justfile                # Automatización de compilación y llamadas a API
└── movigo_information.md   # Especificación de la API REST sintética de MoviGo
```

---

## 🚀 Inicio Rápido

### Automatización con `just` (Recomendado)
El proyecto incluye un [`justfile`](./justfile) con atajos para todas las tareas:

```bash
just                  # Ver lista de todos los comandos disponibles

# Documento de Investigación (Typst)
just build-doc        # Compilar el PDF del informe (document/document.pdf)
just watch-doc        # Live reload del informe en tiempo real (< 30ms)
just info-doc         # Ver páginas y metadatos del PDF del informe

# Diapositivas de Presentación (Typst)
just build-slides     # Compilar las diapositivas (slides/slides.pdf)
just watch-slides     # Live reload de las diapositivas en tiempo real
just info-slides      # Ver metadatos y páginas de las diapositivas

# Todo en uno
just build-all        # Compila tanto el informe como las diapositivas

# Datos y API
just api-check        # Verificar conectividad con la API REST pública
just api-status       # Conteo en vivo de registros en los 7 endpoints
just fetch-zones      # Actualizar document/data/zonas.json desde la API

# Limpieza
just clean            # Limpiar PDFs generados
```
