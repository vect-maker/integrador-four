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
| **05** | [`05_objetivos.md`](./05_objetivos.md) | Objetivo General (*Optimizar*) y cuatro Objetivos Específicos centrados en verbos de acción (*Estructurar*, *Analizar*, *Evaluar*, *Formular*). |
| **06** | [`06_marco_teorico.md`](./06_marco_teorico.md) | Fundamentos de arquitectura de datos (API/ELT/dbt), modelo dimensional Kimball, teoría de *surge pricing*, algoritmos de despacho (Húngaro, Dijkstra, Mochila) y raíces numéricas. |
| **07** | [`07_matriz_de_descriptores.md`](./07_matriz_de_descriptores.md) | Operacionalización de variables, dimensiones, indicadores empíricos e instrumentos de recolección basados en los endpoints de la API. |
| **08** | [`08_diseno_metodologico.md`](./08_diseno_metodologico.md) | Enfoque cuantitativo no experimental sobre el servicio selectivo Movi Go, arquitectura de ingesta API &rarr; PostgreSQL, modelo en estrella `fact_viajes` y suite analítica. |

---

## Síntesis Ejecutiva del Proyecto

El proyecto tiene como propósito optimizar la asignación territorial de la flota de transporte selectivo de la empresa **Movi Go** en el municipio de Managua y evaluar el equilibrio de su sistema de tarifa dinámica (*surge pricing*), considerando factores operativos, espaciales y meteorológicos.

A diferencia de aproximaciones abstractas, la investigación se fundamenta en un ecosistema de datos completo expuesto a través de una **API REST dedicada (`/movigo`)** que registra más de **65,000 viajes anuales**, series de telemetría GPS en tiempo real, cuadrantes urbanos georreferenciados en Managua, directorio de conductores y pasajeros, programas de incentivos y series temporales sincronizadas de precipitación e índice de congestión vial.

El flujo de ingeniería de datos inicia mediante un cliente extractor en Python con paginación optimizada que descarga los datos de la API, reconstruye las relaciones relacionales e ingesta los datos hacia una base de datos relacional **PostgreSQL**. A partir de este repositorio central se orquesta el pipeline ELT con **dbt**, materializando un **Data Warehouse en estrella (Kimball)** gobernado por pruebas automatizadas de integridad. 

Sobre estos Data Marts conformados con dbt se articulan las áreas del Integrador IV:
1. **Bases de Datos Analíticas:** Arquitectura analítica y transformación con **dbt**, diseño dimensional (`fact_viajes`) y tableros BI.
2. **Programación en Scripting:** Ingesta y consumo automatizado de la API REST (`/movigo`), paginación, almacenamiento en Parquet y DataOps.
3. **Estadística Aplicada:** Modelación de demanda, inferencia sobre factores climáticos/congestión y contrastes de hipótesis contextuales.
4. **Métodos Numéricos:** Exploración de esquemas iterativos para calibración tarifaria ($m^*$), estimación de elasticidades e integración de flujos.
5. **Optimización Operativa:** Modelos prescriptivos de asignación de flota, mitigación de recorridos en vacío (*deadhead*) y análisis de ruteo territorial.
