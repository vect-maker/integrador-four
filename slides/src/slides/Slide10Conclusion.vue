<template>
  <section class="slide" data-slide="10" data-title="10. Síntesis &amp; Próximos Pasos">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>10. Conclusiones y Plan de Implementación</span>
        </div>
        <div class="header-right">
          <span>Evaluación de la Propuesta</span>
          <span class="slide-number-tag">10 / 11</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">SÍNTESIS DE LA PROPUESTA</div>
        <h2 class="slide-title reveal">Propuesta Diseñada y <em>Ruta de Implementación</em></h2>
        <p class="slide-subtitle reveal">
          Se estructuran las bases teóricas, metodológicas y el diseño arquitectónico a implementar; la siguiente etapa contempla el despliegue del pipeline y la experimentación computacional.
        </p>

        <div class="grid-2">
          <div class="card reveal" style="border-left: 6px solid var(--border-bold);">
            <div class="card-label" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <CheckCircle2 :size="20" style="color: var(--accent-blue); flex-shrink: 0;" />
              <span>Alcance y Especificación de la Propuesta</span>
            </div>
            <div class="card-title">Marco Metodológico y Arquitectura a Implementar</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Formulación Integral del Problema:</strong> Estructuración formal de la triple dimensión (dinámica operativa, espacial y climática) para el análisis de viajes.</li>
              <li><strong>Arquitectura de Datos ELT Proyectada:</strong> Especificación del esquema dimensional Kimball a desplegarse en PostgreSQL, con staging y marts gobernados por dbt.</li>
              <li><strong>Matriz de Operacionalización Definida:</strong> Selección rigurosa de descriptores dimensionales, métricas operativas y protocolos de validación analítica.</li>
              <li><strong>Marco de Optimización y Modelado:</strong> Formulación conceptual de los objetivos multiobjetivo y restricciones de red para la toma de decisiones informada.</li>
            </ul>
          </div>

          <div class="card reveal" style="border-left: 6px solid var(--accent-red);">
            <div class="card-label" style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <Target :size="20" style="color: var(--accent-red); flex-shrink: 0;" />
              <span>Próximos Hitos de Implementación</span>
            </div>
            <div class="card-title">Despliegue Técnico, Calibración &amp; Experimentación</div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li><strong>Despliegue del Pipeline e Ingesta de Datos:</strong> Conexión efectiva con la API REST de Movi Go y poblamiento del repositorio de datos en PostgreSQL.</li>
              <li><strong>Ejecución y Transformación con dbt:</strong> Materialización de capas de staging y marts dimensionales con pruebas de integridad automatizadas.</li>
              <li><strong>Calibración y Simulación Computacional:</strong> Parametrización de los algoritmos de optimización bajo escenarios contrastados (seco vs. lluvioso).</li>
              <li><strong>Informe Final y Herramienta de Soporte:</strong> Desarrollo del tablero analítico prescriptivo para la toma de decisiones estratégicas de la plataforma.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>PLAN DE TRABAJO E INVESTIGACIÓN</div>
        <div>FASE ACTUAL: ESPECIFICACIÓN Y DISEÑO DE ARQUITECTURA &rarr; SIGUIENTE FASE: IMPLEMENTACIÓN Y EXPERIMENTACIÓN</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>10:00 - 11:00</strong> | Duración: 1:00 min | <em>Fase: Síntesis y Ruta de Implementación</em></p>
      <p>En esta propuesta de investigación hemos definido las bases técnicas, metodológicas y analíticas que se van a implementar:</p>
      <p>1. Se ha diseñado la <strong>arquitectura ELT</strong> con ingesta desde la API REST de Movi Go y transformación dimensional mediante dbt a implementarse en PostgreSQL.<br>
      2. Se definieron las directrices para el <strong>análisis espaciotemporal y contextual</strong> de la demanda frente al clima.<br>
      3. Se formuló el <strong>modelo de optimización multiobjetivo</strong> para apoyar la gestión operativa y tarifaria.</p>
      <p>Los <strong>siguientes pasos de implementación</strong> contemplan:</p>
      <p>- Desplegar el pipeline de datos y materializar los modelos analíticos en dbt.<br>
      - Calibrar y simular los escenarios de asignación de flota en el contexto de Managua.<br>
      - Desarrollar el informe final y la herramienta interactiva de soporte a decisiones.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."</p>
    </aside>
  </section>
</template>

<script setup>
import { CheckCircle2, Target } from '@lucide/vue';
// Slide 10: 10. Síntesis & Próximos Pasos
</script>
