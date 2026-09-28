// Plantilla Académica e Investigativa para Typst
// Proyecto Integrador IV - Ingeniería en Ciencia de Datos

#let project(
  title: "",
  subtitle: "",
  authors: (),
  advisor: none,
  date: none,
  course: "Integrador IV",
  career: "Ingeniería en Ciencia de Datos",
  department: "Departamento de Tecnología",
  institution: "Área de Conocimiento de Ciencias Básicas y Tecnología",
  university: "Universidad Nacional Autónoma de Nicaragua, Managua",
  logo: "assets/unan-logo.jpg",
  work_type: "Informe de Proyecto Integrador IV",
  location: "Managua, Nicaragua",
  abstract: none,
  body
) = {
  // Configuración general del documento
  set document(title: title, author: authors.map(a => if type(a) == str { a } else { a.name }))

  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 2.8cm, left: 3.0cm, right: 2.5cm),
    header: context {
      // Ocultar encabezado en la primera página (portada)
      if counter(page).get().first() > 1 [
        #grid(
          columns: (1fr, auto),
          align(left)[#text(size: 8.5pt, fill: luma(100), font: "Liberation Sans", style: "italic")[#title]],
          align(right)[#text(size: 8.5pt, fill: luma(100), font: "Liberation Sans")[#course]]
        )
        #line(length: 100%, stroke: 0.4pt + luma(180))
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 [
        #line(length: 100%, stroke: 0.4pt + luma(180))
        #v(2pt)
        #align(center)[
          #text(size: 9pt, fill: luma(80))[#counter(page).display()]
        ]
      ]
    }
  )

  // Tipografía y espaciado
  set text(
    font: ("Libertinus Serif", "Liberation Serif", "Noto Serif"),
    size: 11pt,
    lang: "es"
  )

  set par(
    justify: true,
    leading: 0.75em,
    spacing: 1.2em,
    first-line-indent: 0pt
  )

  // Configuración de encabezados
  set heading(numbering: "1.1")
  show heading: it => {
    set text(font: ("Liberation Sans", "Noto Sans", "Adwaita Sans"), fill: rgb("#111827"))
    if it.level == 1 {
      v(1.8em, weak: true)
      text(weight: "bold", size: 16pt)[#it]
      v(0.8em, weak: true)
    } else if it.level == 2 {
      v(1.4em, weak: true)
      text(weight: "bold", size: 13pt)[#it]
      v(0.6em, weak: true)
    } else {
      v(1.2em, weak: true)
      text(weight: "semibold", size: 11.5pt)[#it]
      v(0.5em, weak: true)
    }
  }

  // Estilo de enlaces y código
  show link: set text(fill: rgb("#1d4ed8"))
  show raw: set text(font: ("Liberation Mono", "DejaVu Sans Mono"), size: 9pt)

  // ==================== PORTADA ====================
  let meses = ("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
  let fecha_str = if date != none {
    date
  } else {
    meses.at(datetime.today().month() - 1) + ", " + str(datetime.today().year())
  }

  align(center)[
    #if logo != none [
      #image(logo, width: 6.0cm)
      #v(0.8em)
    ] else [
      #text(size: 12pt, weight: "bold", font: "Liberation Sans")[#upper(university)] \
      #v(2pt)
      #text(size: 10pt, weight: "bold", font: "Liberation Sans", fill: rgb("#1e3a8a"))[UNAN - MANAGUA] \
      #v(4pt)
    ]
    #text(size: 11pt, weight: "bold", font: "Liberation Sans", fill: rgb("#0f172a"))[#upper(institution)] \
    #v(3pt)
    #text(size: 10pt, weight: "bold", font: "Liberation Sans", fill: rgb("#334155"))[#upper(department)] \
    #v(3pt)
    #text(size: 10pt, font: "Liberation Sans", fill: luma(60))[Carrera de #career] \
    #v(0.6em)
    #line(length: 50%, stroke: 0.6pt + rgb("#1e3a8a"))

    #v(1.2fr)

    #text(size: 11pt, weight: "bold", font: "Liberation Sans", fill: rgb("#1e293b"))[#upper(work_type)]

    #v(1fr)

    #text(size: 10pt, weight: "bold", font: "Liberation Sans", fill: rgb("#1e3a8a"))[TEMA:] \
    #v(4pt)
    #text(size: 15pt, weight: "bold", font: "Liberation Sans", fill: rgb("#0f172a"))[#title] \
    #if subtitle != "" [
      #v(0.6em)
      #text(size: 11.5pt, style: "italic", fill: rgb("#334155"))[#subtitle]
    ]

    #v(1.2fr)

    #grid(
      columns: if advisor != none { (1fr, 1fr) } else { (1fr) },
      gutter: 20pt,
      align(center)[
        #text(size: 10pt, weight: "bold", font: "Liberation Sans")[Autores:] \
        #v(4pt)
        #for author in authors [
          #let aname = if type(author) == str { author } else { author.name }
          #text(size: 10pt)[#aname] \
        ]
      ],
      if advisor != none [
        #align(center)[
          #text(size: 10pt, weight: "bold", font: "Liberation Sans")[Docente Guía:] \
          #v(4pt)
          #text(size: 10pt)[#advisor]
        ]
      ]
    )

    #v(1fr)

    #text(size: 10pt, font: "Liberation Sans", fill: luma(60))[#location] \
    #v(2pt)
    #text(size: 10pt, font: "Liberation Sans", fill: luma(60))[#fecha_str]
  ]

  pagebreak()


  // ==================== ÍNDICE GENERAL ====================
  outline(
    title: [Tabla de Contenidos],
    indent: auto,
    depth: 3
  )

  pagebreak()

  // Cuerpo del documento
  body
}

// ==================== COMPONENTES REUTILIZABLES ====================

// Cuadro informativo o destacado
#let callout(title: "", body, color: "blue") = {
  let (border_col, bg_col) = if color == "blue" {
    (rgb("#2563eb"), rgb("#eff6ff"))
  } else if color == "green" {
    (rgb("#16a34a"), rgb("#f0fdf4"))
  } else if color == "amber" {
    (rgb("#d97706"), rgb("#fffbeb"))
  } else {
    (rgb("#4b5563"), rgb("#f9fafb"))
  }

  block(
    width: 100%,
    stroke: (left: 3pt + border_col),
    fill: bg_col,
    radius: (right: 4pt),
    inset: (x: 12pt, y: 10pt),
    [
      #if title != "" [
        #text(weight: "bold", size: 10.5pt, fill: border_col, font: "Liberation Sans")[#title] \
        #v(3pt)
      ]
      #set text(size: 10pt)
      #body
    ]
  )
}
