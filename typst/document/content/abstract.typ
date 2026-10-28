// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil busca equilibrar en tiempo real la oferta de vehículos y la demanda de viajes; no obstante, una calibración desmedida del multiplicador tarifario puede sobrepasar la disposición de pago de los usuarios, disparando las cancelaciones de viajes y generando exclusión en sectores de menor ingreso. La presente investigación determina el impacto del multiplicador de tarifa dinámica y la congestión vial sobre la probabilidad de cancelación de viajes en la plataforma MoviGo en el municipio de Managua durante el año 2024. Mediante un enfoque metodológico mixto con predominio cuantitativo y alcance correlacional-prescriptivo, el estudio implementa un pipeline de ingeniería de datos ELT en la nube (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB), modelación econométrica mediante regresión logística binaria (Logit) resuelta numéricamente por el algoritmo de Newton-Raphson multidimensional (IRLS) con análisis de Deviance y razones de momios (_Odds Ratios_), y optimización de la red de movilidad metropolitana mediante teoría de grafos, centralidad de intermediación y resiliencia vial ante inundaciones. A partir de más de 77,000 registros transaccionales georreferenciados en 24 zonas urbanas, se cuantifica que cada incremento unitario en el multiplicador dinámico casi triplica el riesgo relativo de cancelación ($"OR" = 2.95, p < 0.0001$), mientras que eventos pluviales severos dilatan los tiempos de traslado en un 42.8% promedio en la red, forzando desvíos que sobrecargan los corredores comerciales centrales. Los resultados permiten formular topes tarifarios tolerables ($m^* approx 1.35times$) y esquemas de ruteo adaptativo para mitigar el abandono del servicio.
]

#let palabras-clave-es = (
  "Tarificación dinámica",
  "Tasa de cancelación",
  "Transporte selectivo",
  "Regresión logística",
  "Newton-Raphson",
  "Teoría de grafos",
  "Centralidad de intermediación",
  "Ingeniería de datos",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services aims to balance vehicle availability and passenger trip requests in real time; however, aggressive fare multipliers can exceed commuters' willingness to pay, triggering widespread trip cancellations and socioeconomic exclusion. This study models the impact of dynamic fare multipliers and traffic congestion on the probability of trip cancellation for the MoviGo selective transport service in Managua throughout 2024. Employing a mixed-method research design with quantitative predominance and correlational-prescriptive scope, this work deploys a modern cloud ELT data pipeline (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core, and DuckDB), transactional binary logistic regression (Logit) numerically solved via multidimensional Newton-Raphson (IRLS) with deviance and odds ratio analyses, and urban network graph optimization assessing betweenness centrality and flood resilience. Leveraging over 77,000 transaction records across 24 urban zones, empirical findings demonstrate that each unit increase in the surge multiplier nearly triples the odds of trip cancellation ($"OR" = 2.95, p < 0.0001$), while torrential rainstorms increase average travel times across the metropolitan road network by 42.8%, forcing detours that strain commercial bottleneck hubs. The results provide actionable surge pricing thresholds ($m^* approx 1.35times$) and adaptive routing strategies to curtail service abandonment.
]

#let keywords-en = (
  "Dynamic pricing",
  "Trip cancellation rate",
  "Ride-hailing",
  "Logistic regression",
  "Newton-Raphson",
  "Graph theory",
  "Betweenness centrality",
  "Data engineering",
  "MoviGo",
)
