#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 06. Matriz de Variables y Descriptores

#speaker-note[
⏱ *05:00 - 06:15* | Duración: 1:15 min | *Fase: Variables*

Esta tabla resume la *Matriz de Descriptores* estructurada a partir de los verbos rectores de cada objetivo:

1. OE1 (Estructurar): Base inmutable que extrae los datos de la API REST y los transforma con dbt para garantizar calidad e integridad.
2. OE2 (Analizar): Examina cómo la lluvia, el tráfico y las zonas impactan tiempos de espera y cancelaciones.
3. OE3 (Evaluar): Explora la sensibilidad de oferta y demanda frente al multiplicador dinámico.
4. OE4 (Formular): Diseña modelos prescriptivos para reducir recorridos en vacío (deadhead) y equilibrar tiempos de servicio.

👉 _Transición:_ "Veamos ahora el marco teórico que fundamenta cada una de estas áreas."
]

#v(-10pt)

#set text(size: 7.5pt)

#table(
  columns: (0.35fr, 1fr, 1.6fr, 1.3fr, 1.5fr, 0.95fr),
  stroke: 0.5pt + border-light,
  inset: 3.2pt,
  align: (center + horizon, left + horizon, left, left, left, left),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#fdfdfd") } else { none },
  table.header(
    [*OE*], [*Variable*], [*Definición Operativa*], [*Dimensiones*], [*Indicadores Clave*], [*Técnicas*]
  ),
  [#strong[01]],
  [*Estructurar* \ #text(size: 6.5pt, fill: text-muted)[Pipeline dbt]],
  [Extracción paginada API REST, staging PostgreSQL y marts dbt.],
  [Ingesta API, raw stage, staging, marts dimensionales.],
  [77,487 registros, integridad referencial, tests dbt superados.],
  [API REST, dbt Core, SQL.],

  [#strong[02]],
  [*Analizar* \ #text(size: 6.5pt, fill: text-muted)[Espaciotemporal]],
  [Demanda, demoras y cancelaciones ante factores climáticos y tráfico.],
  [Flujos horarios, lluvia, congestión vial, estratos.],
  [Volumen viajes, variación duración por lluvia, cancelaciones.],
  [Analítica OLAP en DuckDB.],

  [#strong[03]],
  [*Evaluar* \ #text(size: 6.5pt, fill: text-muted)[Tarifa Dinámica]],
  [Respuesta operativa ante variaciones del multiplicador y estratos.],
  [Multiplicador surge, sensibilidad, balance oferta/demanda.],
  [Distribución de $m$, sobrecostos, cancelaciones por zona.],
  [Análisis exploratorio dimensional.],

  [#strong[04]],
  [*Formular* \ #text(size: 6.5pt, fill: text-muted)[Optimización]],
  [Modelos de ruteo vial y resiliencia ante contingencias pluviales.],
  [Topología de red vial, caminos mínimos, desvíos por anegamiento.],
  [Retrasos de red, centralidad de intermediación, rutas óptimas.],
  [Teoría de grafos, Algoritmo de Dijkstra.]
)

#v(1pt)
#text(size: 7pt, fill: text-muted)[
  *Instrumentos:* API REST (/movigo) • dbt Core sobre PostgreSQL • DuckDB • Optimización de redes en Python (NetworkX).
]
