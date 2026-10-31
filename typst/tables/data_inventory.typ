// typst/tables/data_inventory.typ: Analytical Repository Inventory (Fact + Dimensions)
// Hydrated dynamically from data/pipeline_inventory.json (Single Source of Truth)

#import "../data_bindings.typ": inv-rows, fmt-int

#let table-data-inventory(size: 8pt) = {
  set text(size: size)
  table(
    columns: (1.5fr, 1fr, 3.2fr, 1fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 4.5pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 3 { right + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header([*Tabla*], [*Tipo*], [*Grano (una fila por…)*], [*Registros*]),
    [`fct_viajes`], [Hechos], [Intento o servicio de transporte], [#fmt-int(inv-rows.fct_viajes)],
    [`dim_users`], [Dimensión], [Pasajero registrado], [#fmt-int(inv-rows.dim_users)],
    [`dim_drivers`], [Dimensión], [Conductor y su vehículo], [#fmt-int(inv-rows.dim_drivers)],
    [`dim_zones`], [Dimensión], [Zona urbana de Managua], [#fmt-int(inv-rows.dim_zones)],
    [`dim_quadrants`], [Dimensión], [Cuadrante de la malla territorial], [#fmt-int(inv-rows.dim_quadrants)],
    [`dim_weather`], [Dimensión], [Día calendario de 2024], [#fmt-int(inv-rows.dim_weather)],
    [`dim_campaigns`], [Dimensión], [Campaña de incentivos], [#fmt-int(inv-rows.dim_campaigns)],
  )
}

#let fig-data-inventory = figure(
  table-data-inventory(),
  caption: [Inventario del repositorio analítico consolidado: tabla de hechos y dimensiones conformadas],
)
