// Central index of standalone 300 DPI analytical figures for MoviGo

#let fig-urban-network-topology = figure(
  image("urban_network_topology.png", width: 85%),
  caption: [Topología de la Red Vial Urbana de Managua: 24 Zonas Urbanas y Corredores Viales Principales],
)

#let fig-urban-network-dijkstra = figure(
  image("urban_network_dijkstra.png", width: 95%),
  caption: [Ruteo Óptimo mediante Algoritmo de Dijkstra: Comparativa de Trayectorias bajo Flujo Seco vs. Tormenta],
)

#let fig-trip-origins-density = figure(
  image("trip_origins_density.png", width: 90%),
  caption: [Distribución Espacial de Puntos de Origen de Solicitudes (WGS84) y Concentración de Cancelaciones sobre la Trama Vial de Managua],
)

// -----------------------------------------------------------------------------
// Suite de Regresión Simple vía Descenso de Gradiente (SGD)
// -----------------------------------------------------------------------------

#let fig-numerical-duration = figure(
  image("numerical_duration.png", width: 90%),
  caption: [Ajuste de Regresión Lineal Simple para Tiempo de Viaje (ETA) en Función de la Distancia mediante Descenso de Gradiente Estocástico (SGD)],
)

#let fig-numerical-fare = figure(
  image("numerical_fare.png", width: 90%),
  caption: [Ajuste de Regresión Lineal Simple para Tarificación del Servicio en Función de la Distancia mediante Descenso de Gradiente Estocástico (SGD)],
)

// -----------------------------------------------------------------------------
// Suite de Mapas Geoespaciales Exploratorios (Apéndice A: Atlas Espacial MoviGo)
// -----------------------------------------------------------------------------

#let fig-map-quadrants-by-zone = figure(
  image("map_exploratory_quadrants_by_zone.png", width: 95%),
  caption: [Partición Territorial de Managua: 298 Cuadrantes Urbanos Agrupados en las 24 Zonas de Tarifa Base],
)

#let fig-map-od-flows = figure(
  image("map_exploratory_od_flows.png", width: 95%),
  caption: [Corredores de Movilidad Urbana y Matriz de Deseo de Viajes: Top 25 Pares Origen-Destino en Managua],
)

#let fig-map-cancellation-causes = figure(
  image("map_exploratory_cancellation_causes.png", width: 95%),
  caption: [Desagregación Geoespacial de Causas de Cancelación: Tarifa Dinámica, Espera, Fricción del Conductor y Riesgo Pluvial],
)

#let fig-map-flood-risk-quadrants = figure(
  image("map_exploratory_flood_risk_quadrants.png", width: 95%),
  caption: [Vulnerabilidad Hidrológica y Riesgo de Inundación en la Malla de 298 Cuadrantes Urbanos de Managua],
)

#let fig-map-wait-times = figure(
  image("map_exploratory_wait_times.png", width: 95%),
  caption: [Accesibilidad Temporal del Servicio: Tiempos Medios de Espera para Recogida en las 24 Zonas Urbanas],
)
