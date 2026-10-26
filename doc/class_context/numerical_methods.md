# Métodos Numéricos

## Ficha Técnica del Componente Curricular

| Parámetro | Detalle |
| :--- | :--- |
| **Carrera** | Ingeniería en Ciencia de Datos |
| **Facultad** | Ciencias e Ingenierías |
| **Departamento** | Matemática |
| **Componente Curricular** | Métodos Numéricos |
| **Código** | *(Sin asignar)* |
| **Modalidad Educativa** | Presencial |
| **Régimen Temporal** | Semestral |
| **Ubicación en Ciclo Académico** | IV Semestre |
| **Año Académico** | Segundo Año |
| **Prerrequisito** | Matemática III |
| **Frecuencia Semanal** | 4 Horas |
| **Área de Formación** | Matemática y Estadística |
| **Aprobación** | Dra. Ana Marcela Abea Pérez (Directora del Departamento de Matemática) |
| **Fecha de Aprobación** | Octubre 2023 |

---

## 1. Datos Preliminares y Distribución Horaria

| N° | Temas | HT | HL | HPr | HTI | P.LAB.INV | Total Horas | Créditos |
| :-: | :--- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1 | Métodos iterativos para la solución de ecuaciones no lineales | 6 | — | 12 | 25 | — | 43 | 3 |
| 2 | Métodos de interpolación, aproximaciones y ajustes de curva | 8 | — | 16 | 25 | — | 49 | — |
| 3 | Derivación e integración numérica | 6 | — | 12 | 25 | — | 43 | — |
| | **Totales** | **20** | — | **40** | **75** | — | **135** | **3** |

> **Glosario de Modalidades Horarias:**
> - **HT**: Horas Teóricas
> - **HL**: Horas en Línea
> - **HPr**: Horas Prácticas (laboratorios, trabajo de campo, interactividad)
> - **HTI**: Horas de Trabajo Independiente controlado por el docente
> - **P.LAB.INV**: Práctica Laboral e Investigativa

---

## 2. Descriptor del Programa

El programa *Métodos Numéricos* tiene 135 horas y 3 créditos, cubriendo:

- Métodos iterativos para la solución de ecuaciones no lineales (cerrados y abiertos).
- Interpolación, aproximaciones y ajuste de curvas empíricas.
- Derivación e integración numérica computacional.

Se enfoca en el análisis de convergencia, órdenes de convergencia (lineal, cuadrática), control de errores de truncamiento y redondeo, y resolución computacional de modelos continuos donde no existe solución analítica cerrada. El objetivo es dotar a los estudiantes de herramientas matemáticas y algorítmicas para resolver problemas del mundo real a gran escala, integrando cálculo numérico, álgebra lineal computacional y programación científica en Python.

---

## 3. Fundamento del Componente Curricular

El componente de *Métodos Numéricos* permite al estudiante desarrollar un pensamiento lógico-matemático riguroso, dotándolo de herramientas algorítmicas y computacionales para resolver problemas contextualizados mediante operaciones aritméticas finitas y aproximaciones sucesivas.

En Ciencia de Datos, los profesionales se enfrentan a problemas no lineales y sistemas complejos cuya resolución analítica exacta es inviable o computacionalmente intratable. Los métodos numéricos son la piedra angular para:

- **Modelar problemas del mundo real:** Traducir fenómenos de la economía, el transporte, la física y las redes en funciones continuas cuyas raíces, óptimos o dinámicas pueden resolverse numéricamente.
- **Calibrar modelos y optimizar algoritmos:** Comprender la convergencia, la estabilidad numérica y el costo computacional de algoritmos fundamentales utilizados en optimización y aprendizaje automático (ej. métodos basados en gradiente, Newton-Raphson).
- **Tomar decisiones informadas bajo incertidumbre:** Controlar la propagación de errores numéricos y garantizar la precisión requerida en aplicaciones analíticas de misión crítica.

---

## 4. Objetivos de Aprendizaje a Lograr

- Utilizar adecuadamente los conceptos y definiciones de los métodos numéricos en la búsqueda de raíces de ecuaciones no lineales de la forma $f(x) = 0$.
- Analizar el comportamiento, velocidad de convergencia, estabilidad y condiciones iniciales de métodos abiertos y cerrados (Bisección, Newton-Raphson, Secante).
- Aplicar métodos de interpolación (Lagrange, Newton, Splines) y aproximaciones por mínimos cuadrados para ajustar curvas a datos experimentales.
- Analizar y aplicar técnicas de derivación e integración numérica (diferencias finitas, Trapecio, Simpson 1/3 y 3/8, cuadratura de Gauss).
- Implementar los algoritmos numéricos en lenguajes de programación científica (Python: `numpy`, `scipy`) evaluando la eficiencia temporal y espacial.
- Desarrollar pensamiento crítico y autónomo en la interpretación de aproximaciones numéricas.

---

## 5. Competencias a Desarrollar

### 5.1 Competencias Genéricas
- Capacidad para comunicarse de manera oral y escrita en diferentes contextos de actuación.
- Capacidad de identificar y resolver problemas complejos mediante investigación aplicada.
- Capacidad de demostrar creatividad algorítmica para proponer soluciones eficientes.
- Capacidad para utilizar herramientas de software científico y programación de alto rendimiento.
- Capacidad de comprender la realidad socioeconómica del entorno y aportar soluciones técnicas viables.

### 5.2 Competencias Específicas
- Capacidad de analizar exhaustivamente conjuntos de datos complejos aplicando modelado numérico y matemático riguroso.
- Capacidad de desarrollar soluciones de ingeniería de datos y computación científica eficientes y escalables.
- Capacidad de comunicar de manera efectiva los resultados y la convergencia de modelos numéricos a través de gráficos y métricas estandarizadas.

---

## 6. Conocimientos Esenciales (Temario Detallado)

### Tema 1: Métodos iterativos para la solución de ecuaciones no lineales
- Formulación del problema general: $f(x) = 0$.
- Teoría de errores: error absoluto, error relativo y tolerancia de parada ($\epsilon$).
- Métodos cerrados (por intervalos):
  - Método gráfico y separación de raíces
  - Método de la Bisección (convergencia lineal de orden 1)
  - Método de Falsa Posición (*Regula Falsi*)
- Métodos abiertos:
  - Iteración de Punto Fijo ($x = g(x)$) y teorema del punto fijo
  - Método de Newton-Raphson (convergencia cuadrática de orden 2, uso de derivadas)
  - Método de la Secante
- Comparación de desempeño, número de iteraciones y análisis de sensibilidad a la aproximación inicial.

### Tema 2: Métodos de interpolación, aproximaciones y ajustes de curva
- Características generales de los métodos de interpolación
- Polinomios de Taylor y error de truncamiento
- Polinomio de interpolación de Lagrange
- Polinomio de interpolación de Newton y diferencias divididas
- Interpolación por trazadores cúbicos (*Cubic Splines*)
- Ajuste de curvas y aproximación por mínimos cuadrados continuos y discretos
- Linealización de modelos no lineales (exponenciales, potenciales, logarítmicos)
- Regresión polinomial y polinomios ortogonales de Chebyshev

### Tema 3: Derivación e integración numérica
- Diferenciación numérica por diferencias finitas:
  - Hacia adelante (*Forward*)
  - Hacia atrás (*Backward*)
  - Centradas (*Central*)
- Extrapolación de Richardson
- Fórmulas de integración de Newton-Cotes:
  - Regla del Trapecio (simple y compuesta)
  - Regla de Simpson 1/3 (simple y compuesta)
  - Regla de Simpson 3/8
- Integración de Romberg
- Cuadratura Gaussiana (Gauss-Legendre)
- Aplicaciones en machine learning, optimización y cálculo de áreas bajo la curva

### Temas transversales:
- Autoestima, autorreconocimiento y pensamiento autónomo (Pirámide de Maslow).
- Ética en la investigación y rigor científico.

---

## 7. Habilidades Principales a Desarrollar

- Aplicar conceptos, algoritmos y procedimientos numéricos de control de error para resolver problemas del entorno socioeconómico e industrial.
- Modelar matemáticamente situaciones reales traduciéndolas a formulaciones numéricas solubles computacionalmente.
- Desarrollar capacidad de análisis y síntesis sobre la estabilidad y convergencia de algoritmos numéricos.
- Programar e implementar algoritmos en entornos científicos modernos (Python, Jupyter Notebooks), comparando la velocidad de convergencia y robustez de cada método.
- Diagnosticar las limitaciones de cada método (singularidades, derivada nula en Newton-Raphson, oscilaciones en polinomios de alto grado).

---

## 8. Valores Fundamentales

- Responsabilidad Social e Institucional
- Ética Profesional
- Equidad
- Respeto a los Derechos Humanos
- Respeto a la Diversidad y al Medio Ambiente
- Tolerancia, Solidaridad e Identidad Nacional

---

## 9. Indicaciones Metodológicas y de Organización

- **Tema 1 (Ecuaciones No Lineales):** Iniciar con enfoque conceptual de la teoría de aproximaciones y convergencia. Implementar en Python los algoritmos de Bisección y Newton-Raphson comparando su orden de convergencia ($O(1)$ vs. $O(2)$) y número de pasos sobre problemas reales (ej. búsqueda de equilibrio de mercado oferta-demanda).
- **Tema 2 (Interpolación y Ajuste):** Estudios de caso orientados a modelar curvas continuas a partir de muestras discretas. Enfatizar la diferencia entre interpolación exacta y aproximación por mínimos cuadrados, evitando el fenómeno de Runge.
- **Tema 3 (Derivación e Integración):** Aprendizaje activo basado en simulaciones numéricas. Comparar fórmulas simples frente a compuestas y cuadratura gaussiana, analizando el compromiso entre costo computacional y precisión del resultado.
- **Transversalidad Formativa:** Promover la autonomía en la resolución de problemas, el pensamiento crítico y la redacción de informes técnicos siguiendo normativas APA.

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
| **Conceptual** | Comprensión teórica de algoritmos numéricos y convergencia | Demuestra dominio riguroso y completo de la teoría de error, algoritmos numéricos, criterios de parada y tasas de convergencia. | Comprende adecuadamente los conceptos esenciales y explica con claridad el funcionamiento de los métodos. | Muestra comprensión básica, pero presenta dificultades para justificar condiciones de convergencia o estabilidad. | No comprende los fundamentos matemáticos ni las condiciones bajo las cuales convergen los métodos. |
| **Procedimental** | Implementación computacional y resolución de problemas | Implementa algoritmos numéricos limpios y eficientes en código, seleccionando el método óptimo para cada problema. | Resuelve problemas e implementa algoritmos con precisión, requiriendo mínima orientación en casos límite. | Implementa algoritmos estándar siguiendo guías, pero comete errores en la parametrización o criterios de parada. | No logra traducir los algoritmos a código funcional ni interpretar las aproximaciones numéricas. |
| **Actitudinal** | Perseverancia, rigor metodológico y trabajo colaborativo | Participa activamente, demuestra alto interés por la precisión numérica y trabaja de forma colaborativa y ética. | Muestra interés constante, colabora positivamente en equipo y respeta las pautas metodológicas establecidas. | Participa con interés moderado y requiere motivación para profundizar en el análisis de sensibilidad. | Muestra desinterés y escasa disposición para el trabajo analítico o la experimentación numérica. |

---

## 11. Bibliografía Fundamental

- Burden, R. L., & Faires, J. D. (1985). *Análisis Numérico*. Grupo Editorial Iberoamérica.
- Chapra, S. C., & Canale, R. P. (1988). *Métodos numéricos para ingenieros con aplicaciones en computadoras personales*. McGraw-Hill.
- Nieves, A., & Domínguez, F. C. (1995). *Métodos numéricos aplicados a la ingeniería*. CECSA.
- Scheid, F. (1972). *Análisis Numérico*. McGraw-Hill (Serie Schaum).
- Smith, G. D. (1988). *Numerical Analysis*. Prentice Hall.

---

## 12. Autoría del Programa

- **Autor:** MSc. Genaro de Jesús Guillén Morales
- **Instancia:** Departamento de Matemática, Facultad de Ciencias e Ingenierías, UNAN-Managua
