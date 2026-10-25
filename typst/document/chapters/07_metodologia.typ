#show bibliography: none
#bibliography("../../references.bib")
#import "../../snippets.typ": (
  snippet-raw-ddl,
  snippet-loader-azure,
  snippet-fct-viajes,
  snippet-marts-models,
)
#import "../../diagrams/star_schema.typ": diagram-star-schema

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

#figure(
  diagram-star-schema,
  caption: [Diagrama dimensional del Esquema en Estrella (Star Schema) implementado en dbt Core],
) <fig-star-schema>

#figure(
  {
    set text(size: 7.6pt)
    show raw.where(block: false): it => box(
      fill: rgb("#f1f5f9"),
      radius: 1.5pt,
      inset: (x: 1.8pt, y: 0pt),
      baseline: 0%,
      text(font: ("Liberation Mono", "DejaVu Sans Mono"), size: 6.8pt, it.text)
    )
    table(
      columns: (1.35fr, 1.05fr, 1.15fr, 1.35fr, 2.6fr),
      stroke: 0.4pt + rgb("#cbd5e1"),
      inset: (x: 4pt, y: 3.5pt),
      align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
      fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
      table.header(
        [*Modelo (dbt)*], [*Rol Dimensional*], [*PK Subrogada*], [*Relaciones / FK*], [*Grano y Métricas / Atributos Clave*]
      ),
      [`fct_viajes`],
      [Tabla de Hechos (Atómica)],
      [`sk_viaje` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [
        #stack(
          spacing: 1.5pt,
          [`sk_zona_origen`],
          [`sk_zona_destino`],
          [`sk_clima`, `sk_usuario`],
          [`sk_conductor`]
        )
      ],
      [1 fila por solicitud ($N = 77,036$). Multiplicador dinámico, tarifa base, tarifa final, recargo surge, tiempo espera, bandera booleana de cancelación (`es_cancelado`).],

      [`dim_zonas`],
      [Dimensión Conformada],
      [`sk_zona` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [Origen y Destino \ #text(size: 6.8pt, fill: rgb("#64748b"))[(`fct_viajes`)]],
      [12 cuadrantes urbanos. Estrato socioeconómico, nivel ordinal (1--4), latitud, longitud, radio cobertura, bajada de bandera zonal.],

      [`dim_clima`],
      [Dimensión Conformada],
      [`sk_clima` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [`sk_clima` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(`fct_viajes`)]],
      [365 días del ciclo 2024. Precipitación (mm), temperatura (°C), índice y nivel de congestión vial, condición de cielo, indicador de lluvia.],

      [`dim_usuarios`],
      [Dimensión Conformada],
      [`sk_usuario` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [`sk_usuario` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(`fct_viajes`)]],
      [Pasajeros registrados. Preferencia de pago (efectivo vs tarjeta/digital), calificación histórica promedio, fecha de registro.],

      [`dim_conductores`],
      [Dimensión Conformada],
      [`sk_conductor` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [`sk_conductor` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(`fct_viajes`)]],
      [Socios de la flota. Modalidad vehicular (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), modelo, año, calificación, tasa de aceptación, estado activo.],

      [`dim_campanias`],
      [Dimensión Prescriptiva],
      [`sk_campania` \ #text(size: 6.8pt, fill: rgb("#64748b"))[(Hash MD5)]],
      [Optimización \ #text(size: 6.8pt, fill: rgb("#64748b"))[Mochila 0/1]],
      [Programas de bonos. Costo presupuestario en córdobas (NIO), incremento en horas de conexión y ratio de costo unitario por hora.]
    )
  },
  caption: [Especificación arquitectónica del Esquema en Estrella (Star Schema) implementado en dbt Core],
) <tbl-star-schema>

#figure(
  snippet-raw-ddl,
  caption: [Definición del esquema DDL relacional y restricciones de integridad (`raw_schema.sql`)],
) <lst-ddl>

#figure(
  snippet-loader-azure,
  caption: [Conexión cifrada e inserción por lotes en Azure Database for PostgreSQL (`loader.py`)],
) <lst-loader>

#figure(
  snippet-fct-viajes,
  caption: [Modelo de la tabla de hechos atómica en dbt Core con llaves subrogadas hash MD5 (`fct_viajes.sql`)],
) <lst-fct-viajes>

#figure(
  snippet-marts-models,
  caption: [Pruebas declarativas de integridad referencial foránea y calidad de datos en dbt (`_marts__models.yml`)],
) <lst-dbt-marts>

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
+ *Formulación de la Mochila Binaria (0/1):* Selección óptima de programas de incentivos para conductores (`/movigo/campanas`) que maximice las horas totales de conexión activa ($H = sum h_i x_i$), sujeta al límite presupuestario finito de la empresa:
  $ max sum_(i=1)^n h_i x_i quad "sujeto a" quad sum_(i=1)^n c_i x_i <= B, quad x_i in {0,1} $
  donde $c_i$ es el costo de cada campaña y $B = "C\$ 120,000 NIO"$ es el presupuesto disponible.
+ *Impacto en Cancelaciones:* Comparación del volumen de cancelaciones esperadas bajo el esquema actual basado en tarifa dinámica extrema versus el escenario con flota reforzada mediante incentivos optimizados.
