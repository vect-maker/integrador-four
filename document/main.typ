#import "template.typ": project, callout
#import "metadata.typ": title, authors, tutor, course, career, institution, location

#show: project.with(
  title: title,
  authors: authors,
  advisor: tutor,
  course: course,
  career: career,
  institution: institution,
  location: location,
)

#include "chapters/01_contexto.typ"
#pagebreak()

#include "chapters/02_antecedentes.typ"
#pagebreak()

#include "chapters/03_problema.typ"
#pagebreak()

#include "chapters/04_justificacion.typ"
#pagebreak()

#include "chapters/05_objetivos.typ"
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
