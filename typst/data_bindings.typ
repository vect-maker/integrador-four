// Central data bindings for programmatic document rendering (Data-to-Document)
// Exposes typed metrics and formatted strings directly from DuckDB & Python hydration

#let general-kpis = json("data/general_kpis.json").at(0)
#let zones = json("data/zones.json")
#let cancellations-by-hour = json("data/cancellations_by_hour.json")
#let cancellations-by-stratum = json("data/cancellations_by_stratum.json")
#let cancellations-by-weather = json("data/cancellations_by_weather.json")
#let campaigns = json("data/campaigns_optimization.json")
#let routing = json("data/routing_optimization.json")
#let numerical-methods = json("data/numerical_methods.json")

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
// Optimizacion: Red Vial y Algoritmo de Dijkstra
// -----------------------------------------------------------------------------
#let routing-nodes = routing.network_summary.total_nodes
#let routing-edges = routing.network_summary.total_edges
#let routing-avg-dry = routing.global_resilience.avg_travel_time_dry_min
#let routing-avg-storm = routing.global_resilience.avg_travel_time_storm_min
#let routing-net-delay = routing.global_resilience.network_delay_percentage
#let routing-top-bottleneck = routing.top_bottlenecks.at(0).name
#let od1 = routing.routes.at(0)
#let od1-origin = od1.origin.name
#let od1-dest = od1.destination.name
#let od1-dry-time = od1.dry_scenario.travel_time_minutes
#let od1-storm-time = od1.storm_scenario.travel_time_minutes
#let od1-delay-pct = od1.storm_scenario.delay_percentage
#let od1-rerouted = od1.storm_scenario.path_rerouted
#let od1-dry-route = od1.dry_scenario.path_names.join(" → ")
#let od1-storm-route = od1.storm_scenario.path_names.join(" → ")
#let od1-movigo-storm = od1.empirical_benchmark.movigo_observed_storm_min
#let od1-saved-time = od1.empirical_benchmark.prescriptive_time_saved_min

// Resiliencia global y topología de la red
#let routing-pairs = fmt-int(routing.global_resilience.total_pairs_evaluated)
#let routing-diameter-dry = routing.global_resilience.diameter_dry_min
#let routing-diameter-storm = routing.global_resilience.diameter_storm_min
#let routing-flood-corridors = routing.network_summary.flood_prone_corridors_count
#let routing-speed-dry = routing.network_summary.baseline_arterial_speed_kmh
#let routing-speed-storm = routing.network_summary.storm_flood_speed_kmh
#let routing-tortuosity = routing.network_summary.tortuosity_factor

// Cuellos de botella por centralidad de intermediación
#let bn1 = routing.top_bottlenecks.at(0)
#let bn2 = routing.top_bottlenecks.at(1)
#let bn3 = routing.top_bottlenecks.at(2)
#let bn1-name = bn1.name
#let bn2-name = bn2.name
#let bn3-name = bn3.name
#let bn1-stratum = bn1.stratum
#let bn2-stratum = bn2.stratum
#let bn3-stratum = bn3.stratum
#let bn1-dry = bn1.betweenness_dry
#let bn2-dry = bn2.betweenness_dry
#let bn3-dry = bn3.betweenness_dry
#let bn1-storm = bn1.betweenness_storm
#let bn2-storm = bn2.betweenness_storm
#let bn3-storm = bn3.betweenness_storm
#let bn1-degree = bn1.degree
#let bn2-degree = bn2.degree
#let bn3-degree = bn3.degree

// Escenarios origen-destino complementarios (OD 2 y OD 3)
#let od2 = routing.routes.at(1)
#let od2-origin = od2.origin.name
#let od2-dest = od2.destination.name
#let od2-dry-time = od2.dry_scenario.travel_time_minutes
#let od2-storm-time = od2.storm_scenario.travel_time_minutes
#let od2-delay-pct = od2.storm_scenario.delay_percentage
#let od2-rerouted = od2.storm_scenario.path_rerouted
#let od2-dry-route = od2.dry_scenario.path_names.join(" → ")
#let od2-storm-route = od2.storm_scenario.path_names.join(" → ")
#let od2-movigo-storm = od2.empirical_benchmark.movigo_observed_storm_min
#let od2-saved-time = od2.empirical_benchmark.prescriptive_time_saved_min

#let od3 = routing.routes.at(2)
#let od3-origin = od3.origin.name
#let od3-dest = od3.destination.name
#let od3-dry-time = od3.dry_scenario.travel_time_minutes
#let od3-storm-time = od3.storm_scenario.travel_time_minutes
#let od3-delay-pct = od3.storm_scenario.delay_percentage
#let od3-rerouted = od3.storm_scenario.path_rerouted
#let od3-dry-route = od3.dry_scenario.path_names.join(" → ")
#let od3-storm-route = od3.storm_scenario.path_names.join(" → ")
#let od3-movigo-storm = od3.empirical_benchmark.movigo_observed_storm_min
#let od3-saved-time = od3.empirical_benchmark.prescriptive_time_saved_min

// -----------------------------------------------------------------------------
// Modelado Numérico & Inferencia: Regresión Lineal Simple vía SGD
// -----------------------------------------------------------------------------
#let m1-eta = numerical-methods.models.eta_duration
#let m1-b0 = m1-eta.coefficients.intercept
#let m1-b1 = m1-eta.coefficients.distance_km
#let m1-r2 = m1-eta.metrics_test.r2
#let m1-mae = m1-eta.metrics_test.mae
#let m1-rmse = m1-eta.metrics_test.rmse
#let m1-ci-b1-low = m1-eta.confidence_intervals_95_coefficients.distance_km.ci_95_lower
#let m1-ci-b1-upp = m1-eta.confidence_intervals_95_coefficients.distance_km.ci_95_upper
#let m1-epochs = m1-eta.gradient_descent_diagnostics.iterations_to_convergence

#let m2-fare = numerical-methods.models.pricing_fare
#let m2-b0 = m2-fare.coefficients.intercept
#let m2-b1 = m2-fare.coefficients.distance_km
#let m2-r2 = m2-fare.metrics_test.r2
#let m2-mae = m2-fare.metrics_test.mae
#let m2-rmse = m2-fare.metrics_test.rmse
#let m2-ci-b1-low = m2-fare.confidence_intervals_95_coefficients.distance_km.ci_95_lower
#let m2-ci-b1-upp = m2-fare.confidence_intervals_95_coefficients.distance_km.ci_95_upper
#let m2-epochs = m2-fare.gradient_descent_diagnostics.iterations_to_convergence
#let regression-n-train = fmt-int(numerical-methods.metadata.n_train)
#let regression-n-test = fmt-int(numerical-methods.metadata.n_test)

// ==========================================
// OE1: INVENTARIO Y AUDITORÍA DEL PIPELINE
// ==========================================
#let pipeline-inventory = json("data/pipeline_inventory.json")
#let inv-rows = pipeline-inventory.warehouse.rows
#let inv-integrity = pipeline-inventory.warehouse.integrity
#let inv-dbt = pipeline-inventory.dbt
#let dbt-total-tests = inv-dbt.total_tests
#let dbt-staging-models = inv-dbt.staging_models
#let dbt-mart-models = inv-dbt.mart_models
#let dbt-tests-unique = inv-dbt.tests_by_type.unique
#let dbt-tests-not-null = inv-dbt.tests_by_type.not_null
#let dbt-tests-relationships = inv-dbt.tests_by_type.relationships
#let dbt-tests-accepted-values = inv-dbt.tests_by_type.accepted_values
#let total-quadrants = inv-rows.dim_quadrants

// ==========================================
// OE2: BINDINGS ADICIONALES DE REGRESIÓN
// ==========================================
#let regression-n-total = fmt-int(numerical-methods.metadata.n_total_observations)
#let m1-ci-b0-low = m1-eta.confidence_intervals_95_coefficients.intercept.ci_95_lower
#let m1-ci-b0-upp = m1-eta.confidence_intervals_95_coefficients.intercept.ci_95_upper
#let m2-ci-b0-low = m2-fare.confidence_intervals_95_coefficients.intercept.ci_95_lower
#let m2-ci-b0-upp = m2-fare.confidence_intervals_95_coefficients.intercept.ci_95_upper
#let m1-se-b1 = m1-eta.confidence_intervals_95_coefficients.distance_km.std_error
#let m2-se-b1 = m2-fare.confidence_intervals_95_coefficients.distance_km.std_error
#let m1-r2-train = m1-eta.metrics_train.r2
#let m2-r2-train = m2-fare.metrics_train.r2
#let m1-samples-seen = fmt-int(m1-eta.gradient_descent_diagnostics.n_samples_seen)
#let m2-samples-seen = fmt-int(m2-fare.gradient_descent_diagnostics.n_samples_seen)
#let sgd-eta0 = m1-eta.gradient_descent_diagnostics.initial_learning_rate_eta0
#let var-dist = numerical-methods.variable_distributions
#let dist-mean-km = var-dist.distance_km.mean
#let dur-skew = var-dist.duration_minutes.skewness
#let fare-skew = var-dist.final_fare.skewness
#let surge-mean-completed = var-dist.surge_multiplier.mean
#let flag-drop-min = calc.min(..zones.map(z => z.tarifa_base_bajada_bandera))
#let flag-drop-max = calc.max(..zones.map(z => z.tarifa_base_bajada_bandera))

// Redondeo con decimales fijos para presentación (ej. 2.6 -> "2.60")
#let fmt-dec(x, digits: 2) = {
  let r = str(calc.round(x, digits: digits))
  let parts = r.split(".")
  let dec = if parts.len() > 1 { parts.at(1) } else { "" }
  if digits == 0 { return parts.at(0) }
  parts.at(0) + "." + dec + "0" * (digits - dec.len())
}
// Predicción de la regresión simple: y = b0 + b1 * d
// Usa los coeficientes y la distancia redondeados a 2 decimales (tal como se muestran en el texto),
// para que el lector pueda reproducir el cálculo a mano.
#let predict(b0, b1, d) = calc.round(b0, digits: 2) + calc.round(b1, digits: 2) * calc.round(d, digits: 2)
