<template>
  <section class="slide " data-slide="8" data-title="08. Diseño Metodológico Mixto">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>07. Diseño Metodológico</span>
                        </div>
                        <div class="header-right">
                            <span>Enfoque, Tipo y Alcance</span>
                            <span class="slide-number-tag">08 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">RIGOR EPISTEMOLÓGICO Y OPERACIONAL</div>
                        <h2 class="slide-title reveal">Enfoque Mixto y <em>Diseño no Experimental</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 14px;">
          Articulación del procesamiento cuantitativo de eventos transaccionales con la validación cualitativa de reglas de negocio y restricciones de la empresa.
        </p>

        <!-- Mermaid Roadmap Diagram -->
        <div class="card reveal" style="padding: 14px 20px; margin-bottom: 16px; background: var(--card-bg);">
          <div class="card-label" style="margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
            <Workflow :size="13" style="color: var(--accent-red);" />
            <span>Fases Secuenciales del Proceso Metodológico</span>
          </div>
          <MermaidDiagram :code="methodologyDiagram" max-width="100%" />
        </div>

        <div class="grid-4">
                            <div class="card reveal">
                                <div class="card-number">A</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Binary :size="13" style="color: var(--accent-red);" />
                                    <span>Enfoque</span>
                                </div>
                                <div class="card-title">Enfoque Mixto</div>
                                <div class="card-text">
                                    Preponderancia cuantitativa (análisis de millones de registros GPS, tiempos y tarifas) complementada con la interpretación cualitativa de políticas de asignación vehicular y entrevistas operativas de Movi Go.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">B</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Compass :size="13" style="color: var(--accent-red);" />
                                    <span>Tipo &amp; Alcance</span>
                                </div>
                                <div class="card-title">Descriptivo &amp; Propositivo</div>
                                <div class="card-text">
                                    Inicia describiendo la distribución y variabilidad del servicio en Managua, avanza hacia la correlación con clima y concluye con una formulación prescriptiva de optimización de flota y tarifas.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">C</div>
                                <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                                    <Eye :size="13" style="color: var(--accent-red);" />
                                    <span>Diseño</span>
                                </div>
                                <div class="card-title">No Experimental</div>
                                <div class="card-text">
                                    Diseño no experimental transversal/longitudinal: se observan y analizan los registros sin manipulación arbitraria, modelando el comportamiento histórico real del servicio en sus condiciones contextuales.
                                </div>
                            </div>

                            <div class="card accent-card reveal">
                                <div class="card-number" style="color: var(--accent-red);">D</div>
                                <div class="card-label" style="color: var(--accent-red); display: flex; align-items: center; gap: 6px;">
                                    <Car :size="13" />
                                    <span>Unidad de Análisis</span>
                                </div>
                                <div class="card-title">El Viaje Individual</div>
                                <div class="card-text" style="color: #e2e8f0;">
                                    El ciclo atómico de solicitud, abordaje, trayecto y tarifa cobrada en cada cuadrante territorial del municipio de Managua, georreferenciado temporal y espacialmente.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>METODOLOGÍA DE INVESTIGACIÓN</div>
                        <div>SUSTENTO METODOLÓGICO BASADO EN HERNÁNDEZ SAMPIERI &amp; MENDOZA TORRES (2023)</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>07:30 - 08:45</strong> | Duración: 1:15 min | <em>Fase: Metodología</em></p>
      <p>Adoptamos un <strong>enfoque cuantitativo-analítico</strong> con un diseño no experimental longitudinal.</p>
      <p>La investigación se articula en <strong>cuatro fases secuenciales</strong> alineadas a los objetivos específicos:</p>
      <p><strong>Fase 1: Ingesta de Datos</strong>. Extracción sistemática vía API REST <code>/movigo</code> con paginación controlada.<br>
      <strong>Fase 2: Transformación y Calidad con dbt</strong>. Modelado analítico dimensional y auditoría con dbt Core sobre PostgreSQL.<br>
      <strong>Fase 3: Análisis Espaciotemporal y Tarifario</strong>. Caracterización de fluctuaciones de demanda, factores climáticos y sensibilidad del surge.<br>
      <strong>Fase 4: Optimización Operativa</strong>. Formulación y contraste de modelos prescriptivos de asignación de flota y reducción de deadhead.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Entremos al detalle de la arquitectura del pipeline de datos con API y dbt."</p>
    </aside>
  </section>
</template>

<script setup>
import { Workflow, Binary, Compass, Eye, Car } from '@lucide/vue';
import MermaidDiagram from '../components/MermaidDiagram.vue';

const methodologyDiagram = `
flowchart LR
    F1["<b>Fase 1: Ingesta</b><br/>API REST /movigo & Raw DB"] --> F2["<b>Fase 2: Modelado</b><br/>Transformación dbt Core & Tests"]
    F2 --> F3["<b>Fase 3: Análisis</b><br/>Espaciotemporal & Surge Pricing"]
    F3 --> F4["<b>Fase 4: Optimización</b><br/>Asignación & Mitigación Deadhead"]
`;
// Slide 8: 08. Diseño Metodológico Mixto
</script>
