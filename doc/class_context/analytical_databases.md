# Diseño y Uso de Bases de Datos Analíticas

## Ficha Técnica del Componente Curricular

| Parámetro | Detalle |
| :--- | :--- |
| **Carrera** | Ingeniería en Ciencia de Datos |
| **Facultad** | Ciencias e Ingenierías |
| **Departamento** | Matemática |
| **Componente Curricular** | Diseño y Uso de Bases de Datos Analíticas |
| **Código** | *(Sin asignar)* |
| **Modalidad Educativa** | Presencial |
| **Régimen Temporal** | Semestral |
| **Ubicación en Ciclo Académico** | IV Semestre |
| **Año Académico** | Segundo Año |
| **Prerrequisito** | Bases de Datos Relacionales |
| **Frecuencia Semanal** | 4 Horas |
| **Área de Formación** | Arquitectura de Datos |
| **Aprobación** | Dra. Ana Marcela Abea Pérez (Directora del Departamento de Matemática) |
| **Fecha de Aprobación** | Octubre 2023 |

---

## 1. Datos Preliminares y Distribución Horaria

| N° | Temas | HT | HL | HPr | HTI | P.LAB.INV | Total Horas | Créditos |
| :-: | :--- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1 | Introducción a los almacenes de datos y su comparación con las bases de datos relacionales | 6 | — | 12 | 20 | — | 38 | 3 |
| 2 | Construcción de la factoría de información corporativa | 7 | — | 14 | 25 | — | 46 | — |
| 3 | Diseño multidimensional y explotación de datos | 7 | — | 14 | 30 | — | 51 | — |
| | **Totales** | **20** | — | **40** | **75** | — | **135** | **3** |

> **Glosario de Modalidades Horarias:**
> - **HT**: Horas Teóricas
> - **HL**: Horas en Línea
> - **HPr**: Horas Prácticas (laboratorios, trabajo de campo, interactividad)
> - **HTI**: Horas de Trabajo Independiente controlado por el docente
> - **P.LAB.INV**: Práctica Laboral e Investigativa

---

## 2. Descriptor del Programa

El programa *Diseño y Uso de Bases de Datos Analíticas*, con 135 horas y 3 créditos, cubre la introducción a las bases de datos analíticas, la construcción de factorías de información corporativa y el diseño y explotación multidimensional de datos. Los objetivos incluyen:

- Distinguir entre almacenes de datos (*Data Warehouse*) y bases de datos relacionales (*OLTP*).
- Desarrollar estrategias para construir sistemas de *Data Warehouse* efectivos.
- Diseñar e implementar modelos multidimensionales para la explotación analítica de datos.

Este componente desarrolla habilidades en la evaluación y optimización de data warehouses, la planificación y ejecución de la transformación e integración de datos (ETL/ELT), y el uso de herramientas OLAP para análisis profundos. Promueve valores como compromiso social, responsabilidad social e institucional, ética profesional, equidad, tolerancia y solidaridad, enfatizando en la aplicación ética y responsable de tecnologías analíticas.

---

## 3. Fundamento del Componente Curricular

En una era donde el volumen de datos generados crece exponencialmente, la habilidad de diseñar y utilizar bases de datos analíticas se ha convertido en un imperativo para cualquier científico de datos.

El componente *Diseño y Uso de Bases de Datos Analíticas* responde a esta demanda ofreciendo una profundización en técnicas y herramientas que permiten estructurar, almacenar y extraer valor de grandes conjuntos de datos. Este componente no solo proporciona las habilidades técnicas necesarias, sino también una comprensión de cómo las decisiones en el diseño de bases de datos impactan en la obtención de perspectivas valiosas y en la toma de decisiones informadas a nivel estratégico y táctico.

---

## 4. Objetivos de Aprendizaje a Lograr

- Distinguir las características fundamentales, ventajas y desventajas de los almacenes de datos (*Data Warehouse*) en relación con las bases de datos relacionales transaccionales, comprendiendo su importancia en el ámbito analítico.
- Dominar las estrategias y pasos esenciales para la construcción efectiva de un sistema de data warehouse, así como el proceso de transformación e integración en la factoría de información corporativa.
- Diseñar, implementar y optimizar modelos multidimensionales, comprendiendo cada etapa del proceso de diseño (conceptual, lógico y físico), explotando eficientemente los datos mediante herramientas OLAP.
- Reforzar las habilidades técnicas y conocimientos necesarios para optar a certificaciones relevantes en el campo de la Ciencia de Datos e Ingeniería de Datos.
- Fomentar la conciencia de construir un mundo justo y equitativo, destacando el papel de las mujeres en el desarrollo económico y social actual, promoviendo el respeto a las diferencias y la equidad social.

---

## 5. Competencias a Desarrollar

### 5.1 Competencias Genéricas
- Capacidad para comunicarse de manera oral y escrita en diferentes contextos de actuación.
- Capacidad de identificar y resolver problemas de manera individual y en equipos, en los diferentes ámbitos de actuación y campos de acción profesional, a través de la investigación.
- Capacidad de demostrar creatividad para hacer avanzar los diferentes ámbitos de actuación y campos de acción profesional donde se desempeña.
- Capacidad para utilizar las TIC como apoyo para mejorar el aprendizaje en diferentes ámbitos de actuación y campos de acción profesional.
- Capacidad de comprender la realidad socioeconómica, política e histórica del país y actuar en su desarrollo social.

### 5.2 Competencias Específicas
- Capacidad de desarrollar soluciones de ingeniería de datos escalables y eficientes, mediante la recolección, limpieza, transformación y almacenamiento de datos de diversas fuentes, garantizando la integridad, seguridad y disponibilidad de los datos en todo el ciclo de vida del proyecto.
- Capacidad de comunicar de manera efectiva los resultados y hallazgos derivados del análisis de datos, adaptando la presentación según la audiencia, utilizando visualizaciones claras y narrativas sólidas que faciliten la comprensión y respalden la toma de decisiones estratégicas.

---

## 6. Conocimientos Esenciales (Temario Detallado)

### Tema 1: Introducción a los almacenes de datos y su comparación con las bases de datos relacionales
- **Definiciones y conceptos clave:**
  - Bases de datos (DB): Definición y propósito.
  - Data Warehouse (DW): Definición y propósito.
  - Diferencias fundamentales entre DB transaccional (OLTP) y DW analítico (OLAP).
- **Historia y evolución:**
  - Breve historia de las bases de datos relacionales.
  - Surgimiento y evolución de los almacenes de datos corporativos.
- **Arquitectura y diseño:**
  - Arquitectura de una base de datos relacional: tablas, relaciones, claves primarias y foráneas.
  - Arquitectura de un Data Warehouse: esquemas estrella (*star schema*), copo de nieve (*snowflake*) y galaxia / constelación.
  - Zonas de datos: *landing*, *staging*, almacén central y presentación (*marts*).
  - Proceso ETL/ELT (Extract, Transform, Load).
- **Características y funcionalidades:**
  - Operaciones y transacciones en bases de datos relacionales (ACID).
  - Consultas analíticas y operaciones agregadas en Data Warehouses.
- **Ventajas y limitaciones:**
  - Ventajas y limitaciones de las bases de datos relacionales para analítica.
  - Ventajas y limitaciones de los Data Warehouses y motores OLAP columnares.
- **Casos de uso y tendencias:**
  - Ejemplos prácticos y comparativos de aplicación en la industria.
  - Desafíos de escalabilidad, Data Lakes, bases de datos NoSQL y lakehouses modernos.

### Tema 2: Construcción de la factoría de información corporativa
- **Introducción a la Factoría de Información Corporativa (FIC):**
  - Definición y objetivos de la FIC.
  - Relevancia en la estrategia de negocio y soporte a la toma de decisiones.
- **Estrategias de construcción del Data Warehouse:**
  - Enfoque *Top-Down* (Inmon).
  - Enfoque *Bottom-Up* (Kimball).
  - Enfoque híbrido y criterios de selección tecnológica.
- **Fases y pasos en la construcción del Data Warehouse:**
  - Planificación y definición del alcance del negocio.
  - Diseño del modelo de datos dimensional.
  - Selección y evaluación de herramientas y tecnologías (RDBMS, dbt, DuckDB).
  - Construcción, pruebas, validación, implementación, despliegue y mantenimiento.
- **Componentes clave de la FIC:**
  - Data Marts departamentales.
  - Repositorios de metadatos y catálogo de datos.
  - Procesos ETL/ELT: extracción, limpieza, transformación, manejo de valores nulos, normalización/desnormalización, agregación y carga.
  - Calidad de datos, integridad y seguridad.
- **Casos de estudio y tendencias:**
  - Ejemplos de implementación de FIC en diversos sectores y lecciones aprendidas.
  - Evolución hacia Data Lakes, ingesta en tiempo real y privacidad de datos.

### Tema 3: Diseño multidimensional y explotación de datos
- **Necesidades del analista de datos:**
  - Roles, responsabilidades y desafíos en la exploración analítica.
- **Herramientas OLAP y modelos multidimensionales:**
  - Definición, propósito, ventajas y comparación con sistemas OLTP.
  - Conceptos clave: dimensiones, tablas de hechos (*fact tables*), medidas, jerarquías, atributos y granularidad del hecho.
- **Proceso de diseño multidimensional:**
  - **Diseño Conceptual:** Identificación de procesos de negocio, hechos, medidas y dimensiones.
  - **Diseño Lógico:** Construcción de esquemas estrella, copo de nieve y constelación; decisiones de desnormalización y cálculos derivados.
  - **Diseño Físico:** Implementación en motores relacionales/analíticos, particionamiento, indexación y vistas materializadas.
- **Operaciones de explotación y consulta:**
  - Consultas multidimensionales (SQL analítico, funciones de ventana, MDX).
  - Técnicas OLAP: *drill-down*, *roll-up*, *slice*, *dice* y *pivot*.
  - Visualización, dashboards y representación gráfica de resultados.

### Temas transversales:
- Igualdad de género.
- Derechos humanos y respeto a la diversidad.
- Sostenibilidad, mujer y medio ambiente.

---

## 7. Habilidades Principales a Desarrollar

- Capacidad para evaluar y diferenciar las características, ventajas y desventajas entre data warehouses y bases de datos relacionales transaccionales.
- Comprender y valorar la relevancia de los almacenes de datos en contextos analíticos y su impacto en la toma de decisiones estratégicas.
- Dominio en la planificación y aplicación de metodologías de construcción de data warehouses (Inmon vs. Kimball).
- Habilidad para dirigir y ejecutar procesos de integración y transformación de datos en un contexto corporativo.
- Competencia para diseñar estructuras de datos multidimensionales en sus tres etapas: conceptual, lógica y física.
- Capacidad para implementar modelos dimensionales optimizados en sistemas analíticos.
- Habilidad para identificar cuellos de botella de rendimiento y optimizar esquemas dimensionales.
- Dominio en la explotación analítica mediante consultas OLAP, permitiendo análisis profundos y extracción de patrones de negocio.

---

## 8. Valores Fundamentales

- Compromiso Social
- Responsabilidad Social e Institucional
- Ética Profesional
- Equidad
- Tolerancia y Solidaridad

---

## 9. Indicaciones Metodológicas y de Organización

- **Tema 1 (Almacenes vs. Bases Relacionales):** Exploración guiada de bases de datos analíticas en tiempo real con análisis comparativo estructural y funcional. Utilizar diagramas comparativos y casos de estudio reales para fomentar el pensamiento crítico sobre arquitectura de almacenamiento.
- **Tema 2 (Factoría de Información Corporativa):** Simulación de sistemas de data warehouse e interacción con herramientas ETL/ELT (extracción, limpieza, orquestación). Análisis de casos reales de integración empresarial, elaboración de diagramas de flujo y modelos de datos.
- **Tema 3 (Diseño Multidimensional y OLAP):** Metodología de aprendizaje activo basada en proyectos colaborativos. Diseño integral de esquemas estrella (hechos y dimensiones), construcción de consultas analíticas y ejercicios de *drill-down*, *slice & dice* y agregaciones.
- **Transversalidad e Internacionalización:** Promover lectura crítica de artículos sobre normativas APA y ética de la investigación. Orientar talleres de preparación para certificaciones internacionales en Ciencia e Ingeniería de Datos (Azure Data Engineer, dbt Certified Developer, AWS Data Analytics).

---

## 10. Sistema de Evaluación

La evaluación del componente curricular será formativa a lo largo de las sesiones y sumativa al finalizar mediante la estrategia integradora correspondiente al Componente Curricular Integrador, en escala de 2 a 5 por cada corte evaluativo.

### 10.1 Escala de Calificación

| Nivel | Descripción del Desempeño | Calificación | Juicio de Aprobación |
| :-: | :--- | :--- | :--- |
| **5** | Alcanzado | Aprobado | Aprobado con excelencia |
| **4** | En proceso avanzado de logro | Aprobado | Requiere esfuerzo complementario y tutoría |
| **3** | En proceso limitado de logro | Aprobado | Requiere alto esfuerzo y tutoría intensiva |
| **2** | No alcanzado | Reprobado | No cumple los logros mínimos de competencia |

### 10.2 Rúbrica de Evaluación por Competencias

| Dimensión | Indicador de Logro | Nivel 5 (Alcanzado) | Nivel 4 (Avanzado) | Nivel 3 (Intermedio) | Nivel 2 (No Alcanzado) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Conceptual** | Principios fundamentales y avanzados de bases de datos analíticas | Demuestra una comprensión profunda y crítica de los principios fundamentales y avanzados del diseño y uso de bases de datos analíticas. | Comprende y aplica de manera efectiva los principios del diseño y uso de bases de datos analíticas en contextos variados. | Muestra una comprensión básica de los principios subyacentes del diseño y uso de bases de datos analíticas. | Posee conocimientos elementales sobre el diseño y uso de bases de datos analíticas. |
| **Procedimental** | Implementación y optimización autónoma de modelos analíticos | Diseña, implementa y optimiza de manera autónoma bases de datos analíticas para casos complejos. | Aplica procedimientos estándar en el diseño y uso de bases de datos analíticas, identificando y corrigiendo errores. | Utiliza procedimientos básicos para diseñar y usar bases de datos analíticas con supervisión. | Reconoce los procedimientos fundamentales, pero requiere guía constante para su implementación. |
| **Actitudinal** | Actitud proactiva, ética y colaborativa en analítica de datos | Muestra una actitud proactiva y colaborativa, liderando proyectos y promoviendo la innovación en el diseño y uso de bases de datos analíticas. | Participa activamente y colabora en proyectos de bases de datos analíticas, mostrando compromiso y ética profesional. | Muestra interés en aprender y aplicar conocimientos, aunque a veces requiere motivación externa. | Demuestra una actitud pasiva o resistente hacia el diseño y uso de bases de datos analíticas. |

---

## 11. Bibliografía Fundamental

- Abelló, A. (2020). *La construcción de la factoría de información corporativa*. Universitat Oberta de Catalunya (UOC).
- Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling* (3rd ed.). Wiley.
- O'Reilly Media. (2023). *Data Superstream: Data Lakes and Warehouses* [Video]. O'Reilly Online Learning. [Enlace](https://learning.oreilly.com/videos/data-superstream-data/0636920868347/)

---

## 12. Autoría del Programa

- **Autor:** MSc. Raúl Dávila Menis
- **Instancia:** Departamento de Matemática, Facultad de Ciencias e Ingenierías, UNAN-Managua
