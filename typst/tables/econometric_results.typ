#import "../data_bindings.typ": (
  logit-n, logit-n-fmt, logit-pseudo-r2, logit-lr-stat, logit-lr-p,
  logit-dev-null, logit-dev-model, logit-aic, logit-bic, logit-solver-iters,
  logit-b0, logit-b0-se, logit-b0-z, logit-b0-or,
  logit-b-surge, logit-b-surge-se, logit-b-surge-z, logit-b-surge-or, logit-b-surge-or-ci,
  logit-b-dist, logit-b-dist-se, logit-b-dist-z, logit-b-dist-or,
  logit-b-cong, logit-b-cong-se, logit-b-cong-z, logit-b-cong-or,
  logit-b-pico, logit-b-pico-se, logit-b-pico-z, logit-b-pico-or,
)

#let table-econometric-results = {
  block(
    width: 100%,
    stroke: 0.5pt + rgb("#e2e8f0"),
    radius: 4pt,
    inset: 2pt,
    [
      #text(weight: "bold", size: 8.5pt)[Panel A: Estimación del Modelo Logit Binario (MLE / Newton-Raphson, $N = #logit-n-fmt$ viajes)]
      #v(2pt)
      #table(
        columns: (2.2fr, 1.1fr, 1fr, 1fr, 1fr, 1.1fr, 1.4fr),
        align: (left, right, right, right, right, right, center),
        fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
        stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
        [*Variable Independiente*], [*Coef. ($beta$)*], [*Error Est.*], [*$z$ (Wald)*], [*Valor $p$*], [*Odds Ratio*], [*IC 95% OR*],
        [Intercepto ($beta_0$)], [#logit-b0], [#logit-b0-se], [#logit-b0-z], [$< 0.0001$], [#logit-b0-or], [---],
        [Multiplicador ($m$)], [#logit-b-surge], [#logit-b-surge-se], [#logit-b-surge-z], [$< 0.0001$], [*#logit-b-surge-or*], [#logit-b-surge-or-ci.at(0) -- #logit-b-surge-or-ci.at(1)],
        [Distancia ($"km"$)], [#logit-b-dist], [#logit-b-dist-se], [#logit-b-dist-z], [$< 0.0001$], [#logit-b-dist-or], [---],
        [Índice Congestión], [#logit-b-cong], [#logit-b-cong-se], [#logit-b-cong-z], [$< 0.0001$], [*#logit-b-cong-or*], [---],
        [Hora Pico (dummy)], [#logit-b-pico], [#logit-b-pico-se], [#logit-b-pico-z], [$< 0.0001$], [#logit-b-pico-or], [---],
      )

      #v(4pt)
      #text(weight: "bold", size: 8.5pt)[Panel B: Tabla de Análisis de Deviance (Prueba de Razón de Verosimilitud)]
      #v(2pt)
      #table(
        columns: (2.2fr, 1.2fr, 1.4fr, 1.4fr, 1.2fr),
        align: (left, center, right, right, right),
        fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
        stroke: (col, row) => if row == 0 { (bottom: 1pt + rgb("#94a3b8")) } else { 0.4pt + rgb("#e2e8f0") },
        [*Especificación*], [*$G L$ Residuales*], [*Deviance ($-2 ln L$)*], [*Estadístico $chi^2$ (LR)*], [*Valor $p$*],
        [Modelo Nulo ($beta_0$ solo)], [77,486], [#logit-dev-null], [---], [---],
        [Modelo Propuesto (Logit)], [77,482], [#logit-dev-model], [#logit-lr-stat], [$< 0.0001$],
      )

      #v(3pt)
      #align(left)[
        #text(size: 7.2pt, fill: rgb("#475569"))[
          _Métricas Globales:_ Pseudo-$R^2$ (McFadden) = #logit-pseudo-r2 | Prueba de Razón de Verosimilitud $chi^2(4) = #logit-lr-stat$ ($p < 0.0001$) | AIC = #logit-aic | Convergencia numérica de Newton-Raphson alcanzada en #logit-solver-iters iteraciones ($||Delta beta|| < 10^(-7)$).
        ]
      ]
    ]
  )
}

#let fig-econometric-results = figure(
  table-econometric-results,
  caption: [Resultados de la Regresión Logística Binaria y Análisis de Deviance sobre la Probabilidad de Cancelación],
)
