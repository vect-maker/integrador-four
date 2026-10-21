// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil constituye un mecanismo algorítmico determinante para equilibrar en tiempo real la oferta vehicular y la demanda de viajes; sin embargo, en entornos urbanos caracterizados por marcadas asimetrías socioeconómicas y fragilidad ante eventos climáticos, su calibración inadecuada puede inducir cancelaciones masivas y exclusión territorial. La presente investigación evalúa el impacto del esquema de tarificación dinámica del servicio de transporte selectivo MoviGo en el municipio de Managua durante el año 2024. Como trabajo de investigación derivado del producto integrador de componentes curriculares de la carrera de Ingeniería en Ciencias de Datos (UNAN-Managua), el estudio articula técnicas de ingeniería analítica bajo el paradigma ELT (Python, PostgreSQL y dbt Core), modelación econométrica multivariada, solución numérica de ecuaciones de exceso de demanda mediante algoritmos de búsqueda de raíces (Bisección y Newton-Raphson) y optimización de incentivos para la flota mediante programación entera binaria (problema de la mochila 0/1). A partir del procesamiento de más de 77,000 registros de viajes, 19,000 puntos de telemetría y series meteorológicas continuas consumidas exclusivamente vía API REST, se analiza la sensibilidad al precio y la tasa de cancelación en 12 cuadrantes urbanos agrupados en cuatro estratos socioeconómicos. Los hallazgos aportan evidencia cuantitativa para estimar multiplicadores tarifarios de equilibrio y formular políticas de asignación presupuestaria orientadas a mitigar la escasez vehicular sin sobrecargar económicamente a los usuarios.
]

#let palabras-clave-es = (
  "Tarificación dinámica",
  "Transporte selectivo",
  "Elasticidad-precio",
  "Equilibrio de mercado",
  "Ingeniería de datos",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services represents a decisive algorithmic mechanism to balance vehicle supply and passenger trip demand in real time; however, in urban environments characterized by pronounced socioeconomic asymmetries and climate vulnerability, miscalibrated pricing rules can trigger widespread ride cancellations and spatial exclusion. This research evaluates the impact of the dynamic pricing scheme of the MoviGo on-demand selective transport service across the municipality of Managua during 2024. As an integrative capstone research project within the Data Science Engineering program at UNAN-Managua, this study combines analytical engineering under the ELT paradigm (Python, PostgreSQL, and dbt Core), multivariate econometric modeling, numerical resolution of market excess demand equations via root-finding methods (Bisection and Newton-Raphson), and binary integer optimization for driver incentive campaigns (0/1 knapsack problem). Based on the extraction and processing of over 77,000 trip transactions, 19,000 telemetry records, and continuous meteorological observations accessed exclusively via a REST API, price elasticity and cancellation behaviors are examined across 12 urban sectors categorized into four socioeconomic strata. The empirical results provide actionable evidence to determine equilibrium pricing multipliers and design targeted incentive subsidy policies that alleviate vehicle shortages without imposing punitive fare hikes on urban commuters.
]

#let keywords-en = (
  "Dynamic pricing",
  "Ride-hailing",
  "Price elasticity",
  "Market equilibrium",
  "Data engineering",
  "MoviGo",
)
