#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 08. Diseño Metodológico Mixto

#speaker-note[
⏱ *07:30 - 08:45* | Duración: 1:15 min | *Fase: Metodología*

Adoptamos un *enfoque mixto con predominio cuantitativo* y un *alcance correlacional-prescriptivo* bajo un diseño no experimental longitudinal.

La investigación se articula en *cuatro fases secuenciales* alineadas estrictamente a los cuatro objetivos:
*Fase 1: Pipeline ELT y Star Schema*. Ingesta Parquet, carga en Azure PostgreSQL, transformaciones y pruebas de integridad con dbt Core y DuckDB.
*Fase 2: Modelación Econométrica MCO*. Regresión lineal simple y descomposición ANOVA para medir la sensibilidad de la tasa de cancelación ante el multiplicador tarifario.
*Fase 3: Búsqueda Numérica de Raíces*. Algoritmos de Bisección y Newton-Raphson para resolver la condición de vaciado de mercado y hallar el multiplicador de equilibrio $m^* = 1.35times$.
*Fase 4: Optimización en Redes Viales*. Algoritmo de Dijkstra para determinar la ruta mínima y cuantificar el impacto de anegamientos pluviales en Managua.

👉 _Transición:_ "Entremos al detalle de la arquitectura del pipeline de datos con API, Azure, dbt y DuckDB."
]

#v(-6pt)

// Roadmap flow
#grid(
  columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
  align: horizon,
  gutter: 4pt,
  pipeline-step([FASE 1], [Pipeline ELT], [Azure, dbt & DuckDB], accent: brand-red),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 2], [Econometría MCO], [Regresión & ANOVA], accent: brand-dark),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 3], [Raíces Numéricas], [Equilibrio de Mercado], accent: brand-blue),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 4], [Optimización Grafos], [Dijkstra ante Lluvia], accent: brand-red),
)

#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Enfoque Mixto], label: [A • Paradigma], accent: brand-red)[
    #text(size: 8.5pt)[
      Preponderancia cuantitativa (77k registros, MCO, raíces no lineales y grafos) complementada con análisis cualitativo y socio-espacial de Managua.
    ]
  ],
  card(title: [Alcance Mixto], label: [B • Tipo y Alcance], accent: brand-dark)[
    #text(size: 8.5pt)[
      Trasciende lo descriptivo: evalúa correlaciones causales con MCO y formula soluciones prescriptivas de equilibrio tarifario y ruteo vial resiliente.
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
