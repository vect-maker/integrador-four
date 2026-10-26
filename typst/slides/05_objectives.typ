#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 05. Objetivos de Investigación

#speaker-note[
⏱ *04:00 - 05:00* | Duración: 1:00 min | *Fase: Objetivos*

Definimos nuestro *Objetivo General* de manera muy clara y medible:

Determinar el impacto del esquema de tarificación dinámica sobre la tasa de cancelación de viajes del servicio de transporte selectivo MoviGo en el municipio de Managua durante el año 2024.

Este objetivo se desglosa en *cuatro objetivos específicos* con verbos rectores unívocos:
1. *Implementar* el pipeline analítico ELT con Azure PostgreSQL, dbt Core y DuckDB.
2. *Modelar* la tasa de cancelación frente al multiplicador dinámico mediante regresión lineal simple (MCO) y ANOVA.
3. *Calcular* el multiplicador tarifario de equilibrio de mercado mediante búsqueda numérica de raíces (Bisección y Newton-Raphson).
4. *Optimizar* los tiempos de traslado y evaluar la resiliencia en la red vial urbana mediante teoría de grafos y el algoritmo de Dijkstra.

👉 _Transición:_ "Pasemos a ver cómo operacionalizamos formalmente cada una de las variables involucradas."
]

#v(-4pt)

#block(
  fill: rgb("#fff8f8"),
  stroke: (left: 4pt + brand-red, rest: 1pt + border-light),
  inset: 9pt,
  radius: (right: 4pt),
  [
    #text(size: 8pt, weight: "bold", fill: brand-red)[OBJETIVO GENERAL] \
    #text(size: 9.5pt, weight: "bold", fill: brand-dark)[
      Determinar el impacto del esquema de tarificación dinámica sobre la tasa de cancelación de viajes del servicio de transporte selectivo MoviGo en el municipio de Managua durante el año 2024.
    ]
  ]
)

#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Implementar], label: [OE 1 • Pipeline DataOps], accent: brand-red)[
    #text(size: 8pt)[
      Implementar un pipeline ELT (*Azure PostgreSQL, dbt Core y DuckDB*) a partir de la API REST para consolidar el repositorio analítico 2024 con pruebas automáticas.
    ]
  ],
  card(title: [Modelar], label: [OE 2 • Econometría], accent: brand-dark)[
    #text(size: 8pt)[
      Modelar la tasa de cancelación frente al multiplicador dinámico mediante *regresión lineal simple (MCO) y análisis de varianza (ANOVA)*.
    ]
  ],
  card(title: [Calcular], label: [OE 3 • Métodos Numéricos], accent: brand-blue)[
    #text(size: 8pt)[
      Calcular el multiplicador de equilibrio de mercado en la función de exceso de demanda mediante búsqueda de raíces (*Bisección y Newton-Raphson*).
    ]
  ],
  card(title: [Optimizar], label: [OE 4 • Teoría de Grafos], accent: brand-red)[
    #text(size: 8pt)[
      Optimizar las rutas en la red vial urbana y evaluar la resiliencia ante lluvias e inundaciones mediante el *algoritmo de Dijkstra*.
    ]
  ]
)
