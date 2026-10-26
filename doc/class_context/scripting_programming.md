# Programación en Scripting

## Ficha Técnica del Componente Curricular

| Parámetro | Detalle |
| :--- | :--- |
| **Carrera** | Ingeniería en Ciencia de Datos |
| **Facultad** | Ciencias e Ingenierías |
| **Departamento** | Matemática |
| **Componente Curricular** | Programación en Scripting |
| **Código** | *(Sin asignar)* |
| **Modalidad Educativa** | Presencial |
| **Régimen Temporal** | Semestral |
| **Ubicación en Ciclo Académico** | IV Semestre |
| **Año Académico** | Segundo Año |
| **Prerrequisito** | Ninguno |
| **Frecuencia Semanal** | 4 Horas |
| **Área de Formación** | Programación |
| **Aprobación** | Dra. Ana Marcela Abea Pérez (Directora del Departamento de Matemática) |
| **Fecha de Aprobación** | Octubre 2023 |

---

## 1. Datos Preliminares y Distribución Horaria

| N° | Temas | HT | HL | HPr | HTI | P.LAB.INV | Total Horas | Créditos |
| :-: | :--- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1 | Familiarizándose con el Shell | 3 | — | 4 | 10 | — | 17 | 3 |
| 2 | Introducción a Shell Scripting | 2 | — | 6 | 10 | — | 18 | — |
| 3 | Linux Essentials para Shell Scripting | 3 | — | 6 | 10 | — | 19 | — |
| 4 | Trabajando con variables y argumentos | 3 | — | 6 | 10 | — | 19 | — |
| 5 | Condicionales y ciclos | 3 | — | 6 | 10 | — | 19 | — |
| 6 | Usando opciones avanzadas de programación scripting | 4 | — | 6 | 15 | — | 25 | — |
| 7 | Explorando aspectos avanzados y automatización | 2 | — | 6 | 10 | — | 18 | — |
| | **Totales** | **20** | — | **40** | **75** | — | **135** | **3** |

> **Glosario de Modalidades Horarias:**
> - **HT**: Horas Teóricas
> - **HL**: Horas en Línea
> - **HPr**: Horas Prácticas (laboratorios, trabajo de campo, interactividad)
> - **HTI**: Horas de Trabajo Independiente controlado por el docente
> - **P.LAB.INV**: Práctica Laboral e Investigativa

---

## 2. Descriptor del Programa

El programa *Programación en Scripting* tiene 135 horas y 3 créditos, cubriendo:

- Familiarización con la terminal y el Shell de Linux.
- Fundamentos y sintaxis de Bash Scripting.
- Utilidades esenciales de procesamiento de texto (`grep`, `sed`, `awk`, `cut`, `tr`).
- Manejo de variables, argumentos posicionales, expansión de parámetros y arrays.
- Estructuras de control de flujo (condicionales `if/case` y ciclos `for/while/until`).
- Técnicas avanzadas de automatización, manejo de señales (`trap`), funciones modulares, monitoreo del sistema e interacción con APIs y contenedores.

El objetivo es capacitar a los estudiantes para construir pipelines robustos, automatizar tareas repetitivas de ingesta y transformación de datos, y orquestar flujos de trabajo en entornos tipo Unix/Linux. Los valores transversalizados incluyen compromiso social, ética profesional, equidad y respeto al medio ambiente.

---

## 3. Fundamento del Componente Curricular

La programación en scripting es una competencia habilitadora indispensable para cualquier Ingeniero en Ciencia de Datos. En la práctica profesional, los datos provienen de fuentes heterogéneas, servidores remotos, APIs REST y sistemas de archivos masivos que requieren ser descargados, descomprimidos, limpiados, transformados y cargados de forma automática y reproducible.

Esta asignatura introduce al estudiante en las herramientas y la filosofía de la línea de comandos de Linux, proporcionándole las capacidades para:

- Automatizar flujos completos de extracción y carga de datos (*pipelines ELT/ETL*).
- Interactuar con APIs web mediante herramientas de terminal (`curl`, `jq`, scripts de Python/Bash).
- Manipular flujos de texto masivos mediante utilidades estándar de alto rendimiento (`awk`, `sed`, `grep`).
- Orquestar tareas periódicas, entornos de ejecución y contenedores, sirviendo de puente entre la infraestructura operativa y los modelos analíticos.

---

## 4. Objetivos de Aprendizaje a Lograr

- Configurar entornos de desarrollo en terminal y herramientas específicas para scripting en entornos Linux.
- Comprender la arquitectura del Shell, la gestión de procesos, los flujos estándar (STDIN, STDOUT, STDERR) y la redirección de E/S.
- Dominar los comandos y utilidades centrales de Linux para la búsqueda, filtrado y transformación eficiente de texto y archivos.
- Manipular variables, argumentos, funciones, expresiones regulares y arrays para procesar datos de manera estructurada.
- Implementar estructuras de control condicionales y bucles en scripts Bash robustos con control de errores y códigos de salida.
- Diseñar scripts avanzados para la automatización de pipelines de datos, monitoreo de recursos y llamadas a servicios web y APIs.

---

## 5. Competencias a Desarrollar

### 5.1 Competencias Genéricas
- Capacidad para comunicarse de manera oral y escrita en diferentes contextos de actuación.
- Capacidad de identificar y resolver problemas de automatización de manera autónoma y en equipo.
- Capacidad de demostrar creatividad algorítmica para optimizar flujos de trabajo técnico.
- Capacidad para utilizar herramientas CLI avanzadas y sistemas operativos abiertos como soporte para la ciencia de datos.
- Capacidad de comprender la realidad del entorno tecnológico nacional e impulsar soluciones de software libre eficientes.

### 5.2 Competencias Específicas
- Capacidad de analizar exhaustivamente conjuntos de datos complejos utilizando herramientas de terminal y scripts de automatización.
- Capacidad de desarrollar soluciones de ingeniería de datos escalables y eficientes, mediante la recolección, limpieza, transformación y almacenamiento automatizado de datos de diversas fuentes.
- Capacidad de integrar pipelines reproducibles que conecten bases de datos, APIs y herramientas de visualización y modelado.

---

## 6. Conocimientos Esenciales (Temario Detallado)

### Tema 1: Familiarizándose con el Shell
- Introducción al ecosistema Unix/Linux y arquitectura de la terminal
- Permisos del sistema de archivos (`chmod`, `chown`, notación octal y simbólica)
- Estructura del árbol de directorios (FHS)
- Pasos básicos para crear y ejecutar un script Shell (permiso `+x`, línea *shebang* `#!/usr/bin/env bash`)

### Tema 2: Introducción a Shell Scripting
- El rol del intérprete Bash frente a otros shells (Zsh, Sh)
- Flujos estándar: `STDIN (0)`, `STDOUT (1)`, `STDERR (2)`
- Redirección de entrada y salida (`>`, `>>`, `<`, `2>&1`, *pipes* `|`)
- Comandos internos (*built-ins*) vs. programas externos
- Variables de entorno y variables locales
- Archivos de inicialización de Bash (`.bashrc`, `.bash_profile`)
- Códigos de salida de procesos (`exit codes`, `$?`)

### Tema 3: Linux Essentials para Shell Scripting
- Salida formateada con `echo` y `printf`
- Búsqueda de patrones y expresiones regulares (Regex básica y extendida)
- Filtrado de texto con `grep`, `egrep` y opciones avanzadas
- Inspección de archivos: `head`, `tail`, `less`
- Editor de flujo `sed` para transformaciones y sustituciones automáticas
- Lenguaje de procesamiento de texto estructurado `awk` (columnas, filtros, acumuladores)
- Transformación y recorte de caracteres con `tr` y `cut`

### Tema 4: Trabajando con variables y argumentos
- Definición, asignación y alcance de variables en Bash
- Buenas prácticas de entrecomillado (*quoting*: comillas dobles vs. simples)
- Argumentos posicionales (`$1`, `$2`, `$#`, `$@`, `$*`, `shift`)
- Sustitución de comandos (`$(comando)`)
- Documentos en línea (*Here-documents* y *Here-strings*)
- Funciones modulares y retorno de valores
- Sustitución y expansión de parámetros (`${var:-default}`, `${var//buscar/reemplazar}`)
- Aritmética en Bash (`$(( ... ))`, `bc`)

### Tema 5: Condicionales y ciclos
- El comando `test` y su sintaxis moderna `[[ condición ]]`
- Operadores de comparación para enteros (`-eq`, `-ne`, `-lt`, `-ge`), cadenas (`==`, `!=`, `-z`, `-n`) y archivos (`-f`, `-d`, `-s`)
- Estructura `if ... then ... elif ... else ... fi`
- Estructura condicional múltiple `case ... in ... esac`
- Bucles definidos: `for var in lista; do ... done` y bucles tipo C
- Bucles condicionales: `while [ condición ]` y `until [ condición ]`
- Control de bucles: `break` y `continue`

### Tema 6: Usando opciones avanzadas de programación scripting
- Procesamiento de opciones y banderas de línea de comandos (`getopts`)
- Variables locales en funciones (`local`)
- Manejo de señales del sistema operativo con `trap` (limpieza de archivos temporales al abortar)
- Arrays unidimensionales: indexados y asociativos (*key-value*)
- Manipulación de arrays, longitud, iteración y captura de salidas de comandos en arrays (`mapfile` / `readarray`)

### Tema 7: Explorando aspectos avanzados y automatización
- Monitoreo de recursos del sistema (CPU, memoria, disco: `top`, `htop`, `df`, `free`)
- Automatización de tareas programadas con `cron` y temporizadores de `systemd`
- Interacción con APIs REST desde la terminal (`curl`, análisis de JSON con `jq`)
- Integración de scripts de Shell con contenedores (Podman/Docker) y entornos virtuales de Python (`uv`, `.venv`)
- Creación de tareas automatizadas de extracción y carga (scripts de hidratación)

---

## 7. Habilidades Principales a Desarrollar

- Competencia fluida en la navegación y operación desde la interfaz de línea de comandos (CLI) de Linux.
- Capacidad para crear, depurar y mantener scripts de automatización en Bash estructurados y limpios.
- Dominio en el procesamiento masivo de datos tabulares mediante combinaciones de `grep`, `sed`, `awk` y `cut`.
- Capacidad para implementar pipelines de extracción de APIs, transformación y carga directa a bases de datos (DuckDB, PostgreSQL).
- Habilidad para orquestar herramientas heterogéneas mediante scripts (*glue code*) y coordinar entornos de contenedores y Python.

---

## 8. Valores Fundamentales

- Compromiso Social
- Responsabilidad Social e Institucional
- Ética Profesional
- Equidad
- Respeto a los Derechos Humanos y a la Diversidad
- Respeto al Medio Ambiente

---

## 9. Indicaciones Metodológicas y de Organización

- **Tema 1 a 3 (Terminal y Herramientas):** Prácticas continuas de laboratorio en entornos Linux reales. Enfatizar la comprensión de permisos, redirecciones y expresiones regulares aplicadas a logs y datos reales.
- **Tema 4 y 5 (Variables y Control):** Resolución de ejercicios progresivos de programación modular. Implementar scripts con validación exhaustiva de argumentos de entrada y control estricto de códigos de error.
- **Tema 6 y 7 (Técnicas Avanzadas y Automatización):** Aprendizaje Basado en Proyectos (ABP). Construir un pipeline de automatización real (ej. `pipeline/hydrate_paper_data.sh`) que extraiga datos de APIs o bases de datos, ejecute scripts de transformación y valide la integridad de los artefactos resultantes.
- **Transversalidad Ética:** Discusión sobre seguridad informática, permisos mínimos de ejecución, no almacenamiento de credenciales en texto plano (uso de `.env`) y respeto a las licencias de software libre.

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
| **Conceptual** | Fundamentos del Shell, Linux y automatización | Comprende y explica con profundidad todos los conceptos clave de scripting, arquitectura del shell, flujos de E/S y expresiones regulares. | Comprende la mayoría de los conceptos y explica su relevancia e impacto en entornos operativos prácticos. | Entiende conceptos básicos de comandos, pero presenta dudas con temas avanzados (señales, arrays, regex complejas). | Reconoce términos elementales pero no logra explicar el flujo de ejecución ni la lógica de los scripts. |
| **Procedimental** | Construcción y optimización de scripts y pipelines | Diseña, escribe y optimiza scripts Bash complejos y modulares de forma autónoma, integrando APIs, filtros y manejo de errores. | Escribe scripts funcionales para tareas regulares y automatización con supervisión mínima. | Escribe scripts básicos con comandos sencillos, pero tiene dificultades para estructurar bucles o capturar errores. | Tiene serias dificultades para construir scripts completos y comete errores sintácticos frecuentes. |
| **Actitudinal** | Perseverancia, proactividad y buenas prácticas de código | Demuestra iniciativa, promueve buenas prácticas (código limpio, portabilidad, seguridad), perseverancia y colaboración activa. | Colabora regularmente, muestra interés por mejorar la eficiencia de sus scripts y adopta recomendaciones técnicas. | Muestra interés intermitente y requiere recordatorios para documentar su código o estructurar scripts limpios. | Muestra resistencia al uso de la terminal o actitud pasiva ante la resolución de errores en sus programas. |

---

## 11. Bibliografía Fundamental

- Janssens, J. (2021). *Data Science at the Command Line: Obtain, Scrub, Explore, and Model Data with Unix Power Tools* (2nd ed.). O'Reilly Media.
- O'Reilly Media. (s. f.). *Bash Shell Scripting LiveLessons* [Video]. O'Reilly Online Learning. [Enlace](https://www.oreilly.com/library/view/bash-shell-scripting/9780137689064/BSS2_01_03_03.html)
- Packt Publishing. (s. f.). *Complete Bash Shell Scripting* [Video]. O'Reilly Online Learning. [Enlace](https://learning.oreilly.com/videos/complete-bash-shell/9781800209695/)

---

## 12. Autoría del Programa

- **Autor:** MSc. Raúl Dávila Menis
- **Instancia:** Departamento de Matemática, Facultad de Ciencias e Ingenierías, UNAN-Managua
