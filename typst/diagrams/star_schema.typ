// Diagrama Arquitectónico del Esquema en Estrella (Star Schema) - dbt Core & Kimball
// Diseñado con el paquete nativo Fletcher con fidelidad técnica de esquema relacional (ERD)

#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

// Etiquetas tipográficas para claves relacionales
#let pk-tag = text(fill: rgb("#d97706"), weight: "bold", size: 5.5pt)[PK]
#let fk-tag = text(fill: rgb("#2563eb"), weight: "bold", size: 5.5pt)[FK]

// Componente de tabla relacional de base de datos (Database Table Schema)
#let db-table(name, subtitle, header-bg, stroke-color, width: 122pt, rows) = block(
  stroke: 0.5pt + stroke-color,
  radius: 3pt,
  fill: white,
  width: width,
  clip: true,
  [
    // Cabecera de la tabla (Schema Header)
    #block(
      fill: header-bg,
      inset: (x: 5pt, y: 3.5pt),
      width: 100%,
      [
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(size: 7.5pt, weight: "bold", fill: white, font: "Liberation Sans")[#name],
          text(size: 5.5pt, fill: rgb("#e2e8f0").darken(5%), weight: "medium", font: "Liberation Sans")[#subtitle]
        )
      ]
    )
    // Filas estructuradas de atributos y tipos de datos
    #table(
      columns: (12pt, 1fr, auto),
      stroke: (x, y) => if y == 0 { none } else { (top: 0.3pt + rgb("#e2e8f0")) },
      fill: (col, row) => if calc.even(row) { rgb("#ffffff") } else { rgb("#f8fafc") },
      inset: (x: 3.5pt, y: 2.2pt),
      align: (center + horizon, left + horizon, right + horizon),
      ..rows.flatten()
    )
  ]
)

// Diagrama principal del Star Schema exportable
#let diagram-star-schema = align(center)[
  #set text(font: "Liberation Sans", size: 6.5pt)
  #diagram(
    node-stroke: none,
    node-fill: none,
    spacing: (26pt, 16pt),

    // --- FILA SUPERIOR: dim_zones (0, 0) y dim_weather (2, 0) ---
    node((0, 0), db-table("dim_zones", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_zone], text(fill: rgb("#64748b"))[text]),
      ([], [zone_id], text(fill: rgb("#64748b"))[int]),
      ([], [zone_name], text(fill: rgb("#64748b"))[text]),
      ([], [district], text(fill: rgb("#64748b"))[text]),
      ([], [socioeconomic_stratum], text(fill: rgb("#64748b"))[text]),
      ([], [base_flag_drop_fare], text(fill: rgb("#64748b"))[decimal]),
    ))),

    node((2, 0), db-table("dim_weather", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_weather], text(fill: rgb("#64748b"))[text]),
      ([], [date], text(fill: rgb("#64748b"))[date]),
      ([], [precipitation_mm], text(fill: rgb("#64748b"))[decimal]),
      ([], [temperature_c], text(fill: rgb("#64748b"))[decimal]),
      ([], [congestion_index], text(fill: rgb("#64748b"))[decimal]),
      ([], [has_rain], text(fill: rgb("#64748b"))[boolean]),
      ([], [season], text(fill: rgb("#64748b"))[text]),
    ))),

    // --- FILA CENTRAL: fct_viajes (HECHO ATÓMICO) en (1, 1) ---
    node((1, 1), db-table("fct_viajes", "FACT TABLE", rgb("#1e1b4b"), rgb("#4338ca"), width: 152pt, (
      (pk-tag, text(weight: "bold")[sk_trip], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_zone_origin], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_zone_destination], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_weather], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_user], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_driver], text(fill: rgb("#64748b"))[text]),
      ([], [request_date], text(fill: rgb("#64748b"))[date]),
      ([], [request_hour], text(fill: rgb("#64748b"))[int]),
      ([], [surge_multiplier], text(fill: rgb("#64748b"))[decimal]),
      ([], [final_fare], text(fill: rgb("#64748b"))[decimal]),
      ([], [surge_cost_nio], text(fill: rgb("#64748b"))[decimal]),
      ([], [wait_time_minutes], text(fill: rgb("#64748b"))[decimal]),
      ([], text(fill: rgb("#b91c1c"), weight: "bold")[is_cancelled], text(fill: rgb("#b91c1c"), weight: "bold")[boolean]),
    ))),

    // --- FILA INFERIOR: dim_users (0, 2), dim_campaigns (1, 2) y dim_drivers (2, 2) ---
    node((0, 2), db-table("dim_users", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_user], text(fill: rgb("#64748b"))[text]),
      ([], [user_id], text(fill: rgb("#64748b"))[int]),
      ([], [preferred_payment_method], text(fill: rgb("#64748b"))[text]),
      ([], [prefers_cash], text(fill: rgb("#64748b"))[boolean]),
      ([], [average_rating], text(fill: rgb("#64748b"))[decimal]),
      ([], [rating_segment], text(fill: rgb("#64748b"))[text]),
    ))),

    node((1, 2), db-table("dim_campaigns", "OPTIMIZACIÓN", rgb("#14532d"), rgb("#16a34a"), width: 132pt, (
      (pk-tag, text(weight: "bold")[sk_campaign], text(fill: rgb("#64748b"))[text]),
      ([], [campaign_id], text(fill: rgb("#64748b"))[int]),
      ([], [budget_cost_nio], text(fill: rgb("#64748b"))[decimal]),
      ([], [target_driver_hours], text(fill: rgb("#64748b"))[int]),
      ([], [cost_per_hour_nio], text(fill: rgb("#64748b"))[decimal]),
      ([], [target_zone_name], text(fill: rgb("#64748b"))[text]),
    ))),

    node((2, 2), db-table("dim_drivers", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_driver], text(fill: rgb("#64748b"))[text]),
      ([], [driver_id], text(fill: rgb("#64748b"))[int]),
      ([], [service_type], text(fill: rgb("#64748b"))[text]),
      ([], [vehicle_model], text(fill: rgb("#64748b"))[text]),
      ([], [acceptance_rate_pct], text(fill: rgb("#64748b"))[decimal]),
      ([], [total_maintenance_services], text(fill: rgb("#64748b"))[int]),
      ([], [is_active], text(fill: rgb("#64748b"))[boolean]),
    ))),

    // --- ENLACES CARDINALES (1 : N) AL HECHO CENTRAL ---
    edge((0, 0), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: left),
    edge((2, 0), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: right),
    edge((0, 2), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: left),
    edge((2, 2), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: right),

    // --- ENLACE PRESCRIPTIVO dim_campaigns -> dim_drivers ---
    edge((1, 2), (2, 2), "-->", stroke: (dash: "dashed", paint: rgb("#16a34a"), thickness: 0.7pt), label: text(size: 5pt, weight: "bold", fill: rgb("#15803d"))[Incentivos], label-side: left),
  )
]

// Figura enumerada completa con título para documentos formales
#let fig-star-schema = figure(
  diagram-star-schema,
  caption: [Diagrama dimensional del Esquema en Estrella (Star Schema) implementado en dbt Core],
)
