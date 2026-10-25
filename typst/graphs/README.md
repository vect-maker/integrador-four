# Visualizaciones Gráficas Programáticas (Data-to-Document)

Este directorio almacena los componentes modulares de gráficos y visualizaciones estadísticas generadas programáticamente para el paper de investigación y las diapositivas de defensa.

## Convención de Arquitectura
1. **Extracción de Datos:** Los conjuntos agregados se exportan desde DuckDB CLI en formato tabular `.csv` hacia `typst/data/` (o un subdirectorio dedicado).
2. **Componente Gráfico Typst:** Cada gráfico se implementa en un archivo individual (`.typ`) dentro de `typst/graphs/`, consumiendo los datos mediante `#csv(...)`.
3. **Doble Exportación Modular:**
   - **Componente Base:** `#let plot-<nombre>(...) = { ... }` para integración flexible en presentaciones (slides), paneles o resúmenes ejecutivos.
   - **Figura Formal:** `#let fig-<nombre> = figure(plot-<nombre>(), caption: [...])` para inserción directa y numerada en el artículo científico (`typst/document/chapters/`).
