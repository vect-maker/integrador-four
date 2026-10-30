#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 05. Objetivos de Investigación

#speaker-note[
⏱ *04:00 - 05:00* | Duración: 1:00 min | *Fase: Objetivos*

Definimos nuestro *Objetivo General* de manera muy clara y medible:

Analizar la resiliencia operativa y la conectividad de la red de transporte selectivo MoviGo ante estrangulamientos viales y contingencias climáticas en el municipio de Managua durante el año 2024.

Este objetivo se desglosa en *dos objetivos específicos*, cada uno con un único verbo rector y formulado en un nivel conceptual agnóstico a marcas tecnológicas:
1. *Consolidar* un repositorio analítico multidimensional a partir de los registros operativos del servicio mediante un flujo de extracción, carga y transformación para la integración y explotación de los datos transaccionales.
2. *Optimizar* las trayectorias de desplazamiento y la resiliencia de la red vial metropolitana mediante modelos de redes espaciales y algoritmos de camino mínimo ante perturbaciones meteorológicas y cuellos de botella urbanos.

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
      Analizar la resiliencia operativa y la conectividad de la red de transporte selectivo MoviGo ante estrangulamientos viales y contingencias climáticas en el municipio de Managua durante el año 2024.
    ]
  ]
)

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,
  card(title: [Consolidar], label: [OE 1 • Repositorio Analítico], accent: brand-red)[
    #text(size: 8.5pt)[
      Consolidar un repositorio analítico multidimensional a partir de los registros operativos del servicio mediante un flujo de extracción, carga y transformación para la integración y explotación de los datos transaccionales.
    ]
  ],
  card(title: [Optimizar], label: [OE 2 • Redes & Resiliencia], accent: brand-blue)[
    #text(size: 8.5pt)[
      Optimizar las trayectorias de desplazamiento y la resiliencia de la red vial metropolitana mediante modelos de redes espaciales y algoritmos de camino mínimo ante perturbaciones meteorológicas y cuellos de botella urbanos.
    ]
  ]
)
