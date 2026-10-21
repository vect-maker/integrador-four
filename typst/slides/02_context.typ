#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 02. Contextualización: Sistema Dinámico

#speaker-note[
⏱ *01:15 - 02:30* | Duración: 1:15 min | *Fase: Contextualización*

Aquí planteamos la premisa fundamental del proyecto: la movilidad bajo demanda es un *sistema dinámico interdependiente*.

En primer lugar, la *dimensión operativa* no depende sólo de cuántos conductores hay conectados, sino de _dónde están_. Si los vehículos circulan desocupados lejos de los focos de demanda, el tiempo de espera del usuario se dispara.

En segundo lugar, la *dimensión territorial* de Managua presenta una fuerte polarización: orígenes residenciales matutinos hacia corredores comerciales y de oficinas, generando viajes de ida con retorno vacío.

Y en tercer lugar, la *dimensión tarifaria*: un esquema de precios estático no premia al conductor que viaja a zonas periféricas desabastecidas.

💡 *Tip de Defensa:* Si el jurado pregunta por qué no basta con aumentar la flota, enfatizar que saturar de autos sin rebalanceo incrementa la congestión y reduce los ingresos netos del conductor.

👉 _Transición:_ "Veamos qué respaldo encontramos en la literatura científica para modelar este acoplamiento."
]

#let zonas = json("/data/zonas.json")

#text(size: 9.5pt, fill: text-muted)[
  La movilidad bajo demanda no responde a causas aisladas: la ubicación oportuna de unidades, la razonabilidad tarifaria y el entorno urbano configuran un sistema complejo en Managua.
]

#v(2pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  card(title: [Dinámica de Flota], label: [01. Dimensión Operativa], accent: brand-red)[
    Disponibilidad real de unidades, duración del viaje, tiempos de aproximación y permanencia sin pasajero.
    #v(2pt)
    - Tiempos de espera al usuario
    - Kilómetros en vacío (_deadhead_)
    - Utilización porcentual de unidades
  ],
  card(title: [Heterogeneidad Espacial], label: [02. Dimensión Territorial], accent: brand-dark)[
    Managua presenta una estructura urbana discontinua y policéntrica con asimetrías severas en flujos OD.
    #v(2pt)
    - Patrones asimétricos Origen-Destino
    - #zonas.len() zonas urbanas parametrizadas
    - Retornos sin pasaje desde periferias
  ],
  card(title: [Coherencia de Precios], label: [03. Dimensión Tarifaria], accent: brand-blue)[
    La tarifa debe articular los costos reales del viaje, las condiciones de circulación y la sostenibilidad.
    #v(2pt)
    - Correspondencia con costos reales
    - Incentivos de redistribución de oferta
    - Evaluación de multiplicador dinámico
  ]
)

#v(2pt)
#callout-box(accent: brand-blue)[
  *Datos Integrados:* > 65,000 viajes modelados • Flota distribuida en categorías Estándar, Comfort y Moto • Monitoreo meteorológico vía `/movigo/clima`.
]
