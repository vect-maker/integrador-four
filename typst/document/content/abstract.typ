// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil busca equilibrar en tiempo real la oferta de vehículos y la demanda de viajes; no obstante, una calibración desmedida del multiplicador tarifario unida a los estrangulamientos viales metropolitanos y a eventos meteorológicos severos incide drásticamente sobre la tasa de cancelación de viajes. La presente investigación analiza la infraestructura de movilidad y el comportamiento operativo de la plataforma MoviGo en el municipio de Managua durante el año 2024. Mediante un enfoque metodológico mixto con predominio cuantitativo y alcance descriptivo-prescriptivo, el estudio implementa un pipeline de ingeniería de datos ELT en la nube (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB) bajo modelado dimensional Kimball ($N = 77,487$ viajes transaccionales), articulado con la optimización espacial de la red vial metropolitana mediante teoría de grafos, centralidad de intermediación y resiliencia ante contingencias pluviales con el algoritmo de Dijkstra. A partir del censo analítico georreferenciado en 24 zonas urbanas y 44 corredores, se identifican los principales cuellos de botella viales de la capital y se cuantifica que eventos pluviales severos provocan una dilatación del 42.8% en los tiempos de traslado promedio en la red, forzando desvíos que sobrecargan los corredores comerciales centrales. La investigación demuestra la viabilidad de un ecosistema DataOps reproducible con cero deriva de datos para la toma de decisiones operativas y urbanas.
]

#let palabras-clave-es = (
  "Ingeniería de datos",
  "Modelado dimensional Kimball",
  "DuckDB",
  "Teoría de grafos",
  "Centralidad de intermediación",
  "Algoritmo de Dijkstra",
  "Resiliencia vial",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services aims to balance vehicle availability and passenger trip requests in real time; however, fare volatility coupled with metropolitan road network bottlenecks and severe meteorological disruptions drastically impacts trip cancellation rates. This research analyzes the urban mobility infrastructure and operational performance of the MoviGo selective transport service across Managua throughout 2024. Employing a mixed-method research design with quantitative predominance and descriptive-prescriptive scope, this study implements a modern cloud ELT data pipeline (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core, and DuckDB) using Kimball dimensional modeling ($N = 77,487$ transactional trips), coupled with spatial network graph optimization assessing betweenness centrality and flood resilience via Dijkstra's shortest path algorithm. Leveraging georeferenced analytical data across 24 urban zones and 44 arterial corridors, empirical findings identify key metropolitan bottlenecks and demonstrate that torrential rainstorms trigger an average 42.8% travel time dilation across the road network, forcing traffic detours that overload central commercial hubs. The study validates a reproducible DataOps ecosystem with zero data drift for urban mobility and operational platform decision-making.
]

#let keywords-en = (
  "Data engineering",
  "Kimball dimensional modeling",
  "DuckDB",
  "Graph theory",
  "Betweenness centrality",
  "Dijkstra algorithm",
  "Road network resilience",
  "MoviGo",
)
