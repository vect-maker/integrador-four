<template>
  <section class="slide " data-slide="2" data-title="02. Contextualización: Sistema Dinámico">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>01. Contextualización del Problema</span>
                        </div>
                        <div class="header-right">
                            <span>Movi Go • Transporte Selectivo</span>
                            <span class="slide-number-tag">02 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">SISTEMA DINÁMICO DE MOVILIDAD URBANA</div>
                        <h2 class="slide-title reveal">Interdependencia <em>Operativa, Territorial y Tarifaria</em></h2>
                        <p class="slide-subtitle reveal">
                            La movilidad bajo demanda no responde a causas aisladas: la ubicación oportuna de unidades, la razonabilidad tarifaria y el entorno urbano configuran un sistema complejo en Managua.
                        </p>

                        <div class="grid-3">
                            <div class="card reveal">
                                <div class="card-number">01</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Clock :size="14" style="color: var(--accent-red);" />
                                    <span>Dimensión Operativa</span>
                                </div>
                                <div class="card-title">Dinámica de Flota y Tiempos</div>
                                <div class="card-text">
                                    Disponibilidad real de unidades, duración del viaje, tiempos de aproximación y permanencia sin pasajero. La capacidad efectiva se degrada cuando las unidades circulan desocupadas lejos del foco de demanda.
                                </div>
                                <ul class="swiss-list">
                                    <li>Tiempos de espera al usuario</li>
                                    <li>Kilómetros improductivos (deadhead)</li>
                                    <li>Utilización porcentual de unidades</li>
                                </ul>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">02</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <MapPin :size="14" style="color: var(--ink-primary);" />
                                    <span>Dimensión Territorial</span>
                                </div>
                                <div class="card-title">Heterogeneidad Espacial</div>
                                <div class="card-text">
                                    Managua presenta una estructura urbana discontinua y policéntrica (sectores comerciales, residenciales, productivos e institucionales) que genera asimetrías severas en flujos de origen y destino.
                                </div>
                                <ul class="swiss-list">
                                    <li>Patrones asimétricos Origen-Destino</li>
                                    <li>Zonas con déficit de cobertura relativa</li>
                                    <li>Variabilidad vial según horas punta</li>
                                </ul>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">03</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <TrendingUp :size="14" style="color: var(--accent-blue);" />
                                    <span>Dimensión Tarifaria</span>
                                </div>
                                <div class="card-title">Coherencia de Precios</div>
                                <div class="card-text">
                                    La tarifa debe articular los costos reales del viaje, las condiciones de circulación y la sostenibilidad del conductor sin generar barreras al usuario ni incentivos perversos de desbalance.
                                </div>
                                <ul class="swiss-list">
                                    <li>Correspondencia con costos reales</li>
                                    <li>Incentivos de redistribución de oferta</li>
                                    <li>Evaluación rigurosa de tarifa dinámica</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>INVESTIGACIÓN APLICADA • CIENCIA DE DATOS</div>
                        <div class="footer-metrics">
                            <div class="footer-metric-item">Volumen anual: <strong>> 65,000 viajes</strong></div>
                            <div class="footer-metric-item">Flota: <strong>Estándar, Comfort, Moto</strong></div>
                            <div class="footer-metric-item">Fuente: <strong>API /movigo/clima</strong></div>
                        </div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>01:15 - 02:30</strong> | Duración: 1:15 min | <em>Fase: Contextualización</em></p>
      <p>Aquí planteamos la premisa fundamental del proyecto: la movilidad bajo demanda es un <strong>sistema dinámico interdependiente</strong>.</p>
      <p>En primer lugar, la <strong>dimensión operativa</strong> no depende sólo de cuántos conductores hay conectados, sino de <em>dónde están</em>. Si los vehículos circulan desocupados lejos de los focos de demanda, el tiempo de espera del usuario se dispara.</p>
      <p>En segundo lugar, la <strong>dimensión territorial</strong> de Managua presenta una fuerte polarización: orígenes residenciales matutinos hacia corredores comerciales y de oficinas, generando viajes de ida con retorno vacío.</p>
      <p>Y en tercer lugar, la <strong>dimensión tarifaria</strong>: un esquema de precios estático no premia al conductor que viaja a zonas periféricas desabastecidas.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si el jurado pregunta por qué no basta con aumentar la flota, enfatizar que saturar de autos sin rebalanceo incrementa la congestión y reduce los ingresos netos del conductor.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos qué respaldo encontramos en la literatura científica para modelar este acoplamiento."</p>
    </aside>
  </section>
</template>

<script setup>
import { Clock, MapPin, TrendingUp } from '@lucide/vue';
// Slide 2: 02. Contextualización: Sistema Dinámico
</script>
