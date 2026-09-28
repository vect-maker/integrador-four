# Proyecto Integrador IV — MoviGo (Managua)

Este repositorio contiene el proyecto integrador de Ingeniería en Ciencia de Datos enfocado en la **Eficacia y Calibración del Esquema de Tarificación Dinámica en el Transporte Selectivo MoviGo**, analizando sensibilidad de demanda, equilibrio numérico, mitigación de cancelaciones y equidad socio-espacial en Managua.

---

## 📁 Estructura del Repositorio

```text
integrador-four/
├── document/               # Documento académico de investigación en Typst (Code-First)
│   ├── main.typ            # Archivo raíz y orquestador del documento
│   ├── template.typ        # Plantilla académica (márgenes, tipografía, portada)
│   ├── references.bib      # Referencias bibliográficas BibTeX (@cachon2017, etc.)
│   ├── data/               # Datos locales consumidos por el documento (ej. zonas.json)
│   └── chapters/           # 8 capítulos modulares independientes
├── slides/                 # Proyecto frontend de presentación interactiva (Vite + Vue 3)
│   ├── index.html          # Entrada de la presentación
│   ├── vite.config.js      # Configuración del servidor de desarrollo
│   ├── src/                # Componentes Vue, vistas de diapositivas y estilos
│   └── package.json        # Dependencias (Vue 3, Pinia, KaTeX, Mermaid)
└── movigo_information.md   # Especificación de la API REST sintética de MoviGo
```

---

## 🚀 Inicio Rápido

### 1. Compilar el Documento de Investigación (Typst)
```bash
# Modo desarrollo con recarga en vivo:
cd document
typst watch main.typ informe_movigo.pdf

# Compilación directa de entrega:
typst compile main.typ informe_movigo.pdf
```

### 2. Ejecutar la Presentación de Diapositivas (Vite + Vue 3)
```bash
cd slides
npm install
npm run dev
```
Accede desde tu navegador en `http://localhost:5173`.
