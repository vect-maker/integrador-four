#import "@preview/touying:0.6.1": *
#import "template.typ": *
#import "../metadata.typ": authors, tutor, career, location

== 01. Portada: Caso Movi Go

#speaker-note[
⏱ *00:00 - 01:15* | Duración: 1:15 min | *Fase: Introducción*

Buenos días, estimado comité evaluador y profesores. Hoy presentamos la defensa de avance de nuestro Proyecto Integrador IV en Ingeniería en Ciencia de Datos: *Optimización territorial de la flota y diseño de un sistema tarifario dinámico multi-criterio para Movi Go en Managua*.

El núcleo de nuestra investigación es articular tres dimensiones que tradicionalmente se tratan de forma aislada: la *eficiencia operativa* de la flota (reduciendo recorridos en vacío o _deadhead_), la *heterogeneidad territorial* de Managua (con su estructura policéntrica y asimétrica), y el *impacto climático* (precipitaciones severas que alteran la velocidad de la red vial).

Trabajamos sobre una base de más de *65,000 registros* modelados a través de la API REST oficial de Movi Go.

👉 _Transición:_ "Para comprender la complejidad del desafío, veamos cómo interactúan estas tres dimensiones en la operación diaria."
]

#v(-8pt)

#grid(
  columns: (1.35fr, 1fr),
  gutter: 12pt,
  [
    #block(
      fill: rgb("#fff8f8"),
      stroke: (left: 4pt + brand-red, rest: 1pt + border-light),
      inset: (x: 10pt, y: 8pt),
      radius: (right: 4pt),
      [
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(size: 8pt, weight: "bold", fill: brand-red)[CASO DE ESTUDIO: MOVI GO • TRANSPORTE SELECTIVO],
          image("../assets/unan-logo.jpg", width: 3.2cm)
        )
        #v(2pt)
        #text(size: 14pt, weight: "bold", fill: brand-dark)[Optimización territorial de la flota y del _sistema tarifario_ en Managua]
        #v(4pt)
        #text(size: 8.8pt, fill: rgb("#374151"))[
          Articulación analítica de dimensiones operativas, heterogeneidad territorial y factores climáticos para la eficiencia del servicio selectivo.
        ]
        #v(6pt)
        #line(length: 100%, stroke: 0.5pt + border-light)
        #v(3pt)
        #text(size: 7.5pt, fill: text-muted)[
          *Autores:* #authors.map(a => a.short-name).join(" • ") \
          *Tutor del Proyecto:* #tutor.formal-name (#link("mailto:" + tutor.email)[#tutor.email]) \
          *Carrera:* #career • UNAN-Managua (RURD)
        ]
      ]
    )
  ],
  [
    #stack(
      spacing: 5pt,
      card(title: [Flota & Deadhead], label: [Dimensión Operativa], accent: brand-red)[
        Reducción de tiempos muertos y recorridos en vacío mediante asignación dinámica.
      ],
      card(title: [Matrices OD & Moran], label: [Dimensión Territorial], accent: brand-dark)[
        Discretización urbana en zonas operativas y detección de clusters espaciales.
      ],
      card(title: [API Clima & Tráfico], label: [Dimensión Climática], accent: brand-blue)[
        Modelación de velocidad y variabilidad de demanda ante precipitaciones en Managua.
      ]
    )
  ]
)
