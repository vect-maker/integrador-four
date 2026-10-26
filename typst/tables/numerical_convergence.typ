#import "../data_bindings.typ": (
  num-m-star, num-q-star, num-tol,
  num-bisect-iters, num-newton-iters, num-speedup,
)

#let table-numerical-convergence = {
  table(
    columns: (2.2fr, 1.4fr, 1.2fr, 1.2fr, 1.6fr),
    align: (left, center, center, center, center),
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
    stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
    [*Método Numérico*], [*Tipo / Orden*], [*Iteraciones*], [*Tolerancia ($epsilon$)*], [*Raíz Convergida ($m^*$)*],
    [Método de la Bisección], [Cerrado / Lineal ($r=1$)], [#num-bisect-iters], [$10^(-6)$], [#num-m-star],
    [Método de Newton-Raphson], [Abierto / Cuadrático ($r=2$)], [#num-newton-iters], [$10^(-6)$], [#num-m-star],
    [*Comparativa de Eficiencia*], [*Aceleración Relativa*], [*#num-speedup#text(size: 8pt)[$times$ más rápido]*], [---], [*$Q^* = #num-q-star$ v/h*],
  )
}

#let fig-numerical-convergence = figure(
  table-numerical-convergence,
  caption: [Comparativa de Desempeño y Convergencia: Bisección vs. Newton-Raphson en el Equilibrio de Mercado],
)
