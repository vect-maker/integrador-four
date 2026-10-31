// Reusable abstract and keywords for Spanish and English
#let resumen-es = [
El esquema de tarificación dinámica (_surge pricing_) en los servicios de transporte selectivo por aplicación móvil busca equilibrar en tiempo real la oferta de vehículos y la demanda de viajes; no obstante, una calibración desmedida del multiplicador tarifario unida a los estrangulamientos viales metropolitanos y a eventos meteorológicos severos incide drásticamente sobre la tasa de cancelación de viajes. La presente investigación analiza la infraestructura de movilidad y el comportamiento operativo de la plataforma MoviGo en el municipio de Managua durante el año 2024. Mediante un enfoque metodológico mixto con predominio cuantitativo y alcance descriptivo, explicativo y prescriptivo, el estudio implementa un pipeline de ingeniería de datos ELT en la nube (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB) bajo modelado dimensional Kimball ($N = 77,487$ viajes transaccionales), articulado con modelos de regresión lineal resueltos mediante Descenso de Gradiente Estocástico (SGD) con inferencia paramétrica al 95% para estimar la duración del viaje ($R^2 = 0.7212$) y la tarifa ($R^2 = 0.4634$) a partir de la distancia recorrida, así como la optimización espacial de la red vial metropolitana y auditoría algorítmica de caja negra mediante teoría de grafos, centralidad de intermediación y caminos mínimos con el algoritmo de Dijkstra. A partir de la malla espacial celular de 298 cuadrantes y 1,072 conexiones en 24 zonas urbanas, se identifican los cuellos de botella estructurales de la capital y se demuestra que la ausencia de ruteo adaptativo en MoviGo durante tormentas colapsa la velocidad a 8.01 km/h e incrementa la duración media a 95.17 minutos (76.4% de cancelaciones), mientras que el ruteo prescriptivo óptimo circunnavega cauces desbordados ahorrando hasta 82.2 minutos por traslado y neutralizando el detonante de cancelaciones. La investigación valida un ecosistema DataOps reproducible con cero deriva de datos para la toma de decisiones operativas y urbanas.
]

#let palabras-clave-es = (
  "Ingeniería de datos",
  "Modelado dimensional Kimball",
  "Descenso de gradiente",
  "Inferencia estadística",
  "Teoría de grafos",
  "Centralidad de intermediación",
  "Algoritmo de Dijkstra",
  "Resiliencia vial",
  "MoviGo",
)

#let abstract-en = [
Dynamic pricing (_surge pricing_) in on-demand ride-hailing services aims to balance vehicle availability and passenger trip requests in real time; however, fare volatility coupled with metropolitan road network bottlenecks and severe meteorological disruptions drastically impacts trip cancellation rates. This research analyzes the urban mobility infrastructure and operational performance of the MoviGo selective transport service across Managua throughout 2024. Employing a mixed-method research design with quantitative predominance and descriptive, explanatory, and prescriptive scope, this study implements a modern cloud ELT data pipeline (Python, Apache Parquet, Azure Database for PostgreSQL, dbt Core, and DuckDB) using Kimball dimensional modeling ($N = 77,487$ transactional trips), coupled with linear regression models optimized via Stochastic Gradient Descent (SGD) with 95% parametric inference to evaluate trip duration ($R^2 = 0.7212$) and pricing ($R^2 = 0.4634$) as a function of distance, alongside spatial network optimization and black-box routing auditing via graph theory, betweenness centrality, and Dijkstra's shortest path algorithm. Based on a 298-quadrant cellular spatial lattice with 1,072 contiguity edges across 24 urban zones, empirical findings identify structural bottlenecks and demonstrate that MoviGo's lack of flood-adaptive routing during storms causes vehicle speeds to collapse to 8.01 km/h and trip durations to surge to an average of 95.17 minutes (76.4% cancellation rate), whereas prescriptive shortest path routing circumnavigates flooded cauce barriers, saving up to 82.2 minutes per trip and neutralizing the primary driver of ride abandonments. The study validates a reproducible DataOps ecosystem with zero data drift for urban mobility and operational platform decision-making.
]

#let keywords-en = (
  "Data engineering",
  "Kimball dimensional modeling",
  "Gradient descent",
  "Statistical inference",
  "Graph theory",
  "Betweenness centrality",
  "Dijkstra algorithm",
  "Road network resilience",
  "MoviGo",
)
