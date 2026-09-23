<template>
  <section class="slide " data-slide="13" data-title="13. Simulación de 3 Escenarios">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>12. Evaluación Prescriptiva</span>
                        </div>
                        <div class="header-right">
                            <span>Simulación &amp; Comparación de Escenarios</span>
                            <span class="slide-number-tag">13 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">SIMULACIÓN OPERACIONAL</div>
                        <h2 class="slide-title reveal">Evaluación Comparativa de <em>3 Escenarios</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 16px;">
                            Contraste cuantitativo entre la operación empírica tradicional y las propuestas de optimización de flota y tarificación adaptativa.
                        </p>

                        <div class="grid-3">
                            <div class="card reveal" style="border-top: 6px solid var(--border-bold);">
                                <div class="card-number">ESC 0</div>
                                <div class="card-label">Línea Base</div>
                                <div class="card-title">Operación Tradicional</div>
                                <div class="card-text">
                                    Despacho reactivo guiado por intuición individual de choferes y esquema tarifario estático:
                                </div>
                                <ul class="swiss-list" style="margin-top: 14px;">
                                    <li>Alta dispersión en tiempos de espera (12 - 25 min en horas pico).</li>
                                    <li>Elevado porcentaje de deadhead miles (~35-40% del recorrido total).</li>
                                    <li>Colapso de cobertura ante lluvias súbitas en zonas comerciales.</li>
                                    <li>Tarifa invariable que desincentiva viajes difíciles.</li>
                                </ul>
                            </div>

                            <div class="card reveal" style="border-top: 6px solid var(--accent-red);">
                                <div class="card-number" style="color: var(--accent-red);">ESC 1</div>
                                <div class="card-label">Optimización Territorial</div>
                                <div class="card-title">Rebalanceo Proactivo de Flota</div>
                                <div class="card-text">
                                    Redistribución territorial mediante el modelo MILP según matrices OD anticipadas:
                                </div>
                                <ul class="swiss-list" style="margin-top: 14px;">
                                    <li><strong>Reducción estimada de 20-30%</strong> en tiempos de espera al usuario.</li>
                                    <li><strong>Disminución de 18-25%</strong> en recorridos en vacío entre carreras.</li>
                                    <li>Mejor cobertura territorial de sectores periféricos de Managua.</li>
                                    <li>Mantiene esquema tarifario contractual base.</li>
                                </ul>
                            </div>

                            <div class="card accent-card reveal" style="border-top: 6px solid var(--accent-red);">
                                <div class="card-number" style="color: var(--accent-red);">ESC 2</div>
                                <div class="card-label" style="color: var(--accent-red);">Propuesta Integral</div>
                                <div class="card-title">Flota + Tarifa Adaptativa</div>
                                <div class="card-text" style="color: #e2e8f0;">
                                    Acoplamiento de reubicación proactiva con tarifas adaptativas ligadas al clima:
                                </div>
                                <ul class="swiss-list" style="margin-top: 14px; color: #f1f5f9;">
                                    <li>Tarifas calibradas con límites regulatorios estrictos ante alertas climáticas y congestión vial.</li>
                                    <li>Incentivos económicos verificables para que la flota atienda zonas lluviosas.</li>
                                    <li>Incremento estimado del <strong>15% en viajes efectivos completados</strong>.</li>
                                    <li>Sostenibilidad económica superior para conductor y plataforma.</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>ANÁLISIS DE SENSIBILIDAD</div>
                        <div>EVALUACIÓN MULTIOBJETIVO: TIEMPOS DE ATENCIÓN VS. COSTOS OPERATIVOS VS. INGRESO TOTAL</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>15:00 - 16:15</strong> | Duración: 1:15 min | <em>Fase: Simulación</em></p>
      <p>Evaluamos cuantitativamente el impacto de la optimización a través de <strong>tres escenarios comparativos</strong>:</p>
      <p><strong>Escenario 1 (Operación Base Empírica):</strong> Despacho reactivo convencional por distancia mínima. Tiempo de espera promedio de <strong>8.2 minutos</strong>, <strong>34.2% de deadhead</strong> y un 18% de viajes cancelados en hora punta.</p>
      <p><strong>Escenario 2 (Optimizado MILP + Tarifa Dinámica):</strong> Asignación conjunta y rebalanceo preventivo. El tiempo de espera cae a <strong>4.3 minutos (-47%)</strong>, el kilometraje en vacío se reduce al <strong>21.5% (-37%)</strong>, y la tasa de conversión sube al <strong>94.6%</strong>.</p>
      <p><strong>Escenario 3 (Estrés Pluvial - Tormenta de 35 mm/h):</strong> Sin optimización el sistema colapsaría. Con nuestro modelo adaptativo y penalizaciones de riesgo pluvial, la espera se amortigua a 6.8 minutos y se retiene el 89% de conductores activos.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Este proyecto es el reflejo directo de la integración académica del semestre."</p>
    </aside>
  </section>
</template>

<script setup>
// Slide 13: 13. Simulación de 3 Escenarios
</script>
