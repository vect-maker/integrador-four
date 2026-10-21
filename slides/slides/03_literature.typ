#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 03. Estado del Arte & Literatura

#speaker-note[
⏱ *02:30 - 03:45* | Duración: 1:15 min | *Fase: Estado del Arte*

Nuestra investigación se apoya en cuatro pilares de la literatura científica internacional y regional:

1. *Alonso-Mora et al. (2017)* en PNAS demostraron que el despacho y el rebalanceo de flotas en tiempo real deben formularse como un problema de optimización matemática conjunto bajo restricciones temporales estrictas.
2. *Jiao et al. (2021)* demostraron la efectividad de políticas de rebalanceo proactivo para reducir el tiempo inactivo.
3. *Zha et al. (2018) y Liu et al. (2021)* probaron que eventos de lluvia distorsionan fuertemente la velocidad de red y los tiempos de recogida.
4. *Plan Maestro JICA (2017)* confirma que en Managua el 26% de los viajes se realizan en transporte selectivo.

👉 _Transición:_ "Con esta base teórica, examinemos la radiografía exacta de ineficiencias que experimenta Movi Go en Managua."
]

#text(size: 9.5pt, fill: text-muted)[
  La literatura respalda que la eficiencia operativa surge de acoplar simultáneamente el posicionamiento de unidades, el mecanismo de precios y las perturbaciones climáticas.
]

#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 8pt,
  card(title: [Alonso-Mora et al. (2017)], label: [Despacho Dinámico], accent: brand-red)[
    #text(size: 8pt, weight: "bold", fill: brand-red)[PNAS / NYC Testbed] \
    Asignación dinámica viaje-vehículo. Demostró que demanda y flota deben optimizarse conjuntamente bajo ventanas estrictas de tiempo.
  ],
  card(title: [Jiao et al. (2021)], label: [Reposicionamiento], accent: brand-dark)[
    #text(size: 8pt, weight: "bold", fill: brand-dark)[Rebalanceo Espacial] \
    Políticas de redistribución proactiva de unidades vacías considerando el estado espaciotemporal global del sistema para bajar la inactividad.
  ],
  card(title: [Zha (2018) / Liu (2021)], label: [Tarifa & Clima], accent: brand-blue)[
    #text(size: 8pt, weight: "bold", fill: brand-blue)[Sensibilidad Exógena] \
    Equilibrio en surge pricing. 1 mm de lluvia eleva la demanda pero distorsiona drásticamente la velocidad de la red y tiempos de recogida.
  ],
  card(title: [Plan Maestro JICA (2017)], label: [Contexto Managua], accent: brand-red)[
    #text(size: 8pt, weight: "bold", fill: brand-red)[26% Demanda Local] \
    Diagnóstico oficial: el 26% de viajes en Managua usan transporte selectivo, demostrando la alta sensibilidad de la población al modo.
  ]
)

#v(6pt)
#callout-box(accent: brand-dark)[
  *Relevancia Teórica:* Trasladar la frontera matemática de asignación y despacho al entorno vial, institucional y meteorológico específico de Managua.
]
