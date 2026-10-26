#import "../data_bindings.typ": (
  od1-origin, od1-dest,
  od1-dry-time, od1-storm-time, od1-delay-pct,
)

#let table-routing-comparison = {
  table(
    columns: (1.8fr, 1.6fr, 1.2fr, 1.2fr, 1.4fr),
    align: (left, left, center, center, center),
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
    stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
    [*Corredor Vial (OD)*], [*Ruta Dijkstra*], [*Tiempo Seco*], [*Tiempo Tormenta*], [*Impacto Temporal*],
    [OD 1: #od1-origin $arrow.r$ #od1-dest], [Ruta Directa (Seco)], [#od1-dry-time min], [---], [Línea Base],
    [OD 1: #od1-origin $arrow.r$ #od1-dest], [Desvío Metrocentro (Lluvia)], [---], [#od1-storm-time min], [+#od1-delay-pct% (Retraso)],
  )
}

#let fig-routing-comparison = figure(
  table-routing-comparison,
  caption: [Evaluación de Tiempos de Traslado y Desvíos mediante Algoritmo de Dijkstra ante Choque Climático],
)
