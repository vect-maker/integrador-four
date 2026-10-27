#import "../../graphs/index.typ": (
  fig-map-quadrants-by-zone,
  fig-map-od-flows,
  fig-map-cancellation-causes,
  fig-map-flood-risk-quadrants,
  fig-map-wait-times,
)

= Apéndice A: Atlas Cartográfico y Exploración Geoespacial de Managua

== Caracterización Territorial y Descomposición Espacial

El análisis de operaciones de transporte selectivo intermediado por plataformas móviles en áreas metropolitanas de alta heterogeneidad socioespacial, como el municipio de Managua, exige una exploración cartográfica multidimensional. Las decisiones de tarificación dinámica (_surge pricing_), el equilibrio microeconómico de flota y la tasa de abandono de viajes no se distribuyen de manera homogénea en el espacio, sino que interactúan intensamente con la morfología urbana, la infraestructura vial primaria, la segregación residencial y la topografía hidrológica de la cuenca sur del Lago Xolotlán.

A través de la integración del almacén de datos dimensional en DuckDB, el registro transaccional georreferenciado de 77,487 viajes (`fct_viajes`) y la malla territorial conformada por 24 zonas urbanas (`dim_zones`) y 298 cuadrantes micro-operacionales (`dim_quadrants`), el presente atlas documenta visualmente los patrones espaciales subyacentes en la operación de MoviGo durante el año 2024.

=== Partición Territorial: Agrupamiento de 298 Cuadrantes en 24 Zonas Urbanas

Para garantizar la resolución operativa de despacho y la tarificación zonal diferenciada, el territorio metropolitano de Managua se discretiza en una cuadrícula regular de 298 cuadrantes ($0.008 degree times 0.008 degree$, aproximadamente $880 "m" times 880 "m"$). Cada cuadrante se encuentra subordinado a una de las 24 zonas urbanas principales distribuidas en los 7 distritos del municipio (@fig-map-quadrants-by-zone).

#fig-map-quadrants-by-zone <fig-map-quadrants-by-zone>

Esta partición cartográfica evidencia la heterogeneidad superficial entre zonas: mientras los polos corporativos centrales como Metrocentro (Z9) y Los Robles (Z4) abarcan entre 1 y 3 cuadrantes de alta densidad comercial, las zonas de expansión periférica como Esquipulas (Z18, 37 cuadrantes), Carretera Sur (Z17, 35 cuadrantes) y Aeropuerto / Zona Franca (Z21, 30 cuadrantes) presentan una extensa dispersión territorial que incide directamente en los tiempos de posicionamiento de vehículos.

=== Corredores de Movilidad Urbana y Líneas de Deseo (Top 25 Pares OD)

La agregación de trayectorias entre centroides zonales permite identificar los principales ejes de desplazamiento metropolitano en Managua (@fig-map-od-flows). El análisis revela una estructura fuertemente radial con convergencia sobre los polos comerciales y corporativos del Distrito I y Distrito V.

#fig-map-od-flows <fig-map-od-flows>

Destaca la arteria bidireccional entre Bello Horizonte (Z7) y Villa Fontana (Z1), registrando el mayor flujo transaccional de la plataforma (1,238 viajes en sentido Norte-Sur y 1,169 viajes en sentido Sur-Norte), conectando sectores residenciales consolidados del oriente con los centros universitarios y corporativos del suroeste. Asimismo, los corredores entre Las Colinas (Z2) y Villa Fontana (989 viajes), y entre Ciudad Jardín (Z10) y el Mercado Oriental (920 viajes) constituyen arterias críticas de conmutación diaria donde los estrangulamientos viales y las fluctuaciones tarifarias impactan directamente en el volumen de viajes completados.

=== Desagregación Geoespacial de Causas de Cancelación de Viajes

Del total de 77,487 solicitudes registradas en el período analizado, 28,438 culminaron en cancelación (36.70%). La georreferenciación de los puntos de origen revela que los factores detonantes del fallo en el servicio presentan patrones espaciales marcadamente diferenciados (@fig-map-cancellation-causes):

+ *Fricción Operativa del Conductor (19,191 cancelaciones):* Representa el 67.48% de las pérdidas y se concentra fuertemente en cuadrantes periféricos y zonas de borde urbano (Linda Vista, Mayoreo, Sabana Grande, Esquipulas), donde los conductores rechazan solicitudes debido al riesgo de desplazamiento en vacío excesivo ($> 4 "km"$) hacia zonas con baja probabilidad de capturar un viaje de retorno, o por agotamiento tras extensas jornadas operativas.
+ *Sobrecosto por Tarifa Dinámica (4,786 cancelaciones):* Representa el 16.83% del total y se focaliza en zonas comerciales y de estrato medio/popular durante horas pico (Ciudad Jardín, Bello Horizonte, Multicentro Las Américas, Mercado Oriental), donde el multiplicador dinámico excede la disposición máxima a pagar del pasajero.
+ *Latencia Excesiva de Llegada (3,758 cancelaciones):* Representa el 13.21% y predomina en áreas de alta congestión semafórica o cuellos de botella viales donde el vehículo asignado experimenta demoras superiores a la tolerancia del usuario.
+ *Vulnerabilidad Pluvial y Cauces Desbordados (703 cancelaciones):* Ocurren puntualmente a lo largo de los cauces mayores (Cauce Oriental, Dupla Norte, Pista Portezuelo) durante precipitaciones torrenciales que vuelven los corredores físicamente intransitables.

#fig-map-cancellation-causes <fig-map-cancellation-causes>

=== Vulnerabilidad Hidrológica en la Malla de 298 Cuadrantes

Managua presenta una marcada pendiente topográfica en dirección Norte, descendiendo desde altitudes superiores a los 475 m.s.n.m. en las Sierras de Santo Domingo y El Crucero hasta los 58 m.s.n.m. en la ribera del Lago Xolotlán. Esta condición orográfica determina una rápida escorrentía superficial canalizada a través de cauces a cielo abierto que atraviesan la trama vial urbana (@fig-map-flood-risk-quadrants).

#fig-map-flood-risk-quadrants <fig-map-flood-risk-quadrants>

La clasificación hidrológica en `dim_quadrants` categoriza 29 cuadrantes en nivel *Crítico* (concentrados en la franja costanera del lago y el cruce del Cauce Oriental), 197 cuadrantes en nivel *Alto*, 44 en nivel *Medio* y 28 en nivel *Bajo*. Esta distribución fundamenta los parámetros de penalización por anegamiento implementados en el algoritmo de ruteo de Dijkstra, explicando por qué eventos de precipitación severa alteran drásticamente la impedancia temporal en los corredores Juan Pablo II y Mercado Oriental.

=== Accesibilidad Temporal del Servicio y Disparidad Territorial en Tiempos de Espera

El tiempo promedio transcurrido entre la confirmación del viaje y la llegada efectiva del vehículo al punto de recogida constituye una métrica central de calidad de servicio y equidad espacial (@fig-map-wait-times).

#fig-map-wait-times <fig-map-wait-times>

Los resultados empíricos constatan una severa disparidad territorial de accesibilidad:
- Los polos corporativos y comerciales centrales gozan de tiempos medios de espera notablemente reducidos: Metrocentro / Eje UCA (5.57 min), Los Robles (6.37 min) y Mercado Oriental (6.71 min), impulsados por una alta densidad de vehículos activos en recirculación continua.
- Por el contrario, los cuadrantes residenciales periféricos sufren tiempos de espera que duplican los promedios centrales: Linda Vista (11.57 min), Bello Horizonte (11.80 min) y Mercado El Mayoreo (12.77 min).

Esta brecha de accesibilidad temporal ($2.29 times$ entre la zona más rápida y la más demorada) actúa como un amplificador del abandono de servicio, demostrando que en las zonas periféricas las cancelaciones no solo responden a la tarifa dinámica sino a una escasez estructural de oferta vehicular disponible.
