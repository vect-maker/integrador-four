<template>
  <section class="slide" data-slide="10" data-title="10. Síntesis &amp; Próximos Pasos">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>10. Conclusiones y Próximos Pasos</span>
        </div>
        <div class="header-right">
          <span>Evaluación del Avance</span>
          <span class="slide-number-tag">10 / 11</span>
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
            <div class="card-label" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <CheckCircle2 :size="20" style="color: var(--accent-blue); flex-shrink: 0;" />
              <span>Logros Consolidados en este Avance</span>
            </div>
            <div class="card-title">Cimientos Analíticos y Arquitectura Lista</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Definición Rigurosa del Problema:</strong> Integración formal de la triple dimensión (operativa, territorial y climática) sin presunciones arbitrarias.</li>
              <li><strong>Arquitectura de Datos ELT Implementada:</strong> Esquema dimensional Kimball listo en PostgreSQL, con staging y marts gobernados por dbt.</li>
              <li><strong>Matriz de Operacionalización Completa:</strong> Descriptores, indicadores numéricos y técnicas de validación estructuradas.</li>
              <li><strong>Marco de Optimización y Modelado:</strong> Formulación conceptual de los criterios operativos y restricciones de red para la toma de decisiones.</li>
            </ul>
          </div>

          <div class="card reveal" style="border-left: 6px solid var(--accent-red);">
            <div class="card-label" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <Target :size="20" style="color: var(--accent-red); flex-shrink: 0;" />
              <span>Siguientes Hitos de Ejecución</span>
            </div>
            <div class="card-title">Calibración, Simulación &amp; Escenarios Finales</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Calibración con Datos Sintéticos/Reales:</strong> Carga de un dataset transaccional representativo del municipio de Managua con variables de viaje completas.</li>
              <li><strong>Experimentación y Evaluación de Modelos:</strong> Calibración y simulación de alternativas algorítmicas de optimización de flota bajo escenarios seco vs. lluvioso.</li>
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
      <p class="notes-meta">⏱ <strong>10:00 - 11:00</strong> | Duración: 1:00 min | <em>Fase: Conclusiones y Próximos Pasos</em></p>
      <p>En este avance de investigación consolidamos los cimientos técnicos, metodológicos y analíticos:</p>
      <p>1. Disponemos de un <strong>Data Mart validado</strong> con registros procesados mediante el pipeline dbt sobre la base de la API REST.<br>
      2. Establecimos el marco para el <strong>análisis espaciotemporal y contextual</strong> de la demanda y el clima.<br>
      3. Formulamos las directrices para la <strong>evaluación de la dinámica tarifaria y optimización</strong>.</p>
      <p>Nuestros <strong>próximos pasos hacia la entrega final</strong> son:</p>
      <p>- Calibrar los ponderadores multiobjetivo mediante análisis de escenarios en Managua.<br>
      - Evaluar el comportamiento de algoritmos prescriptivos y sensibilidad climática.<br>
      - Finalizar el informe y tablero interactivo de control para la toma de decisiones.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."</p>
    </aside>
  </section>
</template>

<script setup>
import { CheckCircle2, Target } from '@lucide/vue';
// Slide 10: 10. Síntesis & Próximos Pasos
</script>
