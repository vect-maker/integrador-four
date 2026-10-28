#show bibliography: none
#bibliography("../../references.bib")
#import "../../data_bindings.typ": total-trips-fmt, total-zones
#import "../../tables/index.typ": fig-zones-catalog
#import "../../graphs/index.typ": (
  fig-market-equilibrium,
  fig-numerical-convergence,
  fig-urban-network-topology,
  fig-urban-network-dijkstra,
)

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

En el municipio de Managua, la estructura urbana se caracteriza por una marcada heterogeneidad y fragmentación espacial. MoviGo estructura la capital en 24 zonas urbanas agrupadas en cuatro estratos socioeconómicos y subdivididas en 298 cuadrantes espaciales (@tbl-zones-catalog):
- *Alto:* Villa Fontana, Las Colinas, Santo Domingo (bajada de bandera base de C\$ 70.0 a C\$ 80.0 NIO).
- *Medio:* Los Robles, Altamira, Bolonia, Bello Horizonte, Linda Vista (bajada de bandera base de C\$ 48.0 a C\$ 55.0 NIO).
- *Comercial:* Metrocentro / Eje Corporativo UCA, Centro Cívico, Carretera Norte (bajada de bandera base de C\$ 55.0 a C\$ 60.0 NIO).
- *Popular:* Ciudad Jardín, Mercado Oriental, Mercado Roberto Huembes, Villa Libertad, Sabana Grande (bajada de bandera base de C\$ 35.0 a C\$ 45.0 NIO).

#fig-zones-catalog <tbl-zones-catalog>

En la arquitectura del servicio, la *zona de origen* del viaje ($z_"origen"$) es el factor determinante que fija el costo inicial del servicio mediante la tarifa de bajada de bandera ($"BajadaBandera"_(z_"origen")$). Este costo base, sumado a los cargos paramétricos por distancia ($18.00 "NIO/km"$) y tiempo ($4.50 "NIO/min"$), constituye la base imponible sobre la cual se aplica el multiplicador dinámico ($m$).

Esta estructuración genera una fuerte *asimetría en la propensión a la cancelación de viajes*:
+ *Condicionamiento del Medio de Pago:* En los cuadrantes populares de origen predomina el pago en *efectivo*, donde los usuarios planifican sus gastos con presupuestos líquidos estrictos. Cuando la plataforma aplica un multiplicador dinámico elevado ($m > 1.30times$), el sobrecosto sobrepasa la liquidez inmediata del pasajero, forzando la cancelación inmediata de la solicitud.
+ *Inelasticidad en Cuadrantes Altos:* Por el contrario, en los cuadrantes de estrato alto y comercial predomina el pago digital con *tarjeta de crédito o débito*, donde los usuarios presentan menor elasticidad-precio y mayor capacidad de absorber incrementos en la tarifa final sin recurrir a la cancelación.
+ *Doble Rol Dimensional:* Dentro del modelo analítico, la zona de origen actúa como la entidad generadora del viaje y rectora del precio base, mientras que la zona de destino determina la longitud del trayecto y las rutas de desplazamiento sobre la red vial capitalina.

== Arquitectura de Datos y Paradigma ELT vía API REST

Para investigar empíricamente este fenómeno, se requiere una arquitectura analítica moderna capaz de transformar registros transaccionales dispersos en un repositorio estructurado para la toma de decisiones. 

Dado que MoviGo expone sus datos a través de una API REST pública (proporcionada en una URL temporal para fines académicos), la solución tecnológica se estructura bajo el paradigma *ELT (Extract, Load, Transform)*:

+ *Ingesta y Carga Cruda (Python $arrow.r$ Azure PostgreSQL):* Un cliente modular en Python (`fetcher.py`) consume los endpoints transaccionales y de catálogo, gestionando paginación sistemática (`limit=200`, `offset`), serializando archivos columnares en Apache Parquet y asegurando la integridad referencial antes de persistir los datos en un servicio administrado en la nube (*Azure Database for PostgreSQL*). Esta capa opera como réplica transaccional estructurada en la base de datos `postgres` bajo el esquema `raw` (OLTP).
+ *Transformación Analítica con dbt Core:* La orquestación del almacén de datos se delega en *dbt (Data Build Tool)*, estructurando las transformaciones en un flujo de dos niveles: una capa de limpieza y enriquecimiento operacional (_staging_) materializada como vistas lógicas, y una capa dimensional de negocio (_marts_) materializada físicamente en tablas optimizadas para procesamiento analítico en línea (OLAP) @kimball2013.

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

== Fundamentos Teóricos para el Análisis Cuantitativo

A partir de la base de datos analítica consolidada, la investigación articula tres pilares cuantitativos complementarios y su marco de reproducibilidad computacional:

=== Modelación Econométrica y Descomposición de Varianza (MCO y ANOVA)

Para evaluar el impacto del multiplicador tarifario sobre las cancelaciones, se recurre a la teoría de *Mínimos Cuadrados Ordinarios (MCO)*. En el modelo de regresión lineal simple:

$ Y_t = beta_0 + beta_1 X_t + epsilon_t $ <eq-mco-teoria>

donde $Y_t$ es la tasa de cancelación observada en el día $t$, $X_t = overline(m)_t$ es el multiplicador dinámico promedio diario, y $epsilon_t$ es la perturbación estocástica con esperanza nula y varianza constante ($sigma^2$).

Los estimadores de los parámetros se obtienen minimizando la suma de los errores al cuadrado:

$ hat(beta)_1 = frac(sum_(t=1)^n (X_t - overline(X))(Y_t - overline(Y)), sum_(t=1)^n (X_t - overline(X))^2), quad hat(beta)_0 = overline(Y) - hat(beta)_1 overline(X) $

La significancia global y la capacidad explicativa del modelo se contrastan formalmente a través del *Análisis de Varianza (ANOVA)*, que descompone la variabilidad total observada ($S S T$) en la variabilidad explicada por la regresión ($S S R$) y la variabilidad residual no explicada ($S S E$):

$ S S T = S S R + S S E $

El estadístico $F$ de Fisher-Snedecor contrasta la hipótesis nula de ausencia de relación ($H_0: beta_1 = 0$ frente a $H_1: beta_1 eq.not 0$):

$ F = frac(M S R, M S E) = frac(S S R \/ 1, S S E \/ (n - 2)) $

con un coeficiente de determinación $R^2 = frac(S S R, S S T)$ que mide la proporción de la varianza en cancelaciones explicada por la tarifa dinámica.

=== Análisis Numérico de Equilibrio de Mercado y Búsqueda de Raíces

En los sistemas de transporte bajo demanda, la condición de balance entre la demanda de pasajeros $D(m)$ y la oferta de unidades $S(m)$ se formula como una ecuación no lineal continua:

$ f(m) = D(m) - S(m) = 0 $ <eq-balance-mercado>

La intersección de ambas funciones microeconómicas determina el punto de equilibrio operativo $m^*$, donde el exceso de demanda se anula y la flota de conductores activos absorbe el volumen horario de viajes (@fig-market-equilibrium).

#fig-market-equilibrium <fig-market-equilibrium>

Al carecer de solución analítica directa en forma cerrada, la determinación del multiplicador de equilibrio $m^*$ requiere algoritmos iterativos de búsqueda de raíces:

+ *Método de la Bisección (Método Cerrado):* Fundamentado en el *Teorema del Valor Intermedio (Bolzano)*. Si $f(m)$ es continua en el intervalo $[a_0, b_0]$ y $f(a_0) dot f(b_0) < 0$, existe al menos una raíz en el intervalo. En cada paso se evalúa el punto medio $m_k = frac(a_k + b_k, 2)$, reduciendo el intervalo a la mitad con convergencia lineal de orden $r = 1$, garantizando estabilidad incondicional.
+ *Método de Newton-Raphson (Método Abierto):* Aproxima la función localmente mediante su recta tangente utilizando la primera derivada analítica $f'(m)$:
  $ m_(k+1) = m_k - frac(f(m_k), f'(m_k)) $
  Presenta convergencia cuadrática de orden $r = 2$ en las proximidades de la raíz, requiriendo significativamente menos iteraciones para alcanzar una tolerancia de parada dada ($|f(m_k)| < epsilon$ con $epsilon = 10^(-6)$).

La trayectoria de reducción del error absoluto estimado en escala semilogarítmica confirma la superioridad algorítmica de Newton-Raphson (5 iteraciones frente a 20 de la Bisección para una tolerancia de $10^(-6)$), tal como se expone en la @fig-numerical-convergence.

#fig-numerical-convergence <fig-numerical-convergence>

=== Optimización Espacial en Redes y Algoritmo de Ruta Más Corta (Dijkstra)

La infraestructura vial urbana de Managua se modela formalmente como una red espacial mediante un *grafo dirigido y ponderado* $G = (V, E)$, donde:
- $V = {v_1, v_2, dots, v_(24)}$ representa el conjunto de vértices correspondientes a los 24 centroides zonales de la capital.
- $E subset.eq V times V$ representa el conjunto de 44 corredores y arterias viales principales (@fig-urban-network-topology).
- Cada arista $(i, j) in E$ posee una función de costo o impedancia temporal $tau_(i j)$ que cuantifica el tiempo de viaje estimado en minutos:
  $ tau_(i j) (c) = frac(d_(i j), v_(i j) (c)) dot 60 $
  donde $d_(i j)$ es la distancia vial entre zonas y $v_(i j)(c)$ es la velocidad de circulación condicionada por el régimen meteorológico $c in {"seco", "tormenta"}$.

#fig-urban-network-topology <fig-urban-network-topology>

Para determinar la trayectoria de mínima impedancia entre un punto de partida y un destino, se implementa el *Algoritmo de Dijkstra*, el cual mantiene una estimación de distancia tentativa desde el origen y actualiza progresivamente las etiquetas de los nodos adyacentes mediante la operación de *relajación de aristas*:

$ "dist"[j] = min("dist"[j], "dist"[i] + tau_(i j)) $

Este enfoque permite cuantificar el incremento en el tiempo de viaje y los desvíos obligados cuando arterias neurálgicas sufren anegamientos severos. La @fig-urban-network-dijkstra ilustra este comportamiento para la diagonal metropolitana Linda Vista -- Santo Domingo (OD_1): bajo flujo seco el algoritmo traza la ruta directa vía Los Robles (25.48 min, 13.59 km), mientras que durante una tormenta tropical con cauces desbordados, Dijkstra re-rutea la unidad por Metrocentro, generando una demora adicional del 38.0% (35.17 min, 14.07 km).

#fig-urban-network-dijkstra <fig-urban-network-dijkstra>

=== Arquitectura DataOps y Reproducibilidad Computacional

El marco de ingeniería del proyecto se sustenta en los principios de automatización y reproducibilidad de la computación científica en entornos tipo Unix/Linux:
- *Orquestación Declarativa vía `justfile`:* Automatiza la ejecución end-to-end de tareas analíticas y de compilación mediante un ejecutor de comandos centralizado.
- *Shell Scripting Profesional en Bash:* Implementación de scripts de extracción y carga con directivas estrictas (`set -euo pipefail`) para garantizar fallas tempranas ante cualquier inconsistencia.
- *Motor Analítico Columnar DuckDB:* Ejecuta consultas de agregación analítica OLAP de alto rendimiento directamente sobre el archivo de base de datos en proceso (`pipeline/data/analytics.duckdb`), exportando contratos de datos estructurados en formato JSON.
- *Paradigma Data-to-Document en Typst:* El documento final no almacena cifras estáticas manuales; todas las métricas, parámetros de regresión, raíces y tiempos de ruta se leen dinámicamente en tiempo de compilación desde los archivos JSON, garantizando un flujo determinístico sin margen de error por transcripción humana (*zero human drift*).
