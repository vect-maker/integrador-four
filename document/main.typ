#import "template.typ": project, callout

#show: project.with(
  title: "Eficacia y Calibración del Esquema de Tarificación Dinámica en el Transporte Selectivo MoviGo",
  subtitle: "Sensibilidad de la Demanda, Puntos de Equilibrio Numérico, Mitigación de Cancelaciones y Equidad Socio-Espacial en Managua",
  authors: (
    (name: "Equipo de Investigación — Integrador IV", email: "ciencia.datos@investigacion.edu.ni"),
  ),
  course: "Integrador IV",
  career: "Ingeniería en Ciencia de Datos",
  institution: "Área de Conocimiento de Ciencias Básicas y Tecnología",
  location: "Managua, Nicaragua",
  abstract: [
    La presente investigación evalúa la eficacia del esquema de tarificación dinámica (_surge pricing_) de la plataforma tecnológica de transporte selectivo MoviGo en el municipio de Managua. A partir de una arquitectura analítica ELT construida con dbt sobre PostgreSQL que consume más de 77,000 registros transaccionales y series meteorológicas expuestas exclusivamente mediante una API REST, el estudio modela la respuesta elástica de la demanda, las cancelaciones de viajes por estrato socioeconómico y la incidencia de eventos de lluvia torrencial. Se determinan puntos de equilibrio tarifario ($f(m)=0$) mediante los algoritmos numéricos de Bisección y Newton-Raphson, y se formula un modelo de optimización prescriptiva de la oferta vehicular basado en el Problema de la Mochila Binaria (0/1 Knapsack) con una restricción de C\$ 120,000 NIO en campañas de bonos para conductores, demostrando que la estimulación planificada de la oferta mitiga el abandono del servicio sin transferir sobrecostos punitivos a los usuarios en cuadrantes vulnerables de la capital.
  ]
)

// ==================== CAPÍTULOS DE LA INVESTIGACIÓN ====================

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

#include "chapters/07_matriz_descriptores.typ"
#pagebreak()

#include "chapters/08_metodologia.typ"
#pagebreak()

// ==================== REFERENCIAS BIBLIOGRÁFICAS ====================
#bibliography(
  "references.bib",
  title: [Referencias Bibliográficas],
  style: "ieee"
)
