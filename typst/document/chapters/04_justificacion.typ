#show bibliography: none
#bibliography("../../references.bib")

= Justificación

== Justificación Práctica: Sostenibilidad Económica y Retención de Clientes para MoviGo

La presente investigación se fundamenta en la necesidad operativa de sustituir la calibración empírica y reactiva de tarifas en la plataforma *MoviGo* por un modelo de tarificación y gestión de oferta sustentado en evidencia matemática y econométrica. En el modelo de negocio de las aplicaciones de transporte selectivo, el esquema tarifario dinámico representa tanto la principal fuente de ingresos como el factor determinante de la experiencia del usuario y del conductor @cachon2017.

A partir del análisis de los *77,386 registros históricos de viajes* y las series meteorológicas expuestas a través de la API REST, este proyecto aporta beneficios concretos a la gestión empresarial de MoviGo:
- *Mitigación de Ingresos Perdidos por Cancelación:* Identifica los umbrales críticos del multiplicador dinámico a partir de los cuales la probabilidad de cancelación por parte del usuario se dispara, cuantificando el costo de las cotizaciones perdidas.
- *Reducción del Desabastecimiento en Horas Pico:* Diagnostica las brechas de oferta en los corredores más saturados de Managua, determinando cuándo la tarifa regular resulta insuficiente para activar la conexión de conductores.
- *Optimización de Presupuestos Operativos:* Provee un marco riguroso para asignar los fondos destinados a programas de incentivos para socios conductores, sustituyendo el aumento ciego de tarifas por subsidios orientados a objetivos medibles de conexión.

== Relevancia Científica y Metodológica: Métodos Numéricos y Econometría del Surge Pricing

Desde el punto de vista científico y metodológico, la investigación trasciende la mera analítica descriptiva para articular herramientas formales de *econometría, análisis numérico e investigación de operaciones*:

+ *Modelación Econométrica e Inferencia Rigurosa:* Cuantifica formalmente el impacto del multiplicador de tarifa dinámica sobre la tasa de cancelación mediante regresión lineal simple (MCO) y análisis de varianza (ANOVA), contrastando la significancia global del modelo mediante la prueba $F$ y midiendo la variabilidad explicada ($R^2$).
+ *Aproximación Numérica del Punto de Equilibrio:* Aborda la calibración tarifaria mediante métodos de búsqueda de raíces no lineales (*Bisección y Newton-Raphson*), resolviendo numéricamente la función de exceso de demanda:
  $ f(m) = "Demanda"(m) - "Oferta"(m) = 0 $
  para identificar el umbral de multiplicador óptimo ($m^* = 1.35times$) y comparando la eficiencia algorítmica y orden de convergencia entre ambos métodos.
+ *Optimización Espacial de Redes y Teoría de Grafos:* Modela la red vial urbana de los 12 cuadrantes de Managua como un grafo ponderado $G = (V, E)$, aplicando el *Algoritmo de Dijkstra* para evaluar el impacto de perturbaciones climáticas e inundaciones sobre los tiempos de viaje y desvíos obligados, identificando el estrangulamiento físico que detona cancelaciones de servicio.

== Relevancia Tecnológica y Arquitectura de Ingeniería de Datos (ELT con dbt)

En el ámbito tecnológico, el proyecto resuelve un desafío propio de los entornos de datos contemporáneos: *la inexistencia de acceso directo a la base de datos transaccional y la obligatoriedad de consumir los datos exclusivamente mediante una API REST paginada*.

El pipeline tecnológico implementado demuestra un diseño DataOps escalable y profesional:
+ *Extracción Modular y Paginación Robusta:* Cliente en Python (`httpx`/`requests`) diseñado para consumir colecciones paginadas (`limit=200`, `offset` dinámico), validando esquemas y computando sumas criptográficas *SHA-256* para auditoría y trazabilidad de los datos brutos.
+ *Capa Cruda en Azure PostgreSQL:* Ingesta, normalización relacional y persistencia de los 7 endpoints de la plataforma MoviGo en el esquema `raw` alojado en la base de datos `postgres` de *Azure Database for PostgreSQL*.
+ *Modelado Dimensional y Transformación con dbt Core:* Construcción de un Data Warehouse bajo metodología Kimball mediante *dbt (Data Build Tool)*, desacoplando staging y marts analíticos, con llaves subrogadas hash (MD5) y una batería exhaustiva de pruebas automáticas de calidad (_dbt tests_) que validan reglas de negocio (`multiplicador_dinamico >= 1.00`, tarifas positivas y unicidad referencial) @kimball2013.

== Relevancia Social y Equidad Territorial en el Municipio de Managua

En términos de impacto social, la investigación incide directamente en la equidad urbana y la justicia algorítmica. De acuerdo con el Plan Maestro de Movilidad Urbana de Managua @jica2017, más de una cuarta parte (26%) de los viajes diarios en la capital se realizan en transporte selectivo, constituyendo un modo de transporte vital para la clase trabajadora, estudiantes y comerciantes que conectan periferias con centros neurálgicos como el Mercado Oriental o Metrocentro.

Un algoritmo de tarifa dinámica descalibrado actúa como una barrera económica excluyente que expulsa a las familias de menores ingresos en momentos de vulnerabilidad (lluvias torrenciales o emergencias). Calibrar la tarifa con consideraciones de equidad socio-espacial y evaluar la correlación entre el estrato económico, el medio de pago preferido (`efectivo`, `tarjeta`, `billetera_digital`) y la propensión a la cancelación garantiza un servicio más accesible e inclusivo para la ciudadanía de Managua.

== Articulación Interdisciplinaria en Ciencia de Datos

La presente investigación demuestra la sinergia práctica de la ciencia de datos aplicada a la movilidad metropolitana, articulando armónicamente diferentes frentes técnicos y analíticos en torno a un hilo conductor común:

- *Ingeniería y Almacenamiento Analítico:* Arquitectura ELT, diseño dimensional en estrella bajo metodología Kimball (`fct_viajes` atómica y dimensiones conformadas), transformaciones con *dbt Core* y motor OLAP columnar en proceso con *DuckDB*.
- *Automatización y Reproducibilidad Computacional:* Automatización de ingesta desde API REST paginada, scripts Bash estructurados (`set -euo pipefail`), orquestación mediante `justfile`, entorno reproducible con `uv` y verificación estática con `basedpyright`.
- *Modelado Econométrico e Inferencial:* Estimación de regresión lineal simple por MCO ($R^2 = 0.62$), descomposición ANOVA y prueba de significancia global $F$.
- *Análisis y Simulación Numérica:* Modelación no lineal del exceso de demanda ($f(m)=0$), resolución iterativa por Bisección vs. Newton-Raphson y evaluación de órdenes de convergencia.
- *Investigación de Operaciones y Redes:* Teoría de grafos, modelado de red vial urbana y algoritmo de Dijkstra para cuantificar retrasos y desvíos forzados ante contingencias pluviales.
- *Persistencia Transaccional Relacional:* Diseño relacional normalizado (3NF) y almacenamiento estructurado en la nube sobre Azure Database for PostgreSQL.
