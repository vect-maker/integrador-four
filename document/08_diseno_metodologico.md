# 7. Diseño Metodológico

El diseño metodológico describe la secuencia técnica, operativa y computacional implementada para estructurar el pipeline de datos, transformar los registros transaccionales en un modelo dimensional y ejecutar los análisis estadísticos y de optimización para el servicio de transporte selectivo.

---

## 7.1 Enfoque, Tipo y Alcance de la Investigación

La presente investigación adopta un enfoque mixto, debido a que combina el análisis cuantitativo de los datos operativos del servicio delivery de Antojitos Express con la interpretación cualitativa de los procesos relacionados con la preparación, asignación y entrega de los pedidos. Según Hernández Sampieri y Mendoza Torres (2023), el enfoque mixto integra las perspectivas cuantitativa y cualitativa dentro de un mismo proceso investigativo, permitiendo una comprensión más amplia del fenómeno estudiado.

El estudio es de tipo descriptivo, puesto que se orienta a caracterizar el comportamiento temporal y espacial de la demanda, los tiempos correspondientes a las diferentes etapas del ciclo de atención, la distribución de los pedidos y la disponibilidad de los repartidores. Según Hernández Sampieri y Mendoza Torres (2023), los estudios descriptivos buscan especificar las características, propiedades y comportamientos relevantes de los fenómenos sometidos a análisis.

Asimismo, la investigación presenta un diseño no experimental, debido a que las variables serán estudiadas sin manipulación deliberada, conservando las condiciones representadas en los registros utilizados para el análisis. Según Hernández Sampieri y Mendoza Torres (2023), en los diseños no experimentales los fenómenos se analizan tal como ocurren en su contexto, sin intervención intencional sobre las variables objeto de estudio.

---

## 7.2 Arquitectura del Pipeline y Paradigma ELT

El procesamiento de información se estructura bajo el paradigma de Extracción, Carga y Transformación (ELT). Inicialmente, el esquema relacional origen con los datos sintéticos se carga directamente en una instancia de PostgreSQL en la nube, preservando las tablas crudas en un esquema dedicado (*raw layer*) sin alterar su estructura inicial.

A partir de esta capa cruda, se implementa la herramienta dbt (*Data Build Tool*) conectada al motor de PostgreSQL para orquestar la transformación de datos en dos fases secuenciales:

### Capa de Estandarización (Staging)
Generación de vistas intermedias (`stg_*`) donde se ejecutan tareas de limpieza inicial, renombrado de atributos a convenciones homogéneas (`snake_case`) y estandarización de tipos de datos.

### Capa de Modelado Dimensional (Marts)
Materialización de tablas de hechos y dimensiones basadas en el esquema en estrella de la metodología Kimball. En esta etapa se generan llaves subrogadas (*Surrogate Keys*) deterministas mediante funciones de dispersión (*hash*) para desacoplar las identidades analíticas de las claves operativas del origen.

### Pruebas Automatizadas de Calidad (dbt Tests)
La confiabilidad del flujo se asegura mediante pruebas automatizadas de datos (*dbt tests*) declaradas en esquemas YAML, validando aserciones de unicidad, no nulidad, consistencia de llaves foráneas y reglas de dominio (tales como distancias o tiempos no negativos).

---

## 7.3 Definición del Grano y Estructura Dimensional

El diseño del Data Warehouse analítico adopta como proceso de negocio central el ciclo de solicitud y ejecución del viaje. El grano atómico de la tabla de hechos principal (`fct_trips`) se define exactamente al nivel de una fila por cada intento o viaje registrado, almacenando métricas cuantitativas como el tiempo de espera hasta el abordaje, duración total del recorrido, distancia en kilómetros, tarifa cobrada y costo operativo incurrido.

Esta tabla de hechos se vincula con dimensiones conformadas que aportan el contexto de análisis:
* **`dim_zones`**: Delimitación y características de las zonas urbanas de Managua.
* **`dim_vehicles`**: Atributos de la flota disponible.
* **`dim_date` / `dim_time`**: Granularidad temporal por día, hora y franja operativa.
* **`dim_weather`**: Condiciones meteorológicas registradas, incluyendo precipitaciones y temperatura.

---

## 7.4 Análisis Estadístico, Modelación Numérica y Optimización

La capa analítica y prescriptiva se ejecuta en Python interactuando directamente contra los Data Marts de PostgreSQL mediante conexiones vectorizadas (SQLAlchemy y pandas). El procesamiento cuantitativo se distribuye en tres fases:

### Fase 1: Caracterización y Detección de Patrones
Cálculo de métricas agregadas, matrices Origen-Destino (OD) y análisis de autocorrelación espaciotemporal para reconocer zonas críticas de desbalance entre oferta y demanda vehicular.

### Fase 2: Inferencia Estadística
Aplicación de pruebas de hipótesis y modelos de regresión lineal/no lineal para contrastar cómo las variaciones climáticas y las franjas horarias alteran las velocidades de circulación, los tiempos de atención y los componentes de la tarifa.

### Fase 3: Formulación Matemática de Optimización (MILP)
Implementación de un modelo de Programación Lineal Entera Mixta (MILP) formulado para minimizar simultáneamente los tiempos de espera del usuario y los costos por recorridos en vacío (*deadhead miles*). El modelo está sujeto a restricciones de conservación de flujo vehicular, disponibilidad de flota por zona horaria y rangos tarifarios definidos.

---

## 7.5 Evaluación de Escenarios y Visualización

Los resultados del pipeline y del motor de optimización se evalúan mediante simulaciones estructuradas sobre tres escenarios operativos:
1. **Escenario Base:** Derivado de los datos sintéticos iniciales con operación tradicional.
2. **Escenario de Redistribución Territorial Óptima:** Rebalanceo proactivo de la flota mediante el modelo MILP.
3. **Escenario Integrado:** Acopla rebalanceo vehicular con ajuste tarifario adaptativo ante eventos climáticos.

Finalmente, se construyen gráficos y paneles visuales en Python que sintetizan la reducción de tiempos muertos, el aprovechamiento de la flota y la coherencia del esquema tarifario propuesto.
