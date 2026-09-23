<template>
  <section class="slide " data-slide="7" data-title="07. Marco Teórico: Transporte & Clima">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>06. Marco Conceptual</span>
                        </div>
                        <div class="header-right">
                            <span>Teoría de Transporte &amp; Comportamiento Exógeno</span>
                            <span class="slide-number-tag">07 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">FUNDAMENTOS DE TRANSPORTE Y DINÁMICA CLIMÁTICA</div>
                        <h2 class="slide-title reveal">Heterogeneidad Urbana y <em>Efecto Meteorológico</em></h2>
                        <p class="slide-subtitle reveal">
                            La teoría de ride-hailing advierte que disponer de vehículos totales no garantiza cobertura si no coinciden en tiempo y espacio con la demanda urbana.
                        </p>

                        <div class="grid-3">
                            <div class="card reveal">
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Network :size="13" style="color: var(--accent-red);" />
                                    <span>Heterogeneidad Espaciotemporal</span>
                                </div>
                                <div class="card-title">Xu et al. / Moran's I</div>
                                <div class="card-text">
                                    La demanda de movilidad presenta alta autocorrelación espacial y picos concentrados. Si las unidades no se anticipan a los centros generadores de viajes, se incrementa el ratio de <strong>deadhead miles</strong> (recorridos sin pasajero), consumiendo combustible y depreciando la flota.
                                </div>
                                <div style="margin-top: 14px; padding: 10px; background: var(--card-subtle); border-left: 3px solid var(--accent-red); font-family: var(--font-mono); font-size: 13px;">
                                    Moran's I &gt; 0: Concentración espacial de demanda en clusters críticos.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <CloudRain :size="13" style="color: var(--accent-blue);" />
                                    <span>Doble Incidencia Climática</span>
                                </div>
                                <div class="card-title">Precipitación &amp; Velocidad</div>
                                <div class="card-text">
                                    En Managua, con 1,119.8 mm anuales y estacionalidad marcada, la lluvia genera un efecto dual:
                                    <br><br>
                                    <strong>1. Expansión de Demanda:</strong> Los transeúntes migran a transporte selectivo.
                                    <br>
                                    <strong>2. Reducción de Oferta Efectiva:</strong> Disminuye la velocidad de circulación por anegamientos, prolongando la duración de cada viaje y reteniendo unidades ocupadas por más tiempo.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <TrendingDown :size="13" style="color: var(--accent-red);" />
                                    <span>Riesgos de Tarificación</span>
                                </div>
                                <div class="card-title">Efectos Adversos del Surge Pricing</div>
                                <div class="card-text">
                                    Investigaciones en <em>Nature Communications</em> evidencian que una tarificación dinámica mal diseñada puede inducir desbalances en lugar de corregirlos.
                                    <br><br>
                                    Un precio excesivo expulsa a los usuarios habituales, mientras que precios planos en horas críticas incentivan a los choferes a desconectarse o rechazar servicios en zonas distantes.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>ANÁLISIS INTEGRADO</div>
                        <div>EL MODELO DEBE CONSIDERAR RESTRICCIONES VIALES Y CLIMÁTICAS SIMULTÁNEAMENTE</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>07:30 - 08:45</strong> | Duración: 1:15 min | <em>Fase: Marco Teórico</em></p>
      <p>En el marco teórico profundizamos en tres fenómenos estructurales propios de Managua:</p>
      <p>Primero, la <strong>morfología urbana y vial</strong>. Managua no es una cuadrícula; es un trazado irregular articulado por rotondas (Centroamérica, Rubén Darío, Cristo Rey). Cuando una rotonda colapsa, el efecto dominó estrangula las arterias conectoras.</p>
      <p>Segundo, la <strong>economía de plataformas de dos lados (Two-Sided Markets)</strong>. La tarifa debe mantener un equilibrio delicado: si el surge sube demasiado, el pasajero de estrato popular o medio cancela; si baja demasiado, el conductor prefiere desconectarse ante la lluvia.</p>
      <p>Tercero, la <strong>hidrología vial urbana</strong>. La escorrentía superficial convierte calles en cauces temporales, obligando a recalibrar las matrices de tiempo de viaje de forma no lineal.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con el sustento teórico establecido, expliquemos el diseño metodológico de la investigación."</p>
    </aside>
  </section>
</template>

<script setup>
import { Network, CloudRain, TrendingDown } from '@lucide/vue';
// Slide 7: 07. Marco Teórico: Transporte & Clima
</script>
