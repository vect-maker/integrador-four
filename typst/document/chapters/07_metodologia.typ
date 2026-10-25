#import "../../snippets.typ": snippet-raw-ddl, snippet-loader-azure

= Diseño Metodológico

El diseño metodológico establece la secuencia técnica, analítica y computacional estructurada para dar cumplimiento a los cuatro objetivos de la investigación, articulando la ingeniería de datos, la econometría, los métodos numéricos y la optimización prescriptiva.

== Enfoque, Tipo y Alcance

- *Enfoque Cuantitativo:* Sustentado en el modelado estadístico, numérico y de optimización sobre datos empíricos de operaciones de transporte selectivo.
- *Diseño No Experimental y Longitudinal:* Observa transacciones y eventos climáticos registrados a lo largo de un ciclo operativo anual (2024), sin manipulación deliberada de variables.
- *Alcance Correlacional y Prescriptivo:* Evalúa la relación entre la tarifa dinámica y las tasas de cancelación, proponiendo umbrales de equilibrio numérico y asignación óptima de incentivos.
- *Unidad de Análisis:* El viaje individual o solicitud de traslado ($N = 77,036$ registros), caracterizado por su origen, destino, marca temporal, multiplicador dinámico aplicado, condiciones climáticas concurrentes y estado final de atención o cancelación.

== Fases Metodológicas de la Investigación

=== Fase 1: Pipeline de Datos ELT e Infraestructura Cloud (Objetivo 1)
La base computacional consolida los datos dispersos de la plataforma MoviGo mediante un flujo moderno ELT (*Extract, Load, Transform*):
+ *Extracción y Serialización Parquet:* Consumo sistemático de los endpoints de la API REST mediante un cliente en Python (`fetcher.py`) con control dinámico de paginación (`limit=200`, `offset`). Los conjuntos recuperados se serializan en archivos columnares *Apache Parquet* (`pipeline/data/raw/*.parquet`), asegurando inmutabilidad, reducción de almacenamiento y desacoplamiento de la red.
+ *Carga Transaccional en Azure PostgreSQL:* Ejecución del esquema DDL estricto (`raw_schema.sql`) directamente sobre el esquema `public` de una base de datos administrada dedicada (`raw`) en *Azure Database for PostgreSQL*, asegurando tipos de datos e integridad referencial como se ilustra en el @lst-ddl. El script cargador (`loader.py`) aplica casteo de marcas temporales y gestiona claves foráneas, insertando por lotes de 2,000 registros en orden topológico relacional (@lst-loader).
+ *Transformación y Calidad con dbt Core:* Orquestación de modelos dimensionales mediante *dbt*, estructurando vistas de estandarización (`staging`) y la tabla de hechos atómica (`fct_viajes`) en esquema analítico, gobernados por pruebas automatizadas declarativas de no nulidad, unicidad y validación de reglas de negocio en `sources.yml`.

#figure(
  snippet-raw-ddl,
  caption: [Definición del esquema DDL relacional y restricciones de integridad (`raw_schema.sql`)],
) <lst-ddl>

#figure(
  snippet-loader-azure,
  caption: [Conexión cifrada e inserción por lotes en Azure Database for PostgreSQL (`loader.py`)],
) <lst-loader>

=== Fase 2: Modelación Econométrica de la Cancelación de Viajes (Objetivo 2)
A partir del repositorio analítico consolidado, se modela la probabilidad de cancelación del viaje ($Y in {0,1}$, donde $1 = "cancelado"$) como respuesta a la tarifa dinámica y factores exógenos:
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
+ *Formulación de la Mochila Binaria (0/1):* Selección óptima de programas de incentivos para conductores (`/movigo/campanas`) que maximice las horas totales de conexión activa ($H = sum h_i x_i$), sujeta al límite presupuestario finito de la empresa:
  $ max sum_(i=1)^n h_i x_i quad "sujeto a" quad sum_(i=1)^n c_i x_i <= B, quad x_i in {0,1} $
  donde $c_i$ es el costo de cada campaña y $B = "C\$ 120,000 NIO"$ es el presupuesto disponible.
+ *Impacto en Cancelaciones:* Comparación del volumen de cancelaciones esperadas bajo el esquema actual basado en tarifa dinámica extrema versus el escenario con flota reforzada mediante incentivos optimizados.
