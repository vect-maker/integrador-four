#import "../data_bindings.typ": (
  od1-origin, od1-dest, od1-dry-time, od1-storm-time, od1-delay-pct, od1-rerouted,
  od1-movigo-storm, od1-saved-time,
  od2-origin, od2-dest, od2-dry-time, od2-storm-time, od2-delay-pct, od2-rerouted,
  od2-movigo-storm, od2-saved-time,
  od3-origin, od3-dest, od3-dry-time, od3-storm-time, od3-delay-pct, od3-rerouted,
  od3-movigo-storm, od3-saved-time,
)

#let _yes-no(value) = if value { [Sí] } else { [No] }

#let table-routing-comparison = {
  set text(size: 8pt)
  table(
    columns: (2.8fr, 1.1fr, 1.4fr, 1.4fr, 1.2fr, 0.8fr),
    align: (left, center, center, center, center, center),
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
    stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
    table.header(
      [*Corredor (OD)*], [*Seco (min)*], [*Dijkstra Tormenta*], [*MoviGo Obs.*], [*Ahorro Neto*], [*Desvío*]
    ),
    [OD 1: #od1-origin $arrow.r$ #od1-dest], [#od1-dry-time], [#od1-storm-time], [#od1-movigo-storm], [-#od1-saved-time min], [#_yes-no(od1-rerouted)],
    [OD 2: #od2-origin $arrow.r$ #od2-dest], [#od2-dry-time], [#od2-storm-time], [#od2-movigo-storm], [-#od2-saved-time min], [#_yes-no(od2-rerouted)],
    [OD 3: #od3-origin $arrow.r$ #od3-dest], [#od3-dry-time], [#od3-storm-time], [#od3-movigo-storm], [-#od3-saved-time min], [#_yes-no(od3-rerouted)],
  )
}

#let fig-routing-comparison = figure(
  table-routing-comparison,
  caption: [Auditoría de ruteo: tiempos de traslado óptimos (Dijkstra) vs. observados de MoviGo bajo tormenta],
)
