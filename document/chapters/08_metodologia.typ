= Diseño Metodológico

El diseño metodológico describe la secuencia técnica, analítica, econométrica y computacional implementada para extraer los datos de la plataforma MoviGo desde la API REST, estructurar el Data Warehouse analítico con dbt sobre PostgreSQL y ejecutar los modelos de inferencia estadística, métodos numéricos y optimización prescriptiva orientados a la evaluación y calibración de la tarifa dinámica.

== Enfoque, Tipo y Alcance de la Investigación

La presente investigación se enmarca en un *enfoque cuantitativo empírico*, fundamentado en la recolección masiva, transformación y modelación matemática de más de *77,000 registros transaccionales*, series meteorológicas y telemetría vehicular del servicio MoviGo en el municipio de Managua.

De acuerdo con su alcance temporal y metodológico, el estudio presenta las siguientes características:
- *No Experimental y Longitudinal:* Se analizan los registros operativos generados por la plataforma durante un año completo de simulación sin manipular deliberadamente el comportamiento de usuarios o conductores.
- *Correlacional y Explicativo:* Cuantifica la relación funcional entre el multiplicador dinámico, los choques de lluvia, la congestión del tráfico, el estrato socioeconómico y la propensión al abandono del servicio (cancelaciones).
- *Prescriptivo y Propositivo:* Aplica métodos numéricos de búsqueda de raíces para calibrar el multiplicador de equilibrio de mercado y algoritmos de optimización combinatoria para resolver la asignación presupuestaria de incentivos a choferes.

== Arquitectura del Pipeline y Paradigma ELT

La gestión y preparación de los datos adopta el paradigma moderno *ELT (Extract, Load, Transform)*, estructurado en etapas desacopladas:

=== Extracción Paginada y Auditoría DataOps (Python $arrow.r$ PostgreSQL)
Debido a que el acceso a la información se realiza exclusivamente mediante la API REST (`http://4.157.251.192:8000/movigo`), se implementa un script en Python modular con las siguientes especificaciones:
- *Consumo Paginado Eficiente:* Rutina de paginación que itera mediante parámetros `limit=200` y `offset` incremental hasta agotar el `total` reportado por el sobre JSON.
- *Preservación de Integridad Referencial:* Reconstrucción de vínculos foráneos en memoria utilizando *pandas* para validar la coherencia de identificadores de zonas, conductores y pasajeros.
- *Auditoría Criptográfica:* Serialización de cada colección extraída en formato columnar *Parquet* con el cálculo de sumas de comprobación criptográficas *SHA-256* para certificar la inmutabilidad de los datos brutos.
- *Persistencia Relacional:* Ingesta directa de los dataframes hacia esquemas crudos en *PostgreSQL*.

=== Transformación Analítica y Modelado con dbt Core
Sobre la base de datos PostgreSQL se implementa *dbt Core* para estructurar el pipeline de transformación en dos capas:
+ *Capa de Estandarización (_Staging_):* Vistas intermedias SQL (`stg_viajes`, `stg_zonas`, `stg_clima`, `stg_conductores`, `stg_campanas`) donde se homogenizan nombres a convención `snake_case`, se tipifican marcas de tiempo en formato ISO 8601 con zona horaria de Managua (`America/Managua`) y se calculan métricas derivadas como el tiempo de espera hasta el abordaje:
  $ "tiempo_espera_min" = frac("fecha_hora_inicio" - "fecha_hora_solicitud", 60) $
+ *Capa de Modelado Dimensional (_Marts_):* Materialización de tablas físicas de hechos y dimensiones basadas en el modelado dimensional de Ralph Kimball.

=== Aseguramiento de Calidad de Datos (_dbt Tests_)
La integridad analítica se garantiza mediante aserciones automáticas declaradas en esquemas YAML de dbt:
- *Unicidad y No Nulidad:* En llaves primarias y foráneas subrogadas.
- *Reglas de Dominio Operativo:* Verificación estricta de que `multiplicador_dinamico >= 1.00`, `distancia_km >= 0`, `duracion_minutos >= 0` y `tarifa_final > 0`.
- *Consistencia de Estados:* Validación de categorías válidas en `estado_viaje` (`completado`, `cancelado_usuario`, `cancelado_conductor`, `no_asignado`).

== Diseño Dimensional Kimball: El Proceso del Viaje

El proceso de negocio central es la solicitud, cotización, ejecución o cancelación del viaje.

=== Grano de la Tabla de Hechos: `fact_viajes`
Cada registro corresponde a un evento transaccional de viaje solicitado (> 77,000 registros):
- *Métricas Monetarias:* `tarifa_base`, `multiplicador_dinamico`, `tarifa_final`, `propina`.
- *Métricas Operativas:* `distancia_km`, `duracion_minutos`, `tiempo_espera_minutos`.
- *Métricas de Resultado y Calidad:* `estado_viaje`, `motivo_cancelacion`, `calificacion_usuario`, `calificacion_conductor`.
- *Llaves Subrogadas Hash (MD5):* `hk_zona_origen`, `hk_zona_destino`, `hk_conductor`, `hk_usuario`, `hk_tiempo`, `hk_clima`.

=== Dimensiones Conformadas:
- *`dim_zona_origen` / `dim_zona_destino`:* Identificador natural, nombre del cuadrante, estrato socioeconómico (`alto`, `medio`, `popular`, `comercial`), latitud, longitud, radio de cobertura y tarifa de bajada de bandera.
- *`dim_tiempo`:* Fecha, hora, día de la semana, indicador de fin de semana y franja operativa (pico mañana: 07:00–08:59, valle día: 09:00–16:59, pico tarde: 17:00–18:59, nocturno: 19:00–06:59).
- *`dim_clima`:* Registro exógeno por fecha: milímetros de precipitación diaria (`precipitacion_mm`), temperatura (°C), índice de congestión vial (1.00 a 3.50) y condición atmosférica.
- *`dim_conductor`:* Flota registrada, tipo de vehículo (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), placa, año, calificación promedio histórica y tasa de aceptación.
- *`dim_usuario`:* Identificador, teléfono de contacto, método de pago habitual y calificación histórica.

== Metodología Analítica e Inferencia Estadística (Estadística II)

Los análisis inferenciales se ejecutan extrayendo vistas analíticas del Data Mart consolidado en Python mediante librerías científicas (`statsmodels`, `scipy`):

=== 1. Regresión Lineal Múltiple de la Demanda Diaria:
Se ajusta el modelo econométrico para cuantificar el efecto marginal de los choques meteorológicos y viales sobre la demanda agregada de viajes:

$ "ViajesDiarios"_t = beta_0 + beta_1 ("Precipitacion"_(m m, t)) + beta_2 ("IndiceCongestion"_t) + epsilon_t $

Se elabora la *Tabla ANOVA completa* para evaluar la significancia global del modelo ($F$-test, $p < 0.001$) y el coeficiente de determinación ($R^2$, $R^2_("adj")$).

=== 2. Verificación de Supuestos Clásicos de Gauss-Markov:
- *Normalidad:* Contraste de bondad de ajuste de residuos mediante Shapiro-Wilk y Jarque-Bera.
- *Homocedasticidad:* Prueba de Breusch-Pagan y prueba de White para validar varianza residual constante.
- *Independencia Serial:* Prueba de Durbin-Watson para confirmar ausencia de autocorrelación de primer orden ($d approx 2.0$).

=== 3. Batería de Contrastes de Hipótesis Formales:
- *Prueba $t$ de Welch (Muestras con Varianzas Heterogéneas):* 
  $ H_0: mu_("TarifaFinal")(m > 1.25) <= mu_("TarifaBase") quad "vs." quad H_1: mu_("TarifaFinal")(m > 1.25) > mu_("TarifaBase") $
  Validando el incremento monetario neto atribuible al multiplicador dinámico ($alpha = 0.05$).
- *Prueba $z$ de Dos Proporciones:*
  $ H_0: p_("cancel_pico") = p_("cancel_valle") quad "vs." quad H_1: p_("cancel_pico") > p_("cancel_valle") $
  Contrastando si la congestión en horas pico incrementa significativamente la tasa de abandono de viajes.
- *ANOVA de un Factor:* Evaluar si existen diferencias estadísticamente significativas en la duración del viaje y en la magnitud del multiplicador dinámico según el estrato socioeconómico de la zona de destino (`alto`, `medio`, `popular`, `comercial`), complementado con pruebas post-hoc de Tukey HSD.
- *Prueba de Independencia Chi-Cuadrado ($chi^2$):* Contrastar la hipótesis de independencia entre la modalidad de pago (`efectivo`, `tarjeta`, `billetera_digital`) y el estrato socioeconómico de origen ($alpha = 0.01$).

== Métodos Numéricos Computacionales

La calibración de la tarifa dinámica y la medición de la sensibilidad de mercado se resuelven mediante tres esquemas de análisis numérico:

=== 1. Búsqueda de Raíces para el Multiplicador de Equilibrio ($m^*$):
A partir de los datos empíricos de solicitudes aceptadas y vehículos disponibles por nivel de tarifa, se interpola la función de exceso de demanda $f(m) = "Demanda"(m) - "Oferta"(m)$.
- *Método de Bisección:* Método cerrado y globalmente convergente en un intervalo inicial $[a, b] = [1.00, 3.20]$ con tolerancia $"tol" = 10^(-5)$:
  $ m_k = frac(a_k + b_k, 2) $
- *Método de Newton-Raphson:* Esquema abierto con convergencia cuadrática local:
  $ m_(k+1) = m_k - frac(f(m_k), f'(m_k)) $
  donde $f'(m_k)$ se aproxima numéricamente.
Se comparan ambos métodos en términos de iteraciones requeridas, error residual $|f(m^*)|$ y tiempo computacional.

=== 2. Diferenciación Numérica de la Elasticidad-Precio:
Para cada cuadrante y franja horaria, se aproxima la derivada marginal de la demanda $frac(partial Q, partial P)$ mediante *diferencias finitas centradas de orden $cal(O)(h^2)$*:

$ f'(P) approx frac(Q(P + h) - Q(P - h), 2h) $

con paso óptimo $h$. A partir de esta aproximación se obtiene el coeficiente de elasticidad-precio:

$ epsilon = f'(P) dot frac(P, Q(P)) $

determinando si la demanda en los cuadrantes de Managua es elástica ($|epsilon| > 1$) o inelástica ($|epsilon| < 1$).

=== 3. Integración Numérica (Regla de Simpson 1/3):
A partir de la función continua de densidad horaria de viajes $q(t)$ para $t in [0, 24]$, se aplica la *Regla de Simpson 1/3* con particiones pares ($n >= 24$) para aproximar el volumen total diario de viajes:

$ integral_0^(24) q(t) dif t approx frac(Delta t, 3) [ q(t_0) + 4 sum_(i=1,3,dots)^(n-1) q(t_i) + 2 sum_(j=2,4,dots)^(n-2) q(t_j) + q(t_n) ] $

== Optimización Prescriptiva: Modelo de la Mochila (Knapsack 0/1) para Incentivos

Para solucionar el déficit de oferta sin depender exclusivamente del encarecimiento dinámico de la tarifa para los usuarios, se consume el catálogo `/movigo/campanas` y se formula el problema de selección óptima de bonos para choferes.

=== Formulación Matemática:
$ max sum_(k=1)^K v_k dot z_k $

sujeto a:

$ sum_(k=1)^K w_k dot z_k <= W_("max") $

$ z_k in {0, 1}, quad forall k in {1, dots, K} $

Donde:
- $z_k in {0, 1}$: Variable binaria que indica si la campaña de incentivo $k$ es financiada.
- $v_k$: Retorno esperado en *horas de conexión adicionales* (`incremento_horas_conexion`).
- $w_k$: Costo presupuestario en Córdobas asignado al programa (`costo_presupuesto_nio`).
- $W_("max") = 120\,000$ NIO: Techo presupuestario asignado por la administración de MoviGo.

=== Implementación y Resolución:
El modelo se implementa en Python utilizando *Programación Dinámica* con tabla de estados $D P[k, w]$ para garantizar la solución exacta y óptima global, contrastando el resultado contra la relajación lineal continua para evaluar el salto de primalidad (_integrality gap_).
