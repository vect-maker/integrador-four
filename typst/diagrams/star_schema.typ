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

    // --- FILA SUPERIOR: dim_zonas (0, 0) y dim_clima (2, 0) ---
    node((0, 0), db-table("dim_zonas", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_zona], text(fill: rgb("#64748b"))[text]),
      ([], [id_zona], text(fill: rgb("#64748b"))[int]),
      ([], [nombre_zona], text(fill: rgb("#64748b"))[text]),
      ([], [estrato_socioec], text(fill: rgb("#64748b"))[text]),
      ([], [nivel_estrato], text(fill: rgb("#64748b"))[int(1..4)]),
      ([], [bajada_bandera], text(fill: rgb("#64748b"))[decimal]),
    ))),

    node((2, 0), db-table("dim_clima", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_clima], text(fill: rgb("#64748b"))[text]),
      ([], [fecha], text(fill: rgb("#64748b"))[date]),
      ([], [precipitacion_mm], text(fill: rgb("#64748b"))[decimal]),
      ([], [temperatura_c], text(fill: rgb("#64748b"))[decimal]),
      ([], [indice_congestion], text(fill: rgb("#64748b"))[decimal]),
      ([], [tiene_lluvia], text(fill: rgb("#64748b"))[boolean]),
    ))),

    // --- FILA CENTRAL: fct_viajes (HECHO ATÓMICO) en (1, 1) ---
    node((1, 1), db-table("fct_viajes", "FACT TABLE", rgb("#1e1b4b"), rgb("#4338ca"), width: 152pt, (
      (pk-tag, text(weight: "bold")[sk_viaje], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_zona_origen], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_zona_destino], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_clima], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_usuario], text(fill: rgb("#64748b"))[text]),
      (fk-tag, [sk_conductor], text(fill: rgb("#64748b"))[text]),
      ([], [fecha_solicitud], text(fill: rgb("#64748b"))[date]),
      ([], [hora_solicitud], text(fill: rgb("#64748b"))[int]),
      ([], [multiplicador_dinamico], text(fill: rgb("#64748b"))[decimal]),
      ([], [tarifa_final], text(fill: rgb("#64748b"))[decimal]),
      ([], [sobrecosto_surge_nio], text(fill: rgb("#64748b"))[decimal]),
      ([], [tiempo_espera_minutos], text(fill: rgb("#64748b"))[decimal]),
      ([], text(fill: rgb("#b91c1c"), weight: "bold")[es_cancelado], text(fill: rgb("#b91c1c"), weight: "bold")[boolean]),
    ))),

    // --- FILA INFERIOR: dim_usuarios (0, 2), dim_campanias (1, 2) y dim_conductores (2, 2) ---
    node((0, 2), db-table("dim_usuarios", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_usuario], text(fill: rgb("#64748b"))[text]),
      ([], [id_usuario], text(fill: rgb("#64748b"))[int]),
      ([], [metodo_pago_pref], text(fill: rgb("#64748b"))[text]),
      ([], [prefiere_efectivo], text(fill: rgb("#64748b"))[boolean]),
      ([], [calificacion_prom], text(fill: rgb("#64748b"))[decimal]),
      ([], [fecha_registro], text(fill: rgb("#64748b"))[date]),
    ))),

    node((1, 2), db-table("dim_campanias", "OPTIMIZACIÓN", rgb("#14532d"), rgb("#16a34a"), width: 132pt, (
      (pk-tag, text(weight: "bold")[sk_campania], text(fill: rgb("#64748b"))[text]),
      ([], [id_campania], text(fill: rgb("#64748b"))[int]),
      ([], [costo_presupuesto], text(fill: rgb("#64748b"))[decimal]),
      ([], [incremento_horas], text(fill: rgb("#64748b"))[int]),
      ([], [costo_hora_conexion], text(fill: rgb("#64748b"))[decimal]),
    ))),

    node((2, 2), db-table("dim_conductores", "DIMENSION", rgb("#0369a1"), rgb("#0284c7"), (
      (pk-tag, text(weight: "bold")[sk_conductor], text(fill: rgb("#64748b"))[text]),
      ([], [id_conductor], text(fill: rgb("#64748b"))[int]),
      ([], [tipo_servicio], text(fill: rgb("#64748b"))[text]),
      ([], [modelo_vehiculo], text(fill: rgb("#64748b"))[text]),
      ([], [tasa_aceptacion], text(fill: rgb("#64748b"))[decimal]),
      ([], [es_activo], text(fill: rgb("#64748b"))[boolean]),
    ))),

    // --- ENLACES CARDINALES (1 : N) AL HECHO CENTRAL ---
    edge((0, 0), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: left),
    edge((2, 0), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: right),
    edge((0, 2), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: left),
    edge((2, 2), (1, 1), "-|>", stroke: 0.7pt + rgb("#0284c7"), label: text(size: 5.5pt, weight: "bold", fill: rgb("#0369a1"))[1 : N], label-side: right),

    // --- ENLACE PRESCRIPTIVO dim_campanias -> dim_conductores ---
    edge((1, 2), (2, 2), "-->", stroke: (dash: "dashed", paint: rgb("#16a34a"), thickness: 0.7pt), label: text(size: 5pt, weight: "bold", fill: rgb("#15803d"))[Incentivos], label-side: left),
  )
]
