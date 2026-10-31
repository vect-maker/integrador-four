#show bibliography: none
#bibliography("../../references.bib")
#import "../../data_bindings.typ": total-trips-fmt, total-zones
#import "../../tables/index.typ": fig-strata-summary
#import "../../graphs/index.typ": fig-urban-network-topology

= Marco Teórico

== Mercados Bilaterales de Movilidad y Tarificación Dinámica (Surge Pricing)

Las plataformas de transporte selectivo bajo demanda (_ride-hailing_) operan bajo la estructura económica de los *mercados bilaterales* (_two-sided markets_) @cachon2017. En estos entornos, la plataforma actúa como intermediario tecnológico entre dos grupos de agentes interdependientes: los pasajeros que demandan traslados y los socios conductores independientes que suministran capacidad vehicular.

El desafío operativo cardinal de este modelo radica en la volatilidad espaciotemporal de la demanda frente a una oferta vehicular con rigideces de desplazamiento físico. Para coordinar ambos lados del mercado en tiempo real, las plataformas implementan algoritmos de *tarificación dinámica* (_surge pricing_) @zha2018.

Desde la perspectiva teórica, el multiplicador dinámico cumple dos funciones primordiales:
+ *Racionamiento de Demanda:* Eleva el costo del servicio en zonas o momentos saturados, incentivando a los usuarios con viajes postergables o elásticos a desistir de la solicitud.
+ *Incentivo de Oferta:* Incrementa los ingresos esperados de los choferes, atrayendo unidades desocupadas hacia los focos de alta demanda.

No obstante, cuando el multiplicador supera los umbrales de tolerancia económica de los usuarios o cuando la congestión vial impide que los vehículos lleguen a tiempo, el mecanismo puede colapsar, induciendo tasas severas de cancelación mutua y distorsiones territoriales @castillo2017.

== Microeconomía de la Demanda: Elasticidad-Precio y Cancelación de Viajes

El comportamiento del pasajero ante la cotización de un viaje se rige por la *teoría de la demanda y la elasticidad-precio*. La elasticidad-precio de la demanda ($epsilon$) mide la variación porcentual en la cantidad demandada de viajes ($Q$) ante un cambio porcentual en la tarifa ($P$):

$ epsilon = frac(Delta Q \/ Q, Delta P \/ P) = frac(partial Q, partial P) dot frac(P, Q) $ <eq-elasticidad>

En servicios de transporte urbano:
- *Demanda Inelástica ($|epsilon| < 1$):* El usuario requiere movilizarse de forma imperativa (ej. emergencias, compromisos laborales estrictos en horas pico) y tolera incrementos moderados en la tarifa.
- *Demanda Elástica ($|epsilon| > 1$):* El usuario posee alternativas viables o alta sensibilidad presupuestaria, reaccionando al incremento del multiplicador mediante el desistimiento inmediato o la *cancelación del viaje tras haber solicitado el servicio*.

En MoviGo, la tarifa final se define paramétricamente mediante la fórmula:

$ "TarifaBase" = "BajadaBandera"_z + (18.0 dot "distancia_km") + (4.5 dot "duracion_minutos") $

$ "TarifaFinal" = "TarifaBase" dot "multiplicador_dinamico" $

Donde el multiplicador dinámico oscila habitualmente entre $1.00times$ y $2.80times$, con techos extraordinarios de $3.20times$ durante tormentas. Cuando la tarifa final resultante excede el excedente del consumidor, o cuando el tiempo de espera estimado se dilata debido a la congestión, se desencadena la cancelación del viaje (`estado_viaje = 'cancelado_usuario'`), representando una pérdida económica neta tanto para la plataforma como para el conductor.

== Equidad Socio-Espacial y Disparidad Territorial en Managua

La teoría de la justicia espacial y el acceso al transporte urbano postula que las tarifas y la disponibilidad de los servicios de movilidad no deben discriminar ni excluir a las poblaciones de menores recursos.

En el municipio de Managua, la estructura urbana se caracteriza por una marcada heterogeneidad y fragmentación socioespacial. MoviGo discretiza la capital en 24 zonas urbanas agrupadas en cuatro estratos socioeconómicos y subdivididas en 298 cuadrantes operacionales (@tbl-strata-summary; el catálogo pormenorizado con coordenadas y radios de cobertura se detalla en el Apéndice B, @tbl-zones-catalog):

#fig-strata-summary <tbl-strata-summary>

En la arquitectura del servicio, la *zona de origen* del viaje ($z_"origen"$) es el factor determinante que fija el costo inicial del servicio mediante la tarifa de bajada de bandera ($"BajadaBandera"_(z_"origen")$). Este costo base, sumado a los cargos paramétricos por distancia ($18.00 "NIO/km"$) y tiempo ($4.50 "NIO/min"$), constituye la base imponible sobre la cual se aplica el multiplicador dinámico ($m$).

Esta estructuración genera una fuerte *asimetría en la propensión a la cancelación de viajes*:
+ *Condicionamiento del Medio de Pago:* En los cuadrantes populares de origen predomina el pago en *efectivo*, donde los usuarios planifican sus gastos con presupuestos líquidos estrictos. Cuando la plataforma aplica un multiplicador dinámico elevado ($m > 1.30times$), el sobrecosto sobrepasa la liquidez inmediata del pasajero, forzando la cancelación inmediata de la solicitud.
+ *Inelasticidad en Cuadrantes Altos:* Por el contrario, en los cuadrantes de estrato alto y comercial predomina el pago digital con *tarjeta de crédito o débito*, donde los usuarios presentan menor elasticidad-precio y mayor capacidad de absorber incrementos en la tarifa final sin recurrir a la cancelación.
+ *Doble Rol Dimensional:* Dentro del modelo analítico, la zona de origen actúa como la entidad generadora del viaje y rectora del precio base, mientras que la zona de destino determina la longitud del trayecto y las rutas de desplazamiento sobre la red vial capitalina.

== Arquitectura de Datos y Paradigma ELT

Para investigar empíricamente este fenómeno, se requiere una arquitectura analítica moderna capaz de transformar registros transaccionales dispersos en un repositorio estructurado para la toma de decisiones. 

Bajo las mejores prácticas de la ingeniería de datos contemporánea, la solución tecnológica se estructura bajo el paradigma *ELT (Extract, Load, Transform)*:

+ *Ingesta y Carga Cruda (Paradigma ELT):* Los procesos de extracción consumen las fuentes transaccionales y de catálogo, gestionando paginación sistemática, serializando archivos columnares en Apache Parquet y asegurando la integridad referencial antes de persistir los datos en un servicio administrado en la nube (*Azure Database for PostgreSQL*). Esta capa opera como réplica transaccional estructurada en la base de datos bajo el esquema `raw` (OLTP).
+ *Transformación Analítica con dbt Core:* La orquestación del almacén de datos se delega en herramientas declarativas de ingeniería analítica (*dbt Core*), estructurando las transformaciones en un flujo de dos niveles: una capa de limpieza y enriquecimiento operacional (_staging_) materializada como vistas lógicas, y una capa dimensional de negocio (_marts_) materializada físicamente en tablas optimizadas para procesamiento analítico en línea (OLAP) @kimball2013.

== Modelado Dimensional Kimball y Esquema en Estrella para Análisis del Viaje

El diseño analítico sigue rigurosamente los principios de modelado dimensional propuestos por Ralph Kimball @kimball2013, definiendo la atención y resolución del viaje como el proceso de negocio nodal a través de un *Esquema en Estrella* (_Star Schema_):

+ *Tabla de Hechos Atómica (`fct_viajes`):* Posee el grano más fino posible: un registro por cada intento o solicitud de traslado registrado ($N = #total-trips-fmt$). Centraliza tanto métricas monetarias (tarifa base, multiplicador dinámico aplicado, recargo absoluto por surge y tarifa final) como métricas operativas (distancia recorrida, duración efectiva, tiempo de espera en minutos) e indicadores dicotómicos del resultado del servicio (`is_cancelled`, `is_cancelled_by_user`, `is_cancelled_by_driver`, `is_completed`).
+ *Dimensiones Conformadas:* Proveen el contexto descriptivo y los filtros analíticos para el desglose multidimensional:
  - `dim_zones`: Caracteriza las #total-zones zonas urbanas de Managua, su estrato socioeconómico, clasificación ordinal de ingreso, coordenadas geográficas y costo base de bajada de bandera. Opera como dimensión de doble rol (_role-playing dimension_), relacionándose simultáneamente con la zona de origen (`sk_zone_origin`) y la zona de destino (`sk_zone_destination`).
  - `dim_quadrants`: Contiene los 298 cuadrantes espaciales discretizados, permitiendo análisis micro-territoriales, altimetría y clasificación de riesgo pluvial por cauces.
  - `dim_weather`: Registra a nivel diario la serie temporal meteorológica, cuantificando la precipitación en milímetros, temperatura ambiente, condición de cielo, presencia de lluvia, estacionalidad climática de Managua e índice de congestión vehicular.
  - `dim_users`: Consolida atributos de los pasajeros, su comportamiento histórico de calificación, segmento de reputación y preferencia de pago (efectivo versus medios digitales).
  - `dim_drivers`: Agrupa la información del parque vehicular (tipo de servicio: estándar, comfort o moto), modelo, año, estado activo, tasa de aceptación e historial acumulado de mantenimiento mecánico.
  - `dim_campaigns`: Almacena el portafolio de programas de incentivos y bonos para conductores, especificando el costo presupuestario, horas de conexión proyectadas y zona urbana objetivo.
+ *Llaves Subrogadas Sintéticas Determinísticas (MD5):* En concordancia con las mejores prácticas de la ingeniería analítica moderna, el enlace entre la tabla de hechos y las dimensiones no depende de las claves primarias autoincrementales del sistema origen, sino de llaves subrogadas hash (`sk_*`) generadas mediante la función criptográfica `md5(cast(id as text))`. Este mecanismo desacopla el almacén de posibles colisiones o mutaciones en los identificadores operativos, garantizando idempotencia, inmutabilidad y máxima eficiencia en las operaciones de cruce (_joins_).

== Optimización Numérica por Descenso de Gradiente (SGD) e Inferencia Paramétrica

La modelación de las relaciones operativas y financieras del servicio de movilidad se formula formalmente como un problema de *optimización matemática iterativa* sobre la función de pérdida del Error Cuadrático Medio ($"MSE"$). Dado un conjunto de observaciones muestrales $(x_i, y_i)_(i=1)^n$ donde $x_i$ representa la distancia de recorrido en kilómetros e $y_i$ la variable respuesta (duración del viaje en minutos o tarifa final en Córdobas - NIO), el modelo lineal postula:

$ y_i = beta_0 + beta_1 x_i + epsilon_i, quad epsilon_i tilde.op cal(N)(0, sigma^2) $ <eq-regresion-simple>

Para estimar los parámetros óptimos $bold(beta) = [beta_0, beta_1]^T$, se define la función convexa de pérdida cuadrática:

$ L(bold(beta)) = frac(1, 2n) sum_(i=1)^n (y_i - (beta_0 + beta_1 x_i))^2 $ <eq-loss-mse>

En lugar de recurrir a la solución analítica clásica de inversión matricial directa (ecuaciones normales $(X^T X)^(-1) X^T y$), cuya complejidad computacional y demanda de memoria escalan con el volumen transaccional masivo, se implementa el algoritmo iterativo de *Descenso de Gradiente Estocástico (SGD)*. La regla de actualización paramétrica en la época $k+1$ se rige por:

$ bold(beta)^((k+1)) = bold(beta)^((k)) - eta_k nabla L_i (bold(beta)^((k))) $ <eq-sgd-rule>

donde $eta_k$ representa la tasa de aprendizaje modulada mediante un esquema de decrecimiento inverso (_inverse scaling_):

$ eta_k = frac(eta_0, (1 + gamma dot k)^p) $ <eq-learning-rate>

Para asegurar un condicionamiento numérico favorable y evitar oscilaciones en valles alargados de la superficie de pérdida, la variable predictora es estandarizada previamente a escala normal estándar ($z = (x - mu) \/ sigma$). Tras alcanzar la convergencia algorítmica bajo el criterio $\|bold(beta)^((k+1)) - bold(beta)^((k))\|_2 < "tol"$, los coeficientes son des-escalados analíticamente a sus dimensiones físicas reales:

$ beta_1 = frac(w_"scaled", sigma_x), quad beta_0 = b_"scaled" - beta_1 mu_x $ <eq-unscaling>

=== Inferencia Estadística y Bandas de Confianza al 95%

Desde el marco de la inferencia estadística paramétrica, la varianza del estimador de mínimos cuadrados se deduce de la matriz de varianza-covarianza:

$ "Var"(hat(bold(beta))) = sigma^2 (X^T X)^(-1) $ <eq-var-covar>

donde la varianza residual insesgada del modelo se calcula mediante:

$ hat(sigma)^2 = frac(sum_(i=1)^n (y_i - hat(y)_i)^2, n - p) $ <eq-sigma2>

siendo $n$ el tamaño de muestra de entrenamiento y $p = 2$ el número de parámetros libres calculados (intercepto y pendiente). Los errores estándar de los estimadores corresponden a la raíz cuadrada de los elementos diagonales: $"SE"(hat(beta)_j) = sqrt(hat(sigma)^2 [(X^T X)^(-1)]_(j j))$.

Bajo el supuesto de normalidad asintótica garantizado por el Teorema del Límite Central sobre grandes muestras ($N_"train" > 39,000$), el intervalo de confianza al 95% para cada coeficiente paramétrico se establece formalmente como:

$ "IC"_(95%) (beta_j) = [hat(beta)_j - z_(alpha \/ 2) dot "SE"(hat(beta)_j), quad hat(beta)_j + z_(alpha \/ 2) dot "SE"(hat(beta)_j)] $ <eq-ci-95>

donde $z_(0.025) = 1.96$ corresponde al cuantil crítico de la distribución normal estándar.

== Fundamentos Teóricos para la Optimización Espacial y Auditoría de Ruteo

La infraestructura territorial y la movilidad urbana de Managua se modelan formalmente como una red espacial jerárquica de dos escalas:
- Una *red física densa de vías urbanas* $G_"street" = (V_s, E_s)$ extraída de OpenStreetMap, compuesta por $|V_s| = 69,695$ nodos de intersección y $|E_s| = 80,287$ aristas de circulación vial calibradas según su jerarquía funcional (autopistas, arterias principales, vías secundarias y residenciales), donde los tramos a menos de 50 metros de los 485 cauces pluviales sufren anegamiento y colapso de velocidad en eventos de lluvia (@fig-urban-network-topology).
- Una *red celular territorial* $G_"cell" = (V_c, E_c)$ de 298 cuadrantes (`dim_quadrants`) y 1,072 conexiones contiguas en 24 zonas analíticas, articulada con el Star Schema dimensional Kimball para el análisis macroscópico de flujos y centralidad de intermediación.
- Cada arista vial $(i, j) in E_s$ posee una función de impedancia temporal generalizada $tau_(i j)$ que cuantifica el costo de cruce en minutos a partir de su longitud física real $d_(i j)$:
  $ tau_(i j) = frac(d_(i j), v_(i j) (c)) dot 60 $
  donde $v_(i j)(c)$ es la velocidad efectiva de circulación condicionada por la jerarquía vial y el régimen meteorológico $c in {"seco", "tormenta"}$:
  $ v_(i j) (c) = v_(0, "vía") dot (1 - 0.75 dot bb(I)_"anegamiento") $

#fig-urban-network-topology <fig-urban-network-topology>

Para identificar los puntos neurálgicos de estrangulamiento y vulnerabilidad estructural en el sistema de transporte, se analiza la *Centralidad de Intermediación (_Betweenness Centrality_)* de cada cuadrante y zona urbana:

$ C_B (v) = sum_(s eq.not v eq.not t) frac(sigma_(s t)(v), sigma_(s t)) $ <eq-betweenness>

donde $sigma_(s t)$ es el número total de caminos más cortos entre los pares de origen y destino $s$ y $t$, y $sigma_(s t)(v)$ es la cantidad de dichos caminos que transitan obligatoriamente a través del vértice $v$.

=== Auditoría Algorítmica de Caja Negra y Algoritmo de Dijkstra

Dado que el algoritmo de ruteo interno de la plataforma MoviGo es propietario y cerrado (*black box*), su desempeño se evalúa a través de los resultados empíricos observados en el almacén analítico ($t_"real"$, $v_"real"$, $d_"real"$). Para contrastar este comportamiento frente a una alternativa óptima, se implementa el *Algoritmo de Dijkstra* con relajación de aristas:

$ "dist"[j] = min("dist"[j], "dist"[i] + tau_(i j)) $

Dijkstra determina la trayectoria prescriptiva de mínima impedancia capaz de circunnavegar activamente los cuadrantes con cauces desbordados (como el Cauce Occidental y el Cauce Oriental). La ineficiencia o sub-optimización de las rutas observadas de MoviGo frente al óptimo prescriptivo se cuantifica mediante el *Índice de Sub-optimización* ($rho$) y el ahorro temporal neto ($Delta T$):

$ rho = frac(t_"real", t_"óptimo"), quad Delta T = t_"real" - t_"óptimo" $

Este marco permite demostrar empíricamente cómo el ruteo adaptativo no solo reduce las dilataciones de viaje en hasta un 60%, sino que previene el cruce del umbral crítico de 15 minutos de espera que precipita las cancelaciones de viajes.

=== Arquitectura DataOps y Reproducibilidad Computacional

El marco de ingeniería del proyecto se sustenta en los principios de automatización y reproducibilidad de la computación científica en entornos tipo Unix/Linux:
- *Orquestación Declarativa vía `justfile`:* Automatiza la ejecución end-to-end de tareas analíticas y de compilación mediante un ejecutor de comandos centralizado.
- *Shell Scripting Profesional en Bash:* Implementación de scripts de extracción y carga con directivas estrictas (`set -euo pipefail`) para garantizar fallas tempranas ante cualquier inconsistencia.
- *Motor Analítico Columnar DuckDB:* Ejecuta consultas de agregación analítica OLAP de alto rendimiento directamente sobre el archivo de base de datos en proceso (`pipeline/data/analytics.duckdb`), exportando contratos de datos estructurados en formato JSON.
- *Paradigma Data-to-Document en Typst:* El documento final no almacena cifras estáticas manuales; todas las métricas, parámetros de regresión, raíces y tiempos de ruta se leen dinámicamente en tiempo de compilación desde los archivos JSON, garantizando un flujo determinístico sin margen de error por transcripción humana (*zero human drift*).
