# Nota Técnica: Declaración de Bibliografía Local para Linters de Typst

## Contexto y Propósito

En los capítulos modulares de investigación ubicados en `typst/document/chapters/` donde se realizan citas bibliográficas (`@clave` o `#cite(<clave>)`), se incluye deliberadamente el siguiente bloque en la cabecera de cada archivo:

```typst
#show bibliography: none
#bibliography("../../references.bib")
```

---

## Justificación Técnica del Editor / Linter

1. **Resolución de Etiquetas en Tiempo Real (Tinymist / Typst LSP)**:
   - Cuando se edita un capítulo individual en entornos de desarrollo como **Visual Studio Code** o **Zed**, el servidor de lenguaje (_Language Server Protocol_ o LSP) evalúa el archivo abierto como unidad de compilación en búfer.
   - Si un archivo utiliza citas (`@cachon2017`, `@zha2018`, etc.) sin una fuente bibliográfica declarada en su propio ámbito de archivo, el linter arroja advertencias o errores diagnósticos de etiquetas no resueltas (*unknown citation key* / *label not found*).

2. **Ocultamiento del Renderizado Local**:
   - La regla `#show bibliography: none` asegura que el contenido de la bibliografía no se imprima dentro del cuerpo del capítulo individual, manteniendo intacta la paginación y estructura del texto.

---

## Compatibilidad con el Formato APA 7ma Edición

Para garantizar que el documento maestro consolidado (`typst/document.typ`) mantenga el estándar **APA 7ma Edición** sin conflictos por múltiples declaraciones locales:

- **Estilo Global en la Plantilla**: En `typst/document/template.typ`, la función principal aplica `#set bibliography(style: "apa")`, forzando que tanto las citas parentéticas como las citas en prosa (`#cite(<key>, form: "prose")`) sigan la convención Autor-Año.
- **Sección Final Unificada**: En `typst/document.typ`, la lista completa de referencias se genera al final mediante:
  ```typst
  = Referencias

  #bibliography(
    "references.bib",
    style: "apa",
    title: none,
    full: true
  )
  ```
  El parámetro `full: true` garantiza que la totalidad de las fuentes del repositorio se listen alfabéticamente con sangría francesa y formato APA 7, sin perder ninguna entrada.
