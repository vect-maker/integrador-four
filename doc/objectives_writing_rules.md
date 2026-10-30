# Reglas de Oro para la Redacción de Objetivos de Investigación

**Documento:** `doc/objectives_writing_rules.md`  
**Ámbito:** Proyecto Integrador IV — Carrera de Ingeniería en Ciencia de Datos (UNAN-Managua)  
**Propósito:** Establecer los lineamientos metodológicos formales para redactar, auditar o modificar el **Objetivo General** y los **Objetivos Específicos** del artículo científico y las diapositivas de defensa.

---

## 1. Principios Fundamentales (Reglas de Oro)

### Regla 1: Un solo verbo de acción en infinitivo
- **Enunciado:** Cada objetivo (tanto el general como cada uno de los específicos) debe iniciar con **exactamente un único verbo rector en infinitivo** (terminación en *-ar*, *-er*, *-ir*), seleccionado de acuerdo con la Taxonomía de Bloom para el nivel cognitivo correspondiente.
- **Prohibición estricta:** Queda terminantemente prohibido utilizar verbos coordinados, compuestos o dobles unidos por la conjunción "y" o barras diagonales (por ejemplo: ❌ *Construir y optimizar*, ❌ *Diseñar e implementar*, ❌ *Modelar y calibrar*, ❌ *Desarrollar y evaluar*).
- **Justificación metodológica:** Un objetivo con múltiples verbos evalúa más de una acción cognitiva independiente, lo que genera ambigüedad en los criterios de logro, dificulta la verificación empírica y transgrede las normas metodológicas de evaluación de tesis y artículos científicos.

---

### Regla 2: Agnosticismo tecnológico y nivel de abstracción conceptual
- **Enunciado:** En la formulación de los objetivos **no se deben incluir nombres propios de tecnologías, marcas comerciales, motores de bases de datos, librerías o algoritmos específicos** (por ejemplo: ❌ *Azure PostgreSQL*, ❌ *dbt Core*, ❌ *DuckDB*, ❌ *Apache Parquet*, ❌ *API REST*, ❌ *Dijkstra*, ❌ *NetworkX*, ❌ *Pandas*, ❌ *Python*).
- **Prohibición estricta:** No atar los objetivos a la "pila técnica" (*tech stack*) del momento.
- **Justificación metodológica:** Las tecnologías y herramientas representan los **medios instrumentales** (*¿con qué herramientas se ejecuta?*), mientras que los objetivos definen los **fines cognitivos y metodológicos** (*¿qué se investiga y para qué?*). La especificación del software, librerías y algoritmos pertenece exclusivamente al capítulo de **Diseño Metodológico** y a las especificaciones técnicas del repositorio.
- **Traducción a conceptos metodológicos agnósticos:**
  - En vez de *API REST, Parquet, PostgreSQL, dbt Core y DuckDB* $\rightarrow$ usar: **"un flujo de extracción, carga y transformación para consolidar un repositorio analítico multidimensional"**.
  - En vez de *algoritmo de Dijkstra o NetworkX* $\rightarrow$ usar: **"modelos de redes espaciales y algoritmos de camino mínimo"**.
  - En vez de *Docker/Podman y Bash* $\rightarrow$ usar: **"un ecosistema computacional reproducible con trazabilidad de datos"**.

---

### Regla 3: Estructura sintáctica formal estándar
Todo objetivo debe responder de manera armónica a la siguiente estructura gramatical:

$$\text{[Verbo rector en infinitivo]} + \text{[Objeto de estudio: Qué]} + \text{[Enfoque o Medio conceptual: Cómo]} + \text{[Propósito o Finalidad: Para qué]} + \text{[Delimitación contextual: Dónde y Cuándo]}$$

- **¿Qué?:** Fenómeno, entidad o sistema bajo estudio (ej. *la resiliencia operativa y la conectividad de la red vial*).
- **¿Cómo? (Conceptual, sin marcas):** Marco de análisis formal (ej. *mediante modelos de redes espaciales y flujos transaccionales*).
- **¿Para qué?:** Finalidad práctica o científica (ej. *para mitigar las demoras operativas ante perturbaciones meteorológicas*).
- **¿Dónde y Cuándo?:** Delimitación territorial y temporal (ej. *en el servicio MoviGo en el municipio de Managua durante el año 2024*).

---

### Regla 4: Verificabilidad y Trazabilidad Empírica de Cifras (Data-to-Document)
- **Enunciado:** Cualquier métrica, volumen transaccional, recuento dimensional o cifra numérica citada en los objetivos o en el cuerpo de la investigación debe derivarse **exclusiva y estrictamente de los datos reales** consolidados en el almacén analítico (`pipeline/data/analytics.duckdb` y artefactos JSON en `typst/data/`), garantizando la reproducibilidad científica total.
- **Prohibición estricta:**
  1. Queda prohibido citar estimaciones aproximadas, números obsoletos o cifras desalineadas de borradores previos (ej. ❌ *65,000 registros*, ❌ *77,386 viajes*, ❌ *77,036 operaciones* cuando el universo real auditado en `fct_viajes` es exactamente **77,487** transacciones).
  2. En el documento Typst, se debe priorizar el uso de enlaces dinámicos a variables (`#total-trips-fmt`, `#total-zones`, `#routing-edges`, `#routing-net-delay`, etc.) en lugar de escribir números estáticos (*hardcoded*), garantizando cero deriva humana (*zero human drift*).
  3. En los objetivos, si se mencionan cifras cuantitativas de referencia, estas deben auditarse contra la fuente única de verdad (`general_kpis.json`, `routing_optimization.json`) o formularse a nivel conceptual para preservar la generalidad metodológica.

---

## 2. Casos Prácticos del Proyecto (Antes vs. Después)

### Caso 1: Objetivo General
- ❌ **Incorrecto (con verbo instrumental y tecnologías implícitas):**  
  *Desarrollar una plataforma analítica y de optimización espacial para la evaluación de la infraestructura vial y la resiliencia operativa...*  
  *(Error: "Desarrollar una plataforma" describe una tarea técnica o de software, no un objetivo de investigación científica).*
- ✅ **Correcto (un solo verbo, analítico y conceptual):**  
  **Analizar** la resiliencia operativa y la conectividad de la red de transporte selectivo MoviGo ante estrangulamientos viales y contingencias climáticas en el municipio de Managua durante el año 2024.

---

### Caso 2: Objetivo Específico de Datos
- ❌ **Incorrecto (saturado de nombres de tecnologías y marcas):**  
  *Implementar un pipeline de ingeniería de datos bajo el paradigma ELT (API REST, Apache Parquet, Azure Database for PostgreSQL, dbt Core y DuckDB) bajo modelado dimensional Kimball para la consolidación y explotación de un repositorio analítico columnar de 77,487 operaciones.*  
  *(Error: Menciona 5 herramientas tecnológicas propietarias que pertenecen a la metodología).*
- ✅ **Correcto (conceptual, un solo verbo rector, agnóstico):**  
  **Consolidar** un repositorio analítico multidimensional a partir de los registros operativos del servicio mediante un flujo de extracción, carga y transformación para la integración y explotación de los datos transaccionales.

---

### Caso 3: Objetivo Específico de Optimización y Redes
- ❌ **Incorrecto (dos verbos de acción y algoritmo nombrado):**  
  *Construir y optimizar la red de movilidad urbana metropolitana mediante teoría de grafos sobre los flujos origen-destino observados (24 zonas y 44 corredores), evaluando métricas de centralidad de intermediación y la resiliencia operativa ante perturbaciones hidrológicas mediante el algoritmo de Dijkstra.*  
  *(Error: Dos verbos "Construir y optimizar" + nombra el algoritmo de Dijkstra).*
- ✅ **Correcto (un solo verbo rector, conceptual):**  
  **Optimizar** las trayectorias de desplazamiento y la resiliencia de la red vial metropolitana mediante modelos de redes espaciales y algoritmos de camino mínimo ante perturbaciones meteorológicas y cuellos de botella urbanos.

---

## 3. Catálogo de Verbos Sugeridos (Taxonomía de Bloom)

Para futuras ampliaciones, reformulaciones o nuevas asignaturas que se integren (ej. nuevo enfoque de machine learning / regresión), seleccionar exclusivamente verbos de esta tabla:

| Nivel Cognitivo | Verbos Recomendados | Cuándo Usar |
| :--- | :--- | :--- |
| **Analítico / Evaluativo** *(Objetivo General)* | • **Analizar**<br>• **Evaluar**<br>• **Determinar** | Investigaciones que buscan contrastar relaciones complejas, diagnosticar impactos estructurales o medir resiliencia sistémica. |
| **Ingeniería de Datos / Procesamiento** *(OE 1)* | • **Consolidar**<br>• **Estructurar**<br>• **Integrar**<br>• **Implementar** | Construcción de repositorios analíticos, esquemas multidimensionales o flujos automatizados de datos. |
| **Modelado / Aprendizaje Automático** *(OE Futuro)* | • **Modelar**<br>• **Estimar**<br>• **Calibrar**<br>• **Predecir** | Aplicación de técnicas de aprendizaje automático o formulaciones de mínimos cuadrados sobre variables operativas. |
| **Optimización / Prescriptivo** *(OE 2)* | • **Optimizar**<br>• **Prescribir**<br>• **Formular**<br>• **Minimizar** / **Maximizar** | Modelos de investigación de operaciones, grafos, algoritmos de asignación o ruteo bajo restricciones. |

---

## 4. Lista de Verificación Rápida (*Checklist*) para Nuevos Objetivos

Antes de incorporar un nuevo objetivo al paper (`typst/document/chapters/05_objetivos.typ`) o a las diapositivas (`typst/slides/05_objectives.typ`), validar:

- [ ] ¿Comienza con **un solo verbo en infinitivo**?
- [ ] ¿Existe **cero presencia de la conjunción "y" uniendo verbos** principales (*"X y Y"* prohibido)?
- [ ] ¿Se eliminaron nombres comerciales de tecnologías (PostgreSQL, dbt, DuckDB, Python, Dijkstra, etc.)?
- [ ] ¿Describe el **fin cognitivo/analítico** y no la simple tarea informática (*"Desarrollar una app/script"* prohibido)?
- [ ] ¿Responde con claridad a: **Qué se investiga**, **Bajo qué enfoque conceptual**, **Para qué propósito** y **En qué delimitación espacio-temporal**?
- [ ] ¿Las cifras o métricas mencionadas **provienen exclusivamente de los datos reales** (`77,487 viajes`, `24 zonas`, `44 corredores`, etc.) o se utilizan enlaces dinámicos (`#total-trips-fmt`)?
