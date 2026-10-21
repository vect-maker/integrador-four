#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 10. Síntesis & Plan de Implementación

#speaker-note[
⏱ *10:00 - 11:00* | Duración: 1:00 min | *Fase: Síntesis y Ruta de Implementación*

En esta propuesta de investigación hemos definido las bases técnicas, metodológicas y analíticas que se van a implementar:

1. Se ha diseñado la *arquitectura ELT* con ingesta desde la API REST de Movi Go y transformación dimensional mediante dbt a implementarse en PostgreSQL.
2. Se definieron las directrices para el *análisis espaciotemporal y contextual* de la demanda frente al clima.
3. Se formuló el *modelo de optimización multiobjetivo* para apoyar la gestión operativa y tarifaria.

Los *siguientes pasos de implementación* contemplan:
- Desplegar el pipeline de datos y materializar los modelos analíticos en dbt.
- Calibrar y simular los escenarios de asignación de flota en el contexto de Managua.
- Desarrollar el informe final y la herramienta interactiva de soporte a decisiones.

👉 _Transición:_ "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."
]

#v(-6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  card(title: [Marco Diseñado y Especificación], label: [Estado de Avance Actual], accent: brand-dark)[
    - *Formulación Integral del Problema:* Estructuración formal de la triple dimensión (dinámica operativa, espacial y climática).
    - *Arquitectura ELT Proyectada:* Esquema dimensional Kimball en PostgreSQL con transformaciones y pruebas gobernadas por dbt.
    - *Matriz de Descriptores Definida:* Selección de variables, indicadores operacionales y protocolos analíticos.
    - *Marco de Optimización Multiobjetivo:* Formulación matemática de objetivos de reducción de deadhead y balance tarifario.
  ],
  card(title: [Próximos Hitos de Implementación], label: [Ruta de Ejecución], accent: brand-red)[
    - *Despliegue del Pipeline de Ingesta:* Consolidación del histórico total desde la API REST `/movigo` hacia PostgreSQL.
    - *Materialización con dbt Core:* Ejecución de modelos `stg`, `int` y `marts` con validación de calidad continua.
    - *Calibración y Simulación:* Experimentación con escenarios contrastados de demanda y eventos pluviales en Managua.
    - *Tablero de Soporte a Decisiones:* Herramienta analítica prescriptiva e informe final de investigación.
  ]
)

#v(4pt)
#callout-box(accent: brand-blue)[
  *Fase Actual:* Especificación y Diseño de Arquitectura $arrow.r$ *Siguiente Fase:* Implementación, Experimentación y Calibración.
]
