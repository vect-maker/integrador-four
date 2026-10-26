// Central data bindings for programmatic document rendering (Data-to-Document)
// Exposes typed metrics and formatted strings directly from DuckDB & Python hydration

#let general-kpis = json("data/general_kpis.json").at(0)
#let zones = json("data/zones.json")
#let cancellations-by-hour = json("data/cancellations_by_hour.json")
#let cancellations-by-stratum = json("data/cancellations_by_stratum.json")
#let cancellations-by-weather = json("data/cancellations_by_weather.json")
#let campaigns = json("data/campaigns_optimization.json")
#let econometrics = json("data/econometric_regression.json")
#let numerical = json("data/numerical_methods.json")
#let routing = json("data/routing_optimization.json")

// Formatter for integers with thousands separator (comma)
#let fmt-int(n) = {
  let s = str(n)
  let len = s.len()
  if len <= 3 { return s }
  let rem = calc.rem(len, 3)
  let parts = ()
  if rem > 0 { parts.push(s.slice(0, rem)) }
  let i = rem
  while i < len {
    parts.push(s.slice(i, i + 3))
    i += 3
  }
  parts.join(",")
}

// Global operational constants (Data Warehouse / DuckDB)
#let total-trips = general-kpis.total_viajes
#let total-trips-fmt = fmt-int(total-trips)
#let total-cancellations = general-kpis.total_cancelados
#let total-cancellations-fmt = fmt-int(total-cancellations)
#let total-completions = general-kpis.total_completados
#let total-completions-fmt = fmt-int(total-completions)

#let cancellation-rate = general-kpis.tasa_cancelacion_pct
#let avg-surge = general-kpis.surge_promedio
#let avg-base-fare = general-kpis.tarifa_base_promedio_nio
#let avg-final-fare = general-kpis.tarifa_final_promedio_nio
#let avg-surge-cost = general-kpis.sobrecosto_promedio_nio
#let avg-distance-km = general-kpis.distancia_promedio_km
#let avg-wait-time-min = general-kpis.tiempo_espera_promedio_min

// Dimensional inventory counts
#let total-zones = general-kpis.total_zonas
#let total-weather-days = general-kpis.total_dias_clima
#let total-users = general-kpis.total_usuarios
#let total-drivers = general-kpis.total_conductores
#let total-campaigns = general-kpis.total_campanias

// -----------------------------------------------------------------------------
// Estadistica II: Regresion Lineal Simple (MCO) & ANOVA
// -----------------------------------------------------------------------------
#let ols-n = econometrics.sample_size
#let ols-r = econometrics.pearson_r
#let ols-r2 = econometrics.r_squared
#let ols-r2-adj = econometrics.adj_r_squared
#let ols-f-stat = econometrics.f_statistic

#let ols-b0 = econometrics.coefficients.intercept.estimate
#let ols-b0-se = econometrics.coefficients.intercept.std_error
#let ols-b0-t = econometrics.coefficients.intercept.t_stat

#let ols-b1 = econometrics.coefficients.multiplicador.estimate
#let ols-b1-se = econometrics.coefficients.multiplicador.std_error
#let ols-b1-t = econometrics.coefficients.multiplicador.t_stat

#let anova-reg-ss = econometrics.anova.regression.ss
#let anova-reg-df = econometrics.anova.regression.df
#let anova-reg-ms = econometrics.anova.regression.ms

#let anova-res-ss = econometrics.anova.residuals.ss
#let anova-res-df = econometrics.anova.residuals.df
#let anova-res-ms = econometrics.anova.residuals.ms

#let anova-tot-ss = econometrics.anova.total.ss
#let anova-tot-df = econometrics.anova.total.df

// -----------------------------------------------------------------------------
// Metodos Numericos: Raiz de Equilibrio Tarifario
// -----------------------------------------------------------------------------
#let num-d0 = numerical.parameters.demand_base_d0
#let num-s0 = numerical.parameters.supply_base_s0
#let num-alpha = numerical.parameters.demand_elasticity_alpha
#let num-beta = numerical.parameters.supply_incentive_beta
#let num-tol = numerical.parameters.tolerance_epsilon

#let num-m-star = numerical.root_equilibrium.m_star
#let num-q-star = numerical.root_equilibrium.balanced_volume_trips_per_hour

#let num-bisect-iters = numerical.bisection.total_iterations
#let num-newton-iters = numerical.newton_raphson.total_iterations
#let num-speedup = numerical.comparison.iteration_reduction_ratio

// -----------------------------------------------------------------------------
// Optimizacion: Red Vial y Algoritmo de Dijkstra
// -----------------------------------------------------------------------------
#let routing-nodes = routing.network_summary.total_nodes
#let routing-edges = routing.network_summary.total_edges
#let od1 = routing.routes.at(0)
#let od1-origin = od1.origin.name
#let od1-dest = od1.destination.name
#let od1-dry-time = od1.dry_scenario.travel_time_minutes
#let od1-storm-time = od1.storm_scenario.travel_time_minutes
#let od1-delay-pct = od1.storm_scenario.delay_percentage
#let od1-rerouted = od1.storm_scenario.path_rerouted
