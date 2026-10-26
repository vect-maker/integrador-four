#import "../data_bindings.typ": (
  ols-n, ols-r, ols-r2, ols-r2-adj, ols-f-stat,
  ols-b0, ols-b0-se, ols-b0-t,
  ols-b1, ols-b1-se, ols-b1-t,
  anova-reg-ss, anova-reg-df, anova-reg-ms,
  anova-res-ss, anova-res-df, anova-res-ms,
  anova-tot-ss, anova-tot-df,
)

#let table-econometric-results = {
  block(
    width: 100%,
    stroke: 0.5pt + rgb("#e2e8f0"),
    radius: 4pt,
    inset: 2pt,
    [
      #text(weight: "bold", size: 9pt)[Panel A: Estimación MCO del Modelo Lineal Simple ($N = #ols-n$ días)]
      #v(2pt)
      #table(
        columns: (2.2fr, 1.2fr, 1.2fr, 1.2fr, 1.2fr),
        align: (left, right, right, right, right),
        fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
        stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
        [*Variable Independiente*], [*Coeficiente ($beta$)*], [*Error Est.*], [*Estadístico $t$*], [*Valor $p$*],
        [Constante (Intercepto)], [#ols-b0], [#ols-b0-se], [#ols-b0-t], [$< 0.0001$],
        [Multiplicador ($overline(m)$)], [#ols-b1], [#ols-b1-se], [#ols-b1-t], [$< 0.0001$],
      )

      #v(4pt)
      #text(weight: "bold", size: 9pt)[Panel B: Tabla de Análisis de Varianza (ANOVA)]
      #v(2pt)
      #table(
        columns: (2fr, 1.2fr, 0.8fr, 1.2fr, 1fr, 1.2fr),
        align: (left, right, center, right, right, right),
        fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
        stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
        [*Fuente de Variación*], [*Suma Cuadrados ($S S$)*], [*$G L$*], [*Cuadrado Medio ($M S$)*], [*Estadístico $F$*], [*Valor $p$*],
        [Regresión (MCO)], [#anova-reg-ss], [#anova-reg-df], [#anova-reg-ms], [#ols-f-stat], [$< 0.0001$],
        [Residuales (Error)], [#anova-res-ss], [#anova-res-df], [#anova-res-ms], [---], [---],
        [*Total*], [*#anova-tot-ss*], [*#anova-tot-df*], [---], [---], [---],
      )

      #v(3pt)
      #align(left)[
        #text(size: 7.5pt, fill: rgb("#475569"))[
          _Métricas Globales:_ Correlación de Pearson $r = #ols-r$ | $R^2 = #ols-r2$ | $R^2_("adj") = #ols-r2-adj$ | Prueba $F(1, 364) = #ols-f-stat$ ($p < 0.0001$).
        ]
      ]
    ]
  )
}

#let fig-econometric-results = figure(
  table-econometric-results,
  caption: [Resultados de la Regresión Lineal Simple y Descomposición ANOVA de la Tasa de Cancelación],
)
