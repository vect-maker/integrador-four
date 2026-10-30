#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 08. Diseño Metodológico Cuantitativo

#speaker-note[
⏱ *07:30 - 08:45* | Duración: 1:15 min | *Fase: Metodología*

Adoptamos un *enfoque cuantitativo* y un *alcance descriptivo-prescriptivo* bajo un diseño no experimental longitudinal.

La investigación se articula en *dos fases secuenciales*:
*Fase 1: Pipeline ELT y Star Schema*. Ingesta Parquet, carga en Azure PostgreSQL, transformaciones y pruebas de integridad con dbt Core y DuckDB.
*Fase 2: Optimización en Redes Viales*. Modelado de grafo metropolitano (24 zonas y 44 corredores), métricas de centralidad de intermediación y algoritmo de Dijkstra para cuantificar la resiliencia ante anegamientos pluviales en Managua.

👉 _Transición:_ "Entremos al detalle de la arquitectura del pipeline de datos con API, Azure, dbt y DuckDB."
]

#v(-6pt)

// Roadmap flow
#grid(
  columns: (1fr, auto, 1fr),
  align: horizon,
  gutter: 14pt,
  pipeline-step([FASE 1], [Pipeline ELT & Kimball], [Azure, dbt Core & DuckDB], accent: brand-red),
  [#text(size: 16pt, fill: text-muted)[→]],
  pipeline-step([FASE 2], [Optimización en Grafos], [Centralidad & Dijkstra ante Lluvia], accent: brand-blue),
)

#v(8pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Cuantitativo], label: [A • Paradigma], accent: brand-red)[
    #text(size: 8.5pt)[
      Preponderancia cuantitativa (77k registros, almacén OLAP y teoría de redes) articulada con la contextualización territorial de Managua.
    ]
  ],
  card(title: [Descriptivo-Prescriptivo], label: [B • Tipo y Alcance], accent: brand-dark)[
    #text(size: 8.5pt)[
      Describe la movilidad urbana de la capital y formula soluciones prescriptivas de ruteo vial resiliente ante eventos meteorológicos.
    ]
  ],
  card(title: [No Experimental], label: [C • Diseño], accent: brand-blue)[
    #text(size: 8.5pt)[
      Diseño longitudinal: observación continua del ciclo anual 2024 ($n = 366$ días) sin manipulación artificial de las variables del sistema.
    ]
  ],
  card(title: [El Viaje Individual], label: [D • Unidad de Análisis], accent: brand-red)[
    #text(size: 8.5pt)[
      Solicitudes ($N = 77,487$) georreferenciadas en 24 zonas urbanas con métricas tarifarias dinámicas, condiciones de lluvia y estado de cancelación.
    ]
  ]
)

#v(2pt)
#text(size: 7.5pt, fill: text-muted)[
  *Sustento Metodológico:* Marco adaptado conforme a Hernández Sampieri & Mendoza Torres (2023).
]
