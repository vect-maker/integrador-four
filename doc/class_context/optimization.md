# Optimización

## Ficha Técnica del Componente Curricular

| Parámetro | Detalle |
| :--- | :--- |
| **Carrera** | Ingeniería en Ciencia de Datos |
| **Facultad** | Ciencias e Ingenierías |
| **Departamento** | Matemática |
| **Componente Curricular** | Optimización |
| **Código** | *(Sin asignar)* |
| **Modalidad Educativa** | Presencial |
| **Régimen Temporal** | Semestral |
| **Ubicación en Ciclo Académico** | IV Semestre |
| **Año Académico** | Segundo Año |
| **Prerrequisito** | Ninguno |
| **Frecuencia Semanal** | 4 Horas |
| **Área de Formación** | Matemática y Estadística |
| **Aprobación** | Dra. Ana Marcela Abea Pérez (Directora del Departamento de Matemática) |
| **Fecha de Aprobación** | Octubre 2023 |

---

## 1. Datos Preliminares y Distribución Horaria

| N° | Temas | HT | HL | HPr | HTI | P.LAB.INV | Total Horas | Créditos |
| :-: | :--- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1 | Programación lineal | 4 | — | 8 | 15 | — | 27 | 3 |
| 2 | Modelos de redes y teoría de grafos | 8 | — | 16 | 30 | — | 54 | — |
| 3 | Programación lineal entera | 8 | — | 16 | 30 | — | 54 | — |
| | **Totales** | **20** | — | **40** | **75** | — | **135** | **3** |

> **Glosario de Modalidades Horarias:**
> - **HT**: Horas Teóricas
> - **HL**: Horas en Línea
> - **HPr**: Horas Prácticas (laboratorios, trabajo de campo, interactividad)
> - **HTI**: Horas de Trabajo Independiente controlado por el docente
> - **P.LAB.INV**: Práctica Laboral e Investigativa

---

## 2. Descriptor del Programa

El programa *Optimización* tiene 135 horas y 3 créditos, centrado en:

- Programación Lineal (continua y dualidad).
- Modelos de Redes y Teoría de Grafos (ruta más corta, árbol de expansión mínima, flujo máximo y ruta crítica CPM/PERT).
- Programación Lineal Entera (algoritmos exactos y heurísticas).

Los contenidos clave incluyen el modelado matemático formal de problemas de optimización con restricciones, algoritmos de resolución gráfica y Simplex, análisis de sensibilidad, problemas de transporte y asignación, y problemas sobre redes espaciales y de transporte. El objetivo es dotar a los estudiantes de herramientas de Investigación Operativa para la toma de decisiones informadas, la asignación eficiente de recursos escasos y la optimización de flujos y rutas en contextos de Ciencia de Datos.

---

## 3. Fundamento del Componente Curricular

El componente curricular *Optimización* proporciona a los estudiantes de Ciencia de Datos una base rigurosa en la modelación matemática de decisiones, la optimización de recursos limitados y la resolución algorítmica de problemas operativos.

En la era del análisis masivo de datos, las organizaciones no solo requieren saber qué ocurrió o predecir qué ocurrirá, sino determinar cuál es la mejor acción prescriptiva a tomar. La optimización matemática capacita a los profesionales para:

- Formular con precisión funciones objetivo a maximizar (ingresos, cobertura, satisfacción) o minimizar (costos, tiempos de traslado, riesgos, emisiones).
- Definir restricciones operativas, espaciales, temporales o de capacidad que delimitan la región factible.
- Resolver problemas de logística urbana, ruteo de vehículos, asignación de flotas y diseño de redes mediante algoritmos computacionales reproducibles (Python: `networkx`, `scipy.optimize`, solvers lineales).

---

## 4. Objetivos de Aprendizaje a Lograr

- Comprender los conceptos fundamentales de la Investigación de Operaciones relacionados con programación lineal, modelos de redes y programación lineal entera.
- Formular matemáticamente modelos de optimización para situaciones reales en logística, transporte, economía y analítica de datos.
- Implementar y comparar diversos algoritmos que posibiliten proponer alternativas de solución óptimas a problemas del mundo real.
- Utilizar software matemático y bibliotecas científicas de Python (`NumPy`, `SciPy`, `NetworkX`) para modelar redes viales, calcular rutas más cortas y visualizar trayectorias.
- Evaluar la robustez y sensibilidad de las soluciones ante cambios en los parámetros del entorno (ej. análisis de contingencias por clima extremo).

---

## 5. Competencias a Desarrollar

### 5.1 Competencias Genéricas
- Capacidad de identificar y resolver problemas complejos mediante investigación operativa rigurosa.
- Capacidad de demostrar creatividad algorítmica en la resolución de problemas de asignación y ruteo.
- Capacidad para utilizar herramientas de software y lenguajes de programación científica como soporte decisional.
- Capacidad de contextualizar soluciones técnicas a la realidad económica y social de Managua y el país.

### 5.2 Competencias Específicas
- Capacidad de analizar exhaustivamente conjuntos de datos complejos aplicando modelos matemáticos y algoritmos de optimización para la toma de decisiones basada en datos.
- Capacidad de diseñar e implementar soluciones de ingeniería de datos e infraestructura algorítmica escalable para procesos operativos.
- Capacidad de comunicar de manera efectiva las alternativas de solución y rutas óptimas mediante mapas conceptuales, visualizaciones espaciales y tablas de contingencia.

---

## 6. Conocimientos Esenciales (Temario Detallado)

### Tema 1: Programación lineal
- Planteamiento y construcción formal de modelos de Programación Lineal (variables de decisión, función objetivo, restricciones de recursos y no negatividad)
- Algoritmo de solución gráfica (región factible, vértices extremos y curvas de nivel)
- Algoritmo algebraico y Algoritmo Simplex (forma canónica, variables de holgura/exceso, tablas Simplex)
- El problema Dual y teoría de dualidad (precios sombra, interpretación económica)
- Análisis de sensibilidad paramétrica
- Modelos de transporte y transbordo:
  - Algoritmo de la Esquina Noroeste
  - Algoritmo del Costo Mínimo
  - Algoritmo de Aproximación de Vogel (VAM)
- Problema de asignación: Algoritmo Húngaro

### Tema 2: Modelos de redes y teoría de grafos
- Conceptos fundamentales de Teoría de Grafos: nodos/vértices ($V$), aristas/arcos ($E$), grafos dirigidos y no dirigidos, matriz de adyacencia y pesos
- Redes determinísticas fundamentales:
  - **Problema de la Ruta Más Corta (Shortest Path):** Algoritmo de Dijkstra y algoritmo de Bellman-Ford
  - **Árbol de Expansión Mínima (Minimum Spanning Tree):** Algoritmo de Kruskal y algoritmo de Prim
  - **Problema del Flujo Máximo:** Algoritmo de Ford-Fulkerson
- Algoritmos de Gestión de Proyectos y Ruta Crítica (CPM / PERT):
  - Representación de redes mediante diagramas de flechas y precedencias
  - Determinación de tiempos tempranos, tardíos y cálculo de holguras
  - Identificación de la ruta crítica

### Tema 3: Programación lineal entera y problemas combinatorios
- Formulación de modelos enteros puros, mixtos y binarios (0-1)
- Algoritmo de Ramificación y Acotamiento (*Branch and Bound*)
- Algoritmo de Planos Cortantes de Gomory
- Problemas combinatorios clásicos:
  - Problema de la Mochila (*Knapsack Problem*)
  - Problema del Agente Viajero (*Traveling Salesperson Problem - TSP*)
  - Problema de Ruteo de Vehículos (*Vehicle Routing Problem - VRP*)

---

## 7. Habilidades Principales a Desarrollar

- Construir modelos matemáticos rigurosos que representen fielmente situaciones del mundo real para la toma de decisiones basada en datos.
- Abordar y estructurar problemas aplicados de optimización espacial y temporal (ej. asignación de viajes y cálculo de rutas mínimas en redes de transporte).
- Implementar algoritmos de grafos (Dijkstra) y optimización en entornos de programación (Python: `networkx`), evaluando tiempos de ejecución y trayectorias alternas.
- Realizar análisis de escenarios comparativos (escenario base sin congestión vs. escenario de contingencia con vías anegadas).

---

## 8. Valores Fundamentales

- Responsabilidad Social e Institucional
- Ética Profesional
- Respeto a la Diversidad y al Medio Ambiente
- Identidad Institucional, Cultura Nacional y Valores Patrióticos
- Tolerancia y Solidaridad

---

## 9. Indicaciones Metodológicas y de Organización

- **Tema 1 (Programación Lineal):** Ejercicios prácticos continuos de formulación matemática y resolución computacional. Énfasis en la interpretación económica de los precios sombra y la dualidad.
- **Tema 2 (Modelos de Redes y Grafos):** Metodologías activas basadas en estudios de caso y proyectos prácticos. Modelar la red vial de una ciudad (ej. Managua) como un grafo ponderado, implementando Dijkstra para optimizar recorridos urbanos y evaluar el impacto del clima y las inundaciones en los tiempos de viaje.
- **Tema 3 (Programación Entera):** Análisis de problemas combinatorios (ruteo, asignación de turnos). Comparar la complejidad computacional frente a métodos continuos y el uso de heurísticas.
- **Transversalidad Ética:** Discusión sobre la asignación justa de recursos públicos/privados, minimización del impacto ambiental del transporte y cumplimiento de normativas APA en la presentación de resultados.

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
| **Conceptual** | Formulación teórica de modelos matemáticos y algoritmos | Comprende a profundidad todos los fundamentos de programación lineal, dualidad, teoría de grafos y algoritmos de redes. | Comprende adecuadamente los conceptos y es capaz de formular modelos estándar con claridad. | Muestra comprensión básica, pero presenta dificultades al definir variables o restricciones complejas. | No comprende los fundamentos de la optimización ni la representación mediante grafos o matrices. |
| **Procedimental** | Implementación de algoritmos y resolución computacional | Modela problemas reales de forma autónoma e implementa algoritmos de optimización (Simplex, Dijkstra) con precisión y eficiencia. | Implementa algoritmos de optimización con precisión y resuelve problemas estándar con supervisión mínima. | Resuelve modelos sencillos con apoyo de guías, pero comete errores en la codificación o análisis de sensibilidad. | Presenta serias dificultades para estructurar un modelo matemático o ejecutar algoritmos de optimización. |
| **Actitudinal** | Actitud analítica, perseverancia y resolución colaborativa | Demuestra alto interés, proactividad, pensamiento crítico y liderazgo en proyectos de optimización aplicada. | Participa activamente, muestra compromiso y colabora eficientemente en la resolución de problemas de optimización. | Muestra interés moderado y requiere orientación para mantener la perseverancia en problemas complejos. | No muestra disposición ni interés activo hacia la modelación matemática o el trabajo en equipo. |

---

## 11. Bibliografía Fundamental

- Anderson, D. R., Sweeney, D. J., Williams, T. A., Camm, J. D., & Martin, K. (2011). *Métodos cuantitativos para los negocios* (11.ª ed.). Cengage Learning.
- Chediak, F. (2013). *Investigación de Operaciones* (Vol. I). Universidad de Ibagué.
- Hillier, F. S., & Lieberman, G. J. (2010). *Introducción a la Investigación de Operaciones* (9.ª ed.). McGraw-Hill.
- Taha, H. A. (2017). *Investigación de Operaciones* (10.ª ed.). Pearson Educación.
- Turyn, L. (2014). *Advanced Engineering Mathematics*. CRC Press.

---

## 12. Autoría del Programa

- **Autor:** Dr. Rudy Alberto López Potosme
- **Instancia:** Departamento de Matemática, Facultad de Ciencias e Ingenierías, UNAN-Managua
