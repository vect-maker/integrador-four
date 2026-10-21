# Módulo Documental — MoviGo (Integrador IV)

Este directorio contiene los capítulos modulares y la plantilla académica del documento de investigación de MoviGo maquetada y programada en **Typst**.

---

## 📁 Estructura

```text
document/
├── template.typ             # Plantilla académica (portada, márgenes, estilos, callouts)
└── chapters/                # Capítulos modulares del documento
    ├── 01_contexto.typ      # Contextualización y mecánica tarifaria paramétrica
    ├── 02_antecedentes.typ  # Estado del arte y literatura de surge pricing
    ├── 03_problema.typ      # Planteamiento del problema y dilema de calibración
    ├── 04_justificacion.typ # Justificación práctica, científica y curricular
    ├── 05_objetivos.typ     # Objetivos general y específicos
    ├── 06_marco_teorico.typ # Teoría microeconómica, Kimball/dbt y métodos numéricos
    └── 07_metodologia.typ   # Pipeline ELT, pruebas de hipótesis y optimización
```

El punto de entrada del documento se encuentra en: [`typst/document.typ`](../document.typ).

---

## 🚀 Compilación desde la raíz del repositorio

```bash
# Compilar documento a typst/document.pdf
just build-doc
# o directamente:
typst compile --root typst typst/document.typ typst/document.pdf

# Modo observador en tiempo real:
just watch-doc
# o directamente:
typst watch --root typst typst/document.typ typst/document.pdf
```
