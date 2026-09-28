# Proyecto Documental en Typst — MoviGo (Integrador IV)

Este directorio contiene la versión **Code-First** del documento de investigación de MoviGo maquetada y programada en **Typst**. La estructura modular desacopla la plantilla visual, los datos, las referencias bibliográficas y los capítulos individuales.

---

## 📁 Estructura del Proyecto

```text
document/
├── main.typ                 # Archivo raíz y orquestador del documento
├── template.typ             # Plantilla académica (portada, márgenes, estilos, callouts)
├── references.bib           # Bibliografía en formato BibTeX (@cachon2017, etc.)
├── README.md                # Esta guía de uso y compilación
├── data/
│   └── zonas.json           # Datos reales exportados desde la API REST (12 zonas)
├── assets/                  # Directorio para imágenes, capturas y gráficos vectoriales
└── chapters/                # Capítulos modulares del documento
    ├── 01_contexto.typ      # Contextualización y mecánica tarifaria paramétrica
    ├── 02_problema.typ      # Planteamiento del problema y dilema de calibración
    ├── 03_justificacion.typ # Justificación práctica, científica y curricular
    ├── 04_objetivos.typ     # Objetivos general y específicos
    ├── 05_antecedentes.typ  # Estado del arte y literatura de surge pricing
    ├── 06_marco_teorico.typ # Teoría microeconómica, Kimball/dbt y métodos numéricos
    └── 07_metodologia.typ   # Pipeline ELT, pruebas de hipótesis y optimización
```

---

## 🚀 Cómo Compilar y Trabajar en Tiempo Real

### 1. Compilación Automática en Vivo (Live Reload)
Para ver los cambios reflejados en tiempo real cada vez que guardas (`Ctrl + S`), ejecuta desde la terminal:

```bash
cd document
typst watch main.typ informe_movigo.pdf
```

Typst compila en **menos de 30 milisegundos**. Abre `informe_movigo.pdf` en tu visor de PDFs preferido o en VS Code.

### 2. Compilación Única (Para exportar la entrega final)
```bash
typst compile main.typ informe_movigo.pdf
```

---

## 💡 Ventajas de este Enfoque Code-First

1. **Estructura Modular:** Capítulos separados e independientes organizados en `chapters/` para facilitar la colaboración.
2. **Citas Automáticas:** Las referencias como `@cachon2017` o `@jica2017` se resuelven y formatean solas usando el archivo [`references.bib`](./references.bib).
3. **Ecuaciones y Tipografía Profesional:** Todas las fórmulas matemáticas se compilan con alineación y números de ecuación automáticos.
4. **Cero Fricción:** A diferencia de LaTeX, no requiere dependencias de varios gigabytes ni configuraciones complejas.
