// typst/tables/zones_catalog.typ: Territorial & Flag-Drop Base Pricing Catalog
// Programmatically hydrated from data/zones.json via DuckDB (Single Source of Truth)

#import "../data_bindings.typ": zones

// Reusable table component
#let table-zones-catalog(size: 8pt) = {
  set text(size: size)
  table(
    columns: (0.4fr, 2fr, 1fr, 1.3fr, 0.9fr, 1.4fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 5pt, y: 4pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 0 or col == 4 { center + horizon } else if col == 5 { right + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*ID*], [*Zona Urbana*], [*Estrato*], [*Coordenadas*], [*Radio*], [*Bajada Bandera*]
    ),
    ..zones.map(z => (
      [#z.id_zona],
      [#z.nombre_zona],
      [#upper(z.estrato_socioeconomico.slice(0, 1))#z.estrato_socioeconomico.slice(1)],
      [#z.latitud, #z.longitud],
      [#z.radio_cobertura_km km],
      [C\$ #calc.round(z.tarifa_base_bajada_bandera, digits: 2) NIO],
    )).flatten()
  )
}

// Formal enumerated figure with caption for the paper
#let fig-zones-catalog = figure(
  table-zones-catalog(),
  caption: [Catálogo territorial de las 24 zonas urbanas de Managua y tarifas base de bajada de bandera],
)
