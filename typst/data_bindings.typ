// Central data bindings for programmatic document rendering (Data-to-Document)
// Exposes typed metrics and formatted strings directly from DuckDB hydration

#let general-kpis = json("data/general_kpis.json").at(0)
#let zones = json("data/zones.json")
#let cancellations-by-hour = json("data/cancellations_by_hour.json")
#let cancellations-by-stratum = json("data/cancellations_by_stratum.json")
#let cancellations-by-weather = json("data/cancellations_by_weather.json")
#let campaigns = json("data/campaigns_optimization.json")

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

// Global operational constants
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
