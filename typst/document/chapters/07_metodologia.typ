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

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los cuatro objetivos de la investigación, articulando la ingeniería de datos, la econometría, los métodos numéricos y la optimización prescriptiva.

== Enfoque, Tipo y Alcance

- *Enfoque Cuantitativo:* Sustentado en el modelado estadístico, numérico y de optimización sobre datos empíricos de operaciones de transporte selectivo.
- *Diseño No Experimental y Longitudinal:* Observa transacciones y eventos climáticos registrados a lo largo de un ciclo operativo anual (2024), sin manipulación deliberada de variables.
- *Alcance Correlacional y Prescriptivo:* Evalúa la relación entre la tarifa dinámica y las tasas de cancelación, proponiendo umbrales de equilibrio numérico y asignación óptima de incentivos.
- *Unidad de Análisis:* El viaje individual o solicitud de traslado ($N = 77,036$ registros), caracterizado por su origen, destino, marca temporal, multiplicador dinámico aplicado, condiciones climáticas concurrentes y estado final de atención o cancelación.

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
  - *Tabla de Hechos Atómica (`fct_viajes`):* Grano atómico de un registro por cada intento o servicio de transporte ($N = 77,036$). Integra llaves primarias y foráneas subrogadas conformadas calculadas mediante la función criptográfica `md5(cast(id as text))` (`sk_viaje`, `sk_zona_origen`, `sk_zona_destino`, `sk_conductor`, `sk_usuario`, `sk_clima`), métricas financieras de tarifa dinámica, métricas operacionales de tiempo y distancia, y la variable respuesta dicotómica de cancelación para el modelado econométrico (@lst-fct-viajes).
  - *Dimensiones Conformadas (`dim_zonas`, `dim_clima`, `dim_usuarios`, `dim_conductores`, `dim_campanias`):* Tablas de contexto desacopladas que almacenan respectivamente la estratificación urbana, el régimen meteorológico y de congestión diario, el perfil socio-financiero de pasajeros, el parque vehicular activo y los programas presupuestarios de incentivos (@fig-star-schema y @tbl-star-schema).

+ *Marco de Calidad y Pruebas Automatizadas de Integridad:* Implementación de pruebas declarativas automatizadas en `sources.yml`, `_staging__models.yml` y `_marts__models.yml` ejecutadas mediante `dbt test`. El marco valida formalmente la unicidad (`unique`) y completitud (`not_null`) de todas las claves primarias y foráneas subrogadas, la integridad referencial cruzada (`relationships`) entre `fct_viajes` y las dimensiones correspondientes, y la no nulidad en la variable dependiente booleana de cancelación (`es_cancelado: not_null`), tal como se detalla en el @lst-dbt-marts.

#fig-star-schema <fig-star-schema>

#fig-star-schema-table <tbl-star-schema>

#fig-raw-ddl <lst-ddl>

#fig-loader-azure <lst-loader>

#fig-fct-viajes <lst-fct-viajes>

#fig-marts-models <lst-dbt-marts>

=== Fase 2: Modelación Econométrica de la Cancelación de Viajes (Objetivo 2)
A partir del repositorio analítico consolidado, la bandera booleana `es_cancelado` se transforma en el vector dicotómico ($Y in {0,1}$, donde $1 = "true" = "cancelado"$) para modelar la probabilidad de cancelación del viaje como respuesta a la tarifa dinámica y factores exógenos:
+ *Especificación del Modelo Logístico:* Estimación de coeficientes y razones de momios (_odds ratios_) mediante regresión logística binaria:
  $ ln(frac(P(Y=1), 1 - P(Y=1))) = beta_0 + beta_1 dot m + beta_2 dot "precipitacion" + sum_(k) gamma_k dot "estrato"_k + epsilon $
  donde $m$ es el multiplicador dinámico aplicado a la transacción.
+ *Evaluación de Elasticidad y Sensibilidad Socioeconómica:* Estimación de la elasticidad-precio de la demanda y contraste de hipótesis (pruebas Welch y Chi-cuadrado) para determinar si la propensión a cancelar difiere significativamente entre estratos socioeconómicos ante un mismo incremento tarifario.

=== Fase 3: Cálculo Numérico del Umbral Tarifario de Equilibrio (Objetivo 3)
Para resolver la rigidez de las soluciones analíticas continuas en presencia de congestión y lluvia:
+ *Formulación de la Ecuación de Exceso de Demanda:* Se define numéricamente la función de balance $f(m) = "Demanda"(m) - "Oferta"(m) = 0$.
+ *Algoritmos de Búsqueda de Raíces:* Implementación de los métodos de *Bisección* y *Newton-Raphson* para aproximar el multiplicador de equilibrio $m^*$, identificando el umbral de tarifa a partir del cual el incremento marginal en precio dispara las cancelaciones y anula el beneficio de atraer oferta vehicular.

=== Fase 4: Optimización Prescriptiva de Incentivos a la Oferta (Objetivo 4)
Para contrarrestar el desbalance de oferta sin depender exclusivamente del encarecimiento tarifario trasladado al usuario:
+ *Formulación de la Mochila Binaria (0/1):* Selección óptima de programas de incentivos para conductores (`dim_campanias`) que maximice las horas totales de conexión activa ($H = sum h_i x_i$), sujeta al límite presupuestario finito de la empresa:
  $ max sum_(i=1)^n h_i x_i quad "sujeto a" quad sum_(i=1)^n c_i x_i <= B, quad x_i in {0,1} $
  donde $c_i$ es el costo de cada campaña y $B = "C\$ 120,000 NIO"$ es el presupuesto disponible.
+ *Impacto en Cancelaciones:* Comparación del volumen de cancelaciones esperadas bajo el esquema actual basado en tarifa dinámica extrema versus el escenario con flota reforzada mediante incentivos optimizados.

== Ecosistema Computacional y Flujo de Reproducibilidad (DuckDB, Python y Typst)

Para asegurar la validez metodológica y la reproducibilidad científica estricta de los resultados, la fase final de análisis empírico y generación de evidencia desacopla y articula tres herramientas computacionales complementarias bajo el paradigma _Data-to-Document_:

+ *Análisis Exploratorio y Consultas OLAP de Baja Latencia (DuckDB CLI):* Para la exploración inicial y la generación de agregaciones multidimensionales sobre los 77,036 registros, se emplea *DuckDB CLI*. Su motor columnar en proceso permite ejecutar analítica OLAP de alto rendimiento con latencias de milisegundos directamente sobre el almacén analítico. A través de DuckDB se extraen agregaciones espaciotemporales consolidadas (distribución de cancelaciones por estrato, franja horaria y condición meteorológica), las cuales se exportan de forma automatizada hacia artefactos tabulares estandarizados en formato `.csv`.

+ *Inferencia Econométrica, Métodos Numéricos y Optimización (Python):* El cálculo científico avanzado se ejecuta mediante scripts modulares en *Python* soportados en librerías especializadas (`statsmodels`, `scipy`, `pulp`). Este entorno recibe las tablas analíticas depuradas para:
  - Estimar los coeficientes, errores estándar robustos y razones de momios de la regresión logística binaria (Fase 2).
  - Ejecutar los algoritmos numéricos de búsqueda de raíces (Bisección y Newton-Raphson) para hallar el umbral crítico tarifario de equilibrio $m^*$ (Fase 3).
  - Resolver el problema de programación lineal entera binaria para la asignación presupuestaria óptima de bonos (Fase 4).

+ *Renderizado Programático y Trazabilidad sin Error Humano (Typst):* La inclusión de *Typst* como motor de maquetación científica trasciende la tipografía convencional al operar como un procesador de documentos enlazado dinámicamente a los datos:
  - Typst consume directamente los archivos `.csv` generados por DuckDB y los parámetros cuantitativos calculados por Python mediante funciones nativas de ingesta de datos (`#csv(...)`).
  - Las tablas estadísticas, indicadores cuantitativos y visualizaciones gráficas del paper se sintetizan algorítmicamente en tiempo de compilación (`just build-doc`).
  - Esta arquitectura programática establece una *fuente única de verdad* (_single source of truth_), eliminando por completo el riesgo de transcripción manual o desalineación de cifras (*human drift*), garantizando que toda actualización en los datos o en los modelos se refleje de manera inmediata, exacta y determinística en el documento final.
