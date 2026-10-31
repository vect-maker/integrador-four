#show bibliography: none
#bibliography("../../references.bib")
#import "../../tables/index.typ": fig-variables-operationalization
#import "../../data_bindings.typ": total-trips-fmt, total-zones, total-campaigns
#import "../../metadata.typ": repo-url

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los objetivos de la investigación, articulando la ingeniería de datos bajo modelado dimensional Kimball y la optimización prescriptiva de la red vial en redes espaciales.

== Enfoque, Tipo y Alcance

- *Enfoque Mixto (con predominio cuantitativo):* De acuerdo con la tipología metodológica de @sampieri2014, la investigación adopta un enfoque mixto donde converge el rigor cuantitativo formal del modelado analítico dimensional y la optimización en redes espaciales sobre el censo de $N = #total-trips-fmt$ registros transaccionales, articulado con el análisis cualitativo y contextual de la estratificación socioespacial, la infraestructura urbana y la vulnerabilidad histórica ante anegamientos en el municipio de Managua.
- *Diseño No Experimental y Longitudinal:* Se observan transacciones operativas y registros meteorológicos a lo largo del ciclo anual 2024 ($n = 366$ días), sin manipulación deliberada ni intervención exógena sobre las variables del sistema de transporte.
- *Alcance Mixto (Descriptivo, Explicativo y Prescriptivo):* Trasciende la descripción exploratoria del comportamiento de movilidad del servicio; describe los patrones empíricos de asignación, espera y cancelación (dimensión descriptiva), cuantifica mediante modelos funcionales e inferencia estadística el impacto de la distancia sobre la duración y la tarifa (dimensión explicativa), y prescribe estrategias óptimas de ruteo y resiliencia vial ante contingencias meteorológicas mediante algoritmos de caminos mínimos (dimensión prescriptiva).
- *Unidad de Análisis:* El viaje individual o solicitud de traslado ($N = #total-trips-fmt$ registros), caracterizado por su origen, destino, marca temporal, multiplicador dinámico aplicado, condiciones climáticas concurrentes y estado final de atención o cancelación.

A fin de operacionalizar formalmente las hipótesis y dimensiones analíticas del estudio, la @tbl-variables-operationalization desglosa la matriz metodológica de variables, definiendo para cada una su rol analítico, definición conceptual, operacionalización computacional, escala de medición y entidad del repositorio analítico de procedencia.

#fig-variables-operationalization <tbl-variables-operationalization>

== Fases Metodológicas de la Investigación

=== Fase 1: Pipeline de Datos ELT, Procesamiento y Esquema en Estrella (Objetivo 1)

Los datos primarios de la investigación provienen de una API REST que expone un entorno de simulación sintética de alta fidelidad, diseñado específicamente para emular de manera fidedigna la dinámica transaccional, operativa y espacial de una plataforma de transporte selectivo metropolitana en Managua. Aunque el motor de simulación dispone de capacidades de generación continua horaria, para asegurar la reproducibilidad científica estricta y auditoría del estudio se delimitó la extracción al censo anual cerrado del año 2024 ($N = #total-trips-fmt$ operaciones).

Para consolidar el repositorio analítico a partir de las fuentes desacopladas de la API, se ejecutó integralmente un pipeline de datos bajo el paradigma *ELT (Extract, Load, Transform)* articulado en las siguientes etapas computacionales:

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

=== Fase 2: Modelado de Regresión Simple vía Descenso de Gradiente e Inferencia al 95% (Objetivo 2)

Para modelar la dinámica física y comercial del servicio a partir del censo analítico depurado, se formula un esquema de regresión lineal simple bivariada (una variable de entrada y una de salida) resuelto mediante optimización numérica iterativa e inferencia estadística:

+ *Partición Analítica Reproducible (80% Train / 20% Test):* Sobre el universo de viajes completados con telemetría válida ($N = 49,049$), se realiza una partición analítica estricta utilizando un generador pseudoaleatorio fijo (`random_state=42`) sin reposición:
  - *Conjunto de Entrenamiento ($N_"train" = 39,239$ viajes, 80%):* Destinado exclusivamente al ajuste de los pesos paramétricos mediante optimización iterativa.
  - *Conjunto de Prueba ($N_"test" = 9,810$ viajes, 20%):* Mantenido estrictamente aislado para evaluar la capacidad de generalización fuera de muestra mediante el Coeficiente de Determinación ($R^2$), el Error Absoluto Medio ($"MAE"$) y la Raíz del Error Cuadrático Medio ($"RMSE"$).

+ *Formulación y Ajuste de Modelos Operativo y Económico:*
  - *Modelo 1 (Tiempo de Viaje / ETA):* Estima la duración del recorrido en minutos a partir de la distancia recorrida: $"duracion_minutos" = f("distance_km")$.
  - *Modelo 2 (Tarificación del Servicio):* Estima la tarifa final facturada en Córdobas a partir de la distancia recorrida: $"final_fare" = f("distance_km")$.

+ *Optimización Numérica por Descenso de Gradiente (SGD):* Se emplea el algoritmo de Descenso de Gradiente Estocástico con función de pérdida del Error Cuadrático Medio ($"loss" = "squared_error"$). Para acelerar la convergencia y acondicionar la curvatura de la superficie de error, se aplica estandarización $Z$ sobre la distancia (`StandardScaler`). El esquema utiliza una tasa de aprendizaje con decaimiento inverso (`invscaling`, $eta_0 = 0.01$, $"power_t" = 0.25$) y tolerancia de parada $"tol" = 10^(-4)$, alcanzando convergencia en pocas épocas (13 épocas para Duración y 10 para Tarifa). Tras la convergencia, los pesos se des-escalan analíticamente a sus unidades físicas reales.

+ *Inferencia Paramétrica e Intervalos de Confianza al 95%:* Se estima la matriz de varianza-covarianza muestral $sigma^2 (X^T X)^(-1)$ sobre los datos de entrenamiento para derivar los errores estándar de los estimadores y construir intervalos de confianza al 95% ($z_(0.025) = 1.96$), verificando la significancia estadística y la estabilidad de las pendientes operativas y tarifarias.

=== Fase 3: Modelado de Redes Espaciales y Auditoría Algorítmica de Ruteo (Objetivo 3)
Para auditar el ruteo de caja negra de la plataforma y evaluar la optimización prescriptiva ante contingencias meteorológicas:
+ *Modelado Jerárquico de la Red Espacial:* Se estructura la red física mediante la topología densa de OpenStreetMap (69,695 nodos y 80,287 aristas viales) acoplada jerárquicamente a la partición de 298 cuadrantes urbanos (`dim_quadrants`) y 24 zonas analíticas de Managua, integrando la hidrografía de los 485 cauces pluviales vectoriales.
+ *Función de Impedancia Dinámica sobre Vías Reales:* Se calcula el costo temporal de cada arista vial ($tau_(i j) = frac(d_(i j), v_(i j)) dot 60$) utilizando las distancias métricas de las calles reales, las velocidades reguladas por jerarquía vial (arterias, secundarias, residenciales) y penalizaciones hidrológicas severas en tramos viales interceptados por cauces desbordados extraídos de `quadrant_weather`.
+ *Algoritmo de Dijkstra Vectorizado y Protocolo de Auditoría:* Se implementa el algoritmo de Dijkstra mediante matrices dispersas CSR (`scipy.sparse.csgraph.dijkstra`) para resolver caminos mínimos en escenario basal seco y de tormenta. Se evalúan los 552 pares OD metropolitanos y corredores estratégicos, contrastando las trayectorias prescriptivas óptimas frente a los datos observados de MoviGo en `fct_viajes` para cuantificar ahorros temporales ($Delta T$) y mitigación del detonante de cancelaciones.
+ *Centralidad de Intermediación y Cuellos de Botella:* Se computa la centralidad de intermediación $C_B(v)$ sobre la red territorial para caracterizar la vulnerabilidad estructural y la redistribución del tráfico ante inundaciones.

== Ecosistema Computacional y Flujo de Reproducibilidad (DuckDB, Python y Typst)

Para asegurar la validez metodológica y la reproducibilidad científica estricta de los resultados, la fase final de análisis empírico y generación de evidencia desacopla y articula tres herramientas computacionales complementarias bajo el paradigma _Data-to-Document_:

+ *Análisis Exploratorio y Consultas OLAP de Baja Latencia (DuckDB CLI):* Para la exploración inicial y la generación de agregaciones multidimensionales sobre los #total-trips-fmt registros, se emplea *DuckDB CLI*. Su motor columnar en proceso permite ejecutar analítica OLAP de alto rendimiento con latencias de milisegundos directamente sobre el almacén analítico. A través de DuckDB se extraen agregaciones espaciotemporales consolidadas (distribución de cancelaciones por estrato, franja horaria y condición meteorológica), las cuales se exportan de forma automatizada hacia artefactos estructurados en formato `.json`.

+ *Modelado y Optimización Computacional en Python:* El cálculo científico avanzado se ejecuta mediante scripts modulares en *Python* soportados en librerías especializadas (`scikit-learn`, `networkx`, `scipy`, `matplotlib`). Este entorno recibe las tablas analíticas depuradas para:
  - Ajustar y evaluar los modelos de regresión simple mediante Descenso de Gradiente Estocástico (SGD) y estimar intervalos de confianza al 95% para los parámetros (Fase 2).
  - Computar las métricas de centralidad de intermediación (_betweenness_), cuellos de botella viales y simular la resiliencia de la red ante inundaciones mediante el algoritmo de Dijkstra (Fase 3).

+ *Renderizado Programático y Trazabilidad sin Error Humano (Typst):* La inclusión de *Typst* como motor de maquetación científica trasciende la tipografía convencional al operar como un procesador de documentos enlazado dinámicamente a los datos:
  - Typst consume directamente los archivos `.json` generados por DuckDB y los parámetros cuantitativos calculados por Python mediante funciones nativas de ingesta de datos (`#json(...)`).
  - Las tablas de optimización, indicadores cuantitativos y visualizaciones gráficas del paper se sintetizan algorítmicamente en tiempo de compilación (`just build-doc`).
  - Esta arquitectura programática establece una *fuente única de verdad* (_single source of truth_), eliminando por completo el riesgo de transcripción manual o desalineación de cifras (*human drift*), garantizando que toda actualización en los datos o en los modelos se refleje de manera inmediata, exacta y determinística en el documento final.

== Disponibilidad de Código, Datos y Reproducibilidad

En concordancia con los principios de reproducibilidad científica y ciencia abierta, la totalidad de los artefactos computacionales de la investigación (incluyendo los scripts de extracción y carga, las definiciones DDL y transformaciones en dbt Core, el almacén de datos columnar en DuckDB, los scripts de modelación y optimización en Python, así como los archivos fuentes de maquetación y generación de figuras en Typst) se encuentran versionados y disponibles públicamente en el repositorio oficial del proyecto @movigo2024repo (#link(repo-url)).
