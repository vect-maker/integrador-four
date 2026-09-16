# 7. Diseño Metodológico

El diseño metodológico describe la secuencia técnica, computacional y matemática implementada para extraer los datos desde la API REST de Movi Go, cargar la base de datos relacional en PostgreSQL, estructurar el Data Warehouse dimensional con dbt y ejecutar los análisis inferenciales, numéricos y de optimización para el servicio de transporte selectivo en Managua.

---

## 7.1 Enfoque, Tipo y Alcance de la Investigación

La presente investigación adopta un **enfoque mixto con predominio cuantitativo**, debido a que combina el procesamiento computacional masivo de registros transaccionales, telemétricos y climáticos del servicio de transporte selectivo por aplicación **Movi Go** en el municipio de Managua, con la interpretación analítica y contextual de las reglas de negocio, la dinámica urbana y el comportamiento de oferta y demanda. Según Hernández Sampieri y Mendoza Torres (2023), el enfoque mixto integra perspectivas analíticas complementarias para lograr una comprensión integral del fenómeno estudiado.

El estudio es de tipo **descriptivo, correlacional y propositivo (prescriptivo)**:
* **Descriptivo:** Caracteriza la distribución espacial de los más de 65,000 viajes anuales, la disponibilidad de la flota y los patrones temporales de movilidad.
* **Correlacional:** Evalúa el impacto de la precipitación, la congestión y los estratos socioeconómicos sobre la duración de los viajes, las cancelaciones y los métodos de pago.
* **Propositivo (Prescriptivo):** Formula modelos de optimización y algoritmos numéricos para resolver problemas concretos de despacho, ruteo y asignación presupuestaria.

Asimismo, la investigación presenta un **diseño no experimental**, dado que las variables se analizan tal como fueron registradas y simuladas en el entorno operativo sin intervención deliberada sobre el comportamiento de los conductores o los usuarios.

---

## 7.2 Arquitectura del Pipeline y Paradigma ELT

El flujo de procesamiento de información se estructura bajo una arquitectura moderna de dos fases:

```
[API REST /movigo] 
       │ (HTTP GET Paginado - Python / httpx)
       ▼
[pandas DataFrames] ──(Reconstrucción de relaciones y Parquet + SHA-256)
       │ (Carga relacional)
       ▼
[PostgreSQL - Raw Layer]
       │
       ▼ (Transformación con dbt Core)
[Staging (stg_*)] ──(dbt tests: unique, not_null, domain rules)
       │
       ▼ (Modelado Kimball)
[Data Marts: fact_viajes + dim_*]
```

### 7.2.1 Fase de Extracción y Carga Inicial (API REST &rarr; PostgreSQL)
Dado que el acceso a los datos de Movi Go es exclusivo vía API REST, se implementa un script en Python (`httpx`/`requests`) con una función modular de extracción paginada (`fetch_all_records`):
* Manejo de paginación mediante parámetros `limit=200` y `offset` incremental.
* Reconstrucción en memoria con **pandas** de la integridad referencial entre las tablas operativas: zonas, usuarios, conductores, campañas, clima, viajes y telemetría.
* Carga automatizada a tablas relacionales crudas (*raw layer*) en una instancia dedicada de **PostgreSQL**.
* Exportación paralela de los conjuntos de datos en formato columnar **Parquet** con cálculo de firmas criptográficas **SHA-256** para auditoría y trazabilidad DataOps.

### 7.2.2 Fase de Transformación y Modelado Dimensional (dbt Core)
A partir de la capa cruda en PostgreSQL, la herramienta **dbt (Data Build Tool)** orquesta el proceso ELT en dos capas secuenciales:
* **Capa de Estandarización (Staging):** Vistas intermedias (`stg_viajes`, `stg_zonas`, etc.) donde se realiza la homologación de atributos a convenciones homogéneas (`snake_case`), tipificación estricta de marcas temporales con zona horaria de Managua y limpieza de valores ausentes.
* **Capa de Modelado Dimensional (Marts):** Materialización de tablas de hechos y dimensiones basadas en la metodología Kimball, generando llaves subrogadas deterministas mediante funciones de dispersión hash (MD5).

### 7.2.3 Aseguramiento de Calidad de Datos (dbt Tests)
La confiabilidad del flujo se audita mediante pruebas automáticas declaradas en esquemas YAML de dbt:
* Aserciones de unicidad y no nulidad en llaves subrogadas.
* Consistencia de llaves foráneas entre hechos y dimensiones.
* Reglas de dominio de negocio: `multiplicador_dinamico >= 1.00`, `distancia_km >= 0`, `duracion_minutos >= 0` y `tarifa_final > 0`.

---

## 7.3 Definición del Grano y Estructura Dimensional

El diseño del Data Warehouse analítico adopta como proceso de negocio central el ciclo de solicitud, despacho y ejecución del viaje.

### Grano Atómico de la Tabla de Hechos: `fact_viajes`
Se define al nivel de una fila por cada intento o viaje registrado (> 65,000 observaciones anuales). Contiene:
* **Métricas Monetarias:** `tarifa_base`, `multiplicador_dinamico`, `tarifa_final`, `propina`.
* **Métricas Operativas:** `distancia_km`, `duracion_minutos`, `tiempo_espera_recogida_min`.
* **Métricas de Calidad:** `calificacion_usuario`, `calificacion_conductor`.
* **Llaves Foráneas:** Vinculación con las dimensiones del modelo.

### Dimensiones Conformadas:
* **`dim_zona_origen` / `dim_zona_destino`:** Cuadrantes urbanos de Managua, nombre comercial, estrato socioeconómico (`alto`, `medio`, `popular`, `comercial`), latitud, longitud y radio de cobertura.
* **`dim_conductor`:** Flota vehicular registrada, tipo de servicio (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), modelo de auto, año, placa, calificación histórica y tasa de aceptación.
* **`dim_usuario`:** Identificador, teléfono de contacto, método de pago habitual y calificación promedio.
* **`dim_tiempo`:** Fecha, día de la semana, hora, minuto y clasificación de franja horaria (pico matutino, valle, pico vespertino, nocturno).
* **`dim_clima`:** Registro meteorológico diario sincronizado con la API: precipitación acumulada (mm), temperatura (°C), índice de congestión vial (1.00 a 3.50) y condición del cielo.

---

## 7.4 Metodología Analítica, Inferencia y Métodos Numéricos

La capa analítica interactúa directamente contra los Data Marts de PostgreSQL utilizando conexiones vectorizadas en Python (SQLAlchemy, pandas, scipy, statsmodels, pulp):

### 7.4.1 Inferencia Estadística y Validación de Supuestos (Estadística II)
1. **Regresión Lineal Múltiple:** Se modela el volumen de demanda diaria en función de factores climáticos y congestión:
   $$\text{ViajesDiarios} = \beta_0 + \beta_1 (\text{Precipitación}_{mm}) + \beta_2 (\text{ÍndiceCongestión}) + \epsilon$$
   generando la tabla ANOVA completa ($SCA$, $SCE$, $SCT$, grados de libertad y significancia del estadístico $F$).
2. **Validación de Supuestos Gauss-Markov:** 
   * Normalidad de residuos (Shapiro-Wilk / Jarque-Bera).
   * Homocedasticidad (Breusch-Pagan / White).
   * No autocorrelación serial (estadístico Durbin-Watson).
3. **Batería de Pruebas de Hipótesis:**
   * **Prueba $t$ de Welch:** Evaluar si el multiplicador dinámico ($> 1.25\times$) eleva significativamente el costo final del viaje frente a la tarifa base ($p < 0.05$).
   * **Prueba $z$ de proporciones:** Contrastar la tasa de cancelaciones en horas pico vs. horas valle.
   * **ANOVA de un factor:** Determinar si la duración promedio difiere según el estrato socioeconómico de destino.
   * **Prueba $\chi^2$:** Contrastar la independencia entre el método de pago utilizado y el estrato del cuadrante de origen ($p < 0.01$).

### 7.4.2 Métodos Numéricos y Calibración
1. **Búsqueda de Raíces:** Implementación de los métodos de **Bisección** y **Newton-Raphson** para encontrar el multiplicador de equilibrio $m^*$ que anula la función de exceso de demanda:
   $$f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$$
2. **Diferenciación Numérica:** Estimación de la elasticidad-precio de la demanda mediante esquemas de diferencias finitas centradas de orden $\mathcal{O}(h^2)$.
3. **Integración Numérica:** Aplicación de la **Regla de Simpson 1/3** sobre la curva horaria de viajes para aproximar el volumen acumulado de demanda diaria.

---

## 7.5 Modelos de Optimización Prescriptiva y Simulación

La capa prescriptiva implementa tres formulaciones matemáticas concretas:

1. **Despacho Óptimo (Algoritmo Húngaro):**
   * Resuelve la asignación biyectiva óptima entre conductores disponibles en telemetría GPS y solicitudes pendientes para minimizar el tiempo total de recogida de los usuarios.
2. **Ruta Mínima Bajo Lluvia y Congestión (Algoritmo de Dijkstra):**
   * Modela la red de cuadrantes de Managua como un grafo ponderado por distancia e índice de congestión vial.
   * Compara los caminos mínimos en escenarios de flujo libre vs. lluvia torrencial con saturación vial.
3. **Optimización Presupuestaria de Incentivos (Problema de la Mochila 0/1):**
   * Maximiza las horas de conexión adicionales de los conductores seleccionando las mejores campañas de bonos (`/movigo/campanas`) bajo un límite presupuestario estricto de **C$ 120,000 NIO**, resuelto mediante Programación Dinámica.

### Evaluación de Escenarios Operativos:
* **Escenario 0 (Línea Base):** Operación tradicional con despacho reactivo y multiplicador dinámico no calibrado.
* **Escenario 1 (Optimización de Despacho y Ruteo):** Despacho mediante Algoritmo Húngaro acoplado a rutas inteligentes con Dijkstra.
* **Escenario 2 (Optimización Integral con Campañas y Tarifa de Equilibrio):** Incorporación del presupuesto óptimo de incentivos (Mochila 0/1) y multiplicador calibrado $m^*$ ante perturbaciones climáticas.

Finalmente, los resultados se integran en un tablero de control analítico (*BI Dashboard*) que visualiza la reducción de cancelaciones, el ahorro en tiempos muertos y el comportamiento de la tarifa en el municipio de Managua.
