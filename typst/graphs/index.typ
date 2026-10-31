// Central index of standalone 300 DPI analytical figures for MoviGo

#let fig-urban-network-topology = figure(
  image("urban_network_topology.png", width: 85%),
  caption: [Topología de la Red Vial Urbana de Managua: 298 Cuadrantes Urbanos (278 Drenados y 20 Críticos de Inundación) Conectados según 8-Vecindad de Moore],
)

#let fig-urban-network-dijkstra = figure(
  image("urban_network_dijkstra.png", width: 80%),
  caption: [Ruteo Óptimo mediante Algoritmo de Dijkstra: Comparativa de Trayectorias de Ciudad Jardín a Villa Fontana bajo Flujo Seco vs. Tormenta],
  placement: top,
)

#let fig-trip-origins-density = figure(
  image("trip_origins_density.png", width: 90%),
  caption: [Distribución Espacial de Puntos de Origen de Solicitudes (WGS84): 49,049 Viajes Completados vs. 28,438 Cancelados sobre la Trama Vial de Managua],
  placement: top,
)

// -----------------------------------------------------------------------------
// Suite de Regresión Simple vía Descenso de Gradiente (SGD)
// -----------------------------------------------------------------------------

#let fig-numerical-duration = figure(
  image("numerical_duration.png", width: 80%),
  caption: [Ajuste de Regresión Lineal Simple para Tiempo de Viaje ($hat(y) = 3.91 + 2.76 d$, $R^2 = 0.814$) en Función de la Distancia mediante Descenso de Gradiente Estocástico (SGD)],
  placement: top,
)

#let fig-numerical-fare = figure(
  image("numerical_fare.png", width: 80%),
  caption: [Ajuste de Regresión Lineal Simple para Tarificación del Servicio ($hat(y) = 49.33 + 12.87 d$, $R^2 = 0.587$) en Función de la Distancia mediante Descenso de Gradiente Estocástico (SGD)],
  placement: top,
)

// -----------------------------------------------------------------------------
// Suite de Mapas Geoespaciales Exploratorios (Apéndice A: Atlas Espacial MoviGo)
// -----------------------------------------------------------------------------

#let fig-map-quadrants-by-zone = figure(
  image("map_exploratory_quadrants_by_zone.png", width: 95%),
  caption: [Partición Territorial de Managua: 298 Cuadrantes Urbanos Agrupados en las 24 Zonas de Tarifa Base en los 7 Distritos Municipales],
)

#let fig-map-od-flows = figure(
  image("map_exploratory_od_flows.png", width: 95%),
  caption: [Corredores de Movilidad Urbana y Matriz de Deseo de Viajes: Top 25 Pares Origen-Destino en Managua Clasificados por Intensidad Transaccional],
)

#let fig-map-cancellation-causes = figure(
  image("map_exploratory_cancellation_causes.png", width: 95%),
  caption: [Desagregación Geoespacial de 28,438 Cancelaciones según Causalidad: Fricción Operativa (67.5%), Tarifa Dinámica (16.8%), Espera (13.2%) y Riesgo Pluvial (2.5%)],
)

#let fig-map-flood-risk-quadrants = figure(
  image("map_exploratory_flood_risk_quadrants.png", width: 95%),
  caption: [Vulnerabilidad Hidrológica en la Malla de 298 Cuadrantes de Managua: 29 Críticos, 197 Altos, 44 Medios y 28 Bajos con Pendiente hacia Lago Xolotlán],
)

#let fig-map-wait-times = figure(
  image("map_exploratory_wait_times.png", width: 95%),
  caption: [Accesibilidad Temporal del Servicio: Tiempos Medios de Espera para Recogida en las 24 Zonas Urbanas (Disparidad Territorial de 5.6 min a 12.8 min)],
)
