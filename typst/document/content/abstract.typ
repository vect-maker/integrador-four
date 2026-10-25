// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil busca equilibrar en tiempo real la oferta de vehículos y la demanda de viajes; no obstante, una calibración desmedida del multiplicador tarifario puede sobrepasar la disposición de pago de los usuarios, disparando las cancelaciones de viajes y generando exclusión en sectores de menor ingreso. La presente investigación determina el impacto del multiplicador de tarifa dinámica sobre la probabilidad de cancelación de viajes en la plataforma MoviGo en el municipio de Managua durante el año 2024. Como proyecto integrador de la carrera de Ingeniería en Ciencias de Datos (UNAN-Managua), el estudio implementa un pipeline de ingeniería de datos ELT en la nube (Python, Apache Parquet, Azure Database for PostgreSQL y dbt Core), modelación econométrica multivariada de probabilidad de cancelación, aproximación numérica de multiplicadores críticos de equilibrio mediante búsqueda de raíces (Bisección y Newton-Raphson) y optimización de incentivos para conductores mediante programación entera binaria (mochila 0/1). A partir de más de 77,000 registros transaccionales georreferenciados en 12 cuadrantes urbanos y series meteorológicas continuas, se cuantifica la sensibilidad al precio ante perturbaciones climáticas y disparidades socioeconómicas. Los resultados permiten estimar umbrales tarifarios tolerables y formular esquemas óptimos de subsidio de oferta para mitigar el abandono del servicio sin transferir sobrecostos punitivos al usuario.
]

#let palabras-clave-es = (
  "Tarificación dinámica",
  "Cancelación de viajes",
  "Transporte selectivo",
  "Equilibrio numérico",
  "Ingeniería de datos",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services aims to balance vehicle availability and passenger trip requests in real time; however, aggressive fare multipliers can exceed commuters' willingness to pay, triggering widespread trip cancellations and socioeconomic exclusion. This study models the impact of dynamic fare multipliers on trip cancellation probabilities for the MoviGo selective transport service in Managua throughout 2024. Developed as an integrative capstone within the Data Science Engineering program at UNAN-Managua, this work deploys a modern cloud ELT data pipeline (Python, Apache Parquet, Azure Database for PostgreSQL, and dbt Core), multivariate econometric modeling of cancellation propensity, numerical estimation of critical equilibrium pricing thresholds via root-finding algorithms (Bisection and Newton-Raphson), and binary integer optimization (0/1 knapsack) for driver incentive campaigns. Leveraging over 77,000 transaction records across 12 urban sectors combined with daily weather time series, we quantify price sensitivity under rainfall disruptions and socioeconomic stratification. The findings deliver actionable pricing bounds and optimal driver incentive allocation strategies that curtail service abandonment without imposing punitive fare hikes on urban passengers.
]

#let keywords-en = (
  "Dynamic pricing",
  "Trip cancellations",
  "Ride-hailing",
  "Numerical equilibrium",
  "Data engineering",
  "MoviGo",
)
