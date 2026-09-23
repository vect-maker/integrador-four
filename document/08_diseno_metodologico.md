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

## 7.4 Metodología Analítica, Inferencia y Métodos Cuantitativos
 
La capa analítica interactúa directamente contra los Data Marts modelados mediante dbt en PostgreSQL utilizando conexiones vectorizadas en Python (SQLAlchemy, pandas, scipy, statsmodels, pulp):
 
### 7.4.1 Inferencia Estadística y Factores Contextuales
1. **Modelación Econométrica de Demanda:** Se evalúa la relación funcional del volumen de demanda en función de factores exógenos climáticos y de congestión (ej. regresión lineal multivariada o modelos aditivos generalizados):
   $$\text{ViajesDiarios} = f(\text{Precipitación}, \text{ÍndiceCongestión}, \text{FactoresContextuales}) + \epsilon$$
   evaluando la bondad de ajuste y significancia estadística de los estimadores.
2. **Evaluación de Supuestos del Modelo:** 
   * Análisis de distribución y normalidad de residuos.
   * Diagnóstico de heterocedasticidad y estabilidad de varianza.
   * Diagnóstico de autocorrelación serial temporal.
3. **Contrastes de Hipótesis Contextuales (Exploratorios):**
   * Evaluación de impacto del multiplicador dinámico sobre el importe y variabilidad tarifaria.
   * Contraste de tasas de cancelación entre franjas horarias de alta y baja concurrencia.
   * Comparación de duraciones y demoras según estratos socioeconómicos o zonas territoriales.
   * Contrastes de independencia entre modalidades de pago y zonas de origen/destino.
 
### 7.4.2 Métodos Numéricos y Calibración Tarifaria
1. **Calibración de Equilibrio Tarifario:** Exploración de funciones de exceso de demanda $f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$ y evaluación de métodos iterativos de resolución numérica (como Bisección o esquemas basados en derivadas como Newton-Raphson) para identificar multiplicadores de balance.
2. **Estimación de Elasticidad-Precio:** Aproximación empírica y por diferenciación numérica de la elasticidad de la demanda ante variaciones tarifarias.
3. **Agregación Continua de Demanda:** Métodos de cuadratura o integración numérica sobre curvas horarias estimadas para computar volúmenes agregados diarios.
 
---
 
## 7.5 Modelos Prescriptivos de Optimización y Evaluación Operativa
 
La capa prescriptiva formula y contrasta enfoques matemáticos adaptables a la asignación de recursos y mitigación de desequilibrios:
 
1. **Asignación Operativa de Flota:**
   * Formulación de modelos de asignación bipartita / emparejamiento entre oferta vehicular disponible y solicitudes entrantes, buscando reducir tiempos de espera y recorridos en vacío (*deadhead*).
2. **Ruteo y Redes Territoriales:**
   * Modelación de la red vial urbana como grafo ponderado por distancia e índices de congestión o afectación climática, evaluando algoritmos de caminos mínimos para mitigar demoras.
3. **Estrategias de Incentivos y Cobertura:**
   * Modelos de distribución de incentivos o bonos para conductores bajo restricciones presupuestarias para estimular la oferta en horas pico o zonas deficitarias.
 
### Evaluación Comparativa de Escenarios Operativos:
* **Escenario 0 (Línea Base):** Operación observada a partir del histórico de la API con asignación reactiva y multiplicador dinámico no calibrado.
* **Escenario 1 (Optimización de Despacho y Ruteo):** Despacho basado en modelos prescriptivos de asignación y ruteo inteligente.
* **Escenario 2 (Estrategia Integral con Calibración de Oferta y Tarifa):** Esquema integral que combina incentivos focalizados y multiplicadores tarifarios calibrados ante contingencias climáticas.
 
Los resultados consolidados se comunican a través de tableros de control analítico (*BI Dashboards*) que sintetizan indicadores clave de servicio, cobertura territorial y eficiencia operativa en Managua.
