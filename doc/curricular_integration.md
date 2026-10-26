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
| **Estadística II** | IV (135 h) | • Muestreo e inferencia<br>• Regresión Lineal Simple (MCO)<br>• Descomposición ANOVA<br>• Pruebas $t$ y $F$ de significancia global | Formular modelos de regresión lineal, verificar la bondad de ajuste ($R^2$) y evaluar la significancia de la pendiente mediante contrastes de hipótesis. | • [`pipeline/analysis/01_econometrics.py`](../pipeline/analysis/01_econometrics.py)<br>• MCO Simple ($Y = \text{TasaCancelacion}$, $X = \overline{m}$, $R^2 = 0.623$)<br>• Tabla ANOVA ($F = 601.53$, $p < 0.0001$)<br>• Gráfico `regression_fit.png` | Cap. 6.6.1 (Modelación Econométrica MCO)<br>Cap. 7.2 (Fase 2: Modelación MCO) |
| **Métodos Numéricos** | IV (135 h) | • Ecuaciones no lineales $f(x)=0$<br>• Métodos cerrados: Bisección (orden 1, Teorema de Bolzano)<br>• Métodos abiertos: Newton-Raphson (orden 2, uso de derivadas)<br>• Control de errores ($\epsilon = 10^{-6}$) | Formular funciones continuas no lineales, aproximar raíces numéricas iterativas y evaluar la velocidad y estabilidad algorítmica. | • [`pipeline/analysis/02_numerical_methods.py`](../pipeline/analysis/02_numerical_methods.py)<br>• Balance de mercado: $f(m) = D(m) - S(m) = 0$<br>• Bisección (21 iter.) vs. Newton-Raphson (3 iter., $7\times$ speedup)<br>• Raíz $m^* = 1.3476\times$ ($Q^* = 175.5$ v/h) | Cap. 6.6.2 (Análisis Numérico de Raíces)<br>Cap. 7.2 (Fase 3: Búsqueda de Raíces) |
| **Optimización** | IV (135 h) | • Teoría de grafos y redes viales $G=(V, E)$<br>• Matriz de impedancia temporal $tau_{ij}$<br>• Algoritmo de la Ruta Más Corta (Dijkstra)<br>• Análisis de resiliencia y contingencias pluviales | Formular problemas de redes de transporte, implementar algoritmos de camino mínimo y evaluar la sensibilidad operativa ante choques exógenos. | • [`pipeline/analysis/03_optimization.py`](../pipeline/analysis/03_optimization.py)<br>• Grafo de 12 nodos y 22 aristas viales de Managua<br>• Escenarios Seco vs. Tormenta (inundación)<br>• Dijkstra: Rerouting y retrasos (+49.3% en OD 1) | Cap. 6.6.3 (Optimización Espacial en Redes)<br>Cap. 7.2 (Fase 4: Ruteo en Grafos) |
| **Programación en Scripting** | IV (135 h) | • Filosofía Linux y shell scripting en Bash<br>• Control estricto (`set -euo pipefail`, exit codes)<br>• Orquestación reproducible mediante `justfile`<br>• Entorno virtual hermético (`uv`) y tipado estático (`basedpyright`) | Construir pipelines reproducibles automatizados en Linux, manipular flujos masivos de datos y orquestar tareas end-to-end sin intervención manual. | • [`justfile`](../justfile)<br>• [`pipeline/hydrate_paper_data.sh`](../pipeline/hydrate_paper_data.sh)<br>• Ingesta en `fetcher.py` con paginación dinámica<br>• `basedpyright` estricto (0 errores) | Cap. 6.6.4 (Arquitectura DataOps)<br>Cap. 7.3 (Ecosistema Computacional Data-to-Document) |

---

## 3. Síntesis de Evidencias por Componente para la Evaluación Docente

### 3.1 Bases de Datos Relacionales (Semestre III)
- **Evidencia en Repositorio:** `pipeline/sql/raw_schema.sql` y `pipeline/src/loader.py`.
- **Rúbrica Evaluada:** Cumplimiento de Tercera Forma Normal (3NF), claves foráneas con acciones referenciales, restricciones de dominio `CHECK` (ej. tarifas no negativas, coordenadas dentro del municipio de Managua) y uso de TLS/SSL para la conexión a Azure PostgreSQL.

### 3.2 Diseño y Uso de Bases de Datos Analíticas (Semestre IV)
- **Evidencia en Repositorio:** Directorio `pipeline/dbt/` (`models/staging` y `models/marts`), archivo de snapshot `pipeline/data/analytics.duckdb` y suites de prueba en YAML (`_marts__models.yml`).
- **Rúbrica Evaluada:** Implementación de metodología Kimball: tabla de hechos `fct_viajes` a grano atómico por viaje ($N = 77,036$), dimensiones conformadas desacopladas con llaves subrogadas hash MD5, y ejecución de consultas analíticas OLAP en DuckDB con tiempos submilisegundo.

### 3.3 Estadística II (Semestre IV)
- **Evidencia en Repositorio:** `pipeline/analysis/01_econometrics.py`, dataset de resultados `typst/data/econometric_regression.json` y figura `typst/graphs/regression_fit.png`.
- **Rúbrica Evaluada:** Formulación y estimación del modelo de regresión lineal simple por Mínimos Cuadrados Ordinarios ($Y = \text{tasa\_cancelacion}$, $X = \overline{m}$), cuantificando $R^2 = 0.623$, $r = 0.789$, estadístico $t = 24.53$ ($p < 0.0001$), y descomposición de variabilidad mediante tabla ANOVA formal ($F = 601.53$).

### 3.4 Métodos Numéricos (Semestre IV)
- **Evidencia en Repositorio:** `pipeline/analysis/02_numerical_methods.py`, dataset `typst/data/numerical_methods.json`, figuras `market_equilibrium_curves.png` y `numerical_convergence.png`.
- **Rúbrica Evaluada:** Formulación no lineal de la función de exceso de demanda $f(m) = 220 e^{-0.65(m-1)} - 140(1 + 0.85 \ln m) = 0$, contrastando la convergencia lineal del método de la Bisección (21 iteraciones) frente a la convergencia cuadrática del método de Newton-Raphson (3 iteraciones, aceleración de $7\times$) bajo tolerancia $\epsilon = 10^{-6}$.

### 3.5 Optimización (Semestre IV)
- **Evidencia en Repositorio:** `pipeline/analysis/03_optimization.py`, dataset `typst/data/routing_optimization.json` y mapa `typst/graphs/urban_network_dijkstra.png`.
- **Rúbrica Evaluada:** Modelación de redes espaciales mediante teoría de grafos ($|V|=12, |E|=22$), definición de funciones de impedancia temporal condicionadas por meteorología, y aplicación del algoritmo de Dijkstra para cuantificar la dilatación de tiempos (+49.3%) y el desvío obligatorio hacia Metrocentro por anegamiento de cauces en la Pista Juan Pablo II.

### 3.6 Programación en Scripting (Semestre IV)
- **Evidencia en Repositorio:** `justfile`, `pipeline/hydrate_paper_data.sh`, `pyrightconfig.json` y configuración de entorno virtual con `uv`.
- **Rúbrica Evaluada:** Uso profesional de la terminal Linux, automatización de flujos de datos sin interacción manual, control riguroso de errores (`set -euo pipefail`), tipado estático con Basedpyright (0 errores) y enlace directo Data-to-Document en Typst compilando en $< 7$ segundos.
