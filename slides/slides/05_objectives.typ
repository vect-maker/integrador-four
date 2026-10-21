#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 05. Objetivos de Investigación

#speaker-note[
⏱ *04:00 - 05:00* | Duración: 1:00 min | *Fase: Objetivos*

Definimos nuestro *Objetivo General* de manera muy clara y medible:

Diseñar e implementar un modelo analítico y prescriptivo para la plataforma Movi Go que integre factores operativos, espaciales y climáticos de Managua, optimizando la asignación de flota y formulando directrices tarifarias transparentes.

Este objetivo se desglosa en *cuatro objetivos específicos* con verbos rectores unívocos:
1. *Estructurar* el pipeline analítico con dbt y PostgreSQL.
2. *Analizar* la relación espaciotemporal entre demanda, demoras y factores climáticos.
3. *Evaluar* el impacto de la tarificación dinámica en la oferta y la aceptación.
4. *Formular* lineamientos para la asignación eficiente de flota y reducción de deadhead.

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
      Optimizar la distribución operativa de la flota vehicular y el esquema de tarifa dinámica del servicio Movi Go en Managua mediante la ingesta vía API REST y modelado con dbt, evaluando patrones espaciotemporales y estrategias de asignación bajo condiciones variables de demanda y clima urbano.
    ]
  ]
)

#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Estructurar], label: [OE 1 • Pipeline], accent: brand-red)[
    #text(size: 8.5pt)[
      Estructurar un pipeline de ingeniería de datos con *dbt Core sobre PostgreSQL* a partir de la *API REST (/movigo)*, garantizando consolidación, auditoría y pruebas automáticas.
    ]
  ],
  card(title: [Analizar], label: [OE 2 • Territorio], accent: brand-dark)[
    #text(size: 8.5pt)[
      Analizar la distribución espaciotemporal de demanda, tiempos de espera y duración de viajes frente a *eventos meteorológicos, congestión* y disparidades zonales en Managua.
    ]
  ],
  card(title: [Evaluar], label: [OE 3 • Tarifa], accent: brand-blue)[
    #text(size: 8.5pt)[
      Evaluar la dinámica de *surge pricing* y la sensibilidad de oferta/demanda vehicular ante variaciones en el multiplicador tarifario según franja horaria y clima.
    ]
  ],
  card(title: [Formular], label: [OE 4 • Modelos], accent: brand-red)[
    #text(size: 8.5pt)[
      Formular modelos prescriptivos de *optimización operativa y rebalanceo* de flota vehicular, orientados a mitigar recorridos en vacío (*deadhead*) y equilibrar tiempos de servicio.
    ]
  ]
)
