// Helper styling and UI components for MoviGo Typst Presentation

#let brand-red = rgb("#d9383a")
#let brand-blue = rgb("#2563eb")
#let brand-dark = rgb("#1f2937")
#let brand-gray = rgb("#f8f9fa")
#let border-light = rgb("#e5e7eb")
#let text-muted = rgb("#6b7280")

// Card container
#let card(title: none, label: none, accent: brand-red, body) = {
  block(
    fill: brand-gray,
    stroke: (left: 3.5pt + accent, rest: 0.5pt + border-light),
    inset: (x: 8pt, y: 6pt),
    radius: (right: 3pt),
    width: 100%,
    [
      #if label != none [
        #text(size: 8pt, weight: "bold", fill: accent, tracking: 0.04em)[#upper(label)]
        #v(1pt)
      ]
      #if title != none [
        #text(size: 10pt, weight: "bold", fill: brand-dark)[#title]
        #v(2pt)
      ]
      #text(size: 8.8pt, fill: brand-dark)[#body]
    ]
  )
}

// Callout / Highlight box
#let callout-box(title: none, accent: brand-blue, body) = {
  block(
    fill: rgb("#f0f7ff"),
    stroke: 0.75pt + accent,
    inset: (x: 8pt, y: 5pt),
    radius: 3pt,
    width: 100%,
    [
      #if title != none [
        #text(size: 9.5pt, weight: "bold", fill: accent)[#title]
        #v(2pt)
      ]
      #text(size: 8.5pt)[#body]
    ]
  )
}

// Metric badge
#let metric-badge(value, label, accent: brand-red) = {
  block(
    fill: brand-gray,
    stroke: 1pt + border-light,
    inset: 8pt,
    radius: 4pt,
    align(center)[
      #text(size: 16pt, weight: "extrabold", fill: accent)[#value] \
      #v(2pt)
      #text(size: 8pt, weight: "bold", fill: text-muted)[#upper(label)]
    ]
  )
}

// Pipeline step block
#let pipeline-step(step-num, title, subtitle, accent: brand-red) = {
  block(
    fill: brand-gray,
    stroke: (top: 3pt + accent, rest: 1pt + border-light),
    inset: 8pt,
    radius: 3pt,
    align(center)[
      #text(size: 8pt, weight: "bold", fill: accent)[#step-num] \
      #text(size: 9.5pt, weight: "bold", fill: brand-dark)[#title] \
      #text(size: 8pt, fill: text-muted)[#subtitle]
    ]
  )
}
