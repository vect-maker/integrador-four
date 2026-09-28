// Plantilla Académica e Investigativa para Typst
// Proyecto Integrador IV - Ingeniería en Ciencia de Datos

#let project(
  title: "",
  subtitle: "",
  authors: (),
  date: datetime.today().display("[day]/[month]/[year]"),
  course: "Integrador IV",
  career: "Ingeniería en Ciencia de Datos",
  institution: "Área de Conocimiento de Ciencias Básicas y Tecnología",
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
  align(center)[
    #text(size: 11pt, weight: "bold", font: "Liberation Sans")[#upper(institution)] \
    #v(3pt)
    #text(size: 10.5pt, font: "Liberation Sans", fill: luma(60))[Carrera de #career] \
    #text(size: 10pt, font: "Liberation Sans", fill: luma(80))[Asignatura: #course]

    #v(4.5cm)

    #text(size: 20pt, weight: "bold", font: "Liberation Sans", fill: rgb("#0f172a"))[#title] \
    #if subtitle != "" [
      #v(0.8em)
      #text(size: 13pt, style: "italic", fill: rgb("#334155"))[#subtitle]
    ]

    #v(4.5cm)

    #grid(
      columns: (1fr),
      align(center)[
        #text(size: 11pt, weight: "semibold")[Autores / Investigadores:] \
        #v(4pt)
        #for author in authors [
          #if type(author) == str [
            #text(size: 11pt)[#author] \
          ] else [
            #text(size: 11pt)[#author.name] \
            #if "email" in author [
              #text(size: 9pt, fill: luma(90))[#author.email] \
            ]
          ]
        ]
      ]
    )

    #v(2.5cm)

    #text(size: 10pt, fill: luma(80))[#location] \
    #text(size: 10pt, fill: luma(80))[#date]
  ]

  pagebreak()

  // ==================== RESUMEN / ABSTRACT ====================
  if abstract != none [
    #v(1cm)
    #align(center)[
      #text(size: 14pt, weight: "bold", font: "Liberation Sans")[Resumen Ejecutivo]
    ]
    #v(0.8cm)
    #block(
      width: 100%,
      stroke: (left: 2.5pt + rgb("#3b82f6")),
      inset: (left: 14pt, y: 8pt),
      fill: rgb("#f8fafc"),
      [
        #set text(size: 10.5pt, style: "italic")
        #abstract
      ]
    )
    #v(1.5cm)
  ]

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
