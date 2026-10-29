// typst/tables/strata_summary.typ: Compact Socioeconomic Stratification Summary
// Hydrated dynamically from data/cancellations_by_stratum.json (Single Source of Truth)

#import "../data_bindings.typ": cancellations-by-stratum

#let table-strata-summary(size: 8pt) = {
  set text(size: size)
  table(
    columns: (1.2fr, 2.2fr, 1.4fr, 1.4fr, 1.6fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),
    align: (col, row) => if row == 0 { center + horizon } else if col == 0 { left + horizon } else if col == 2 or col == 3 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Estrato*], [*Zonas Representativas*], [*Bajada de Bandera*], [*Tasa Cancelación*], [*Medio de Pago Predominante*]
    ),
    [Alto (Nivel 4)], [Villa Fontana, Las Colinas, Sto. Domingo], [C\$ 70.00 -- 80.00], [33.85%], [Tarjeta de crédito / débito (digital)],
    [Comercial (Nivel 3)], [Metrocentro, Centro Cívico, Carr. Norte], [C\$ 55.00 -- 60.00], [34.62%], [Billetera digital y corporativo],
    [Medio (Nivel 2)], [Los Robles, Altamira, Bolonia, Bello Hte.], [C\$ 48.00 -- 55.00], [32.36%], [Mixto (efectivo y tarjeta)],
    [Popular (Nivel 1)], [Ciudad Jardín, Oriental, Huembes, Sabana G.], [C\$ 35.00 -- 45.00], [41.67%], [Efectivo estricto (alta elasticidad)],
  )
}

#let fig-strata-summary = figure(
  table-strata-summary(),
  caption: [Estratificación socioeconómica territorial de Managua y condiciones base del servicio],
)
