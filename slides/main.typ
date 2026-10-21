#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "template.typ": *
#import "metadata.typ": title-presentation, subtitle-presentation, authors, tutor, career, university, institutional-motto

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => [
    #text(size: 7.5pt, fill: text-muted)[
      MoviGo • Integrador IV • UNAN-Managua
    ]
  ],
  config-info(
    title: title-presentation,
    subtitle: subtitle-presentation,
    author: authors.map(a => a.short-name).join(" • "),
    institution: [
      #career • #university \
      #text(size: 9pt, style: "italic")[Tutor: #tutor.formal-name (#link("mailto:" + tutor.email)[#tutor.email])]
    ],
    date: [Segundo Semestre • 2026],
  ),
  config-colors(
    primary: brand-red,
    secondary: brand-dark,
    neutral-light: rgb("#f8f9fa"),
    neutral-dark: rgb("#111827"),
  )
)

#title-slide()

= 01. Contexto y Planteamiento

#include "slides/01_cover.typ"
#include "slides/02_context.typ"
#include "slides/03_literature.typ"
#include "slides/04_problem.typ"

= 02. Marco Metodológico y Objetivos

#include "slides/05_objectives.typ"
#include "slides/06_variables.typ"
#include "slides/07_theory.typ"

= 03. Ingeniería de Datos y Propuesta

#include "slides/08_methodology.typ"
#include "slides/09_pipeline.typ"
#include "slides/10_conclusion.typ"
#include "slides/11_questions.typ"
