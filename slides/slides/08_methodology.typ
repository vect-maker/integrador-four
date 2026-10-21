#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 08. Diseño Metodológico Mixto

#speaker-note[
⏱ *07:30 - 08:45* | Duración: 1:15 min | *Fase: Metodología*

Adoptamos un *enfoque cuantitativo-analítico* con un diseño no experimental longitudinal.

La investigación se articula en *cuatro fases secuenciales* alineadas a los objetivos específicos:
*Fase 1: Ingesta de Datos*. Extracción sistemática vía API REST `/movigo` con paginación controlada.
*Fase 2: Transformación y Calidad con dbt*. Modelado analítico dimensional y auditoría con dbt Core sobre PostgreSQL.
*Fase 3: Análisis Espaciotemporal y Tarifario*. Caracterización de fluctuaciones de demanda, factores climáticos y sensibilidad del surge.
*Fase 4: Optimización Operativa*. Formulación y contraste de modelos prescriptivos de asignación de flota y reducción de deadhead.

👉 _Transición:_ "Entremos al detalle de la arquitectura del pipeline de datos con API y dbt."
]

#v(-6pt)

// Roadmap flow
#grid(
  columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
  align: horizon,
  gutter: 4pt,
  pipeline-step([FASE 1], [Ingesta de Datos], [API REST /movigo], accent: brand-red),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 2], [Modelado & Calidad], [dbt Core & PostgreSQL], accent: brand-dark),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 3], [Análisis Contextual], [Espaciotemporal & Clima], accent: brand-blue),
  [#text(size: 14pt, fill: text-muted)[→]],
  pipeline-step([FASE 4], [Optimización], [Asignación & Deadhead], accent: brand-red),
)

#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Enfoque Mixto], label: [A • Paradigma], accent: brand-red)[
    #text(size: 8.5pt)[
      Preponderancia cuantitativa (>65k registros de viajes, GPS, tiempos y tarifas) complementada con validación cualitativa de reglas de negocio operativas.
    ]
  ],
  card(title: [Descriptivo & Propositivo], label: [B • Tipo y Alcance], accent: brand-dark)[
    #text(size: 8.5pt)[
      Describe la distribución del servicio en Managua, evalúa correlaciones con clima y formula lineamientos prescriptivos de optimización de flota.
    ]
  ],
  card(title: [No Experimental], label: [C • Diseño], accent: brand-blue)[
    #text(size: 8.5pt)[
      Diseño longitudinal: se observan y analizan los registros sin manipulación arbitraria, modelando el comportamiento histórico real de Movi Go.
    ]
  ],
  card(title: [El Viaje Individual], label: [D • Unidad de Análisis], accent: brand-red)[
    #text(size: 8.5pt)[
      Ciclo de solicitud, recogida, trayecto y tarifa cobrada en cada cuadrante de Managua, georreferenciado espacial y temporalmente.
    ]
  ]
)

#v(2pt)
#text(size: 7.5pt, fill: text-muted)[
  *Sustento Metodológico:* Marco adaptado conforme a Hernández Sampieri & Mendoza Torres (2023).
]
