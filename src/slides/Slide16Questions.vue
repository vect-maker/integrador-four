<template>
  <section class="slide " data-slide="16" data-title="16. Cierre & Sesión de Preguntas">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>15. Defensa de Avance</span>
                        </div>
                        <div class="header-right">
                            <span>Ingeniería en Ciencia de Datos</span>
                            <span class="slide-number-tag">16 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body" style="justify-content: center; align-items: center; text-align: center;">
                        <div class="section-tag reveal" style="justify-content: center;">SESIÓN DE PREGUNTAS Y DEFENSA</div>
                        <h2 class="slide-title reveal" style="font-size: 58px; max-width: 1300px; margin: 0 auto 20px auto;">
                            Optimización territorial de la flota vehicular y sistema tarifario — <em>Movi Go</em>
                        </h2>
                        <p class="slide-subtitle reveal" style="font-size: 24px; max-width: 900px; margin: 0 auto 40px auto;">
                            Muchas gracias por su atención. Quedamos a disposición del comité evaluador para comentarios y preguntas.
                        </p>

                        <div class="grid-3 reveal" style="max-width: 1200px; margin: 0 auto; text-align: left;">
                            <div class="card subtle-card" style="padding: 20px;">
                                <div class="card-label">Institución</div>
                                <div style="font-weight: 800; font-size: 16px;">Ciencias Básicas y Tecnología</div>
                                <div style="font-size: 14px; color: var(--ink-secondary); margin-top: 4px;">Ingeniería en Ciencia de Datos</div>
                            </div>
                            <div class="card subtle-card" style="padding: 20px;">
                                <div class="card-label">Asignatura</div>
                                <div style="font-weight: 800; font-size: 16px;">Integrador IV</div>
                                <div style="font-size: 14px; color: var(--ink-secondary); margin-top: 4px;">Segundo Año • Segundo Semestre 2026</div>
                            </div>
                            <div class="card subtle-card" style="padding: 20px;">
                                <div class="card-label">Sede / Ubicación</div>
                                <div style="font-weight: 800; font-size: 16px;">Managua, Nicaragua</div>
                                <div style="font-size: 14px; color: var(--ink-secondary); margin-top: 4px;">Caso: Movi Go Selectivo</div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>DEFENSA DE INVESTIGACIÓN • INTEGRADOR IV</div>
                        <div>2026 • CIENCIA DE DATOS</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>18:30+</strong> | Duración: Sesión Q&A | <em>Fase: Defensa ante el Jurado</em></p>
      <p>Muchas gracias a los profesores y miembros del jurado evaluador. Abrimos con gusto la sesión de preguntas y retroalimentación.</p>
      <p><strong>🎯 Respuestas de Defensa Preparadas para Preguntas Comunes:</strong></p>
      <p>• <em>¿Por qué MILP y no solo una heurística como Algoritmos Genéticos?</em><br>
      "El MILP nos garantiza optimalidad matemática global o un gap de optimalidad acotado demostrable. Para ventanas de despacho de 3 minutos sobre cuadrantes de Managua, el solver PuLP con CBC o HiGHS resuelve en menos de 1.8 segundos, por lo que no es necesario sacrificar optimalidad con una heurística ciega."</p>
      <p>• <em>¿Cómo afecta la informalidad del transporte en Managua?</em><br>
      "La modelamos en la elasticidad precio y en la matriz de métodos de pago en efectivo, lo que justifica por qué el surge pricing no puede ser puramente multiplicativo en zonas periféricas sin generar deserción masiva."</p>
      <p>• <em>¿Cómo se garantiza la reproducibilidad de los datos?</em><br>
      "Todo el pipeline está versionado en Git, con seeds de dbt, scripts de ingesta idempotentes y semillas pseudoaleatorias fijadas para la simulación sintética."</p>
    </aside>
  </section>
</template>

<script setup>
// Slide 16: 16. Cierre & Sesión de Preguntas
</script>
