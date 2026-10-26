// Central index of standalone 300 DPI analytical figures for MoviGo

#let fig-regression-fit = figure(
  image("regression_fit.png", width: 90%),
  caption: [Ajuste de Regresión Lineal Simple (MCO): Tasa de Cancelación vs. Multiplicador Dinámico Promedio],
)

#let fig-market-equilibrium = figure(
  image("market_equilibrium_curves.png", width: 90%),
  caption: [Curvas Microeconómicas de Demanda y Oferta Vehicular: Punto de Equilibrio Teórico ($m^* = 1.35times$)],
)

#let fig-numerical-convergence = figure(
  image("numerical_convergence.png", width: 90%),
  caption: [Convergencia Algorítmica: Comparación de Iteraciones entre el Método de la Bisección y Newton-Raphson],
)

#let fig-urban-network-topology = figure(
  image("urban_network_topology.png", width: 85%),
  caption: [Topología de la Red Vial Urbana de Managua: 12 Cuadrantes y Corredores Viales Principales],
)

#let fig-urban-network-dijkstra = figure(
  image("urban_network_dijkstra.png", width: 95%),
  caption: [Ruteo Óptimo mediante Algoritmo de Dijkstra: Comparativa de Trayectorias bajo Flujo Seco vs. Tormenta],
)
