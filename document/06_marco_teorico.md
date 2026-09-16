# 6. Marco Teórico

## 6.1 Eficiencia del Servicio y Fundamentos Operacionales

La optimización de un servicio de transporte selectivo requiere comprender que su eficiencia no depende únicamente del número de vehículos disponibles, sino de la capacidad de la empresa para ubicar su flota de acuerdo con el comportamiento territorial y temporal de la demanda, responder oportunamente a los cambios del entorno y establecer tarifas coherentes con las condiciones reales en las que se presta el servicio.

En una organización como Movi Go, cuyo ámbito de análisis se concentra en el área metropolitana del municipio de Managua, estas relaciones adquieren especial importancia debido a que las solicitudes de transporte presentan variaciones marcadas según el cuadrante urbano, la hora del día, el día de la semana, la disponibilidad de vehículos, las condiciones meteorológicas y los niveles tarifarios aplicados.

Desde esta perspectiva, la distribución territorial de la flota y la determinación de tarifas constituyen problemas estrechamente vinculados. Una concentración excesiva de vehículos en zonas con baja demanda produce tiempos ociosos y desplazamientos improductivos, mientras que una disponibilidad insuficiente en zonas de elevada demanda incrementa el tiempo de espera de los usuarios, aumenta las distancias de aproximación y dispara la tasa de cancelaciones del servicio.

De manera paralela, una estructura tarifaria que no responda adecuadamente al comportamiento de la oferta, la demanda y las condiciones operativas puede afectar tanto la percepción del usuario como la sostenibilidad económica del conductor y de la plataforma. Por ello, la toma de decisiones requiere una base analítica que permita observar estas variables de manera conjunta y no como elementos independientes.

---

## 6.2 Arquitectura de Datos y Paradigma ELT vía API REST

La construcción de esta base analítica comienza con la adecuada administración de los datos generados por la operación. En el entorno de Movi Go, las transacciones operativas no residen en una base de datos directamente accesible mediante sentencias SQL, sino que se encuentran encapsuladas detrás de una **API REST (`/movigo`)** que expone 7 endpoints especializados con respuestas estructuradas en formato JSON bajo el envoltorio `PaginatedResponse`:

```json
{
  "items": [...],
  "count": 50,
  "total": 65000,
  "offset": 0,
  "limit": 50
}
```

La arquitectura de datos se diseña bajo un flujo de dos etapas principales:

### Etapa 1: Ingesta y Reconstrucción Relacional (Python + pandas &rarr; PostgreSQL)
Se implementa un cliente automatizado en Python (`httpx`/`requests`) que maneja paginación optimizada (`limit` de hasta 200 registros) para extraer las colecciones de:
* `/movigo/zonas`: Cuadrantes urbanos, coordenadas WGS84, estrato y bajada de bandera.
* `/movigo/usuarios`: Pasajeros y preferencias de pago.
* `/movigo/conductores`: Socios conductores, categorías de vehículos y estado operativo.
* `/movigo/campanas`: Programas de incentivos y presupuestos.
* `/movigo/clima`: Series diarias de lluvia, temperatura y congestión vial.
* `/movigo/viajes`: Histórico transaccional de más de 65,000 viajes anuales.
* `/movigo/telemetria`: Pings GPS y velocidad instantánea.

Estos datos se cargan en memoria mediante **pandas** para validar llaves foráneas e integridad referencial, volcándose posteriormente en tablas crudas (*raw layer*) dentro de un motor relacional **PostgreSQL**.

### Etapa 2: Transformación y Modelado Analítico con dbt Core (ELT)
Una vez centralizados los datos en PostgreSQL, se activa el paradigma **ELT (Extracción, Carga y Transformación)** utilizando **dbt (Data Build Tool)**. Esta herramienta orquesta las transformaciones en SQL de manera modular y versionada, transitando desde vistas de limpieza inicial (*staging*) hasta tablas dimensionales materializadas (*marts*).

---

## 6.3 Modelado Dimensional y Metodología Kimball

El modelado dimensional según la metodología Kimball busca estructurar la información analítica de forma intuitiva y de alto rendimiento de consulta, separando los acontecimientos medibles del negocio del contexto descriptivo que los rodea.

En Movi Go, el proceso de negocio central es la solicitud y realización del viaje. La arquitectura del Data Warehouse se diseña con un **Esquema en Estrella (*Star Schema*)**:

### Tabla de Hechos: `fact_viajes`
Grano atómico de una fila por cada viaje solicitado. Contiene las métricas cuantitativas clave:
* `tarifa_base` (NIO)
* `multiplicador_dinamico` (factor continuo $\ge 1.0$)
* `tarifa_final` (NIO cobrados)
* `distancia_km`
* `duracion_minutos`
* `tiempo_espera_recogida_min`
* `propina` (NIO)
* `calificacion_usuario` y `calificacion_conductor`

### Dimensiones Conformadas:
* **`dim_zona_origen` / `dim_zona_destino`:** Atributos del cuadrante urbano, estrato socioeconómico (`alto`, `medio`, `popular`, `comercial`), latitud, longitud y radio de servicio.
* **`dim_conductor`:** Nombre, categoría de servicio (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), modelo de auto, año y calificación histórica.
* **`dim_usuario`:** Identificador, método de pago preferido (`efectivo`, `tarjeta`, `billetera_digital`) y calificación.
* **`dim_tiempo`:** Fecha, día de semana, hora del día y franja operativa (pico matutino, valle, pico vespertino, nocturno).
* **`dim_clima`:** Precipitación en mm, temperatura en °C, índice de congestión y condición atmosférica.

---

## 6.4 Llaves Subrogadas y Pruebas Automatizadas de Calidad

Dentro del Data Warehouse se implementan **Llaves Subrogadas (*Surrogate Keys*)** generadas mediante funciones hash deterministas (MD5). Estas llaves desacoplan la identidad analítica de los identificadores operativos de la API, permitiendo la preservación del historial dimensional ante posibles cambios futuros en los sistemas de origen.

La confiabilidad del almacén de datos se garantiza mediante pruebas de calidad (*dbt tests*) declaradas en esquemas YAML que validan:
* **Unicidad y no nulidad:** De todas las llaves primarias y foráneas.
* **Reglas de negocio:** `multiplicador_dinamico >= 1.00`, `distancia_km >= 0`, `duracion_minutos >= 0` y `tarifa_final > 0`.
* **Consistencia referencial:** Verificación de integridad entre viajes, conductores y zonas de Managua.

---

## 6.5 Heterogeneidad Espaciotemporal y Recorridos Improductivos (Deadhead Miles)

La literatura sobre servicios bajo demanda demuestra que la heterogeneidad espacial y temporal es una característica intrínseca de la movilidad (Xu et al.; Alonso-Mora et al.). En Managua, las solicitudes no se distribuyen uniformemente: corredores comerciales como Metrocentro o Pista Juan Pablo II concentran viajes en horas específicas, mientras que cuadrantes populares o residenciales actúan principalmente como generadores en la mañana y atractores en la tarde.

Cuando un vehículo debe recorrer una distancia considerable sin pasajero antes de iniciar un viaje, incurre en **recorridos en vacío (*deadhead miles*)**. Estos traslados generan costos improductivos de combustible y depreciación de la unidad sin generar ingresos. La telemetría GPS (`/movigo/telemetria`) permite calcular y monitorear la velocidad instantánea y el estado de la flota para minimizar estos tiempos muertos.

---

## 6.6 Dinámica de la Tarifa Paramétrica y Surge Pricing

Movi Go calcula sus tarifas mediante un modelo paramétrico formal:

$$\text{TarifaBase} = \text{BajadaBandera} + (18 \times \text{distancia\_km}) + (4.5 \times \text{duracion\_minutos})$$

$$\text{TarifaFinal} = \text{TarifaBase} \times \text{multiplicador\_dinamico}$$

El multiplicador dinámico (*surge pricing*) opera en un rango habitual de **$1.00\times$ a $2.80\times$**, con picos de tormenta de hasta **$3.20\times$**. Su propósito teórico es racionar la demanda en horas de saturación vial y atraer conductores hacia áreas con déficit de oferta. 

Sin embargo, como advierte la investigación empírica en *Nature Communications*, si la tarifa dinámica no está calibrada con precisión respecto a la elasticidad-precio de los usuarios, puede generar desbalances severos, aumentando drásticamente la tasa de cancelaciones.

---

## 6.7 Inferencia Estadística y Validación de Hipótesis (Estadística II)

Sobre los Data Marts consolidados se despliegan modelos estadísticos rigurosos:

### 1. Regresión Lineal Múltiple de la Demanda:
Se modela el volumen de viajes diarios en función de las perturbaciones exógenas:

$$\text{ViajesDiarios} = \beta_0 + \beta_1 (\text{Precipitacion}_{mm}) + \beta_2 (\text{IndiceCongestion}) + \epsilon$$

evaluando la tabla ANOVA completa ($SCA$, $SCE$, $SCT$, grados de libertad y significancia del estadístico $F$).

### 2. Verificación de Supuestos Gauss-Markov:
* **Normalidad de residuos:** Pruebas de Shapiro-Wilk y Jarque-Bera.
* **Homocedasticidad:** Pruebas de Breusch-Pagan y White.
* **Independencia de errores:** Estadístico de Durbin-Watson para descartar autocorrelación serial.

### 3. Batería de Contrastes de Hipótesis Formales:
* **Prueba $t$ de Welch:** Contrastar si el multiplicador dinámico ($> 1.25\times$) eleva de forma estadísticamente significativa la tarifa final respecto a la tarifa base ($p < 0.05$).
* **Prueba $z$ de dos proporciones:** Verificar si la tasa de cancelación en horas pico (07:00–08:59 y 17:00–18:59) es significativamente superior a la observada en horas valle.
* **ANOVA de un factor:** Determinar si la duración de los viajes difiere significativamente según el estrato socioeconómico del destino (`alto`, `medio`, `popular`, `comercial`).
* **Prueba $\chi^2$ de Independencia:** Contrastar la asociación entre el método de pago preferido y el estrato socioeconómico de origen ($p < 0.01$).

---

## 6.8 Métodos Numéricos en Modelación de Transporte

La matemática computacional y el análisis numérico proporcionan herramientas clave para calibrar el comportamiento de la plataforma:

### 1. Búsqueda de Raíces para el Multiplicador de Equilibrio:
Se define la función de exceso de demanda en el mercado de viajes:

$$f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$$

Se implementan los algoritmos de **Bisección** y **Newton-Raphson** para encontrar la raíz $m^*$ (multiplicador de equilibrio), evaluando la velocidad de convergencia y el error residual.

### 2. Diferenciación Numérica de la Elasticidad-Precio:
Se aproxima la elasticidad-precio de la demanda mediante diferencias finitas centradas de orden $\mathcal{O}(h^2)$:

$$f'(P) \approx \frac{Q(P + h) - Q(P - h)}{2h}, \quad \varepsilon = f'(P) \cdot \frac{P}{Q(P)}$$

determinando si la demanda en los cuadrantes de Managua es elástica ($|\varepsilon| > 1$) o inelástica ($|\varepsilon| < 1$).

### 3. Integración Numérica (Regla de Simpson 1/3):
A partir de la función horaria continua de intensidad de viajes $q(t)$ a lo largo de las 24 horas del día, se aplica la **Regla de Simpson 1/3** para calcular el volumen total acumulado diario de viajes con alta precisión numérica.

---

## 6.9 Modelos de Optimización Prescriptiva (Investigación de Operaciones)

La fase prescriptiva implementa tres algoritmos canónicos de optimización para resolver problemas críticos de la empresa:

### 1. Algoritmo Húngaro (Despacho Óptimo Viaje-Conductor):
Dado un conjunto de $n$ conductores disponibles (monitoreados mediante `/movigo/telemetria`) y $n$ solicitudes simultáneas de viaje, se construye la matriz de tiempos de llegada $C = [c_{ij}]$ y se resuelve el problema de asignación biyectiva que minimiza el tiempo global de respuesta:

$$\min \sum_{i=1}^n \sum_{j=1}^n c_{ij} x_{ij} \quad \text{s.a.} \quad \sum_{j=1}^n x_{ij} = 1, \quad \sum_{i=1}^n x_{ij} = 1, \quad x_{ij} \in \{0, 1\}$$

### 2. Algoritmo de Dijkstra (Ruta Más Corta Bajo Congestión y Lluvia):
La red vial de Managua se modela como un grafo dirigido y ponderado $G = (V, E)$, donde los pesos de los arcos combinan la distancia física y el índice de congestión vial afectado por precipitaciones. Se implementa Dijkstra para determinar la ruta óptima en condiciones ordinarias vs. episodios de lluvia torrencial.

### 3. Problema de la Mochila (Knapsack 0/1 para Campañas de Incentivos):
A partir del catálogo de campañas de bonos (`/movigo/campanas`), la plataforma debe seleccionar qué programas activar para maximizar las horas adicionales de conexión de choferes bajo una restricción de presupuesto máximo de **C$ 120,000 NIO**:

$$\max \sum_{k \in \mathcal{K}} v_k \cdot z_k \quad \text{s.a.} \quad \sum_{k \in \mathcal{K}} w_k \cdot z_k \le 120\,000, \quad z_k \in \{0, 1\}$$

Donde $v_k$ representa las horas ganadas y $w_k$ el costo presupuestario de la campaña $k$.
