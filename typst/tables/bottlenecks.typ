// typst/tables/bottlenecks.typ: Zonas con mayor centralidad de intermediación (OE3)
// Hydrated dynamically from data/routing_optimization.json (Single Source of Truth)

#import "../data_bindings.typ": routing, fmt-dec

#let table-bottlenecks(size: 8pt) = {
  set text(size: size)
  table(
    columns: (2.7fr, 1.2fr, 1.2fr, 1.2fr, 0.9fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 4.5pt),
    align: (col, row) => if row == 0 { center + horizon } else if col >= 2 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Zona urbana*], [*Estrato*], [*$C_B$ seco*], [*$C_B$ tormenta*], [*Grado*]
    ),
    ..routing.top_bottlenecks.slice(0, 5).map(b => (
      b.name,
      b.stratum,
      fmt-dec(b.betweenness_dry, digits: 3),
      fmt-dec(b.betweenness_storm, digits: 3),
      str(b.degree),
    )).flatten(),
  )
}

#let fig-bottlenecks = figure(
  table-bottlenecks(),
  caption: [Zonas con mayor centralidad de intermediación en la red vial de Managua (seco vs. tormenta)],
)
