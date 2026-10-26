// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil busca equilibrar en tiempo real la oferta de vehículos y la demanda de viajes; no obstante, una calibración desmedida del multiplicador tarifario puede sobrepasar la disposición de pago de los usuarios, disparando las cancelaciones de viajes y generando exclusión en sectores de menor ingreso. La presente investigación determina el impacto del multiplicador de tarifa dinámica sobre la tasa de cancelación de viajes en la plataforma MoviGo en el municipio de Managua durante el año 2024. Mediante un enfoque metodológico mixto con predominio cuantitativo y alcance correlacional-prescriptivo, el estudio implementa un pipeline de ingeniería de datos ELT en la nube (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB), modelación econométrica por Mínimos Cuadrados Ordinarios (MCO) con descomposición ANOVA, aproximación numérica del multiplicador de equilibrio de mercado mediante búsqueda de raíces (Bisección y Newton-Raphson), y optimización de trayectorias en la red vial urbana mediante teoría de grafos (algoritmo de Dijkstra). A partir de más de 77,000 registros transaccionales georreferenciados en 12 cuadrantes urbanos y series meteorológicas continuas, se cuantifica la sensibilidad al precio y se evalúa el estrangulamiento vial ante perturbaciones pluviales. Los resultados permiten estimar umbrales tarifarios tolerables y formular esquemas de ruteo resiliente para mitigar el abandono del servicio sin transferir sobrecostos punitivos al usuario.
]

#let palabras-clave-es = (
  "Tarificación dinámica",
  "Tasa de cancelación",
  "Transporte selectivo",
  "Equilibrio numérico",
  "Algoritmo de Dijkstra",
  "Ingeniería de datos",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services aims to balance vehicle availability and passenger trip requests in real time; however, aggressive fare multipliers can exceed commuters' willingness to pay, triggering widespread trip cancellations and socioeconomic exclusion. This study models the impact of dynamic fare multipliers on the trip cancellation rate for the MoviGo selective transport service in Managua throughout 2024. Employing a mixed-method research design with quantitative predominance and correlational-prescriptive scope, this work deploys a modern cloud ELT data pipeline (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core, and DuckDB), Ordinary Least Squares (OLS) linear econometric modeling with ANOVA decomposition, numerical estimation of market equilibrium pricing thresholds via root-finding algorithms (Bisection and Newton-Raphson), and shortest-path road network optimization using graph theory (Dijkstra's algorithm). Leveraging over 77,000 transaction records across 12 urban sectors combined with daily weather time series, we quantify price sensitivity and analyze traffic bottlenecks under torrential rainfall disruptions. The findings deliver actionable equilibrium pricing bounds and resilient routing strategies that curtail service abandonment without imposing punitive fare hikes on urban passengers.
]

#let keywords-en = (
  "Dynamic pricing",
  "Trip cancellation rate",
  "Ride-hailing",
  "Numerical equilibrium",
  "Dijkstra algorithm",
  "Data engineering",
  "MoviGo",
)
