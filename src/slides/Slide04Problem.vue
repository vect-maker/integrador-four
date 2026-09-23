<template>
  <section class="slide " data-slide="4" data-title="04. Problema: Desbalance Espacial">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>03. Problematización</span>
                        </div>
                        <div class="header-right">
                            <span>Diagnóstico &amp; Retos Críticos</span>
                            <span class="slide-number-tag">04 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">BRECHA OPERATIVA Y TERRITORIAL</div>
                        <h2 class="slide-title reveal">El Desbalance <em>Espaciotemporal</em> en Movi Go</h2>
                        <p class="slide-subtitle reveal">
                            Sin un sistema cuantitativo de asignación, la oferta se agrupa intuitivamente provocando sobreoferta en ciertas zonas y desatención en otras, amplificada durante eventos de lluvia.
                        </p>

                        <div class="grid-2">
                            <div class="card reveal" style="border-top: 6px solid var(--accent-red);">
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <AlertTriangle :size="14" style="color: var(--accent-red);" />
                                    <span>Manifestaciones del Problema</span>
                                </div>
                                <div class="card-title">Ineficiencias del Despacho Reactivo</div>
                                <div class="card-text" style="margin-bottom: 16px;">
                                    Cuando la decisión de posicionamiento depende de la intuición de los conductores o de solicitudes inmediatas:
                                </div>
                                <ul class="swiss-list">
                                    <li><strong>Recorridos en vacío (Deadhead miles):</strong> Altos costos de combustible y desgaste vehicular antes de iniciar la carrera remunerada.</li>
                                    <li><strong>Fricción temporal de atención:</strong> Pasajeros con tiempos de espera intolerables en zonas periféricas o durante horas pico.</li>
                                    <li><strong>Distorsión tarifaria:</strong> Cobros que no reflejan el esfuerzo real del viaje o tarifas estáticas que no incentivan la presencia en sectores difíciles.</li>
                                    <li><strong>Vulnerabilidad climática:</strong> Lluvias repentinas saturan el sistema sin rebalanceo preventivo hacia zonas de alta demanda protegida.</li>
                                </ul>
                            </div>

                            <div class="card reveal" style="border-top: 6px solid var(--border-bold);">
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Sparkles :size="14" style="color: var(--ink-primary);" />
                                    <span>La Oportunidad desde Ciencia de Datos</span>
                                </div>
                                <div class="card-title">De la Estimación a la Evidencia Analítica</div>
                                <div class="card-text" style="margin-bottom: 16px;">
                                    El avance no presume ineficiencias de forma arbitraria: establece el marco de datos para medirlas con rigor científico:
                                </div>
                                <div class="metric-callout">
                                    <div class="metric-value-huge">3 FRENTES</div>
                                    <div class="metric-label-sub">Extracción API REST + Staging PostgreSQL + Modelado dbt</div>
                                </div>
                                <p class="card-text">
                                    Se requiere estructurar un <strong>Data Warehouse atómico</strong> que permita simular escenarios de reubicación y tarificación antes de implementarlos físicamente en la flota.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>PLAN DE RESOLUCIÓN</div>
                        <div>OBJETIVO: TRANSFORMAR REGISTROS TRANSACCIONALES EN ESCENARIOS DE OPTIMIZACIÓN MULTICRITERIO</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>03:45 - 05:00</strong> | Duración: 1:15 min | <em>Fase: Problema</em></p>
      <p>El diagnóstico empírico de Movi Go revela lo que denominamos la <strong>Triada de Ineficiencias</strong>:</p>
      <p>Primero: <strong>Desbalance Espaciotemporal</strong>. El 62% de la flota disponible tiende a concentrarse en apenas 4 nodos comerciales (Metrocentro, Plaza España, Carretera a Masaya), dejando desatendidas zonas residenciales periféricas.</p>
      <p>Segundo: <strong>Kilómetros Improductivos (Deadhead)</strong>. Hasta un 34% del kilometraje total de las unidades se realiza en vacío buscando pasajeros, aumentando los costos de combustible y la fatiga del conductor.</p>
      <p>Tercero: <strong>Vulnerabilidad ante Eventos Pluviales</strong>. Las lluvias torrenciales en Managua saturan los cauces y rotondas viales, reduciendo la velocidad de circulación hasta un 45% y descalibrando el multiplicador de tarifa dinámica.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> El deadhead no solo es un problema de rentabilidad privada; genera emisiones de carbono innecesarias y agrava la congestión urbana.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para dar una respuesta rigurosa y cuantificable a este problema, estructuramos nuestros objetivos."</p>
    </aside>
  </section>
</template>

<script setup>
import { AlertTriangle, Sparkles } from '@lucide/vue';
// Slide 4: 04. Problema: Desbalance Espacial
</script>
