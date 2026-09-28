# Proyecto Integrador IV — MoviGo (Managua)

Este repositorio contiene el proyecto integrador de Ingeniería en Ciencia de Datos enfocado en la **Evaluación y Calibración del Esquema de Tarificación Dinámica del Servicio de Transporte Selectivo MoviGo en el Municipio de Managua**, analizando sensibilidad de demanda, equilibrio numérico, mitigación de cancelaciones y equidad socio-espacial.

---

## 📁 Estructura del Repositorio

```text
integrador-four/
├── document/               # Documento académico de investigación en Typst (Code-First)
│   ├── main.typ            # Archivo raíz y orquestador del documento
│   ├── template.typ        # Plantilla académica (márgenes, tipografía, portada)
│   ├── references.bib      # Referencias bibliográficas BibTeX (@cachon2017, etc.)
│   ├── data/               # Datos locales consumidos por el documento (ej. zonas.json)
│   └── chapters/           # 7 capítulos modulares independientes
├── slides/                 # Proyecto frontend de presentación interactiva (Vite + Vue 3)
│   ├── index.html          # Entrada de la presentación
│   ├── vite.config.js      # Configuración del servidor de desarrollo
│   ├── src/                # Componentes Vue, vistas de diapositivas y estilos
│   └── package.json        # Dependencias (Vue 3, Pinia, KaTeX, Mermaid)
└── movigo_information.md   # Especificación de la API REST sintética de MoviGo
```

---

## 🚀 Inicio Rápido

### 1. Compilar el Documento de Investigación (Typst)
```bash
# Modo desarrollo con recarga en vivo:
cd document
typst watch main.typ informe_movigo.pdf

# Compilación directa de entrega:
typst compile main.typ informe_movigo.pdf
```

### 3. Automatización con `just` (Recomendado)
El proyecto incluye un [`justfile`](./justfile) con atajos para todas las tareas frecuentes:

```bash
just                  # Ver lista de todos los comandos disponibles

# Documentación (Typst)
just watch-doc        # Live reload del PDF (< 30ms)
just build-doc        # Compilar el PDF una sola vez
just info-doc         # Ver páginas y metadatos del PDF compilado

# Datos y API
just api-status       # Conteo en vivo de registros en los 7 endpoints
just fetch-zones      # Actualizar document/data/zonas.json desde la API

# Diapositivas (Vite + Vue)
just slides-dev       # Iniciar servidor local de presentación
just slides-build     # Compilar presentación para producción

# Limpieza
just clean            # Limpiar temporales y artefactos de compilación
```
