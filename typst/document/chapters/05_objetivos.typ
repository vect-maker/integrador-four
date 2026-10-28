= Objetivos de la Investigación

== Objetivo General

*Determinar* el impacto del esquema de tarificación dinámica y los estrangulamientos viales de la red urbana sobre la probabilidad de cancelación de viajes del servicio de transporte selectivo MoviGo en el municipio de Managua durante el año 2024.

== Objetivos Específicos

+ *Implementar* un pipeline de ingeniería de datos bajo el paradigma ELT (API REST, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB) para la consolidación y explotación de un repositorio analítico columnar de 77,487 operaciones.

+ *Modelar* la probabilidad condicional de cancelación de viajes a nivel transaccional en función del multiplicador de tarifa dinámica y fricciones operacionales mediante regresión logística binaria (Logit), calibrada numéricamente mediante el algoritmo iterativo de Newton-Raphson (IRLS) y evaluando la significancia inferencial mediante el análisis de Deviance y razones de momios (_Odds Ratios_).

+ *Construir y optimizar* la red de movilidad urbana metropolitana mediante teoría de grafos sobre los flujos origen-destino observados (24 zonas), evaluando métricas de centralidad de intermediación (_betweenness_), cuellos de botella viales y la resiliencia operativa de los corredores ante perturbaciones hidrológicas y congestión severa.
