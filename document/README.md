# Eficacia y Calibración de la Tarifa Dinámica en el Transporte Selectivo — MoviGo (Managua)

**Área de Conocimiento de Ciencias Básicas y Tecnología**  
**Carrera:** Ingeniería en Ciencia de Datos  
**Asignatura:** Integrador IV  
**Tipo de Documento:** Propuesta y Avance de Investigación  
**Período:** Segundo Año • Segundo Semestre 2026  
**Sede:** Managua, Nicaragua  

---

## Estructura Modular del Documento de Investigación

El documento de investigación se organiza en ocho archivos temáticos alineados con el **Enfoque A: Calibración de la Tarifa Dinámica, Sensibilidad de la Demanda, Mitigación de Cancelaciones y Equidad Socio-Espacial**:

| No. | Archivo | Descripción del Contenido |
| :---: | :--- | :--- |
| **01** | [`01_contextualizacion.md`](./01_contextualizacion.md) | Contextualización de MoviGo, mecánica de la tarifa paramétrica y el multiplicador dinámico, estratificación de los 12 cuadrantes urbanos de Managua, choques de lluvia y acceso exclusivo vía API REST. |
| **02** | [`02_antecedentes.md`](./02_antecedentes.md) | Revisión de literatura sobre mercados bilaterales de movilidad, tarificación dinámica (*surge pricing*), elasticidad y abandono del servicio, equidad socio-espacial, incentivos a conductores y Plan Maestro JICA 2017. |
| **03** | [`03_planteamiento_del_problema.md`](./03_planteamiento_del_problema.md) | El dilema de calibración de la tarifa dinámica: sobredimensión de precios y cancelaciones de usuarios vs. subestimación y escasez de flota; asimetrías socioeconómicas por estrato y pregunta central de investigación. |
| **04** | [`04_justificacion.md`](./04_justificacion.md) | Justificación práctica empresarial para MoviGo, relevancia metodológica (econometría + análisis numérico + optimización), arquitectura de datos DataOps y coherencia curricular con el Integrador IV. |
| **05** | [`05_objetivos.md`](./05_objetivos.md) | Objetivo General focalizado en la evaluación de la tarifa dinámica, cancelaciones y equidad; y cuatro Objetivos Específicos secuenciales (*Consolidar*, *Determinar*, *Modelar*, *Diseñar*). |
| **06** | [`06_marco_teorico.md`](./06_marco_teorico.md) | Teoría microeconómica de mercados bilaterales, modelado dimensional Kimball con dbt, econometría y supuestos Gauss-Markov, métodos de raíces (Newton-Raphson/Bisección) y problema de la mochila 0/1. |
| **07** | [`07_matriz_de_descriptores.md`](./07_matriz_de_descriptores.md) | Matriz formal de operacionalización de variables, dimensiones, indicadores empíricos y articulación con las herramientas técnicas del proyecto. |
| **08** | [`08_diseno_metodologico.md`](./08_diseno_metodologico.md) | Diseño cuantitativo no experimental, pipeline ELT (API REST &rarr; Python &rarr; PostgreSQL &rarr; dbt Core), esquema en estrella `fact_viajes`, batería de inferencia estadística, métodos numéricos y optimización prescriptiva. |

---

## Síntesis Ejecutiva del Proyecto

El proyecto investiga la eficacia, calibración y equidad del esquema de **tarificación dinámica (*surge pricing*)** de la plataforma de transporte selectivo **MoviGo** en el municipio de Managua. 

A partir del consumo directo de una **API REST pública (`http://4.157.251.192:8000/movigo`)** que modela la operación anual de la empresa con **más de 77,000 registros transaccionales**, series telemétricas GPS, catálogos zonales y registros diarios de precipitación y congestión vial, la investigación resuelve el dilema entre maximización de ingresos, abastecimiento vehicular y retención de usuarios.

### Articulación Interdisciplinaria (Integrador IV):
1. **Bases de Datos Analíticas & DataOps:** Extracción paginada en Python, auditoría con sumas de comprobación SHA-256 en Parquet, carga en PostgreSQL y transformación analítica con **dbt Core** (esquema dimensional Kimball centrado en `fact_viajes` con pruebas automáticas de calidad).
2. **Estadística II (Econometría e Inferencia):** Modelación de la demanda diaria frente a precipitaciones e índice de congestión mediante regresión lineal múltiple con validación Gauss-Markov (Shapiro-Wilk, Breusch-Pagan, Durbin-Watson) y contrastes de hipótesis (Welch $t$, proporciones $z$, ANOVA por estratos y $\chi^2$ de medios de pago).
3. **Métodos Numéricos:** Estimación del multiplicador de equilibrio $m^*$ resolviendo la función de exceso de demanda $f(m) = 0$ con **Bisección y Newton-Raphson**, diferenciación numérica centrada $\mathcal{O}(h^2)$ para aproximar la elasticidad-precio zonal e integración de Simpson 1/3 para el volumen diario continuo.
4. **Optimización Prescriptiva (Investigación de Operaciones):** Formulación del **Problema de la Mochila Binaria (0/1 Knapsack)** sobre las campañas de bonos para choferes (`/movigo/campanas`) bajo un presupuesto de **C$ 120,000 NIO**, maximizando las horas de conexión vehicular como alternativa estructural al incremento excesivo de tarifas dinámicas.
