// Especificación Arquitectónica del Esquema en Estrella (Star Schema)
// Componente de tabla reutilizable para el paper, presentaciones y anexos técnicos

#let table-star-schema(size: 7.6pt, raw-size: 6.8pt) = {
  set text(size: size)
  show raw.where(block: false): it => box(
    fill: rgb("#f1f5f9"),
    radius: 1.5pt,
    inset: (x: 1.8pt, y: 0pt),
    baseline: 0%,
    text(font: ("Liberation Mono", "DejaVu Sans Mono"), size: raw-size, it.text)
  )
  table(
    columns: (1.35fr, 1.05fr, 1.15fr, 1.35fr, 2.6fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 4pt, y: 3.5pt),
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header(
      [*Modelo (dbt)*], [*Rol Dimensional*], [*PK Subrogada*], [*Relaciones / FK*], [*Grano y Métricas / Atributos Clave*]
    ),
    [`fct_viajes`],
    [Tabla de Hechos (Atómica)],
    [`sk_viaje` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [
      #stack(
        spacing: 1.5pt,
        [`sk_zona_origen`],
        [`sk_zona_destino`],
        [`sk_clima`, `sk_usuario`],
        [`sk_conductor`]
      )
    ],
    [1 fila por solicitud ($N = 77,036$). Multiplicador dinámico, tarifa base, tarifa final, recargo surge, tiempo espera, bandera booleana de cancelación (`es_cancelado`).],

    [`dim_zonas`],
    [Dimensión Conformada],
    [`sk_zona` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [Origen y Destino \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_viajes`)]],
    [12 cuadrantes urbanos. Estrato socioeconómico, nivel ordinal (1--4), latitud, longitud, radio cobertura, bajada de bandera zonal.],

    [`dim_clima`],
    [Dimensión Conformada],
    [`sk_clima` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_clima` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_viajes`)]],
    [365 días del ciclo 2024. Precipitación (mm), temperatura (°C), índice y nivel de congestión vial, condición de cielo, indicador de lluvia.],

    [`dim_usuarios`],
    [Dimensión Conformada],
    [`sk_usuario` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_usuario` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_viajes`)]],
    [Pasajeros registrados. Preferencia de pago (efectivo vs tarjeta/digital), calificación histórica promedio, fecha de registro.],

    [`dim_conductores`],
    [Dimensión Conformada],
    [`sk_conductor` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [`sk_conductor` \ #text(size: raw-size, fill: rgb("#64748b"))[(`fct_viajes`)]],
    [Socios de la flota. Modalidad vehicular (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), modelo, año, calificación, tasa de aceptación, estado activo.],

    [`dim_campanias`],
    [Dimensión Prescriptiva],
    [`sk_campania` \ #text(size: raw-size, fill: rgb("#64748b"))[(Hash MD5)]],
    [Optimización \ #text(size: raw-size, fill: rgb("#64748b"))[Mochila 0/1]],
    [Programas de bonos. Costo presupuestario en córdobas (NIO), incremento en horas de conexión y ratio de costo unitario por hora.]
  )
}

// Figura enumerada completa con título y formato formal
#let fig-star-schema-table = figure(
  table-star-schema(),
  caption: [Especificación arquitectónica del Esquema en Estrella (Star Schema) implementado en dbt Core],
)
