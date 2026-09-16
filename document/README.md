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
| **01** | [`01_contextualizacion.md`](./01_contextualizacion.md) | Contextualización de la investigación, dimensiones operativa, territorial, tarifaria y climática en Managua. |
| **02** | [`02_antecedentes.md`](./02_antecedentes.md) | Revisión del estado del arte, ride-hailing dinámico, impacto meteorológico empírico y antecedentes institucionales (JICA). |
| **03** | [`03_planteamiento_del_problema.md`](./03_planteamiento_del_problema.md) | Desbalance espaciotemporal de oferta/demanda, recorridos en vacío (deadhead) y brecha empírica. |
| **04** | [`04_justificacion.md`](./04_justificacion.md) | Justificación práctica, metodológica, tecnológica (ELT), social y articulación formativa en Ciencia de Datos. |
| **05** | [`05_objetivos.md`](./05_objetivos.md) | Formulación formal del Objetivo General y los cuatro Objetivos Específicos. |
| **06** | [`06_marco_teorico.md`](./06_marco_teorico.md) | Fundamentos de ingeniería de datos (ELT, dbt), modelado dimensional Kimball, análisis espacial (Moran's I) y optimización multiobjetivo. |
| **07** | [`07_matriz_de_descriptores.md`](./07_matriz_de_descriptores.md) | Operacionalización de variables, dimensiones analíticas, indicadores cuantitativos y técnicas de recolección. |
| **08** | [`08_diseno_metodologico.md`](./08_diseno_metodologico.md) | Enfoque mixto, arquitectura del pipeline ELT, modelo dimensional `fct_trips`, inferencia en Python y formulación MILP. |

---

## Síntesis Ejecutiva del Proyecto

El proyecto tiene como propósito optimizar la asignación espacial de la flota de transporte selectivo de la empresa **Movi Go** en el municipio de Managua, articulando un esquema tarifario coherente con las condiciones reales de servicio. La investigación integra la ingeniería de datos moderna (ELT, PostgreSQL, dbt), el análisis espacial (matrices Origen-Destino, autocorrelación de Moran), la influencia de perturbaciones meteorológicas (series oficiales de INETER) y modelos de investigación de operaciones (Programación Lineal Entera Mixta - MILP) para evaluar y simular escenarios de rebalanceo vehicular que minimicen tiempos de espera y recorridos en vacío.
