#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 04. Problema: Desbalance Espacial

#speaker-note[
⏱ *03:45 - 05:00* | Duración: 1:15 min | *Fase: Problema*

El diagnóstico empírico de Movi Go revela lo que denominamos la *Triada de Ineficiencias*:

Primero: *Desbalance Espaciotemporal*. El 62% de la flota disponible tiende a concentrarse en apenas 4 nodos comerciales (Metrocentro, Plaza España, Carretera a Masaya), dejando desatendidas zonas residenciales periféricas.

Segundo: *Kilómetros Improductivos (Deadhead)*. Hasta un 34% del kilometraje total de las unidades se realiza en vacío buscando pasajeros, aumentando los costos de combustible y la fatiga del conductor.

Tercero: *Vulnerabilidad ante Eventos Pluviales*. Las lluvias torrenciales en Managua saturan los cauces y rotondas viales, reduciendo la velocidad de circulación hasta un 45% y descalibrando el multiplicador de tarifa dinámica.

💡 *Tip de Defensa:* El deadhead no solo es un problema de rentabilidad privada; genera emisiones innecesarias y agrava la congestión urbana.

👉 _Transición:_ "Para dar una respuesta rigurosa y cuantificable a este problema, estructuramos nuestros objetivos."
]

#let zonas = json("/document/data/zonas.json")

#grid(
  columns: (1.2fr, 1fr),
  gutter: 12pt,
  [
    #card(title: [Manifestaciones del Problema], label: [Diagnóstico Operativo], accent: brand-red)[
      *Ineficiencias del Despacho Reactivo:*
      - *Recorridos en vacío (_deadhead_):* Hasta un 34% del kilometraje total se realiza en vacío sin pasajero.
      - *Fricción de espera:* Concentración del 62% de la flota en 4 nodos comerciales, desatendiendo la periferia.
      - *Distorsión tarifaria:* Multiplicadores que no compensan el retorno desde zonas periféricas de baja demanda.
      - *Vulnerabilidad climática:* Caída de velocidad de hasta un 45% ante precipitaciones severas en rotondas y cauces.
    ]
  ],
  [
    #card(title: [De la Suposición a la Evidencia], label: [Enfoque Analítico], accent: brand-dark)[
      *Estructura de Datos Multicriterio:*
      - Consolidación de un *Data Warehouse atómico* en PostgreSQL vía *dbt*.
      - Parametrización territorial de *#zonas.len() zonas urbanas*:
      
      #v(3pt)
      #table(
        columns: (1.2fr, 1.5fr, 1.2fr),
        stroke: 0.5pt + border-light,
        inset: 4pt,
        align: (left, left, right),
        table.header([*Zona*], [*Estrato*], [*Base*]),
        ..zonas.slice(0, 3).map(z => (
          text(size: 7.5pt)[#z.nombre_zona],
          text(size: 7.5pt)[#z.estrato_socioeconomico],
          text(size: 7.5pt)[#str(z.tarifa_base_bajada_bandera) C\$]
        )).flatten()
      )
      #text(size: 7.5pt, fill: text-muted)[(Datos extraídos de `document/data/zonas.json`)]
    ]
  ]
)
