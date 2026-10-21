#import "@preview/touying:0.6.1": *
#import "../template.typ": *

== 09. Arquitectura ELT & dbt Core

#speaker-note[
⏱ *08:45 - 10:00* | Duración: 1:15 min | *Fase: Pipeline ELT*

En esta lámina observamos la *Arquitectura de Datos Moderna* que planteamos e implementaremos como base firme del proyecto:

Sustituimos el ETL monolítico tradicional por un *paradigma ELT* (Extract-Load-Transform):
1. *Extracción:* Script en Python con cliente HTTP asíncrono, paginando registros hasta consolidar el histórico completo.
2. *Raw Stage:* Ingesta sin pérdida de fidelidad en tablas staging de PostgreSQL.
3. *Transformación Modular con dbt Core:* Estructurada en capas `stg` (limpieza y casteo), `int` (enriquecimiento geográfico) y `fct`/`dim` (marts analíticos).
4. *Garantía de Calidad:* Suites de pruebas automatizadas (`dbt test`) verificando unicidad, no nulidad y consistencia referencial.

💡 *Tip de Defensa:* Si preguntan por qué dbt: asegura reproducibilidad analítica, linaje visual de dependencias y pruebas de calidad automáticas antes de alimentar cualquier modelo.

👉 _Transición:_ "Pasemos ahora a la síntesis de la propuesta y la ruta de implementación."
]

#v(-6pt)

// ELT flow pipeline diagram in Typst
#grid(
  columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, auto, 1fr),
  align: horizon,
  gutter: 3pt,
  pipeline-step([ORIGEN], [API REST /movigo], [Extracción JSON], accent: brand-red),
  [#text(size: 11pt, fill: text-muted)[→]],
  pipeline-step([RAW STAGE], [PostgreSQL], [Tablas Crudas], accent: brand-dark),
  [#text(size: 11pt, fill: text-muted)[→]],
  pipeline-step([STAGING], [dbt `stg_*`], [Casteo & Limpieza], accent: brand-blue),
  [#text(size: 11pt, fill: text-muted)[→]],
  pipeline-step([MARTS], [dbt `fct_*` / `dim_*`], [Modelos Kimball], accent: brand-red),
  [#text(size: 11pt, fill: text-muted)[→]],
  pipeline-step([AUDITORÍA], [dbt test], [Unicidad & Integridad], accent: brand-blue),
)

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  card(title: [Ventajas del Paradigma ELT frente a ETL], label: [Arquitectura Moderna], accent: brand-red)[
    Preserva la integridad de los datos originales en la base de datos de destino. Permite auditar el linaje completo y re-ejecutar transformaciones dimensionales con nuevas hipótesis analíticas sin requerir re-extracción de la API transaccional.
  ],
  card(title: [Gobierno y Linaje con dbt Core], label: [Control de Calidad], accent: brand-blue)[
    Cada indicador de desempeño operativo (deadhead, esperas, ingresos, multiplicador) queda formalizado en código SQL modular y versionado en Git con suites automatizadas de pruebas de integridad referencial y no negatividad.
  ]
)

#v(4pt)
#callout-box(accent: brand-dark)[
  *Data Engineering Stack:* Python Async Client • PostgreSQL Cloud • dbt Core • Versionado Git reproducible.
]
