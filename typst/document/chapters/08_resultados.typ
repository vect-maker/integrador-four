#show bibliography: none
#bibliography("../../references.bib")

#import "../../data_bindings.typ": (
  total-trips-fmt, total-cancellations-fmt, total-completions-fmt, cancellation-rate, avg-surge,
  avg-final-fare, avg-distance-km, avg-wait-time-min, total-users, total-drivers, total-zones,
  total-quadrants, total-weather-days, total-campaigns, dbt-total-tests, dbt-staging-models,
  dbt-mart-models, dbt-tests-unique, dbt-tests-not-null, dbt-tests-relationships,
  dbt-tests-accepted-values, inv-integrity, regression-n-total, regression-n-train, regression-n-test,
  m1-b0, m1-b1, m1-r2, m1-r2-train, m1-mae, m1-rmse, m1-ci-b1-low, m1-ci-b1-upp, m1-epochs,
  m2-b0, m2-b1, m2-r2, m2-r2-train, m2-mae, m2-rmse, m2-ci-b1-low, m2-ci-b1-upp, m2-epochs,
  sgd-eta0, dist-mean-km, dur-skew, fare-skew, surge-mean-completed, flag-drop-min, flag-drop-max,
  fmt-dec, predict, routing-nodes, routing-edges, routing-avg-dry, routing-avg-storm,
  routing-net-delay, routing-pairs, routing-diameter-dry, routing-diameter-storm,
  routing-flood-corridors, routing-speed-dry, routing-speed-storm, routing-tortuosity,
  bn1-name, bn2-name, bn3-name, bn1-stratum, bn1-dry, bn2-dry, bn3-dry, bn1-storm, bn2-storm,
  bn3-storm, bn2-degree, bn3-degree, od1-origin, od1-dest, od1-dry-time, od1-storm-time,
  od1-delay-pct, od1-dry-route, od1-storm-route, od2-origin, od2-dest, od2-dry-time,
  od2-storm-time, od2-delay-pct, od2-dry-route, od3-origin, od3-dest, od3-dry-time,
  od3-storm-time, od3-delay-pct,
)
#import "../../diagrams/star_schema.typ": fig-star-schema
#import "../../tables/index.typ": (
  fig-data-inventory, fig-general-kpis, fig-regression-summary, fig-bottlenecks, fig-routing-comparison,
)
#import "../../graphs/index.typ": (
  fig-trip-origins-density, fig-numerical-duration, fig-numerical-fare, fig-urban-network-dijkstra,
)
#import "../../snippets.typ": fig-dbt-integrity, fig-duckdb-kpis

= Resultados y Discusión

La investigación partió de una pregunta concreta: de qué manera un repositorio analítico multidimensional y la optimización espacial de la red vial permiten cuantificar los estrangulamientos de MoviGo y mitigar sus demoras ante contingencias climáticas. Responderla exigió recorrer tres tramos que no son independientes. El primero convierte #total-trips-fmt solicitudes dispersas en un repositorio auditable. El segundo mide hasta dónde la distancia explica el tiempo y el precio de un viaje. El tercero busca en la geografía urbana los puntos donde el sistema pierde tiempo. Cada tramo prepara al siguiente: sin un dato confiable no hay modelo que signifique algo; sin un modelo de tiempo y costo no se sabe qué buscar en la red; sin el mapa de la red, el promedio urbano oculta dónde se concentra el problema. El capítulo sigue ese recorrido y discute, en el mismo movimiento, lo que cada resultado permite afirmar y lo que deja fuera.

== El repositorio: convertir registros dispersos en una base confiable (Objetivo 1)

El primer objetivo específico consistió en consolidar un repositorio analítico multidimensional a partir de los registros operativos del servicio. La tarea suele describirse como infraestructura, pero define el alcance de todo lo que sigue: un repositorio mal integrado produce promedios que parecen ciertos y coeficientes que no resisten la auditoría. Por eso el trabajo no terminó cuando los datos estuvieron cargados; terminó cuando cada cifra pudo rastrearse hasta su origen.

=== La arquitectura que hace posible la consulta

Las fuentes llegaron separadas. La API expone siete conjuntos —zonas, usuarios, conductores, campañas, clima, viajes y telemetría— que describen el mismo servicio desde ángulos distintos. El flujo de extracción, carga y transformación los recuperó con paginación controlada, los serializó en archivos columnares Parquet y los cargó en un esquema relacional normalizado. Sobre esa base, la capa de transformación construyó el modelo dimensional. La elección no es estética: un esquema en estrella permite que una consulta analítica cruce el viaje con la zona, el clima o el usuario mediante una sola unión, en lugar de recorrer las tablas normalizadas de origen, siguiendo los principios del modelado dimensional de Kimball @kimball2013.

El resultado es una tabla de hechos con #total-trips-fmt registros —uno por cada intento de viaje de 2024, sin muestreo— y seis dimensiones que describen a #total-users pasajeros, #total-drivers conductores, #total-zones zonas urbanas, #total-quadrants cuadrantes, #total-weather-days días de clima y #total-campaigns campañas de incentivos (@tbl-data-inventory). La tabla de hechos conserva el grano atómico; las dimensiones aportan el contexto que hace legible cada registro: quién viajó, desde dónde, hacia dónde, bajo qué clima y dentro de qué campaña.

#fig-data-inventory <tbl-data-inventory>

La estructura resultante es un esquema en estrella: la tabla de hechos al centro y cada dimensión unida por llaves sustitutas (@fig-star-schema). Con esa forma, el repositorio deja de ser un archivo de transacciones y se convierte en una base para comparar territorios. El diccionario completo de campos está en el Apéndice C (@tbl-star-schema).

#fig-star-schema <fig-star-schema>

=== La integridad se prueba, no se supone

La calidad se verificó en dos frentes. El proyecto dbt declara #dbt-total-tests pruebas automáticas sobre #(dbt-staging-models + dbt-mart-models) modelos (#dbt-staging-models de preparación y #dbt-mart-models dimensionales): #dbt-tests-unique de unicidad, #dbt-tests-not-null de completitud, #dbt-tests-relationships de integridad referencial y #dbt-tests-accepted-values de valores permitidos. El fragmento de la @fig-dbt-integrity muestra cómo se declaran esas pruebas sobre la tabla de hechos: la llave primaria subrogada debe ser única y no nula, y cada llave foránea debe existir en su dimensión correspondiente.

#fig-dbt-integrity <fig-dbt-integrity>

La segunda verificación fue una auditoría directa del repositorio final. El resultado fue consistente con las pruebas: #inv-integrity.duplicated_trip_keys viajes duplicados, #inv-integrity.total_orphans llaves huérfanas entre la tabla de hechos y sus dimensiones, #inv-integrity.total_null_keys llaves vacías y #inv-integrity.total_null_metrics valores vacíos en distancia, duración, tarifa final y multiplicador dinámico. Ninguna de las dos verificaciones sustituye a la otra: las pruebas previenen regresiones en la transformación, y la auditoría confirma que el estado actual del almacén es íntegro.

La consecuencia práctica es directa. Cada viaje apunta a una zona, un usuario, un conductor y un día que existen, y las variables que alimentan los modelos del Objetivo 2 están completas; no fue necesario imputar valores. La integridad no es un sello final, sino la condición que permite que las regresiones y la red se lean como resultados y no como artefactos de un cruce mal hecho.

=== El censo de 2024 y el mapa de la desigualdad territorial

Con el repositorio validado, la primera consulta fue un censo general del servicio (@tbl-general-kpis). De los #total-trips-fmt viajes registrados, #total-completions-fmt se completaron y #total-cancellations-fmt se cancelaron, lo que arroja una tasa de cancelación de #cancellation-rate%. El multiplicador dinámico promedio fue #avg-surge, la tarifa final promedio de C\$ #avg-final-fare, el recorrido medio de #avg-distance-km km y el tiempo de espera promedio de #avg-wait-time-min minutos. La consulta que produce estas cifras se conserva en el repositorio y se ejecuta en cada actualización (@fig-duckdb-kpis), de modo que el censo no depende de una transcripción manual.

#fig-general-kpis <tbl-general-kpis>

#fig-duckdb-kpis <fig-duckdb-kpis>

Una tasa de cancelación de #cancellation-rate% implica que poco más de un tercio de las solicitudes no termina en viaje. Ese nivel de fricción no se explica por una sola causa, pero sí justifica mirar el fenómeno en dos escalas: la del viaje individual, donde la distancia y el precio importan, y la del territorio, donde las condiciones de acceso cambian según la zona. El censo ofrece la primera escala; el mapa ofrece la segunda.

La ubicación de las solicitudes se proyectó sobre la trama urbana de Managua (@fig-trip-origins-density). Los orígenes se concentran en los polos comerciales y corporativos y se dispersan hacia las zonas populares y periféricas. Esa diferencia territorial no es un detalle descriptivo: anticipa que un mismo servicio opera con condiciones de acceso distintas y que la red vial puede amplificar o amortiguar esa desigualdad.

#fig-trip-origins-density <fig-trip-origins-density>

=== Lo que este repositorio no puede decir

Tres límites acotan lo que el repositorio permite afirmar. Los datos provienen de un entorno de simulación de alta fidelidad, no de registros reales de la empresa; los resultados describen el comportamiento del simulador y no necesariamente el de la operación histórica. El análisis trabaja sobre una copia local en DuckDB tomada en un momento dado, no sobre un flujo continuo. Y el repositorio está diseñado para responder preguntas sobre viajes y zonas, no sobre la experiencia del pasajero ni la calidad percibida del servicio. Reconocerlo no debilita el resultado: delimita su alcance.

Con todo, el repositorio deja una base firme. La distancia, la duración y la tarifa final de cada viaje completado quedan disponibles para el siguiente tramo; las zonas y el clima, para el análisis de red. La pregunta que sigue es si la distancia basta para explicar el tiempo y el precio.

== La distancia: dos ecuaciones para entender tiempo y precio (Objetivo 2)

El segundo objetivo específico buscó modelar cómo la distancia del viaje determina su duración y su costo. La pregunta no es trivial: si la distancia explicara el tiempo con precisión, la planeación operativa podría reducirse a medir kilómetros; si explicara también el precio, la tarifa dinámica sería un ajuste menor. Los datos mostraron una realidad más matizada.

Se usaron los #regression-n-total viajes completados del repositorio, ya que solo estos tienen duración y tarifa cobrada. Los modelos se ajustaron con #regression-n-train viajes (80%) y se evaluaron con los #regression-n-test restantes (20%), que el algoritmo nunca vio durante el ajuste. Se trató de dos regresiones lineales simples, una para la duración y otra para la tarifa, con la distancia como única variable de entrada. Los coeficientes se estimaron por descenso de gradiente estocástico y se acompañaron de intervalos de confianza al 95%; la separación entre entrenamiento y prueba permite evaluar generalización, no solo ajuste.

=== El tiempo de viaje sigue a la distancia

La recta ajustada para estimar la duración $hat(y)$, en minutos, a partir de la distancia $d$, en km, es:

$ hat(y)_"min" = #fmt-dec(m1-b0) + #fmt-dec(m1-b1) dot d $

La pendiente tiene una lectura inmediata: cada kilómetro adicional añade #fmt-dec(m1-b1) minutos al viaje, lo que equivale a una velocidad media de #fmt-dec(60 / m1-b1, digits: 1) km/h dentro de Managua. El intercepto (#fmt-dec(m1-b0) min) recoge el tiempo que el viaje paga antes de moverse: el arranque, la recogida y la incorporación al flujo. Esa separación importa porque distingue lo que crece con la distancia de lo que se cobra una sola vez. Para el viaje promedio de #fmt-dec(dist-mean-km) km, la ecuación predice alrededor de #fmt-dec(predict(m1-b0, m1-b1, dist-mean-km), digits: 1) minutos.

La incertidumbre del coeficiente es estrecha. Con un 95% de confianza, el efecto real de la distancia está entre #fmt-dec(m1-ci-b1-low) y #fmt-dec(m1-ci-b1-upp) minutos por kilómetro: el intervalo está lejos de cero y su amplitud es pequeña, de modo que el efecto es estadísticamente significativo y estable. En los viajes de prueba, el modelo explica el #fmt-dec(m1-r2 * 100, digits: 1)% de la variación de la duración ($R^2 = #fmt-dec(m1-r2, digits: 3)$), con un error típico de #fmt-dec(m1-mae) minutos (MAE). El RMSE (#fmt-dec(m1-rmse) min) es mayor porque penaliza con más fuerza los errores grandes: existen viajes con demoras muy superiores a lo esperado, en línea con la asimetría de la duración (coeficiente de #fmt-dec(dur-skew, digits: 1)).

La lectura operativa es directa: la ecuación permite estimar el tiempo de llegada antes de iniciar el viaje y ajustar la promesa al pasajero. Pero el ajuste no es perfecto. La dispersión vertical de la @fig-numerical-duration muestra viajes que se alargan más de lo previsto, y esos casos son precisamente los que la operación necesita anticipar. El modelo describe la tendencia; no reemplaza el seguimiento del viaje en curso.

#fig-numerical-duration <fig-numerical-duration>

=== La tarifa obedece a más que la distancia

La recta ajustada para estimar la tarifa final, en córdobas, es:

$ hat(y)_"C$" = #fmt-dec(m2-b0) + #fmt-dec(m2-b1) dot d $

Cada kilómetro adicional encarece el viaje en promedio C\$ #fmt-dec(m2-b1), con un intervalo de confianza al 95% entre C\$ #fmt-dec(m2-ci-b1-low) y C\$ #fmt-dec(m2-ci-b1-upp). El intercepto (C\$ #fmt-dec(m2-b0)) funciona como un cargo base del servicio. Es algo mayor que la bajada de bandera de las zonas (entre C\$ #fmt-dec(flag-drop-min) y C\$ #fmt-dec(flag-drop-max)), porque además del arranque absorbe el cobro por el tiempo fijo del viaje y, en promedio, parte del recargo dinámico. Para el viaje promedio, la ecuación sitúa la tarifa en torno a C\$ #fmt-dec(predict(m2-b0, m2-b1, dist-mean-km)).

El ajuste, sin embargo, es claramente menor que el del modelo de duración. La tarifa explica el #fmt-dec(m2-r2 * 100, digits: 1)% de la variación ($R^2 = #fmt-dec(m2-r2, digits: 3)$), con un error típico de C\$ #fmt-dec(m2-mae) (MAE) y un RMSE de C\$ #fmt-dec(m2-rmse). La diferencia no es un defecto del modelo, sino una pista: la tarifa no depende solo de la distancia. También depende del multiplicador dinámico (en promedio #fmt-dec(surge-mean-completed) en los viajes completados), de la bajada de bandera de cada zona y del tiempo real del trayecto. La literatura sobre tarificación dinámica coincide en que el multiplicador responde a tráfico, clima y entorno urbano @battifarano2019; por eso una recta de distancia no puede capturarlo todo @cachon2017.

#fig-numerical-fare <fig-numerical-fare>

La dispersión vertical de la @fig-numerical-fare confirma esa lectura: viajes de igual distancia pueden tener precios muy distintos. En términos operativos, la ecuación sirve como referencia de precio base, no como cotización exacta. Para el pasajero, la promesa de precio es menos confiable que la promesa de llegada; para la plataforma, la estimación debe combinarse con el multiplicador vigente y el estado de la red.

=== Lo que ambas ecuaciones permiten y lo que ocultan

La @tbl-regression-summary reúne ambos modelos. El descenso de gradiente llegó a la solución en #m1-epochs épocas para la duración y en #m2-epochs para la tarifa, partiendo de una tasa de aprendizaje inicial de #sgd-eta0. La convergencia rápida se explica por la estandarización previa de la distancia, que acondiciona la superficie de error y facilita el descenso.

#fig-regression-summary <tbl-regression-summary>

Los valores de $R^2$ en entrenamiento y en prueba son casi iguales en el modelo de duración (#fmt-dec(m1-r2-train, digits: 3) frente a #fmt-dec(m1-r2, digits: 3)), lo que indica una buena generalización. En la tarifa la diferencia es mayor (#fmt-dec(m2-r2-train, digits: 3) frente a #fmt-dec(m2-r2, digits: 3)). Con solo dos parámetros, esa brecha no indica sobreajuste: se explica por las tarifas extremas. La tarifa es muy asimétrica (coeficiente de #fmt-dec(fare-skew, digits: 1)), y unos pocos viajes muy caros en el conjunto de prueba bastan para reducir el $R^2$.

Las dos ecuaciones comparten una limitación de diseño: una sola variable de entrada. Dejan fuera la tarifa dinámica, la congestión y la lluvia; en la duración el sesgo es menor porque la distancia es el determinante principal, pero en la tarifa el efecto es grande. Los intervalos de confianza suponen, además, que la dispersión de los errores es la misma para viajes cortos y largos; la asimetría observada sugiere que esa dispersión crece con la distancia, de modo que los intervalos podrían ser algo más estrechos de lo real. Y los datos, otra vez, provienen de un simulador.

El resultado conjunto permite una conclusión operativa: la distancia ofrece una estimación razonable del tiempo y una estimación parcial del costo. Para el pasajero, eso se traduce en una promesa de llegada más confiable que una promesa de precio. Para la plataforma, en la necesidad de combinar la ecuación con el multiplicador vigente y el estado de la red. Esa última condición conduce al tercer tramo: el promedio de #fmt-dec(60 / m1-b1, digits: 1) km/h describe la ciudad en conjunto, pero no dice dónde se pierde el tiempo.

== La red: dónde se concentra el tiempo perdido (Objetivo 3)

El tercer objetivo específico buscó optimizar las trayectorias y la resiliencia de la red vial metropolitana. El punto de partida es una limitación del resultado anterior: una velocidad media de #fmt-dec(60 / m1-b1, digits: 1) km/h trata a la ciudad como un punto. En la práctica, el tiempo se pierde en corredores concretos y la lluvia no afecta a todos por igual. La pregunta cambia de escala: no cuánto tarda un viaje en promedio, sino por dónde se mueve y qué ocurre cuando el agua interrumpe los corredores críticos.

=== Una ciudad de 24 nodos y 44 corredores

La red se modeló como un grafo $G = (V, E)$ con #routing-nodes nodos —las #total-zones zonas urbanas— y #routing-edges corredores arteriales (@fig-urban-network-topology). Cada arista recibió un peso de tiempo: la distancia Haversine entre coordenadas, corregida por un factor de tortuosidad de #routing-tortuosity y dividida por la velocidad de circulación. En escenario seco se usó una velocidad base de #routing-speed-dry km/h; en tormenta, de #routing-speed-storm km/h. Los #routing-flood-corridors corredores propensos a inundación —la Pista Juan Pablo II, los pasos bajo cauces y varias intersecciones críticas— recibieron penalizaciones adicionales.

El grafo no es una abstracción decorativa: reproduce la estructura radial y los cuellos de botella de la capital. Con #routing-nodes nodos y #routing-edges aristas, la red es suficientemente densa para ofrecer rutas alternativas, pero suficientemente rígida para que unas pocas intersecciones concentren el tráfico. Esa combinación —alternativas disponibles y concentración estructural— explica por qué la red puede absorber una perturbación en algunos trayectos y colapsar en otros @jica2017.

=== Los cuellos de botella que la lluvia revela

La centralidad de intermediación mide la fracción de rutas mínimas que pasan por cada nodo. Un valor alto indica que la zona funciona como puente obligado entre otras. El cálculo sobre los #routing-pairs pares origen-destino identifica una jerarquía clara (@tbl-bottlenecks). #bn1-name encabeza la lista con una centralidad de #fmt-dec(bn1-dry, digits: 3), seguida por #bn2-name (#fmt-dec(bn2-dry, digits: 3)) y #bn3-name (#fmt-dec(bn3-dry, digits: 3)).

#fig-bottlenecks <tbl-bottlenecks>

La lectura territorial es reveladora: la zona con mayor centralidad no es la de mayor estrato ni la más céntrica en términos administrativos, sino un nodo de estrato #bn1-stratum que conecta corredores comerciales y residenciales. Esa posición explica por qué la congestión en #bn1-name se propaga al resto de la red. #bn2-name y #bn3-name, con #bn2-degree y #bn3-degree conexiones respectivamente, cumplen una función parecida en el norte y el este de la ciudad.

La tormenta no crea cuellos de botella nuevos: revela los que ya existían. La centralidad se mantiene alta en #bn1-name (#fmt-dec(bn1-dry, digits: 3) en seco frente a #fmt-dec(bn1-storm, digits: 3) en tormenta) y desciende en #bn2-name (#fmt-dec(bn2-dry, digits: 3) frente a #fmt-dec(bn2-storm, digits: 3)), mientras otros nodos ganan peso relativo. El cambio importa porque muestra que la red no solo se vuelve más lenta: se reorganiza. Los corredores que antes eran secundarios pasan a soportar rutas que ya no pueden usar los ejes inundados.

=== Resiliencia medida en minutos

El efecto agregado sobre la red es una dilatación sostenida. El tiempo medio de traslado pasa de #routing-avg-dry minutos en seco a #routing-avg-storm minutos bajo tormenta, un incremento de #routing-net-delay%. El diámetro —el viaje más largo entre dos nodos— crece de #routing-diameter-dry a #routing-diameter-storm minutos. La @tbl-routing-comparison resume el comportamiento de los tres corredores estratégicos y permite ver que el promedio esconde respuestas muy distintas.

#fig-routing-comparison <tbl-routing-comparison>

En el corredor OD 1, entre #od1-origin y #od1-dest, la ruta seca sigue #od1-dry-route y tarda #od1-dry-time minutos. Bajo tormenta, la red encuentra una salida: desvía el recorrido por #od1-storm-route y paga #od1-storm-time minutos, un #od1-delay-pct% más. En el corredor OD 2, entre #od2-origin y #od2-dest, no hay desvío posible: la ruta se mantiene y el tiempo pasa de #od2-dry-time a #od2-storm-time minutos, un #od2-delay-pct% adicional. En el corredor OD 3, entre #od3-origin y #od3-dest, el trayecto resiste sin cambiar de recorrido, pero aun así pierde #od3-delay-pct% de su tiempo base (#od3-dry-time frente a #od3-storm-time minutos).

Los tres casos muestran que la resiliencia no se reduce a un porcentaje. En OD 1 la red absorbe la perturbación con un desvío moderado; en OD 2 no hay alternativa y el tiempo casi se duplica; en OD 3 el corredor resiste, pero la velocidad cae. La misma tormenta produce tres respuestas distintas según la geometría de cada trayecto. El patrón coincide con la evidencia sobre lluvia y movilidad: la precipitación no solo reduce la velocidad, también cambia la distribución de la demanda y la elección de rutas @li2018. En Managua, esa combinación se traduce en un sistema que responde de forma desigual: los corredores comerciales centrales absorben los desvíos y los nodos populares quedan expuestos a la congestión residual.

#fig-urban-network-dijkstra <fig-urban-network-dijkstra>

=== Del promedio urbano a la decisión operativa

La red permite pasar del diagnóstico a la prescripción. Tres decisiones se desprenden de los resultados. La primera es la planeación de flota: priorizar la posición en los nodos de mayor centralidad, porque una unidad disponible en #bn1-name o #bn2-name reduce el tiempo de acceso a múltiples corredores. La segunda es la estimación de llegada: ajustarla por escenario climático, ya que el mismo trayecto puede costar #routing-net-delay% más en promedio y hasta #od2-delay-pct% en el caso más desfavorable. La tercera es la comunicación al pasajero: anticipar el desvío cuando la ruta cambia, como ocurre en OD 1, donde el tiempo adicional es de #od1-delay-pct%.

Los límites también son claros. El grafo es estático: no incorpora el estado del tráfico en tiempo real ni la capacidad de las vías. Solo tres pares origen-destino se evaluaron en detalle, aunque la resiliencia global se calculó sobre los #routing-pairs pares. Y los datos, como en los tramos anteriores, provienen de un simulador. Estas restricciones no invalidan la lectura: la señalan como una aproximación estructural, útil para priorizar inversiones y diseñar escenarios, no para prometer tiempos exactos.

Con eso, el recorrido se cierra. El repositorio hizo auditable la operación; la distancia explicó el tiempo y parte del precio; la red mostró dónde se concentra el tiempo perdido y cómo la lluvia redistribuye la carga. Los tres resultados no son capítulos separados: son tres escalas del mismo problema.

== Síntesis: tres miradas sobre un mismo servicio

Leídos en conjunto, los resultados describen una misma operación desde tres escalas. En la escala del dato, #total-trips-fmt solicitudes se convierten en un repositorio que permite comparar zonas, días y condiciones climáticas sin perder trazabilidad. En la escala del viaje, la distancia explica el #fmt-dec(m1-r2 * 100, digits: 1)% de la variación de la duración y el #fmt-dec(m2-r2 * 100, digits: 1)% de la variación de la tarifa: el tiempo es predecible, el precio solo en parte. En la escala de la ciudad, la red muestra que ese tiempo y ese precio no se distribuyen de manera uniforme; la dilatación promedio de #routing-net-delay% esconde casos de #od2-delay-pct% y una reorganización de rutas que castiga a los nodos de mayor centralidad.

La consecuencia para MoviGo es una agenda de tres frentes. El primero es la calidad del dato: sin integridad, cualquier modelo posterior es una conjetura bien presentada. El segundo es la calibración tarifaria: la distancia no basta para explicar el precio, de modo que la plataforma necesita incorporar el multiplicador, la zona y el clima en su estimación. El tercero es la operación en red: la resiliencia no depende solo de la velocidad promedio, sino de la posición de los cuellos de botella y de la capacidad de la red para ofrecer alternativas. Los tres frentes se sostienen entre sí, y esa interdependencia es, quizá, el hallazgo central del capítulo.

El recorrido deja, además, una lección metodológica. Cada cifra de este capítulo nace del repositorio y se actualiza con él; las tablas, las figuras y los coeficientes no se transcriben a mano. Esa disciplina no es un adorno de ingeniería: es lo que permite que la discusión anterior sea reproducible y que cualquier corrección en los datos se propague sin reescribir el argumento. Sin esa base, la distinción entre lo que el modelo explica y lo que deja fuera sería una afirmación retórica; con ella, es una conclusión verificable.
