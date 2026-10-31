#import "document/template.typ": project, badge
#import "metadata.typ": (
  title,
  authors,
  tutor,
  course,
  career,
  department,
  area,
  institution,
  university,
  campus,
  location,
  date,
  institutional-motto,
)
#import "document/content/abstract.typ": (
  resumen-es,
  palabras-clave-es,
)

#show: project.with(
  title: title,
  authors: authors,
  tutor: tutor,
  date: date,
  course: course,
  career: career,
  department: department,
  area: area,
  institution: institution,
  university: university,
  campus: campus,
  location: location,
  institutional-motto: institutional-motto,
)

// ==========================================
// RESUMEN
// ==========================================
= Resumen

#resumen-es

*Palabras clave:* #palabras-clave-es.join(", ").

#pagebreak()

// ==========================================
// CAPÍTULOS DE LA INVESTIGACIÓN
// ==========================================

#include "document/chapters/01_contexto.typ"
#pagebreak()

#include "document/chapters/02_antecedentes.typ"
#pagebreak()

#include "document/chapters/03_problema.typ"
#pagebreak()

#include "document/chapters/04_justificacion.typ"
#pagebreak()

#include "document/chapters/05_objetivos.typ"
#pagebreak()

#include "document/chapters/06_marco_teorico.typ"
#pagebreak()

#include "document/chapters/07_metodologia.typ"
#pagebreak()

#include "document/chapters/08_resultados.typ"
#pagebreak()

#include "document/chapters/09_conclusiones.typ"
#pagebreak()

// ==========================================
// REFERENCIAS (NORMA APA 7MA EDICIÓN)
// ==========================================
= Referencias

#bibliography(
  "references.bib",
  style: "apa",
  title: none,
  full: true
)

#pagebreak()

// ==========================================
// APÉNDICE A: ATLAS CARTOGRÁFICO Y EXPLORATORIO
// ==========================================
#include "document/chapters/apendice_a_atlas.typ"

#pagebreak()

// ==========================================
// APÉNDICE B: CATÁLOGO TERRITORIAL DE ZONAS URBANAS
// ==========================================
#include "document/chapters/apendice_b_catalog.typ"

#pagebreak()

// ==========================================
// APÉNDICE C: ESPECIFICACIÓN TÉCNICA DE INGENIERÍA
// ==========================================
#include "document/chapters/apendice_c_engineering.typ"
