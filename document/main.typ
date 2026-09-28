#import "template.typ": project, callout

#show: project.with(
  title: "Evaluación del Esquema de Tarificación Dinámica del Servicio de Transporte Selectivo MoviGo en el Municipio de Managua (2024)",
  authors: (
    (name: "Aguilar Rodríguez, Kendall Ezequiel"),
    (name: "Miranda Pérez, José Daniel"),
    (name: "Oyarzo Morales, Ricardo Alberto"),
    (name: "Medrano Dávila, Luis David"),
  ),
  course: "Integrador IV",
  career: "Ingeniería en Ciencia de Datos",
  institution: "Área de Conocimiento de Ciencias Básicas y Tecnología",
  location: "Managua, Nicaragua"
)

#include "chapters/01_contexto.typ"
#pagebreak()

#include "chapters/02_problema.typ"
#pagebreak()

#include "chapters/03_justificacion.typ"
#pagebreak()

#include "chapters/04_objetivos.typ"
#pagebreak()

#include "chapters/05_antecedentes.typ"
#pagebreak()

#include "chapters/06_marco_teorico.typ"
#pagebreak()

#include "chapters/07_metodologia.typ"
#pagebreak()


#bibliography(
  "references.bib",
  title: [Referencias Bibliográficas],
  style: "ieee"
)
