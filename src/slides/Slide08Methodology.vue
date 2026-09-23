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
                            <span class="slide-number-tag">08 / 16</span>
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
          <div class="card-label" style="margin-bottom: 8px;">Fases Secuenciales del Proceso Metodológico</div>
          <MermaidDiagram :code="methodologyDiagram" max-width="100%" />
        </div>

        <div class="grid-4">
                            <div class="card reveal">
                                <div class="card-number">A</div>
                                <div class="card-label">Enfoque</div>
                                <div class="card-title">Enfoque Mixto</div>
                                <div class="card-text">
                                    Preponderancia cuantitativa (análisis de millones de registros GPS, tiempos y tarifas) complementada con la interpretación cualitativa de políticas de asignación vehicular y entrevistas operativas de Movi Go.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">B</div>
                                <div class="card-label">Tipo &amp; Alcance</div>
                                <div class="card-title">Descriptivo &amp; Propositivo</div>
                                <div class="card-text">
                                    Inicia describiendo la distribución y variabilidad del servicio en Managua, avanza hacia la correlación con clima y concluye con una formulación prescriptiva de optimización de flota y tarifas.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">C</div>
                                <div class="card-label">Diseño</div>
                                <div class="card-title">No Experimental</div>
                                <div class="card-text">
                                    Diseño no experimental transversal/longitudinal: se observan y analizan los registros sin manipulación arbitraria, modelando el comportamiento histórico real del servicio en sus condiciones contextuales.
                                </div>
                            </div>

                            <div class="card accent-card reveal">
                                <div class="card-number" style="color: var(--accent-red);">D</div>
                                <div class="card-label" style="color: var(--accent-red);">Unidad de Análisis</div>
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
      <p class="notes-meta">⏱ <strong>08:45 - 10:00</strong> | Duración: 1:15 min | <em>Fase: Metodología</em></p>
      <p>Adoptamos un <strong>enfoque cuantitativo-analítico</strong> con un diseño no experimental longitudinal de panel.</p>
      <p>La investigación se ejecuta en <strong>cuatro fases secuenciales e integradas</strong>:</p>
      <p><strong>Fase 1: Ingesta y Estandarización</strong>. Extracción sistemática vía API REST <code>/movigo</code> con paginación controlada y validación de esquemas Pydantic.<br>
      <strong>Fase 2: Arquitectura y Modelado Dimensional</strong>. Pipeline ELT con dbt Core y PostgreSQL bajo la metodología Kimball.<br>
      <strong>Fase 3: Análisis Espacial e Inferencia</strong>. Construcción de matrices OD, pruebas $\chi^2$ y cálculo del Índice de Moran.<br>
      <strong>Fase 4: Optimización Matemática y Simulación</strong>. Resolución del modelo MILP en Python y contraste cuantitativo de escenarios.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Entremos al detalle de la arquitectura de datos construida en la Fase 1 y 2."</p>
    </aside>
  </section>
</template>

<script setup>
import MermaidDiagram from '../components/MermaidDiagram.vue';

const methodologyDiagram = `
flowchart LR
    F1["<b>Fase 1: Ingesta</b><br/>API REST /movigo & Pydantic"] --> F2["<b>Fase 2: Modelado</b><br/>ELT Kimball & dbt Core"]
    F2 --> F3["<b>Fase 3: Inferencia</b><br/>Matrices O-D & Moran Espacial"]
    F3 --> F4["<b>Fase 4: Optimización</b><br/>Modelo MILP & Simulación"]
`;
// Slide 8: 08. Diseño Metodológico Mixto
</script>
