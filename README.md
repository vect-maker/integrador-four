# Proyecto Integrador IV — MoviGo (Managua)

Este repositorio contiene la investigación de grado en Ingeniería en Ciencia de Datos: **Modelación del Impacto de la Tarifa Dinámica sobre la Tasa de Cancelación de Viajes en el Servicio MoviGo en Managua (2024)**, abordando sensibilidad econométrica, equilibrio de mercado, optimización vial ante eventos meteorológicos y reproducibilidad científica estricta (*Data-to-Document*).

---

## 📋 Requisitos del Sistema y Entorno de Ejecución

Para garantizar la máxima velocidad y reproducibilidad sin sobrecargar el sistema, el proyecto separa claramente qué se ejecuta nativamente en el host y qué requiere contenedor:

1. **Gestor de Entornos Python (`uv`):**
   - Todos los scripts de extracción (`fetcher.py`), carga relacional (`loader.py`) y modelado analítico (`pipeline/analysis/*.py`) se ejecutan **directamente en el host dentro del entorno virtual `.venv`**, sin contenedor.
   - Es necesario tener [`uv`](https://docs.astral.sh/uv/) instalado en el sistema.
   - Si no tienes `uv`, la receta `just setup-env` **lo descargará e instalará automáticamente** en tu usuario (`~/.local/bin`).

2. **Automatizador de Tareas (`just`):**
   - Utilizado como interfaz unificada para compilar documentos, correr análisis y gestionar datos.

3. **Compilador Científico (`typst`):**
   - Requerido para compilar el paper académico (`typst/document.pdf`) y las diapositivas (`typst/slides.pdf`).

4. **Contenedor Podman / Docker (Únicamente para dbt):**
   - El uso de contenedores está **estrictamente limitado** al contenedor oficial de dbt Labs (`ghcr.io/dbt-labs/dbt-postgres`) para compilar los modelos del *Star Schema* en PostgreSQL (`just dbt ...`). Los scripts de Python no utilizan contenedores.

---

## 🚀 Inicio Rápido

### 1. Configurar el Entorno Python
Crea el entorno virtual e instala todas las dependencias científicas (`pandas`, `statsmodels`, `scipy`, `networkx`, `matplotlib`, `duckdb`):

```bash
just setup-env
```

> **Nota:** Si `uv` no está presente en tu `$PATH`, la receta lo instalará automáticamente desde su instalador oficial de Astral.

### 2. Ejecutar Modelos Analíticos
Los scripts analíticos leen directamente el snapshot analítico local de DuckDB (`pipeline/data/analytics.duckdb`) y exportan métricas JSON y gráficos vectoriales SVG:

```bash
# Ejecutar modelo econométrico MCO y tabla ANOVA
just run-econometrics

# Hidratar y refrescar todos los datos agregados en typst/data/
just hydrate-data
```

### 3. Compilar el Documento de Investigación y Diapositivas
Compila las publicaciones académicas con enlace dinámico de datos (*single source of truth*, 0 error humano):

```bash
just build-all      # Compila document.pdf y slides.pdf
just build-doc      # Compilar únicamente el paper (typst/document.pdf)
just watch-doc      # Live reload del paper en tiempo real (< 30ms)
just build-slides   # Compilar únicamente las diapositivas (typst/slides.pdf)
```

---

## 📁 Estructura del Repositorio

```text
movigo-analytics/
├── doc/                        # Documentación central y notas técnicas
│   ├── paper_completion_roadmap.md  # Hoja de ruta maestra, especificaciones y plan de hitos
│   ├── movigo_information.md        # Especificación técnica de la API REST sintética
│   └── README.md                    # Índice del directorio de documentación
├── pipeline/                   # Pipeline ELT y suite de análisis computacional
│   ├── analysis/               # Scripts de modelado científico (Python nativo en .venv)
│   │   └── 01_econometrics.py  # Regresión MCO, ANOVA, diagnósticos y gráfico SVG
│   ├── dbt/                    # Proyecto dbt Core (capas staging y marts / Star Schema)
│   ├── sql/                    # Consultas SQL modulares de hidratación analítica
│   ├── data/                   # Datos locales (raw parquet y snapshot analytics.duckdb)
│   ├── fetcher.py              # Ingesta paginada desde la API REST
│   ├── loader.py               # Carga transaccional en Azure PostgreSQL
│   ├── snapshot_duckdb.sh      # Extractor del snapshot columnar local
│   ├── hydrate_paper_data.sh   # Orquestador de exportación JSON/SVG
│   └── requirements.txt        # Especificación de dependencias Python con uv
├── typst/                      # Módulo de maquetación y renderizado dinámico
│   ├── document.typ            # Punto de entrada del paper -> typst/document.pdf
│   ├── slides.typ              # Punto de entrada de diapositivas -> typst/slides.pdf
│   ├── data_bindings.typ       # Enlace centralizado de variables JSON relativas
│   ├── data/                   # Datasets JSON tipados (fuente única de verdad)
│   ├── graphs/                 # Figuras vectoriales SVG generadas programáticamente
│   ├── tables/                 # Tablas modulares en Typst
│   ├── document/               # Capítulos modulares del paper científico
│   └── slides/                 # Diapositivas modulares Touying
├── justfile                    # Automatización de tareas de compilación y datos
└── README.md                   # Documentación general del repositorio
```

---

## 🛠️ Catálogo Completo de Comandos (`just`)

Ejecuta `just` o `just --list` en la raíz del repositorio para ver todas las recetas disponibles:

| Comando | Descripción |
| :--- | :--- |
| `just setup-env` | Prepara el entorno virtual `.venv` con `uv` e instala dependencias científicas. |
| `just build-all` | Compila tanto el paper (`document.pdf`) como las diapositivas (`slides.pdf`). |
| `just build-doc` | Compila el informe de investigación a PDF. |
| `just watch-doc` | Modo observador con recarga en vivo para el informe (< 30ms). |
| `just build-slides` | Compila las diapositivas de defensa a PDF. |
| `just watch-slides` | Modo observador con recarga en vivo para las diapositivas. |
| `just pipeline-fetch` | Extrae las colecciones paginadas de la API REST a archivos Parquet. |
| `just pipeline-load` | Carga el esquema DDL y los datos Parquet en Azure PostgreSQL. |
| `just dbt [args]` | Ejecuta comandos de dbt (`run`, `test`, `debug`) mediante Podman. |
| `just duckdb-snapshot`| Descarga y actualiza el snapshot local `analytics.duckdb` desde PostgreSQL. |
| `just run-econometrics`| Ejecuta el modelo MCO, tabla ANOVA, exporta JSON y gráfico SVG. |
| `just hydrate-data` | Purga y refresca todos los archivos JSON en `typst/data/`. |
| `just duckdb` | Inicia la consola interactiva CLI de DuckDB sobre el snapshot analítico. |
| `just duckdb-sql "..."`| Ejecuta una consulta SQL rápida sobre el snapshot local. |
