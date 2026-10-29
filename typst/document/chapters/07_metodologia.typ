#show bibliography: none
#bibliography("../../references.bib")
#import "../../diagrams/star_schema.typ": fig-star-schema
#import "../../tables/index.typ": fig-variables-operationalization
#import "../../graphs/index.typ": fig-trip-origins-density
#import "../../data_bindings.typ": total-trips-fmt, total-zones, total-campaigns
#import "../../metadata.typ": repo-url

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los tres objetivos de la investigación, articulando la ingeniería de datos, el modelado econométrico y numérico (Logit y Newton-Raphson) y la optimización prescriptiva en redes espaciales.

== Enfoque, Tipo y Alcance

- *Enfoque Mixto (con predominio cuantitativo):* De acuerdo con la tipología metodológica de @sampieri2014, la investigación adopta un diseño mixto donde convergen el rigor analítico formal del modelado econométrico y numérico (regresión logística binaria optimizada por Newton-Raphson IRLS) y la teoría de grafos en redes viales sobre $N = #total-trips-fmt$ registros transaccionales, complementado con la contextualización socioespacial de los estratos urbanos y la vulnerabilidad ante anegamientos en Managua.
- *Diseño No Experimental y Longitudinal:* Se observan transacciones operativas y registros meteorológicos a lo largo del ciclo anual 2024 ($n = 366$ días), sin manipulación deliberada ni intervención exógena sobre las variables del sistema de transporte.
- *Alcance Mixto (Descriptivo, Correlacional y Prescriptivo):* Trasciende la descripción exploratoria del comportamiento del servicio; cuantifica e infiere la relación estadística entre el multiplicador tarifario y la tasa de cancelación (alcance correlacional), determina numéricamente el punto de equilibrio operativo de mercado y prescribe rutas óptimas de contingencia vial ante disrupciones climáticas (alcance prescriptivo).
- *Unidad de Análisis:* El viaje individual o solicitud de traslado ($N = #total-trips-fmt$ registros), caracterizado por su origen, destino, marca temporal, multiplicador dinámico aplicado, condiciones climáticas concurrentes y estado final de atención o cancelación.

A fin de operacionalizar formalmente las hipótesis y dimensiones analíticas del estudio, la @tbl-variables-operationalization desglosa la matriz metodológica de variables, definiendo para cada una su rol analítico, definición conceptual, operacionalización computacional, escala de medición y entidad del repositorio analítico de procedencia.

#fig-variables-operationalization <tbl-variables-operationalization>

== Fases Metodológicas de la Investigación

=== Fase 1: Pipeline de Datos ELT, Procesamiento y Esquema en Estrella (Objetivo 1)

Para consolidar el repositorio analítico de operaciones 2024 a partir de las fuentes desagregadas de la plataforma MoviGo, se ejecutó integralmente un pipeline de datos moderno bajo el paradigma *ELT (Extract, Load, Transform)* articulado en las siguientes etapas computacionales:

+ *Extracción y Serialización Parquet:* Consumo sistemático de los endpoints de la API REST mediante un cliente en Python (`fetcher.py`) con control dinámico de paginación (`limit=200`, `offset`). Los conjuntos recuperados se serializan en siete archivos columnares *Apache Parquet* (`pipeline/data/raw/*.parquet`: zonas, usuarios, conductores, campañas, clima, viajes y telemetría), garantizando inmutabilidad, reducción volumétrica de almacenamiento y desacoplamiento de la red.

+ *Carga Transaccional Relacional en Azure PostgreSQL:* Despliegue del esquema DDL estricto (`raw_schema.sql`) en el esquema dedicado `raw` de *Azure Database for PostgreSQL*, asegurando tipificación fuerte, restricciones de clave primaria y foránea, así como validaciones de dominio mediante reglas `CHECK` (código DDL documentado en el Apéndice C, @lst-ddl). El script cargador (`loader.py`) aplica casteo de marcas temporales, establece conexión cifrada TLS/SSL y ejecuta inserciones por bloques de 2,000 registros respetando el orden topológico de dependencias (@lst-loader).

+ *Capa de Preparación y Limpieza (Staging en dbt Core):* Implementación de modelos intermedios en dbt materializados como vistas lógicas (`view`) puras 1:1 bajo la capa `staging`. En esta fase se homogenizan formatos en inglés, se descartan dependencias cruzadas y se realiza tipificación formal:
  - En `stg_trips`: extracción y casteo de identificadores (`trip_id`, `user_id`, `driver_id`), cuadrantes de origen y destino (`origin_quadrant_id`, `destination_quadrant_id`), componentes temporales (`request_date`, `request_hour`, `iso_day_of_week`), indicadores booleanos de hora pico (`is_peak_hour`) y fin de semana (`is_weekend`), métricas operativas de distancia y duración (`distance_km`, `duration_minutes`), y binarización determinística del resultado del servicio (`is_cancelled`, `is_cancelled_by_user`, `is_cancelled_by_driver`, `is_completed`).
  - En `stg_trip_payments`: descomposición de la tarifa (`base_fare`, `surge_multiplier`, `has_surge`, `final_fare`, `surge_cost_nio`), método de pago y estado de liquidación.
  - En `stg_trip_cancellations`: tiempo de espera en minutos hasta el abandono (`wait_time_minutes`), motivo de cancelación (`cancellation_reason`), actor responsable (`cancelled_by`) y ratio de oferta/demanda local al momento del fallo.
  - En `stg_weather_daily`: serie temporal agregada diaria con categorización ordinal de precipitación (`precipitation_category`), umbrales de severidad pluvial e índice de congestión vehicular (`congestion_index`).
  - En `stg_urban_zones` y `stg_quadrants`: normalización territorial de las 24 zonas urbanas de Managua y discretización espacial en 298 cuadrantes con cota altimétrica y riesgo de inundación.
  - En `stg_campaigns`: incentivos y bonos para conductores (`budget_cost_nio`, `target_driver_hours`, `cost_per_hour_nio`).
  - En `stg_vehicles` y `stg_vehicle_maintenance`: parque automotor y registros de mantenimiento mecánico preventivo y correctivo.

+ *Capa Dimensional y Esquema en Estrella (Marts en dbt Core):* Transformación y estructuración de los datos en un *Esquema en Estrella* (_Star Schema_) según la metodología de Ralph Kimball @kimball2013, materializado físicamente como tablas (`table`) en la base de datos para maximizar el rendimiento analítico (OLAP):
  - *Tabla de Hechos Atómica (`fct_viajes`):* Grano atómico de un registro por cada intento o servicio de transporte ($N = #total-trips-fmt$). Integra llaves primarias y foráneas subrogadas conformadas calculadas mediante la función criptográfica `md5(cast(id as text))` (`sk_trip`, `sk_zone_origin`, `sk_zone_destination`, `sk_driver`, `sk_user`, `sk_weather`), métricas financieras de tarifa dinámica, métricas operacionales de tiempo y distancia, y la variable respuesta dicotómica de cancelación para el modelado econométrico (especificación SQL en @lst-fct-viajes).
  - *Dimensiones Conformadas (`dim_zones`, `dim_quadrants`, `dim_weather`, `dim_users`, `dim_drivers`, `dim_campaigns`):* Tablas de contexto desacopladas que almacenan respectivamente la estratificación urbana de las 24 zonas, la malla de 298 cuadrantes territoriales, el régimen meteorológico y de escorrentía diario, el perfil socio-financiero de pasajeros, el parque vehicular enriquecido con métricas acumuladas de taller, y los programas presupuestarios de incentivos (@fig-star-schema; ver diccionario completo de campos en el Apéndice C, @tbl-star-schema). Destaca en particular `dim_zones` como dimensión de doble rol (_role-playing dimension_), donde la llave `sk_zone_origin` fija la tarifa base de bajada de bandera del servicio y el estrato socioeconómico de partida, mientras que `sk_zone_destination` delimita el alcance geográfico del trayecto.

+ *Marco de Calidad y Pruebas Automatizadas de Integridad:* Implementación de pruebas declarativas automatizadas en `sources.yml`, `_staging__models.yml` y `_marts__models.yml` ejecutadas mediante `dbt test`. El marco valida formalmente la unicidad (`unique`) y completitud (`not_null`) de todas las claves primarias y foráneas subrogadas, la integridad referencial cruzada (`relationships`) entre `fct_viajes` y las dimensiones correspondientes, y la no nulidad en la variable dependiente booleana de cancelación (`is_cancelled: not_null`), tal como se detalla en el Apéndice C (@lst-dbt-marts).

+ *Análisis de Densidad Espacial y Distribución Geográfica:* La captura granular de coordenadas GPS en origen y destino permite proyectar el universo transaccional sobre la malla urbana de Managua mediante un mapa base arterial georreferenciado de OpenStreetMap (@fig-trip-origins-density). Esta visualización revela la concentración espacial de solicitudes en polos comerciales y corporativos (Metrocentro, Villa Fontana, Los Robles) frente a la dispersión de puntos de cancelación en zonas populares y periféricas.

#fig-star-schema <fig-star-schema>

#fig-trip-origins-density <fig-trip-origins-density>

=== Fase 2: Modelación Econométrica y Optimización Numérica de Cancelaciones (Objetivo 2)
A partir de las transacciones individuales consolidadas en el repositorio analítico ($N = 77,487$ viajes registrados en 2024), se formula un modelo de regresión logística binaria (Logit) para cuantificar la probabilidad condicional de cancelación de viajes frente a variaciones en la tarifa dinámica y fricciones operacionales:
+ *Especificación del Modelo Logit Transaccional:* 
  $ ln(frac(pi_i, 1 - pi_i)) = beta_0 + beta_1 m_i + beta_2 d_i + beta_3 "cong"_i + beta_4 "pico"_i $
  donde $pi_i = P(Y_i = 1 mid bold(x)_i)$ es la probabilidad de que el viaje sea cancelado, $m_i$ es el multiplicador dinámico asignado, $d_i$ es la distancia de ruta en kilómetros, $"cong"_i$ es el índice diario de congestión vial y $"pico"_i$ es la variable dummy de hora pico.
+ *Optimización Numérica por Newton-Raphson (IRLS) e Inferencia:* Dado que el modelo no admite estimación analítica cerrada, los parámetros $bold(beta)$ se obtienen por Máxima Verosimilitud mediante el algoritmo iterativo de Newton-Raphson multidimensional, registrando la convergencia cuadrática del vector gradiente y la matriz Hessiana. La significancia estadística se evalúa a través de la tabla de Análisis de Deviance (prueba de razón de verosimilitud $chi^2$), contrastes individuales de Wald ($z$) y el cálculo de las Razones de Momios (_Odds Ratios_ $= e^(beta_j)$) con intervalos de confianza al 95%.

=== Fase 3: Modelado de Redes, Centralidad y Resiliencia Espacial ante Inundaciones (Objetivo 3)
Para mitigar los retrasos operacionales y evaluar la vulnerabilidad de la movilidad ante eventos climáticos severos:
+ *Modelado de la Red Vial como Grafo Ponderado:* Se estructura la red de las 24 zonas urbanas de Managua (`dim_zones`) como un grafo $G = (V, E)$ de 44 corredores arteriales principales (Pista Juan Pablo II, Carretera a Masaya, Eje Tiscapa, radiales comerciales), calibrados con distancias Haversine corregidas por tortuosidad vial ($kappa = 1.30$).
+ *Análisis de Centralidad de Intermediación (_Betweenness_):* Se computa la métrica de intermediación $C_B(v)$ sobre los 24 vértices para rankear e identificar los cuellos de botella sistémicos de la infraestructura vial de Managua.
+ *Función de Impedancia y Evaluación de Resiliencia con Dijkstra:* Se calcula el costo temporal de cada arista ($tau_(i j) = frac(d_(i j), v_(i j)(c)) dot 60$) bajo escenarios secos y de lluvia torrencial con penalizaciones hidrológicas por desbordamiento de cauces. Se aplica el algoritmo de Dijkstra sobre la totalidad de los 552 pares OD metropolitanos y sobre corredores estratégicos para cuantificar la dilatación en tiempos de traslado y los desvíos forzosos hacia arterias corporativas.

== Ecosistema Computacional y Flujo de Reproducibilidad (DuckDB, Python y Typst)

Para asegurar la validez metodológica y la reproducibilidad científica estricta de los resultados, la fase final de análisis empírico y generación de evidencia desacopla y articula tres herramientas computacionales complementarias bajo el paradigma _Data-to-Document_:

+ *Análisis Exploratorio y Consultas OLAP de Baja Latencia (DuckDB CLI):* Para la exploración inicial y la generación de agregaciones multidimensionales sobre los #total-trips-fmt registros, se emplea *DuckDB CLI*. Su motor columnar en proceso permite ejecutar analítica OLAP de alto rendimiento con latencias de milisegundos directamente sobre el almacén analítico. A través de DuckDB se extraen agregaciones espaciotemporales consolidadas (distribución de cancelaciones por estrato, franja horaria y condición meteorológica), las cuales se exportan de forma automatizada hacia artefactos estructurados en formato `.json`.

+ *Inferencia Econométrica, Métodos Numéricos y Optimización (Python):* El cálculo científico avanzado se ejecuta mediante scripts modulares en *Python* soportados en librerías especializadas (`statsmodels`, `scipy`, `networkx`, `matplotlib`). Este entorno recibe las tablas analíticas depuradas para:
  - Estimar los parámetros del modelo de regresión logística binaria (Logit), calcular errores estándar de Wald, razones de momios (_Odds Ratios_) y el análisis de Deviance con prueba de razón de verosimilitud (Fase 2).
  - Auditar la convergencia numérica cuadrática del algoritmo multidimensional de Newton-Raphson / IRLS en la maximización de la log-verosimilitud (Fase 2).
  - Computar las métricas de centralidad de intermediación (_betweenness_), cuellos de botella viales y simular la resiliencia de la red ante inundaciones mediante el algoritmo de Dijkstra (Fase 3).

+ *Renderizado Programático y Trazabilidad sin Error Humano (Typst):* La inclusión de *Typst* como motor de maquetación científica trasciende la tipografía convencional al operar como un procesador de documentos enlazado dinámicamente a los datos:
  - Typst consume directamente los archivos `.json` generados por DuckDB y los parámetros cuantitativos calculados por Python mediante funciones nativas de ingesta de datos (`#json(...)`).
  - Las tablas estadísticas, indicadores cuantitativos y visualizaciones gráficas del paper se sintetizan algorítmicamente en tiempo de compilación (`just build-doc`).
  - Esta arquitectura programática establece una *fuente única de verdad* (_single source of truth_), eliminando por completo el riesgo de transcripción manual o desalineación de cifras (*human drift*), garantizando que toda actualización en los datos o en los modelos se refleje de manera inmediata, exacta y determinística en el documento final.

== Disponibilidad de Código, Datos y Reproducibilidad

En concordancia con los principios de reproducibilidad científica y ciencia abierta, la totalidad de los artefactos computacionales de la investigación —incluyendo los scripts de extracción y carga, las definiciones DDL y transformaciones en dbt Core, el almacén de datos columnar en DuckDB, los scripts de modelación econométrica, numérica y de optimización en Python, así como los archivos fuentes de maquetación y generación de figuras en Typst— se encuentran versionados y disponibles públicamente en el repositorio oficial del proyecto @movigo2024repo (#link(repo-url)).
