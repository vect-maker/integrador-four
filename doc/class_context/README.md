# Contexto Curricular Académico — Semestre II Año (Ciencia de Datos)

Este directorio reúne los programas analíticos oficiales (*Planes de Componente Curricular*) correspondientes al segundo año de la carrera de **Ingeniería en Ciencia de Datos** (Facultad de Ciencias e Ingenierías, Departamento de Matemática, UNAN-Managua).

El Proyecto Integrador IV articula estos componentes en torno a un caso de estudio real de movilidad urbana (*MoviGo*, Managua, 2024).

---

## 1. Índice de Componentes Curriculares

| Componente Curricular | Semestre | Créditos / Horas | Archivo Estandarizado | Articulación con el Proyecto MoviGo |
| :--- | :---: | :---: | :--- | :--- |
| **Bases de Datos Relacionales** | III | 3 CR (135 h) | [`relational_databases.md`](relational_databases.md) | Modelo relacional transaccional (OLTP) en PostgreSQL (Azure) y esquemas normalizados. |
| **Diseño y Uso de Bases de Datos Analíticas** | IV | 3 CR (135 h) | [`analytical_databases.md`](analytical_databases.md) | Modelo dimensional Kimball (esquema estrella con `fct_viajes` y dimensiones), dbt y DuckDB. |
| **Estadística II** | IV | 3 CR (135 h) | [`statistics_ii.md`](statistics_ii.md) | MCO bivariado y multivariado, ANOVA, diagnósticos residuales (DW, JB) y colinealidad (VIF). |
| **Métodos Numéricos** | IV | 3 CR (135 h) | [`numerical_methods.md`](numerical_methods.md) | Búsqueda de raíces no lineales ($f(m)=0$) para equilibrio de mercado (Bisección vs. Newton-Raphson). |
| **Optimización** | IV | 3 CR (135 h) | [`optimization.md`](optimization.md) | Teoría de grafos y algoritmo de Dijkstra en la red vial urbana de Managua (escenario seco vs. tormenta). |
| **Programación en Scripting** | IV | 3 CR (135 h) | [`scripting_programming.md`](scripting_programming.md) | Automatización integral vía CLI (`justfile`, Bash `hydrate_paper_data.sh`, `curl`, `jq`, `uv`). |

---

## 2. Convenciones de Estandarización Aplicadas

Todos los documentos de este directorio han sido normalizados bajo la siguiente estructura homogénea:

1. **Ficha Técnica Oficial:** Metadatos institucionales (carrera, departamento, prerrequisitos, horas semanales, aprobación y autoría).
2. **Distribución Horaria Tabulada:** Desglose riguroso de horas teóricas (HT), prácticas (HPr), trabajo independiente (HTI) y créditos.
3. **Descriptor y Fundamentación:** Justificación curricular y pertinencia profesional en Ciencia de Datos.
4. **Objetivos de Aprendizaje:** Competencias cognitivas y procedimentales a alcanzar.
5. **Competencias Genéricas y Específicas:** Vinculación con el perfil de egreso.
6. **Conocimientos Esenciales (Temario Detallado):** Unidades temáticas desglosadas por contenido específico.
7. **Habilidades y Valores:** Perfil procedimental y ético transversal.
8. **Orientaciones Metodológicas:** Estrategias didácticas (aprendizaje activo, resolución de problemas y proyectos prácticos).
9. **Sistema de Evaluación y Rúbricas:** Niveles de logro (2 a 5) y descriptores para dimensiones conceptual, procedimental y actitudinal.
10. **Bibliografía Fundamental:** Referencias bibliográficas en formato estándar.
