# Matriz de Integración Curricular — Proyecto Integrador IV (MoviGo 2024)

**Carrera:** Ingeniería en Ciencia de Datos  
**Facultad:** Ciencias e Ingenierías | **Departamento:** Matemática | **Institución:** UNAN-Managua  
**Proyecto:** *Modelación del Impacto de la Tarifa Dinámica sobre la Tasa de Cancelación de Viajes en el Servicio MoviGo en Managua (2024)*  
**Ubicación Documental:** `doc/curricular_integration.md`  
**Referencia de Syllabi:** [`doc/class_context/`](class_context/README.md)

---

## 1. Justificación y Propósito Académico

El **Proyecto Integrador IV** constituye el espacio de síntesis formativa del segundo año (IV Semestre) de la carrera de Ingeniería en Ciencia de Datos. Su propósito institucional es evidenciar la capacidad del estudiante para articular, en un caso de estudio real de movilidad metropolitana (*MoviGo*, Managua), los conocimientos teórico-prácticos adquiridos a lo largo del semestre, complementados con la base transaccional del III Semestre.

Para mantener la naturalidad y el estándar de publicación formal del artículo científico (*paper* en Typst), las menciones escolares directas ("asignaturas", "semestres") se omiten en el cuerpo del manuscrito y se consolidan en este documento para fines de evaluación y auditoría docente.

---

## 2. Matriz Maestra de Articulación Curricular

| Componente Curricular | Semestre / Horas | Unidad del Programa Oficial (`doc/class_context/`) | Competencias y Temas Evaluados | Implementación Técnica en el Repositorio | Sección Metodológica en el Paper |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Bases de Datos Relacionales** | III (135 h) | • Modelo relacional y 3NF<br>• Claves `PK`/`FK`, `CHECK`<br>• Transaccionalidad ACID en PostgreSQL | Diseñar esquemas transaccionales normalizados e íntegros para el almacenamiento seguro de datos brutos. | • [`pipeline/sql/raw_schema.sql`](../pipeline/sql/raw_schema.sql)<br>• Carga modular `loader.py` en Azure PostgreSQL (esquema `raw`)<br>• 7 tablas fuente tipadas | Cap. 6.4 (Paradigma ELT y Capa Cruda)<br>Cap. 7.2 (Fase 1: Carga Relacional) |
| **Diseño y Uso de Bases de Datos Analíticas** | IV (135 h) | • Data Warehouse vs. OLTP<br>• Factoría de Información Corporativa (FIC)<br>• Metodología Kimball (esquema estrella)<br>• Motor OLAP columnar (DuckDB)<br>• Pruebas de calidad y linaje | Diseñar modelos multidimensionales, estructurar capas staging y marts en dbt Core, y ejecutar analítica OLAP de alto rendimiento. | • Modelos dbt en [`pipeline/dbt/`](../pipeline/dbt/)<br>• Snapshot en `pipeline/data/analytics.duckdb`<br>• Pruebas automáticas (`unique`, `not_null`, `relationships`)<br>• Consultas OLAP de agregación | Cap. 6.5 (Modelado Kimball)<br>Cap. 7.2 (Fase 1: Capas Staging y Marts)<br>Diagrama ERD y tabla de hechos |
| **Optimización** | IV (135 h) | • Teoría de grafos y redes viales $G=(V, E)$<br>• Centralidad de intermediación (*Betweenness*)<br>• Algoritmo de la Ruta Más Corta (Dijkstra)<br>• Análisis de resiliencia y contingencias pluviales | Formular problemas de redes espaciales, calcular métricas de centralidad para detectar cuellos de botella e implementar algoritmos de camino mínimo ante perturbaciones exógenas. | • [`pipeline/analysis/03_optimization.py`](../pipeline/analysis/03_optimization.py)<br>• Red vial de Managua: 24 zonas y 44 corredores<br>• Top cuellos de botella: Ciudad Jardín ($C_B = 0.419$), Bolonia ($C_B = 0.371$)<br>• Dijkstra: Rerouting y retrasos (+42.8% global metropolitano) | Cap. 6.6 (Optimización Espacial en Redes)<br>Cap. 7.2 (Fase 2: Ruteo y Resiliencia en Grafos) |
| **Programación en Scripting** | IV (135 h) | • Filosofía Linux y shell scripting en Bash<br>• Control estricto (`set -euo pipefail`, exit codes)<br>• Orquestación reproducible mediante `justfile`<br>• Entorno virtual hermético (`uv`) y tipado estático (`basedpyright`) | Construir pipelines reproducibles automatizados en Linux, manipular flujos masivos de datos y orquestar tareas end-to-end sin intervención manual. | • [`justfile`](../justfile)<br>• [`pipeline/hydrate_paper_data.sh`](../pipeline/hydrate_paper_data.sh)<br>• Ingesta en `fetcher.py` con paginación dinámica<br>• `basedpyright` estricto (0 errores) | Cap. 6.6.4 (Arquitectura DataOps)<br>Cap. 7.3 (Ecosistema Computacional Data-to-Document) |
| *Estadística II* | IV (135 h) | *(En redefinición / Pendiente de reimplementación técnica)* | Módulo desacoplado en preparación para una nueva formulación de regresión simple y modelado. | *(Pendiente de nueva implementación técnica)* | *(En redefinición)* |
| *Métodos Numéricos* | IV (135 h) | *(En redefinición / Pendiente de reimplementación técnica)* | Módulo desacoplado en preparación para una nueva formulación mediante machine learning con diferencias al cuadrado. | *(Pendiente de nueva implementación técnica)* | *(En redefinición)* |

---

## 3. Síntesis de Evidencias por Componente para la Evaluación Docente

### 3.1 Bases de Datos Relacionales (Semestre III)
- **Evidencia en Repositorio:** `pipeline/sql/raw_schema.sql` y `pipeline/src/loader.py`.
- **Rúbrica Evaluada:** Cumplimiento de Tercera Forma Normal (3NF), claves foráneas con acciones referenciales, restricciones de dominio `CHECK` (ej. tarifas no negativas, coordenadas dentro del municipio de Managua) y uso de TLS/SSL para la conexión a Azure PostgreSQL.

### 3.2 Diseño y Uso de Bases de Datos Analíticas (Semestre IV)
- **Evidencia en Repositorio:** Directorio `pipeline/dbt/` (`models/staging` y `models/marts`), archivo de snapshot `pipeline/data/analytics.duckdb` y suites de prueba en YAML (`_marts__models.yml`).
- **Rúbrica Evaluada:** Implementación de metodología Kimball: tabla de hechos `fct_viajes` a grano atómico por viaje ($N = 77,036$), dimensiones conformadas desacopladas con llaves subrogadas hash MD5, y ejecución de consultas analíticas OLAP en DuckDB con tiempos submilisegundo.

### 3.3 Estadística II (Semestre IV)
- **Estado:** Componente desacoplado del repositorio activo. La formulación preliminar ha sido retirada para permitir una reconstrucción limpia e integral bajo el nuevo enfoque que se defina.

### 3.4 Métodos Numéricos (Semestre IV)
- **Estado:** Componente desacoplado del repositorio activo. Se retiró la búsqueda unidimensional y multidimensional para preparar una reimplementación limpia desde cero con un enfoque de machine learning basado en diferencias al cuadrado (mínimos cuadrados) para regresión simple.

### 3.5 Optimización (Semestre IV)
- **Evidencia en Repositorio:** `pipeline/analysis/03_optimization.py`, dataset `typst/data/routing_optimization.json`, mapas `typst/graphs/urban_network_topology.png` y `urban_network_dijkstra.png`.
- **Rúbrica Evaluada:** Modelación de redes espaciales mediante teoría de grafos ($|V|=24, |E|=44$), análisis de Centralidad de Intermediación (*Betweenness Centrality*) para detección de cuellos de botella (Ciudad Jardín $C_B = 0.419$, Bolonia $C_B = 0.371$), y aplicación del algoritmo de Dijkstra sobre 552 pares OD para evaluar resiliencia vial y demoras (+42.8% global) ante inundación de cauces.

### 3.6 Programación en Scripting (Semestre IV)
- **Evidencia en Repositorio:** `justfile`, `pipeline/hydrate_paper_data.sh`, `pyrightconfig.json` y configuración de entorno virtual con `uv`.
- **Rúbrica Evaluada:** Uso profesional de la terminal Linux, automatización de flujos de datos sin interacción manual, control riguroso de errores (`set -euo pipefail`), tipado estático con Basedpyright (0 errores) y enlace directo Data-to-Document en Typst compilando en $< 7$ segundos.
