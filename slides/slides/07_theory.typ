#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 07. Marco Teórico: Transporte & Clima

#speaker-note[
⏱ *07:30 - 08:45* | Duración: 1:15 min | *Fase: Marco Teórico*

En el marco teórico profundizamos en tres fenómenos estructurales propios de Managua:

Primero, la *morfología urbana y vial*. Managua no es una cuadrícula; es un trazado irregular articulado por rotondas (Centroamérica, Rubén Darío, Cristo Rey). Cuando una rotonda colapsa, el efecto dominó estrangula las arterias conectoras.

Segundo, la *economía de plataformas de dos lados (Two-Sided Markets)*. La tarifa debe mantener un equilibrio delicado: si el surge sube demasiado, el pasajero de estrato popular o medio cancela; si baja demasiado, el conductor prefiere desconectarse ante la lluvia.

Tercero, la *hidrología vial urbana*. La escorrentía superficial convierte calles en cauces temporales, obligando a recalibrar las matrices de tiempo de viaje de forma no lineal.

👉 _Transición:_ "Con el sustento teórico establecido, expliquemos el diseño metodológico de la investigación."
]

#v(-4pt)

#text(size: 8.5pt, fill: text-muted)[
  La teoría de ride-hailing advierte que disponer de vehículos totales no garantiza cobertura si no coinciden en tiempo y espacio con la demanda urbana.
]

#v(2pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  card(title: [Xu et al. / Moran's I], label: [Heterogeneidad Espaciotemporal], accent: brand-red)[
    La demanda presenta alta autocorrelación espacial. Si las unidades no se anticipan a centros generadores, el ratio de *deadhead miles* se dispara.
    #v(2pt)
    #block(fill: rgb("#fff0f0"), inset: 3pt, radius: 2pt)[
      #text(size: 7.5pt, fill: brand-red)[`Moran's I > 0: Clusters espaciales críticos.`]
    ]
  ],
  card(title: [Precipitación & Red Vial], label: [Doble Incidencia Climática], accent: brand-blue)[
    Con *1,119.8 mm anuales* en Managua, la lluvia genera un efecto dual:
    #v(2pt)
    - *Expansión de Demanda:* Migración masiva hacia selectivo protegido.
    - *Contracción Oferta:* Reducción de velocidad vial por anegamientos.
  ],
  card(title: [Two-Sided Markets], label: [Riesgos de Tarificación], accent: brand-dark)[
    Investigaciones en _Nature Communications_ evidencian que un surge mal balanceado induce fallas de mercado:
    #v(2pt)
    - Precio excesivo: *expulsa al usuario*.
    - Precio plano bajo lluvia: *chofer se desconecta* o rechaza servicios lejanos.
  ]
)

#v(2pt)
#callout-box(accent: brand-red)[
  *Síntesis:* El modelo prescriptivo debe integrar restricciones de red vial, hidrología urbana y equilibrio bifronte simultáneamente.
]
