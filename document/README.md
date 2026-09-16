# Optimización de la Distribución Territorial de la Flota Vehicular y del Sistema Tarifario — Movi Go

**Área de Conocimiento de Ciencias Básicas y Tecnología**  
**Carrera:** Ingeniería en Ciencia de Datos  
**Asignatura:** Integrador IV  
**Tipo de Documento:** Avance de Investigación  
**Período:** Segundo Año • Segundo Semestre 2026  
**Sede:** Managua, Nicaragua  

---

## Estructura del Documento de Investigación

El documento de investigación del proyecto ha sido organizado de manera modular en los siguientes archivos temáticos:

| No. | Archivo | Descripción del Contenido |
| :---: | :--- | :--- |
| **01** | [`01_contextualizacion.md`](./01_contextualizacion.md) | Contextualización de Movi Go, categorías de flota, dinámica urbana de Managua, clima sintético con congestión vial y acceso vía API REST. |
| **02** | [`02_antecedentes.md`](./02_antecedentes.md) | Revisión del estado del arte en asignación dinámica, tarificación con *surge pricing*, impacto meteorológico y diagnóstico de movilidad en Managua. |
| **03** | [`03_planteamiento_del_problema.md`](./03_planteamiento_del_problema.md) | Desbalance espaciotemporal, cancelaciones en horas pico, congestión por lluvias torrenciales y necesidad de calibración matemática de la tarifa y flota. |
| **04** | [`04_justificacion.md`](./04_justificacion.md) | Justificación práctica con ~65,000 viajes anuales, tecnológica (API REST &rarr; pandas &rarr; PostgreSQL &rarr; dbt) y curricular (las 5 materias del Integrador IV). |
| **05** | [`05_objetivos.md`](./05_objetivos.md) | Objetivo General y cuatro Objetivos Específicos alineados a la ingeniería de datos, inferencia estadística, métodos numéricos y optimización. |
| **06** | [`06_marco_teorico.md`](./06_marco_teorico.md) | Fundamentos de arquitectura de datos (API/ELT/dbt), modelo dimensional Kimball, teoría de *surge pricing*, algoritmos de despacho (Húngaro, Dijkstra, Mochila) y raíces numéricas. |
| **07** | [`07_matriz_de_descriptores.md`](./07_matriz_de_descriptores.md) | Operacionalización de variables, dimensiones, indicadores empíricos e instrumentos de recolección basados en los endpoints de la API. |
| **08** | [`08_diseno_metodologico.md`](./08_diseno_metodologico.md) | Enfoque cuantitativo no experimental sobre el servicio selectivo Movi Go, arquitectura de ingesta API &rarr; PostgreSQL, modelo en estrella `fact_viajes` y suite analítica. |

---

## Síntesis Ejecutiva del Proyecto

El proyecto tiene como propósito optimizar la asignación territorial de la flota de transporte selectivo de la empresa **Movi Go** en el municipio de Managua y evaluar el equilibrio de su sistema de tarifa dinámica (*surge pricing*), considerando factores operativos, espaciales y meteorológicos.

A diferencia de aproximaciones abstractas, la investigación se fundamenta en un ecosistema de datos completo expuesto a través de una **API REST dedicada (`/movigo`)** que registra más de **65,000 viajes anuales**, series de telemetría GPS en tiempo real, cuadrantes urbanos georreferenciados en Managua, directorio de conductores y pasajeros, programas de incentivos y series temporales sincronizadas de precipitación e índice de congestión vial.

El flujo de ingeniería de datos inicia mediante un cliente extractor en Python con paginación optimizada que descarga los datos de la API, reconstruye las relaciones relacionales e ingesta los datos hacia una base de datos relacional **PostgreSQL**. A partir de este repositorio central se orquesta el pipeline ELT con **dbt**, materializando un **Data Warehouse en estrella (Kimball)** gobernado por pruebas automatizadas de integridad. 

Sobre estos Data Marts se articulan las cinco disciplinas del Integrador IV:
1. **Bases de Datos Analíticas:** Data Warehouse estrella (`fact_viajes`), linaje con dbt y dashboards de BI.
2. **Programación en Scripting:** Automatización del cliente API REST, almacenamiento en Parquet y alertas DataOps de cancelación.
3. **Estadística II:** Regresión múltiple (demanda vs. lluvia y congestión), ANOVA de duración por estrato, validación Gauss-Markov y pruebas de hipótesis (Welch para tarifa dinámica, $z$ de cancelaciones, $\chi^2$ de pagos).
4. **Métodos Numéricos:** Bisección y Newton-Raphson para el multiplicador de equilibrio $m^*$, diferenciación numérica $\mathcal{O}(h^2)$ para elasticidad-precio e integración Simpson 1/3 para el volumen acumulado de viajes.
5. **Optimización:** Algoritmo Húngaro para asignación óptima conductor-viaje, Dijkstra para rutas críticas bajo inundación y Problema de la Mochila 0/1 para maximizar horas de conexión en campañas con restricción de C$ 120,000 NIO.
