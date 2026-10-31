#import "../../data_bindings.typ": (
  total-trips-fmt, total-cancellations-fmt, total-completions-fmt, cancellation-rate, avg-surge,
  avg-final-fare, avg-distance-km, avg-wait-time-min, total-users, total-drivers, total-zones,
  total-quadrants, total-weather-days, total-campaigns, dbt-total-tests, dbt-staging-models,
  dbt-mart-models, dbt-tests-unique, dbt-tests-not-null, dbt-tests-relationships,
  dbt-tests-accepted-values, inv-integrity, regression-n-total, regression-n-train, regression-n-test,
  m1-b0, m1-b1, m1-r2, m1-r2-train, m1-mae, m1-rmse, m1-ci-b1-low, m1-ci-b1-upp, m1-epochs,
  m2-b0, m2-b1, m2-r2, m2-r2-train, m2-mae, m2-rmse, m2-ci-b1-low, m2-ci-b1-upp, m2-epochs,
  sgd-eta0, dist-mean-km, dur-skew, fare-skew, surge-mean-completed, flag-drop-min, flag-drop-max,
  fmt-dec, predict,
)
#import "../../diagrams/star_schema.typ": fig-star-schema
#import "../../tables/index.typ": fig-data-inventory, fig-general-kpis, fig-regression-summary
#import "../../graphs/index.typ": fig-trip-origins-density, fig-numerical-duration, fig-numerical-fare

// Distancias de ejemplo (entradas ilustrativas, no resultados) para mostrar el uso de las ecuaciones
#let ex-short = 5
#let ex-long = 15

= Resultados y Discusión

Los resultados se presentan en el mismo orden de los objetivos específicos: primero el repositorio analítico (Objetivo 1), luego el modelado numérico (Objetivo 2) y finalmente la optimización de la red vial (Objetivo 3).

== Resultados del Objetivo 1: Consolidación del Repositorio Analítico

El primer objetivo específico buscaba *consolidar* un repositorio analítico multidimensional a partir de los registros operativos del servicio. Esta sección muestra qué produjo el flujo de extracción, carga y transformación, qué tan confiable es el resultado y qué análisis permite. El procedimiento seguido se describe en la Fase 1 del diseño metodológico.

=== Repositorio resultante

El flujo integró las fuentes de la API en un solo repositorio con una tabla de hechos y seis dimensiones. La tabla de hechos contiene #total-trips-fmt registros, uno por cada intento de viaje de 2024, sin muestreo. Las dimensiones describen a #total-users pasajeros, #total-drivers conductores, #total-zones zonas urbanas, #total-quadrants cuadrantes, #total-weather-days días de clima y #total-campaigns campañas de incentivos (@tbl-data-inventory).

#fig-data-inventory <tbl-data-inventory>

La estructura es un esquema en estrella: la tabla de hechos al centro, unida a cada dimensión por llaves sustitutas (@fig-star-schema). Con esta forma, una consulta cruza el viaje con la zona, el clima o el usuario mediante una sola unión, sin recorrer las tablas normalizadas de origen. El diccionario completo de campos está en el Apéndice C (@tbl-star-schema).

#fig-star-schema <fig-star-schema>

=== Tratamiento y calidad de los datos

La transformación en dbt dejó los datos listos para el análisis. En la capa de preparación se corrigieron los tipos de dato, se convirtieron los estados del viaje en indicadores verdadero/falso (completado, cancelado por el usuario, cancelado por el conductor) y se clasificó la lluvia en categorías ordenadas. En la capa dimensional, los #total-quadrants cuadrantes se agruparon en #total-zones zonas urbanas para poder comparar territorios.

La calidad se verificó de dos maneras. Primero, el proyecto dbt declara #dbt-total-tests pruebas automáticas sobre #(dbt-staging-models + dbt-mart-models) modelos (#dbt-staging-models de preparación y #dbt-mart-models dimensionales): #dbt-tests-unique de unicidad, #dbt-tests-not-null de completitud, #dbt-tests-relationships de integridad referencial y #dbt-tests-accepted-values de valores permitidos. Segundo, se auditó directamente el repositorio final y se encontraron #inv-integrity.duplicated_trip_keys viajes duplicados, #inv-integrity.total_orphans llaves huérfanas entre la tabla de hechos y sus dimensiones, #inv-integrity.total_null_keys llaves vacías y #inv-integrity.total_null_metrics valores vacíos en distancia, duración, tarifa final y multiplicador dinámico.

En términos simples: cada viaje apunta a una zona, un usuario, un conductor y un día que existen, y las variables que usan los modelos del Objetivo 2 están completas. No fue necesario imputar valores en esas variables.

=== Explotación del repositorio: perfil del censo 2024

Para comprobar que el repositorio sirve para analizar, se consultó con DuckDB el perfil general del servicio (@tbl-general-kpis). Del total de #total-trips-fmt viajes, #total-completions-fmt se completaron y #total-cancellations-fmt se cancelaron, lo que da una tasa de cancelación de #cancellation-rate%. El multiplicador dinámico promedio fue #avg-surge, la tarifa final promedio fue de C\$ #avg-final-fare, el viaje promedio recorrió #avg-distance-km km y el tiempo de espera promedio fue de #avg-wait-time-min minutos.

#fig-general-kpis <tbl-general-kpis>

La ubicación de los viajes se proyectó sobre el mapa de Managua (@fig-trip-origins-density). Las solicitudes se concentran en los polos comerciales y corporativos, y se dispersan hacia las zonas populares y periféricas. Esa diferencia territorial es la que motiva el análisis de red del Objetivo 3.

#fig-trip-origins-density <fig-trip-origins-density>

=== Reproducibilidad del flujo

Todas las cifras, tablas y figuras de este documento se generan desde el repositorio analítico. El comando `just hydrate-data` recalcula los archivos JSON y las imágenes, y Typst los lee al compilar. Por eso, si cambian los datos, el documento cambia con ellos y no queda ningún número escrito a mano.

=== Discusión del Objetivo 1

El objetivo se cumplió: las fuentes quedaron integradas en un modelo dimensional, las pruebas de integridad no encontraron fallas y el repositorio ya responde preguntas operativas. Además, deja listas las entradas de los siguientes objetivos: la distancia, la duración y la tarifa final del viaje alimentan los modelos del Objetivo 2, y las zonas y el clima alimentan la red vial del Objetivo 3.

Hay dos límites que deben tenerse presentes. Los datos provienen de un entorno de simulación y no de registros reales de la empresa, así que los resultados describen el comportamiento del simulador. Además, el análisis trabaja sobre una copia local en DuckDB tomada en un momento dado, y no sobre un flujo continuo de datos.

== Resultados del Objetivo 2: Modelado de las Relaciones Operativas y Tarifarias

El segundo objetivo específico buscaba *modelar* cómo la distancia del viaje determina su duración y su costo. Para ello se ajustaron dos regresiones lineales simples, cada una con una sola variable de entrada (la distancia en km) y una de salida. Los coeficientes se obtuvieron por descenso de gradiente y se acompañaron de intervalos de confianza al 95%, como se describe en la Fase 2 del diseño metodológico.

=== Datos de modelado

Se usaron los #regression-n-total viajes completados del repositorio del Objetivo 1, ya que solo estos tienen duración y tarifa cobrada. Los modelos se ajustaron con #regression-n-train viajes (80%) y se evaluaron con los #regression-n-test restantes (20%), que el algoritmo nunca vio durante el ajuste. Así, las métricas de desempeño reflejan cómo se comportaría el modelo con viajes nuevos.

=== Modelo 1: de la distancia a la duración del viaje

La recta ajustada para estimar la duración $hat(y)$, en minutos, a partir de la distancia $d$, en km, es:

$ hat(y)_"min" = #fmt-dec(m1-b0) + #fmt-dec(m1-b1) dot d $

*Cómo se usa.* Basta con multiplicar la distancia del viaje por #fmt-dec(m1-b1) y sumar #fmt-dec(m1-b0). Por ejemplo, para un viaje de distancia promedio (#fmt-dec(dist-mean-km) km):

$ hat(y)_"min" = #fmt-dec(m1-b0) + #fmt-dec(m1-b1) dot #fmt-dec(dist-mean-km) approx #fmt-dec(predict(m1-b0, m1-b1, dist-mean-km), digits: 1) "minutos" $

De la misma forma, un viaje corto de #ex-short km toma unos #fmt-dec(predict(m1-b0, m1-b1, ex-short), digits: 1) minutos, y uno largo de #ex-long km, unos #fmt-dec(predict(m1-b0, m1-b1, ex-long), digits: 1) minutos.

*Qué significan los coeficientes.* La pendiente indica que cada kilómetro adicional agrega en promedio #fmt-dec(m1-b1) minutos al viaje, lo que equivale a una velocidad media de #fmt-dec(60 / m1-b1, digits: 1) km/h dentro de Managua. El intercepto (#fmt-dec(m1-b0) min) es un tiempo fijo que no depende de la distancia, asociado al arranque del viaje.

*Qué tan seguros son.* Con un 95% de confianza, el efecto real de la distancia está entre #fmt-dec(m1-ci-b1-low) y #fmt-dec(m1-ci-b1-upp) minutos por km. El intervalo es muy estrecho y está lejos de cero, por lo que el efecto de la distancia es estadísticamente significativo y estable.

*Qué tan bien predice.* En los viajes de prueba, el modelo explica el #fmt-dec(m1-r2 * 100, digits: 1)% de la variación de la duración ($R^2 = #fmt-dec(m1-r2, digits: 3)$). El error típico de una predicción es de #fmt-dec(m1-mae) minutos (MAE). El RMSE (#fmt-dec(m1-rmse) min) es mayor porque penaliza más los errores grandes: hay viajes con demoras muy superiores a lo esperado, lo que coincide con la asimetría de la duración (coeficiente de asimetría de #fmt-dec(dur-skew, digits: 1)). En la @fig-numerical-duration se observa que la mayoría de los puntos sigue la recta y que los alejados quedan casi siempre por encima de ella.

#fig-numerical-duration <fig-numerical-duration>

=== Modelo 2: de la distancia a la tarifa final

La recta ajustada para estimar la tarifa final, en córdobas, es:

$ hat(y)_"C$" = #fmt-dec(m2-b0) + #fmt-dec(m2-b1) dot d $

*Cómo se usa.* Se multiplica la distancia por #fmt-dec(m2-b1) y se suma #fmt-dec(m2-b0). Para el viaje promedio de #fmt-dec(dist-mean-km) km:

$ hat(y)_"C$" = #fmt-dec(m2-b0) + #fmt-dec(m2-b1) dot #fmt-dec(dist-mean-km) approx "C$" #fmt-dec(predict(m2-b0, m2-b1, dist-mean-km)) $

Con el mismo cálculo, un viaje de #ex-short km costaría unos C\$ #fmt-dec(predict(m2-b0, m2-b1, ex-short)) y uno de #ex-long km, unos C\$ #fmt-dec(predict(m2-b0, m2-b1, ex-long)).

*Qué significan los coeficientes.* Cada kilómetro adicional encarece el viaje en promedio C\$ #fmt-dec(m2-b1), con un intervalo de confianza al 95% entre C\$ #fmt-dec(m2-ci-b1-low) y C\$ #fmt-dec(m2-ci-b1-upp). El intercepto (C\$ #fmt-dec(m2-b0)) funciona como un cargo base del servicio. Es algo mayor que la bajada de bandera de las zonas (entre C\$ #fmt-dec(flag-drop-min) y C\$ #fmt-dec(flag-drop-max)), porque además del arranque absorbe el cobro por el tiempo fijo del viaje y, en promedio, parte del recargo dinámico.

*Qué tan bien predice.* Este modelo explica el #fmt-dec(m2-r2 * 100, digits: 1)% de la variación de la tarifa ($R^2 = #fmt-dec(m2-r2, digits: 3)$), con un error típico de C\$ #fmt-dec(m2-mae) (MAE) y un RMSE de C\$ #fmt-dec(m2-rmse). Su ajuste es claramente menor que el del Modelo 1, y la razón es directa: la tarifa no depende solo de la distancia. También depende del multiplicador dinámico (en promedio #fmt-dec(surge-mean-completed) en los viajes completados), de la bajada de bandera de cada zona y del tiempo real del trayecto, factores que el modelo no incluye. Por eso, viajes de igual distancia pueden tener precios muy distintos, como muestra la dispersión vertical de la @fig-numerical-fare.

#fig-numerical-fare <fig-numerical-fare>

=== Comparación de los modelos y convergencia del descenso de gradiente

La @tbl-regression-summary resume ambos modelos. El descenso de gradiente llegó a la solución en #m1-epochs épocas para la duración y en #m2-epochs para la tarifa, partiendo de una tasa de aprendizaje inicial de #sgd-eta0. La convergencia rápida se debe a que la distancia se estandarizó antes del ajuste, lo que hace que la superficie de error sea regular y fácil de descender.

#fig-regression-summary <tbl-regression-summary>

Los valores de $R^2$ en entrenamiento y en prueba son casi iguales en el Modelo 1 (#fmt-dec(m1-r2-train, digits: 3) frente a #fmt-dec(m1-r2, digits: 3)), por lo que el modelo generaliza bien. En el Modelo 2 la diferencia es mayor (#fmt-dec(m2-r2-train, digits: 3) frente a #fmt-dec(m2-r2, digits: 3)). Con solo dos parámetros esto no indica sobreajuste. Se explica por las tarifas extremas: la tarifa es muy asimétrica (asimetría de #fmt-dec(fare-skew, digits: 1)), y unos pocos viajes muy caros en el conjunto de prueba bastan para bajar el $R^2$.

=== Discusión del Objetivo 2

El objetivo se cumplió: se cuantificó el impacto de la distancia sobre la duración y el costo del viaje mediante descenso de gradiente, y ambos efectos resultaron estadísticamente significativos al 95%. La distancia es un buen predictor del tiempo de viaje y un predictor parcial de la tarifa. En la práctica, MoviGo podría usar estas dos ecuaciones para dar al pasajero una estimación rápida de tiempo y precio antes de solicitar el viaje.

Los resultados tienen límites claros. Primero, cada modelo usa una sola variable, por lo que deja fuera la tarifa dinámica, la congestión y la lluvia; esto pesa sobre todo en la tarifa. Segundo, los intervalos de confianza suponen que la dispersión de los errores es la misma para viajes cortos y largos, pero la asimetría de los datos sugiere que la dispersión crece con la distancia, así que los intervalos podrían ser algo más estrechos de lo real. Tercero, los datos provienen de un entorno de simulación.

Finalmente, la velocidad media de #fmt-dec(60 / m1-b1, digits: 1) km/h es un promedio de toda la ciudad, que no muestra dónde se pierde el tiempo. Identificar los puntos de la red vial que concentran las demoras y cómo empeoran con la lluvia es la tarea del Objetivo 3.

== Resultados del Objetivo 3: Optimización de la Red Vial y Resiliencia

#text(fill: gray)[_[Pendiente: cuellos de botella por centralidad de intermediación y efecto de la lluvia intensa sobre los tiempos de traslado.]_]
