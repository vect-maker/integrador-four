# 4. Justificación

## 4.1 Justificación Práctica: Sostenibilidad Económica y Retención de Clientes para MoviGo

La presente investigación se fundamenta en la necesidad operativa de sustituir la calibración empírica y reactiva de tarifas en la plataforma **MoviGo** por un modelo de tarificación y gestión de oferta sustentado en evidencia matemática y econométrica. En el modelo de negocio de las aplicaciones de transporte selectivo, el esquema tarifario dinámico representa tanto la principal fuente de ingresos como el factor determinante de la experiencia del usuario y del conductor (Cachon et al., 2017).

A partir del análisis de los **77,386 registros históricos de viajes** y las series meteorológicas expuestas a través de la API REST, este proyecto aporta beneficios concretos a la gestión empresarial de MoviGo:
* **Mitigación de Ingresos Perdidos por Cancelación:** Identifica los umbrales críticos del multiplicador dinámico a partir de los cuales la probabilidad de cancelación por parte del usuario se dispara, cuantificando el costo de las cotizaciones perdidas.
* **Reducción del Desabastecimiento en Horas Pico:** Diagnostica las brechas de oferta en los corredores más saturados de Managua, determinando cuándo la tarifa regular resulta insuficiente para activar la conexión de conductores.
* **Optimización de Presupuestos Operativos:** Provee un marco riguroso para asignar los fondos destinados a programas de incentivos para socios conductores, sustituyendo el aumento ciego de tarifas por subsidios orientados a objetivos medibles de conexión.

---

## 4.2 Relevancia Científica y Metodológica: Métodos Numéricos y Econometría del Surge Pricing

Desde el punto de vista científico y metodológico, la investigación trasciende la mera analítica descriptiva para articular herramientas formales de **econometría, análisis numérico e investigación de operaciones**:

1. **Modelación Econométrica e Inferencia Rigurosa:** Permite contrastar de manera rigurosa cómo interactúan el multiplicador dinámico, los fenómenos meteorológicos diarios (`precipitacion_mm`) y la saturación del tráfico (`indice_congestion`) sobre el volumen de viajes y la tasa de cancelación, validando formalmente los supuestos clásicos de Gauss-Markov (normalidad, homocedasticidad y no autocorrelación).
2. **Aproximación Numérica de la Elasticidad y Puntos de Equilibrio:** Aborda el problema de calibración tarifaria mediante métodos de búsqueda de raíces (**Bisección y Newton-Raphson**) para resolver numéricamente la función de exceso de demanda:
   $$f(m) = \text{Demanda}(m) - \text{Oferta}(m) = 0$$
   calculando además la elasticidad-precio de la demanda mediante aproximaciones diferenciales de orden $\mathcal{O}(h^2)$ para tipificar el comportamiento elástico o inelástico en cada cuadrante.
3. **Optimización Prescriptiva de la Oferta (Mochila Binaria):** Modela la selección de campañas de bonificación e incentivos para conductores (`/movigo/campanas`) como un **Problema de la Mochila 0/1**, maximizando las horas adicionales de conexión activa bajo una restricción presupuestaria de **C$ 120,000 NIO**.

---

## 4.3 Relevancia Tecnológica y Arquitectura de Ingeniería de Datos (ELT con dbt)

En el ámbito tecnológico, el proyecto resuelve un desafío propio de los entornos de datos contemporáneos: **la inexistencia de acceso directo a la base de datos transaccional y la obligatoriedad de consumir los datos exclusivamente mediante una API REST paginada**.

El pipeline tecnológico implementado demuestra un diseño DataOps escalable y profesional:
1. **Extracción Modular y Paginación Robusta:** Cliente en Python (`httpx`/`requests`) diseñado para consumir colecciones paginadas (`limit=200`, `offset` dinámico), validando esquemas y computando sumas criptográficas **SHA-256** para auditoría y trazabilidad de los datos brutos.
2. **Capa Cruda en PostgreSQL:** Ingesta y normalización relacional de los 7 endpoints de la plataforma MoviGo en tablas crudas locales.
3. **Modelado Dimensional y Transformación con dbt Core:** Construcción de un Data Warehouse bajo metodología Kimball mediante **dbt (Data Build Tool)**, desacoplando staging y marts analíticos, con llaves subrogadas hash (MD5) y una batería exhaustiva de pruebas automáticas de calidad (*dbt tests*) que validan reglas de negocio (`multiplicador_dinamico >= 1.00`, tarifas positivas y unicidad referencial).

---

## 4.4 Relevancia Social y Equidad Territorial en el Municipio de Managua

En términos de impacto social, la investigación incide directamente en la equidad urbana y la justicia algorítmica. De acuerdo con el Plan Maestro de Movilidad Urbana de Managua (JICA, 2017), más de una cuarta parte (26%) de los viajes diarios en la capital se realizan en transporte selectivo, constituyendo un modo de transporte vital para la clase trabajadora, estudiantes y comerciantes que conectan periferias con centros neurálgicos como el Mercado Oriental o Metrocentro.

Un algoritmo de tarifa dinámica descalibrado actúa como una barrera económica excluyente que expulsa a las familias de menores ingresos en momentos de vulnerabilidad (lluvias torrenciales o emergencias). Calibrar la tarifa con consideraciones de equidad socio-espacial y evaluar la correlación entre el estrato económico, el medio de pago preferido (`efectivo`, `tarjeta`, `billetera_digital`) y la propensión a la cancelación garantiza un servicio más accesible e inclusivo para la ciudadanía de Managua.

---

## 4.5 Coherencia Curricular y Formativa (Integrador IV)

El presente estudio satisface plenamente las exigencias académicas y formativas del **Integrador IV** de la carrera de Ingeniería en Ciencia de Datos, articulando los conocimientos de las cinco asignaturas del semestre en torno a un único hilo conductor coherente:

* **Bases de Datos Analíticas:** Arquitectura ELT, diseño dimensional en estrella (`fact_viajes`) y materialización con **dbt Core** sobre PostgreSQL.
* **Programación en Scripting:** Ingesta automatizada de la API REST, paginación, serialización Parquet y control de integridad DataOps.
* **Estadística Aplicada (Estadística II):** Modelos de regresión múltiple, batería de contrastes de hipótesis (Welch, ANOVA, Chi-cuadrado, proporciones z) y verificación Gauss-Markov.
* **Métodos Numéricos:** Solución numérica de ecuaciones no lineales ($f(m)=0$) mediante Bisección y Newton-Raphson, derivación numérica de elasticidad e integración con la regla de Simpson 1/3.
* **Investigación de Operaciones / Optimización:** Programación entera binaria (Problema de la Mochila 0/1) para la selección de campañas de incentivos presupuestarias.
