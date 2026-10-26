#show bibliography: none
#bibliography("../../references.bib")
#import "../../snippets.typ": (
  fig-raw-ddl,
  fig-loader-azure,
  fig-fct-viajes,
  fig-marts-models,
)
#import "../../diagrams/star_schema.typ": fig-star-schema
#import "../../tables/star_schema.typ": fig-star-schema-table
#import "../../data_bindings.typ": total-trips-fmt, total-zones, total-campaigns
#import "../../metadata.typ": repo-url

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los cuatro objetivos de la investigación, articulando la ingeniería de datos, la econometría, los métodos numéricos y la optimización prescriptiva.

== Enfoque, Tipo y Alcance

- *Enfoque Mixto (con predominio cuantitativo):* De acuerdo con la tipología metodológica de @sampieri2014, la investigación adopta un diseño mixto donde convergen el rigor analítico formal del modelado econométrico (MCO), la aproximación numérica de equilibrio y la optimización en redes viales sobre $N = #total-trips-fmt$ registros transaccionales, complementado con la contextualización cualitativa y socio-espacial de los estratos urbanos, las barreras de bancarización y la vulnerabilidad ante anegamientos en Managua.
- *Diseño No Experimental y Longitudinal:* Se observan transacciones operativas y registros meteorológicos a lo largo del ciclo anual 2024 ($n = 366$ días), sin manipulación deliberada ni intervención exógena sobre las variables del sistema de transporte.
- *Alcance Mixto (Descriptivo, Correlacional y Prescriptivo):* Trasciende la descripción exploratoria del comportamiento del servicio; cuantifica e infiere la relación estadística entre el multiplicador tarifario y la tasa de cancelación (alcance correlacional), determina numéricamente el punto de equilibrio operativo de mercado y prescribe rutas óptimas de contingencia vial ante disrupciones climáticas (alcance prescriptivo).
- *Unidad de Análisis:* El viaje individual o solicitud de traslado ($N = #total-trips-fmt$ registros), caracterizado por su origen, destino, marca temporal, multiplicador dinámico aplicado, condiciones climáticas concurrentes y estado final de atención o cancelación.

== Fases Metodológicas de la Investigación

=== Fase 1: Pipeline de Datos ELT, Procesamiento y Esquema en Estrella (Objetivo 1)

Para consolidar el repositorio analítico de operaciones 2024 a partir de las fuentes desagregadas de la plataforma MoviGo, se ejecutó integralmente un pipeline de datos moderno bajo el paradigma *ELT (Extract, Load, Transform)* articulado en las siguientes etapas computacionales:

+ *Extracción y Serialización Parquet:* Consumo sistemático de los endpoints de la API REST mediante un cliente en Python (`fetcher.py`) con control dinámico de paginación (`limit=200`, `offset`). Los conjuntos recuperados se serializan en siete archivos columnares *Apache Parquet* (`pipeline/data/raw/*.parquet`: zonas, usuarios, conductores, campañas, clima, viajes y telemetría), garantizando inmutabilidad, reducción volumétrica de almacenamiento y desacoplamiento de la red.

+ *Carga Transaccional Relacional en Azure PostgreSQL:* Despliegue del esquema DDL estricto (`raw_schema.sql`) en el esquema dedicado `raw` de *Azure Database for PostgreSQL*, asegurando tipificación fuerte, restricciones de clave primaria y foránea, así como validaciones de dominio mediante reglas `CHECK` como se ilustra en el @lst-ddl. El script cargador (`loader.py`) aplica casteo de marcas temporales, establece conexión cifrada TLS/SSL y ejecuta inserciones por bloques de 2,000 registros respetando el orden topológico de dependencias (@lst-loader).

+ *Capa de Preparación y Limpieza (Staging en dbt Core):* Implementación de modelos intermedios en dbt materializados como vistas lógicas (`view`) bajo la capa `staging`. En esta fase se homogenizan formatos, se limpian inconsistencias y se realiza ingeniería de características operacional:
  - En `stg_viajes`: segregación de componentes temporales (`fecha_solicitud`, `hora_solicitud`, `dia_semana_iso`), identificación determinística de fines de semana (`es_fin_de_semana`) y horas pico matutinas (07:00--08:59) y vespertinas (17:00--18:59) (`es_hora_pico`), cuantificación del sobrecosto monetario atribuible al surge (`sobrecosto_surge_nio = tarifa_final - tarifa_base`), cálculo del tiempo de espera en minutos hasta el inicio del servicio (`tiempo_espera_minutos`), y binarización rigurosa de las cancelaciones en indicadores analíticos (`es_cancelado`, `es_cancelado_usuario`, `es_cancelado_conductor`, `es_completado`).
  - En `stg_clima`: categorización ordinal de la intensidad de precipitación (`sin lluvia`, `ligera`, `moderada`, `fuerte`) y de los niveles de saturación vial (`baja`, `moderada`, `alta`, `critica`).
  - En `stg_zonas`: derivación del estrato socioeconómico ordinal (`nivel_estrato` de 1 a 4).
  - En `stg_campanias`: cálculo del costo presupuestario unitario por hora adicional de conexión de conductores (`costo_por_hora_conexion`).

+ *Capa Dimensional y Esquema en Estrella (Marts en dbt Core):* Transformación y estructuración de los datos en un *Esquema en Estrella* (_Star Schema_) según la metodología de Ralph Kimball @kimball2013, materializado físicamente como tablas (`table`) en la base de datos para maximizar el rendimiento analítico (OLAP):
  - *Tabla de Hechos Atómica (`fct_viajes`):* Grano atómico de un registro por cada intento o servicio de transporte ($N = #total-trips-fmt$). Integra llaves primarias y foráneas subrogadas conformadas calculadas mediante la función criptográfica `md5(cast(id as text))` (`sk_viaje`, `sk_zona_origen`, `sk_zona_destino`, `sk_conductor`, `sk_usuario`, `sk_clima`), métricas financieras de tarifa dinámica, métricas operacionales de tiempo y distancia, y la variable respuesta dicotómica de cancelación para el modelado econométrico (@lst-fct-viajes).
  - *Dimensiones Conformadas (`dim_zonas`, `dim_clima`, `dim_usuarios`, `dim_conductores`, `dim_campanias`):* Tablas de contexto desacopladas que almacenan respectivamente la estratificación urbana, el régimen meteorológico y de congestión diario, el perfil socio-financiero de pasajeros, el parque vehicular activo y los programas presupuestarios de incentivos (@fig-star-schema y @tbl-star-schema). Destaca en particular `dim_zonas` como dimensión de doble rol (_role-playing dimension_), donde la llave `sk_zona_origen` fija la tarifa base de bajada de bandera del servicio y el estrato socioeconómico de partida, mientras que `sk_zona_destino` delimita el alcance geográfico del trayecto.

+ *Marco de Calidad y Pruebas Automatizadas de Integridad:* Implementación de pruebas declarativas automatizadas en `sources.yml`, `_staging__models.yml` y `_marts__models.yml` ejecutadas mediante `dbt test`. El marco valida formalmente la unicidad (`unique`) y completitud (`not_null`) de todas las claves primarias y foráneas subrogadas, la integridad referencial cruzada (`relationships`) entre `fct_viajes` y las dimensiones correspondientes, y la no nulidad en la variable dependiente booleana de cancelación (`es_cancelado: not_null`), tal como se detalla en el @lst-dbt-marts.

#fig-star-schema <fig-star-schema>

#fig-star-schema-table <tbl-star-schema>

#fig-raw-ddl <lst-ddl>

#fig-loader-azure <lst-loader>

#fig-fct-viajes <lst-fct-viajes>

#fig-marts-models <lst-dbt-marts>

=== Fase 2: Modelación Estadística y Regresión Lineal Simple (Objetivo 2)
A partir de las series agregadas diarias del repositorio analítico ($n = 366$ días correspondientes al año bisiesto 2024), se formula un modelo de regresión lineal simple estimado por Mínimos Cuadrados Ordinarios (MCO) para cuantificar la sensibilidad de la tasa de cancelación de viajes frente al multiplicador tarifario:
+ *Especificación del Modelo MCO:* 
  $ "TasaCancelacion"_t = beta_0 + beta_1 dot overline(m)_t + epsilon_t $
  donde $"TasaCancelacion"_t$ representa el porcentaje diario de servicios cancelados respecto al total solicitado, $overline(m)_t$ es el multiplicador dinámico promedio ponderado del día, y $epsilon_t$ es el término de error estocástico.
+ *Inferencia y Descomposición ANOVA:* Cálculo de los errores estándar de los estimadores, estadísticos $t$ y valores $p$ asociados para contrastar la significancia individual de la tarifa dinámica. Asimismo, se estructura la tabla de Análisis de Varianza (ANOVA) para descomponer la variabilidad total ($S S T = S S R + S S E$) y contrastar la significancia global del modelo mediante la prueba $F$ y el coeficiente de determinación ($R^2$ y $R^2_("adj")$).

=== Fase 3: Cálculo Numérico del Umbral Tarifario de Equilibrio (Objetivo 3)
Para resolver la rigidez de las soluciones analíticas continuas en presencia de congestión y lluvia:
+ *Formulación de la Ecuación de Exceso de Demanda:* Se define numéricamente la función de balance $f(m) = "Demanda"(m) - "Oferta"(m) = 0$.
+ *Algoritmos de Búsqueda de Raíces:* Implementación de los métodos de *Bisección* y *Newton-Raphson* para aproximar el multiplicador de equilibrio $m^*$, identificando el umbral de tarifa a partir del cual el incremento marginal en precio dispara las cancelaciones y anula el beneficio de atraer oferta vehicular.

=== Fase 4: Optimización de Rutas en la Red Vial Urbana mediante Teoría de Grafos (Objetivo 4)
Para mitigar los retrasos operacionales y evaluar la vulnerabilidad de la movilidad ante eventos climáticos severos:
+ *Modelado de la Red Vial como Grafo Ponderado:* Se estructura la red de los 12 cuadrantes urbanos de Managua (`dim_zonas`) como un grafo $G = (V, E)$, donde los nodos corresponden a los centroides espaciales y las aristas representan los corredores viales principales (Pista Juan Pablo II, Carretera a Masaya, Eje Tiscapa, radiales comerciales).
+ *Función de Impedancia y Penalización Climática:* Se define el costo de cada arista como el tiempo de viaje estimado en minutos:
  $ tau_(i j) = frac(d_(i j), v_(i j) (c)) dot 60 $
  donde $d_(i j)$ es la distancia geodésica corregida por tortuosidad vial y $v_(i j)(c)$ es la velocidad de circulación condicionada por el régimen meteorológico $c in {"flujo normal", "tormenta"}$. En condiciones de precipitación torrencial, los tramos propensos a escorrentías e inundaciones sufren penalizaciones de velocidad de hasta el $70%$.
+ *Algoritmo de Ruta Más Corta (Dijkstra):* Se implementa el algoritmo de Dijkstra para identificar la trayectoria óptima entre pares estratégicos de origen-destino, comparando las rutas resultantes, los tiempos de traslado y los desvíos obligados bajo condiciones secas versus eventos de tormenta.

== Ecosistema Computacional y Flujo de Reproducibilidad (DuckDB, Python y Typst)

Para asegurar la validez metodológica y la reproducibilidad científica estricta de los resultados, la fase final de análisis empírico y generación de evidencia desacopla y articula tres herramientas computacionales complementarias bajo el paradigma _Data-to-Document_:

+ *Análisis Exploratorio y Consultas OLAP de Baja Latencia (DuckDB CLI):* Para la exploración inicial y la generación de agregaciones multidimensionales sobre los #total-trips-fmt registros, se emplea *DuckDB CLI*. Su motor columnar en proceso permite ejecutar analítica OLAP de alto rendimiento con latencias de milisegundos directamente sobre el almacén analítico. A través de DuckDB se extraen agregaciones espaciotemporales consolidadas (distribución de cancelaciones por estrato, franja horaria y condición meteorológica), las cuales se exportan de forma automatizada hacia artefactos estructurados en formato `.json`.

+ *Inferencia Econométrica, Métodos Numéricos y Optimización (Python):* El cálculo científico avanzado se ejecuta mediante scripts modulares en *Python* soportados en librerías especializadas (`statsmodels`, `scipy`, `networkx`, `matplotlib`). Este entorno recibe las tablas analíticas depuradas para:
  - Estimar los coeficientes de regresión lineal simple (MCO), errores estándar y descomposición ANOVA para cuantificar el impacto del multiplicador tarifario en las cancelaciones (Fase 2).
  - Ejecutar los algoritmos numéricos de búsqueda de raíces (Bisección y Newton-Raphson) para hallar el umbral crítico tarifario de equilibrio $m^*$ (Fase 3).
  - Resolver el problema de ruta más corta en la red vial urbana mediante el algoritmo de Dijkstra bajo condiciones normales y meteorología extrema (Fase 4).

+ *Renderizado Programático y Trazabilidad sin Error Humano (Typst):* La inclusión de *Typst* como motor de maquetación científica trasciende la tipografía convencional al operar como un procesador de documentos enlazado dinámicamente a los datos:
  - Typst consume directamente los archivos `.json` generados por DuckDB y los parámetros cuantitativos calculados por Python mediante funciones nativas de ingesta de datos (`#json(...)`).
  - Las tablas estadísticas, indicadores cuantitativos y visualizaciones gráficas del paper se sintetizan algorítmicamente en tiempo de compilación (`just build-doc`).
  - Esta arquitectura programática establece una *fuente única de verdad* (_single source of truth_), eliminando por completo el riesgo de transcripción manual o desalineación de cifras (*human drift*), garantizando que toda actualización en los datos o en los modelos se refleje de manera inmediata, exacta y determinística en el documento final.

== Disponibilidad de Código, Datos y Reproducibilidad

En concordancia con los principios de reproducibilidad científica y ciencia abierta, la totalidad de los artefactos computacionales de la investigación —incluyendo los scripts de extracción y carga, las definiciones DDL y transformaciones en dbt Core, el almacén de datos columnar en DuckDB, los scripts de modelación econométrica, numérica y de optimización en Python, así como los archivos fuentes de maquetación y generación de figuras en Typst— se encuentran versionados y disponibles públicamente en el repositorio oficial del proyecto @movigo2024repo (#link(repo-url)).
