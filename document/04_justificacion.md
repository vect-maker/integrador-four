# 4. Justificación

## 4.1 Justificación Práctica: Gestión Basada en Evidencia para Movi Go

La presente investigación se justifica por la necesidad de abordar la gestión operativa del transporte selectivo por aplicación desde una perspectiva basada en evidencia empírica. La literatura especializada demuestra que la correspondencia dinámica entre localización de vehículos, demanda y decisiones de asignación constituye un pilar esencial para elevar el rendimiento del sistema (Alonso-Mora et al., 2017; Jiao et al., 2021).

A través del acceso a un volumen de más de **65,000 registros anuales de viajes** expuestos vía API, el estudio permite a Movi Go:
* Identificar con precisión matemática las franjas horarias y cuadrantes urbanos donde se concentran los cuellos de botella de la demanda en Managua.
* Cuantificar la pérdida económica derivada de los recorridos en vacío (*deadhead miles*) y las cancelaciones recurrentes en horas pico.
* Evaluar el comportamiento real de los conductores registrados en sus tres categorías (`movigo_estandar`, `movigo_comfort`, `movigo_moto`), analizando sus tasas de aceptación y tiempos de respuesta.

Esta información deja de ser una apreciación cualitativa para transformarse en métricas operativas contrastables que orienten el despacho y la retención de socios conductores.

---

## 4.2 Relevancia del Análisis Tarifario y Calibración del Surge Pricing

El análisis del sistema tarifario es fundamental para garantizar la sostenibilidad del servicio. Dado que Movi Go opera con una tarifa paramétrica estructurada:

$$\text{TarifaBase} = \text{BajadaBandera} + (18 \times \text{distancia\_km}) + (4.5 \times \text{duracion\_minutos})$$

$$\text{TarifaFinal} = \text{TarifaBase} \times \text{multiplicador\_dinamico}$$

donde la bajada de bandera varía por zona entre C$ 30 y C$ 90 NIO y el multiplicador dinámico oscila entre $1.00\times$ y $3.20\times$, la investigación permite comprobar si los incrementos tarifarios responden efectivamente a desbalances de mercado o si terminan castigando al usuario e induciendo cancelaciones masivas. 

Calibrar el multiplicador mediante métodos cuantitativos ofrece una base sólida para fijar precios justos y competitivos que conserven la lealtad del cliente sin desincentivar la conexión de choferes.

---

## 4.3 Relevancia Tecnológica y Flujo de Ingeniería de Datos

Desde la perspectiva técnica y de gestión de datos, el proyecto cobra una relevancia destacada al resolver el reto de **integrar datos transaccionales no accesibles directamente por base de datos, sino a través de una API REST**.

El pipeline tecnológico implementado demuestra un diseño robusto y moderno:
1. **Extracción y Paginación:** Script en Python (`httpx`/`requests`) que consume colecciones paginadas de hasta 200 registros por página, reconstruyendo llaves y relaciones en memoria mediante **pandas**.
2. **Capa Operativa Relacional:** Ingesta estructurada hacia **PostgreSQL** para consolidar la capa cruda (*raw data layer*).
3. **Modelado Dimensional y Gobierno:** Transformación con **dbt Core**, estructurando un esquema en estrella con la tabla de hechos atómica `fact_viajes` y dimensiones conformadas, protegidas mediante pruebas de calidad (*dbt tests*) que validan la no negatividad y las reglas de dominio.
4. **DataOps y Auditoría:** Almacenamiento seguro en formato columnar **Parquet** con cálculo de sumas de comprobación **SHA-256** para certificar la integridad de los datos.

---

## 4.4 Modelación Analítica, Simulación y Métodos Numéricos

La modelación matemática y el análisis cuantitativo permiten evaluar el comportamiento del sistema y explorar alternativas analíticas sin perturbar la operación real de la empresa:
* **Estimación de Equilibrio y Dinámica Tarifaria:** Modelos para evaluar la respuesta de la demanda ante multiplicadores dinámicos ($f(m) = 0$), explorando métodos de resolución iterativa o búsqueda de raíces numéricas (tales como Bisección o Newton-Raphson como alternativas metodológicas).
* **Sensibilidad y Elasticidad:** Análisis de la elasticidad-precio de la demanda mediante aproximaciones diferenciales numéricas o empíricas según la dispersión zonal de los datos.
* **Agregación de Flujos:** Técnicas de integración numérica o aproximación temporal continua para estimar volúmenes diarios acumulados a partir de curvas horarias.

---

## 4.5 Optimización Prescriptiva y Estrategias de Operación

En el plano de la Investigación de Operaciones, el estudio formula y evalúa modelos prescriptivos adaptables a los problemas de movilidad urbana:
1. **Modelos de Asignación de Flota:** Enfoques de optimización combinatoria y emparejamiento (por ejemplo, formulaciones tipo Algoritmo Húngaro o programación lineal) para relacionar vehículos disponibles y solicitudes entrantes minimizando tiempos de espera.
2. **Ruteo y Redes Viales:** Análisis de caminos óptimos en grafos bajo congestión o perturbaciones climáticas (evaluando algoritmos de caminos mínimos como Dijkstra o similares en la red de cuadrantes).
3. **Estrategias de Incentivos y Cobertura:** Formulación de modelos de asignación de recursos o incentivos operativos para conductores, evaluables bajo restricciones presupuestarias y escenarios de demanda pico.

---

## 4.6 Relevancia Social, Urbana y Formativa (Integrador IV)

Desde una perspectiva social y urbana, optimizar el transporte selectivo en Managua contribuye a mejorar la accesibilidad de la ciudadanía en una ciudad donde el 26% de los traslados diarios dependen de este modo de transporte (JICA, 2017). Un despacho más ágil reduce la congestión vial, disminuye la emisión de contaminantes por recorridos ociosos y proporciona tarifas previsibles y transparentes.

En el ámbito académico, el proyecto responde con fidelidad a los objetivos formativos del **Integrador IV**, articulando de manera armónica las áreas temáticas del semestre:
* **Bases de Datos Analíticas:** Arquitectura ELT, modelado y transformación analítica con **dbt**, diseño dimensional y tableros BI.
* **Programación en Scripting:** Ingesta automatizada de la API REST, paginación, exportación a Parquet y flujos DataOps.
* **Estadística Aplicada:** Modelación econométrica/estadística de la demanda, inferencia multivariada y contrastes de hipótesis contextuales.
* **Métodos Numéricos:** Exploración de esquemas iterativos para calibración de tarifas, elasticidad y aproximación de volumen de flujos.
* **Optimización e Investigación de Operaciones:** Modelos prescriptivos de asignación de recursos, ruteo en redes y distribución territorial de flota.
