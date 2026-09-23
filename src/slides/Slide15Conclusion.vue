<template>
  <section class="slide" data-slide="15" data-title="15. Síntesis & Próximos Pasos">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>14. Conclusiones y Próximos Pasos</span>
        </div>
        <div class="header-right">
          <span>Evaluación del Avance</span>
          <span class="slide-number-tag">15 / 16</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">SÍNTESIS DEL ESTADO ACTUAL</div>
        <h2 class="slide-title reveal">Logros del Avance e <em>Hitos Futuros</em></h2>
        <p class="slide-subtitle reveal">
          Se consolidaron los cimientos teóricos, metodológicos y la arquitectura de datos; el siguiente paso es la calibración y experimentación computacional.
        </p>

        <div class="grid-2">
          <div class="card reveal" style="border-left: 6px solid var(--border-bold);">
            <div class="card-label">Logros Consolidados en este Avance</div>
            <div class="card-title">Cimientos Analíticos y Arquitectura Lista</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Definición Rigurosa del Problema:</strong> Integración formal de la triple dimensión (operativa, territorial y climática) sin presunciones arbitrarias.</li>
              <li><strong>Arquitectura de Datos ELT Implementada:</strong> Esquema dimensional Kimball listo en PostgreSQL, con staging y marts gobernados por dbt.</li>
              <li><strong>Matriz de Operacionalización Completa:</strong> Descriptores, indicadores numéricos y técnicas de validación estructuradas.</li>
              <li><strong>Modelo MILP Formulado:</strong> Función objetivo multicriterio y restricciones físicas de red vehicular codificadas.</li>
            </ul>
          </div>

          <div class="card reveal" style="border-left: 6px solid var(--accent-red);">
            <div class="card-label">Siguientes Hitos de Ejecución</div>
            <div class="card-title">Calibración, Solvers &amp; Escenarios Finales</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Calibración con Datos Sintéticos/Reales:</strong> Carga de un dataset transaccional representativo del municipio de Managua con variables de viaje completas.</li>
              <li><strong>Ejecución del Solver MILP en Python:</strong> Obtención de los vectores de redistribución óptima <KatexMath expr="x_{ijt}" /> bajo escenarios seco vs. lluvioso.</li>
              <li><strong>Validación de Sensibilidad Climática:</strong> Corridas comparativas con series de precipitación e índice de congestión de la API.</li>
              <li><strong>Informe Final y Dashboard de Simulación:</strong> Visualización interactiva de matrices OD y panel de control prescriptivo para Movi Go.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>CRONOGRAMA DE INVESTIGACIÓN</div>
        <div>FASE ACTUAL: AVANCE METODOLÓGICO Y ARQUITECTÓNICO &rarr; FASE FINAL: SIMULACIÓN EXPERIMENTAL</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>17:30 - 18:30</strong> | Duración: 1:00 min | <em>Fase: Conclusiones y Próximos Pasos</em></p>
      <p>En este avance de investigación consolidamos los cimientos técnicos, metodológicos y matemáticos:</p>
      <p>1. Disponemos de un <strong>Data Mart validado</strong> con más de 65,000 registros procesados mediante el pipeline dbt.<br>
      2. Demostramos estadísticamente la <strong>autocorrelación espacial y el sesgo socioeconómico</strong> en la demanda.<br>
      3. Formulamos y probamos computacionalmente el <strong>modelo matemático MILP</strong>.</p>
      <p>Nuestros <strong>próximos pasos hacia la entrega final</strong> son:</p>
      <p>- Calibrar los ponderadores multiobjetivo mediante análisis de sensibilidad en el frente de Pareto.<br>
      - Implementar la arquitectura de inferencia en tiempo real con ventanas de despacho de 3 minutos.<br>
      - Finalizar el artículo científico con las especificaciones académicas requeridas.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."</p>
    </aside>
  </section>
</template>

<script setup>
import KatexMath from '../components/KatexMath.vue';
// Slide 15: 15. Síntesis & Próximos Pasos
</script>
