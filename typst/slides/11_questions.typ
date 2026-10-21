#import "@preview/touying:0.6.1": *
#import "template.typ": *

== 11. Cierre & Sesión de Preguntas

#speaker-note[
⏱ *11:00+* | Duración: Sesión Q&A | *Fase: Defensa ante el Jurado*

Muchas gracias a los profesores y miembros del jurado evaluador. Abrimos con gusto la sesión de preguntas y retroalimentación.

🎯 *Respuestas de Defensa Preparadas para Preguntas Comunes:*
• _¿Por qué la ingesta con API REST y dbt es la base fija?_
"Porque los datos provienen del servicio real/emulado en la API /movigo, y dbt garantiza reproducibilidad total, linaje formal y pruebas de integridad referencial antes de alimentar cualquier modelo analítico o prescriptivo."

• _¿Por qué los modelos matemáticos y estadísticos se presentan como exploratorios?_
"Porque las técnicas numéricas, de inferencia y optimización deben contrastarse y calibrarse según la distribución empírica de los datos observados en Managua, sin asumir métodos rígidos a priori."

• _¿Cómo se garantiza la reproducibilidad de los datos?_
"Todo el pipeline está versionado en Git, con seeds y modelos de dbt, scripts de ingesta estructurados y documentación técnica completa."
]

#v(-8pt)

#align(center)[
  #text(size: 8pt, weight: "bold", fill: brand-red)[INTEGRADOR IV • INGENIERÍA EN CIENCIA DE DATOS] \
  #v(1pt)
  #text(size: 14pt, weight: "bold", fill: brand-dark)[Optimización territorial de la flota y del sistema tarifario — Movi Go] \
  #v(2pt)
  #text(size: 9pt, fill: text-muted)[Muchas gracias por su atención. Quedamos a disposición del jurado evaluador para comentarios y preguntas.]
]

#v(2pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 7pt,
  card(title: [Base Fija: API + dbt], label: [Pregunta Frecuente 1], accent: brand-red)[
    Garantiza reproducibilidad inmutable, linaje formal y tests de integridad sobre >65,000 registros antes de ejecutar inferencia o simulación.
  ],
  card(title: [Modelos Contrastados], label: [Pregunta Frecuente 2], accent: brand-dark)[
    Las técnicas de optimización y estimación se calibran empíricamente según la distribución observada en Managua, evitando supuestos rígidos a priori.
  ],
  card(title: [Reproducibilidad Total], label: [Pregunta Frecuente 3], accent: brand-blue)[
    Pipeline versionado en Git: seeds, modelos dbt, scripts de ingesta y documentación de tesis en Typst con fuentes abiertas.
  ]
)

#v(2pt)
#callout-box(accent: brand-dark)[
  *Contacto:* Área de Conocimiento de Ciencias Básicas y Tecnología • UNAN-Managua • 2026.
]
