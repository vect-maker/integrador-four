<template>
  <section class="slide " data-slide="11" data-title="11. Cierre &amp; Sesión de Preguntas">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>11. Defensa de Avance</span>
                        </div>
                        <div class="header-right">
                            <span>Ingeniería en Ciencia de Datos</span>
                            <span class="slide-number-tag">11 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body" style="justify-content: center; align-items: center; text-align: center;">
                        <div class="section-tag reveal" style="justify-content: center; display: inline-flex; align-items: center; gap: 8px;">
                            <HelpCircle :size="20" style="color: var(--accent-red); flex-shrink: 0;" />
                            <span>SESIÓN DE PREGUNTAS Y DEFENSA</span>
                        </div>
                        <h2 class="slide-title reveal" style="font-size: 58px; max-width: 1300px; margin: 0 auto 20px auto;">
                            Optimización territorial de la flota vehicular y sistema tarifario — <em>Movi Go</em>
                        </h2>
                        <p class="slide-subtitle reveal" style="font-size: 24px; max-width: 900px; margin: 0 auto;">
                            Muchas gracias por su atención. Quedamos a disposición del comité evaluador para comentarios y preguntas.
                        </p>
                    </div>

                    <div class="slide-footer">
                        <div>DEFENSA DE INVESTIGACIÓN • INTEGRADOR IV</div>
                        <div>2026 • CIENCIA DE DATOS</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>11:00+</strong> | Duración: Sesión Q&A | <em>Fase: Defensa ante el Jurado</em></p>
      <p>Muchas gracias a los profesores y miembros del jurado evaluador. Abrimos con gusto la sesión de preguntas y retroalimentación.</p>
      <p><strong>🎯 Respuestas de Defensa Preparadas para Preguntas Comunes:</strong></p>
      <p>• <em>¿Por qué la ingesta con API REST y dbt es la base fija?</em><br>
      "Porque los datos provienen del servicio real/emulado en la API /movigo, y dbt garantiza reproducibilidad total, linaje formal y pruebas de integridad referencial antes de alimentar cualquier modelo analítico o prescriptivo."</p>
      <p>• <em>¿Por qué los modelos matemáticos y estadísticos se presentan como exploratorios?</em><br>
      "Porque las técnicas numéricas, de inferencia y optimización deben contrastarse y calibrarse según la distribución empírica de los datos observados en Managua, sin asumir métodos rígidos a priori."</p>
      <p>• <em>¿Cómo se garantiza la reproducibilidad de los datos?</em><br>
      "Todo el pipeline está versionado en Git, con seeds y modelos de dbt, scripts de ingesta estructurados y documentación técnica completa."</p>
    </aside>
  </section>
</template>

<script setup>
import { HelpCircle } from '@lucide/vue';
// Slide 11: 11. Cierre & Sesión de Preguntas
</script>
