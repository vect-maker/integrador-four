<template>
  <section class="slide" data-slide="9" data-title="09. Arquitectura ELT & dbt Core">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>08. Ingeniería de Datos</span>
        </div>
        <div class="header-right">
          <span>Pipeline ELT &amp; Orquestación dbt</span>
          <span class="slide-number-tag">09 / 16</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">ARQUITECTURA MODERNA DE DATOS</div>
        <h2 class="slide-title reveal">Paradigma ELT sobre <em>PostgreSQL &amp; dbt Core</em></h2>
        <p class="slide-subtitle reveal" style="margin-bottom: 16px;">
          Extracción directa a capa cruda (raw), desacople analítico y transformaciones versionadas mediante dbt para asegurar reproducibilidad total del linaje de datos.
        </p>

        <!-- Mermaid Architecture Pipeline Diagram -->
        <div class="card reveal" style="padding: 16px 20px; margin-bottom: 20px; background: var(--card-bg);">
          <div class="card-label" style="margin-bottom: 8px;">Linaje y Flujo de Transformación de Datos (ELT)</div>
          <MermaidDiagram :code="pipelineDiagram" max-width="100%" />
        </div>

        <div class="grid-2 reveal">
          <div class="card subtle-card" style="padding: 18px 24px;">
            <div class="card-label">Ventajas del Paradigma ELT frente a ETL</div>
            <div class="card-text">
              Preserva la integridad de los datos originales en la base de datos de destino, facilitando auditorías de linaje y permitiendo re-ejecutar modelos dimensionales con nuevas reglas sin requerir nuevas extracciones del origen transaccional.
            </div>
          </div>
          <div class="card subtle-card" style="padding: 18px 24px;">
            <div class="card-label">Gobierno y Linaje con dbt</div>
            <div class="card-text">
              Cada indicador de desempeño operativo (deadhead, esperas, ingresos) queda formalmente documentado en código SQL versionado en Git con su respectiva prueba de no negatividad y validación de tipos.
            </div>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>DATA ENGINEERING STACK</div>
        <div>POSTGRESQL CLOUD • DBT CORE • SQL TRANSFORMATIONS • REPRODUCIBILIDAD COMPLETA</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>10:00 - 11:15</strong> | Duración: 1:15 min | <em>Fase: Pipeline ELT</em></p>
      <p>En esta lámina observamos la <strong>Arquitectura de Datos Moderna</strong> que implementamos siguiendo las mejores prácticas de la industria y la materia de Bases de Datos II:</p>
      <p>Sustituimos el ETL monolítico tradicional por un <strong>paradigma ELT</strong> (Extract-Load-Transform):</p>
      <p>1. <em>Extracción:</em> Script en Python con cliente HTTP asíncrono, paginando 50 registros por lote hasta consolidar los 65,000 viajes.<br>
      2. <em>Raw Stage:</em> Ingesta sin pérdida de fidelidad en tablas staging de PostgreSQL.<br>
      3. <em>Transformación Modular con dbt Core:</em> Estructurada en capas <code>stg</code> (limpieza y casteo), <code>int</code> (enriquecimiento con distancias Haversine y métricas de velocidad) y <code>fct</code>/<code>dim</code> (marts analíticos).<br>
      4. <em>Garantía de Calidad:</em> Suites de pruebas automatizadas (<code>dbt test</code>) verificando unicidad, no nulidad y consistencia referencial.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si preguntan por qué dbt: asegura reproducibilidad analítica, linaje visual de dependencias y pruebas de calidad automáticas antes de alimentar el optimizador.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos la estructura del modelo dimensional resultante en la capa de marts."</p>
    </aside>
  </section>
</template>

<script setup>
import MermaidDiagram from '../components/MermaidDiagram.vue';

const pipelineDiagram = `
flowchart LR
    API["API REST /movigo<br><b>Extracción Paged JSON</b>"] --> RAW[("PostgreSQL<br><b>Raw Staging</b>")]
    RAW --> STG["dbt Staging<br><b>stg_* (Cast & Clean)</b>"]
    STG --> INT["dbt Intermediate<br><b>int_* (Haversine & Geo)</b>"]
    INT --> MARTS[("Data Marts<br><b>fct_trips & dim_*</b>")]
    MARTS --> TESTS{{"dbt test<br><b>Unicidad & Integridad</b>"}}
`;
// Slide 9: 09. Arquitectura ELT & dbt Core
</script>
