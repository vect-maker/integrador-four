// Plantilla Académica e Investigativa bajo Formato APA 7ma Edición
// Universidad Nacional Autónoma de Nicaragua, Managua (UNAN-Managua)
// Proyecto Integrador IV - Carrera de Ingeniería en Ciencias de Datos

#let project(
  title: "",
  authors: (),
  advisor: none,
  tutor: none,
  date: none,
  course: "Integrador IV",
  career: "Carrera de Ingeniería en Ciencias de Datos",
  department: "Tecnología",
  area: "Área de Conocimiento de Ciencias Básicas y Tecnología",
  institution: "Área de Conocimiento de Ciencias Básicas y Tecnología",
  university: "Universidad Nacional Autónoma de Nicaragua, Managua",
  campus: "Recinto Universitario «Rubén Darío»",
  logo: "../assets/unan-logo.jpg",
  work_type: "Trabajo de investigación derivado de producto integrador de componentes curriculares",
  location: "Managua, octubre de 2026",
  institutional-motto: "«2026: Por una Educación al Servicio del Pueblo, ¡Viva Sandino!»",
  body
) = {
  let doc_tutor = if tutor != none { tutor } else { advisor }

  // 1. Metadatos del Documento
  set document(
    title: title,
    author: authors.map(a => if type(a) == str { a } else if "formal-name" in a { a.formal-name } else { a.name }),
    date: date,
  )

  // 2. Configuración de Página (Norma APA 7: Carta US-Letter, Márgenes de 2.54 cm en los cuatro lados)
  set page(
    paper: "us-letter",
    margin: (top: 2.54cm, bottom: 2.54cm, left: 2.54cm, right: 2.54cm),
    footer: context {
      let i = counter(page).get().first()
      if i > 1 {
        align(right, text(size: 11pt)[#(i - 1)])
      }
    }
  )

  // 3. Tipografía y Estilo de Texto (APA 7: Fuente Serif 12pt, texto justificado, espaciado uniforme)
  set text(
    font: "Liberation Serif",
    size: 12pt,
    lang: "es"
  )

  // Configuración global de bibliografía y citaciones (Norma APA 7ma Edición)
  set bibliography(style: "apa")

  // 4. Enlaces con estilo consistente
  show link: it => text(fill: rgb("#1b58a6"), underline(it))

  // 5. Párrafos
  set par(
    justify: true,
    leading: 0.65em,
    spacing: 1.05em
  )

  // 6. Figuras y Tablas
  set figure(gap: 0.8em)
  set figure.caption(separator: [. ])

  // 7. Listas
  set list(spacing: 0.75em)
  set enum(spacing: 0.75em)

  // 8. Títulos y Encabezados según Norma APA 7ma Edición
  // Nivel 1: Centrado, Negrita (16pt)
  show heading.where(level: 1): it => block(
    width: 100%,
    above: 1.5em,
    below: 0.9em,
    align(center, text(weight: "bold", size: 16pt)[#it.body])
  )

  // Nivel 2: Alineado a la izquierda, Negrita (13pt)
  show heading.where(level: 2): it => block(
    above: 1.2em,
    below: 0.6em,
    text(weight: "bold", size: 13pt)[#it.body]
  )

  // Nivel 3: Alineado a la izquierda, Negrita (12pt)
  show heading.where(level: 3): it => block(
    above: 1.0em,
    below: 0.4em,
    text(weight: "bold", size: 12pt)[#it.body]
  )

  // ==========================================
  // PORTADA / COVER PAGE (ESTILO INSTITUCIONAL UNAN-MANAGUA)
  // ==========================================
  align(center)[
    #text(size: 11pt, style: "italic")[
      #institutional-motto
    ]

    #v(0.3cm)
    #if logo != none [
      #image(logo, width: 5.2cm)
    ]

    #v(0.3cm)
    #text(weight: "bold", size: 12pt)[
      #university \
      #campus \
      #area \
      Departamento de #department \
      #career \
    ]

    #v(0.2cm)
    #text(size: 11pt, weight: "medium")[
      #work_type
    ]

    #v(0.5cm)
    #text(weight: "bold", size: 11pt)[Título:] \
    #v(0.15cm)
    #text(weight: "bold", size: 13pt)[
      #title
    ]

    #v(0.5cm)
    #text(weight: "bold", size: 11pt)[Autor(es):] \
    #v(0.2cm)
    #block(width: 85%, align(left)[
      #grid(
        columns: (1fr),
        row-gutter: 0.5em,
        ..authors.map(a => [
          #let aname = if type(a) == str { a } else { a.name }
          #let aorcid = if type(a) == dictionary and "orcid" in a { a.orcid } else { none }
          #aname #if aorcid != none and aorcid != "" [ -- (ORCID: #link("https://orcid.org/" + aorcid)[#aorcid])]
        ])
      )
    ])

    #v(0.5cm)
    #text(weight: "bold", size: 11pt)[Tutor:] \
    #v(0.15cm)
    #let adv_name = if type(doc_tutor) == str { doc_tutor } else if type(doc_tutor) == dictionary and "name" in doc_tutor { doc_tutor.name } else { "" }
    #let adv_orcid = if type(doc_tutor) == dictionary and "orcid" in doc_tutor { doc_tutor.orcid } else { none }
    #text(size: 12pt)[#adv_name]#if adv_orcid != none and adv_orcid != "" [ -- #if adv_orcid.starts-with("00") [(ORCID: #link("https://orcid.org/" + adv_orcid)[#adv_orcid])] else [(ORCID: #adv_orcid)]]

    #v(0.6cm)
    #text(size: 11pt)[
      #location
    ]
  ]

  pagebreak()

  // ==========================================
  // ÍNDICE GENERAL
  // ==========================================
  {
    show outline.entry: it => {
      set text(size: 9.5pt)
      it
    }
    set par(leading: 0.45em)
    outline(
      title: [Índice],
      depth: 2,
      indent: 1.2em,
    )
  }

  pagebreak()

  // Cuerpo del documento
  body
}

// ==========================================
// COMPONENTES COMPLEMENTARIOS REUTILIZABLES
// ==========================================

// Etiqueta o badge visual
#let badge(txt, bg, fg) = box(
  fill: bg,
  radius: 2pt,
  inset: (x: 3.5pt, y: 1.2pt),
  baseline: 0%,
  text(size: 6.5pt, weight: "bold", fill: fg)[#txt]
)

// Conector de flujo
#let connector(label) = [
  #align(center)[
    #box(
      fill: rgb("#f8fafc"),
      stroke: 0.35pt + rgb("#cbd5e1"),
      radius: 6pt,
      inset: (x: 6pt, y: 1pt),
    )[
      #text(size: 6.5pt, weight: "medium", fill: rgb("#475569"))[#sym.arrow.b #label]
    ]
  ]
]
