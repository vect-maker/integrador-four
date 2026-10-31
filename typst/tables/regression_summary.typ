// typst/tables/regression_summary.typ: Simple Regression Models Summary (OE2)
// Hydrated dynamically from data/numerical_methods.json (Single Source of Truth)

#import "../data_bindings.typ": (
  m1-b0, m1-b1, m1-r2, m1-r2-train, m1-mae, m1-rmse, m1-epochs, m1-ci-b0-low, m1-ci-b0-upp,
  m1-ci-b1-low, m1-ci-b1-upp, m2-b0, m2-b1, m2-r2, m2-r2-train, m2-mae, m2-rmse, m2-epochs,
  m2-ci-b0-low, m2-ci-b0-upp, m2-ci-b1-low, m2-ci-b1-upp, fmt-dec,
)

#let table-regression-summary(size: 8pt) = {
  set text(size: size)
  let ci(lo, up) = [[#fmt-dec(lo), #fmt-dec(up)]]
  table(
    columns: (2.2fr, 2fr, 2fr),
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 4.5pt),
    align: (col, row) => if col == 0 and row > 0 { left + horizon } else { center + horizon },
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
    table.header([*Indicador*], [*Modelo 1: Duración (min)*], [*Modelo 2: Tarifa (C\$)*]),
    [Ecuación ajustada],
      [$hat(y) = #fmt-dec(m1-b0) + #fmt-dec(m1-b1) dot d$],
      [$hat(y) = #fmt-dec(m2-b0) + #fmt-dec(m2-b1) dot d$],
    [Intercepto $beta_0$ (IC 95%)], [#fmt-dec(m1-b0) #ci(m1-ci-b0-low, m1-ci-b0-upp)], [#fmt-dec(m2-b0) #ci(m2-ci-b0-low, m2-ci-b0-upp)],
    [Pendiente $beta_1$ por km (IC 95%)], [#fmt-dec(m1-b1) #ci(m1-ci-b1-low, m1-ci-b1-upp)], [#fmt-dec(m2-b1) #ci(m2-ci-b1-low, m2-ci-b1-upp)],
    [$R^2$ entrenamiento], [#fmt-dec(m1-r2-train, digits: 3)], [#fmt-dec(m2-r2-train, digits: 3)],
    [$R^2$ prueba], [#fmt-dec(m1-r2, digits: 3)], [#fmt-dec(m2-r2, digits: 3)],
    [MAE (prueba)], [#fmt-dec(m1-mae) min], [C\$ #fmt-dec(m2-mae)],
    [RMSE (prueba)], [#fmt-dec(m1-rmse) min], [C\$ #fmt-dec(m2-rmse)],
    [Épocas hasta converger (SGD)], [#m1-epochs], [#m2-epochs],
  )
}

#let fig-regression-summary = figure(
  table-regression-summary(),
  caption: [Resumen de los modelos de regresión lineal simple ajustados por descenso de gradiente: coeficientes, intervalos de confianza al 95% y desempeño],
)
