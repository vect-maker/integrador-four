#import "../template.typ": callout

= Matriz de Descriptores y Operacionalización de Variables

#callout(
  title: "Objetivo General del Proyecto",
  color: "blue",
  [
    *Evaluar* la eficacia del esquema de tarificación dinámica (_surge pricing_) de la plataforma MoviGo en el municipio de Managua y su impacto sobre la tasa de cancelación y la equidad socio-espacial, determinando puntos de equilibrio tarifario mediante métodos numéricos y formulando estrategias óptimas de asignación de incentivos a la flota bajo condiciones variables de demanda y clima urbano.
  ]
)

#v(1em)

#figure(
  table(
    columns: (auto, 1.8fr, 1.2fr, 2fr, 1.8fr),
    align: (center + horizon, left, left, left, left),
    stroke: 0.5pt + luma(180),
    fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else { none },
    table.header(
      [*Obj.*],
      [*Objetivo Específico*],
      [*Variable Conceptual*],
      [*Dimensiones / Indicadores*],
      [*Instrumentos y Herramientas*]
    ),
    
    // Fila 1
    [*1*],
    [Consolidar repositorio analítico multidimensional con dbt sobre PostgreSQL vía API REST.],
    [*Ingesta y Modelado Dimensional (Kimball)*],
    [- Ingesta de 7 endpoints API REST \
     - Registros: 77,386 viajes, 19k telemetría \
     - Pruebas dbt (`not_null`, `unique`, dominio) \
     - Firmas SHA-256 y Parquet],
    [API REST `/movigo`, Python (`httpx`, `pandas`), PostgreSQL, dbt Core.],

    // Fila 2
    [*2*],
    [Determinar la sensibilidad de demanda, variaciones tarifarias y probabilidad de cancelación.],
    [*Sensibilidad, Cancelación y Equidad*],
    [- Coeficientes de regresión múltiple ($beta_1, beta_2$) \
     - Estadísticos: Welch $t$, Proporciones $z$, ANOVA, $chi^2$ \
     - Supuestos Gauss-Markov verificados \
     - Tasa de cancelación por franja y estrato],
    [PostgreSQL, dbt Marts, Python (`statsmodels`, `scipy.stats`), seaborn.],

    // Fila 3
    [*3*],
    [Modelar numéricamente el equilibrio de mercado ($f(m)=0$) y la elasticidad-precio.],
    [*Equilibrio Numérico y Elasticidad*],
    [- Multiplicador de equilibrio $m^*$ \
     - Iteraciones y convergencia (Bisección vs. Newton-Raphson) \
     - Derivada numérica por diferencias finitas $cal(O)(h^2)$ \
     - Integral de volumen por Simpson 1/3],
    [Data Marts de dbt, Python (`numpy`, `scipy.optimize`), algoritmos numéricos propios.],

    // Fila 4
    [*4*],
    [Diseñar modelo prescriptivo de asignación de incentivos a choferes (mochila binaria 0/1).],
    [*Optimización Prescriptiva de Oferta*],
    [- Solución binaria óptima ${z_1, dots, z_K}$ \
     - Horas de conexión maximizadas ($sum v_k z_k$) \
     - Restricción presupuestaria ($<= "C\$ 120,000"$) \
     - Oferta mitigada sin sobrecosto al usuario],
    [Catálogo `/movigo/campanas`, Python (`pulp`), Programación Dinámica.]
  ),
  caption: [Matriz de operacionalización metodológica y descriptores del proyecto.]
) <tbl-matriz-descriptores>
