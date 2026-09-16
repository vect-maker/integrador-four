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

## 4.4 Modelación, Simulación y Métodos Numéricos

La modelación matemática y el análisis numérico adquieren protagonismo al permitir simular el comportamiento del sistema sin perturbar la operación real de la empresa:
* **Búsqueda de Raíces (Bisección y Newton-Raphson):** Permite hallar el multiplicador de equilibrio $m^*$ que anula el exceso de demanda ($f(m) = 0$).
* **Diferenciación Numérica $\mathcal{O}(h^2)$:** Permite estimar la elasticidad-precio de la demanda en diferentes zonas de la capital mediante diferencias finitas centrales.
* **Integración Numérica (Simpson 1/3):** Permite aproximar el volumen total acumulado de viajes a partir de la función de intensidad horaria diaria.

---

## 4.5 Optimización Prescriptiva y Asignación de Recursos

En el plano de la Investigación de Operaciones, el estudio proporciona soluciones prescriptivas concretas a problemas clásicos de movilidad:
1. **Algoritmo Húngaro:** Resuelve el problema de asignación biyectiva óptima entre solicitudes entrantes y vehículos desocupados monitoreados por telemetría GPS, minimizando el tiempo total de espera.
2. **Algoritmo de Dijkstra:** Determina la ruta más corta y menos congestionada entre cuadrantes urbanos representados como grafos ponderados, comparando condiciones de flujo libre frente a inundaciones por tormenta.
3. **Problema de la Mochila (Knapsack 0/1):** Optimiza la selección de campañas de incentivos y bonos para conductores (`/movigo/campanas`) maximizando las horas-hombre de conexión ganadas bajo una restricción de presupuesto de **C$ 120,000 NIO**.

---

## 4.6 Relevancia Social, Urbana y Formativa (Integrador IV)

Desde una perspectiva social y urbana, optimizar el transporte selectivo en Managua contribuye a mejorar la accesibilidad de la ciudadanía en una ciudad donde el 26% de los traslados diarios dependen de este modo de transporte (JICA, 2017). Un despacho más ágil reduce la congestión vial, disminuye la emisión de contaminantes por recorridos ociosos y proporciona tarifas previsibles y transparentes.

En el ámbito académico, el proyecto responde con fidelidad a los objetivos formativos del **Integrador IV**, articulando de manera armónica las cinco asignaturas del semestre:
* **Bases de Datos Analíticas:** Arquitectura ELT, dbt, modelado dimensional Kimball y tableros BI.
* **Programación en Scripting:** Ingesta de APIs REST, paginación, exportación a Parquet y scripts de alerta DataOps.
* **Estadística II:** Regresión lineal múltiple (viajes vs. lluvia y congestión), ANOVA, contrastes de hipótesis (Welch, proporciones $z$, estratos, $\chi^2$) y verificación de supuestos Gauss-Markov.
* **Métodos Numéricos:** Raíces de funciones no lineales (Bisección y Newton-Raphson), diferenciación numérica e integración Simpson 1/3.
* **Optimización:** Asignación con Algoritmo Húngaro, rutas mínimas con Dijkstra y optimización combinatoria 0/1 Knapsack.
