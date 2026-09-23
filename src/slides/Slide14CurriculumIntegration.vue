<template>
  <section class="slide " data-slide="14" data-title="14. Integración Curricular">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>13. Articulación Curricular</span>
                        </div>
                        <div class="header-right">
                            <span>Ingeniería en Ciencia de Datos</span>
                            <span class="slide-number-tag">14 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">INTERDISCIPLINARIEDAD DEL INTEGRADOR IV</div>
                        <h2 class="slide-title reveal">Convergencia de las <em>Cinco Asignaturas</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 14px;">
                            El proyecto articula holísticamente los contenidos del semestre para resolver una problemática real de ingeniería urbana en Managua.
                        </p>

                        <!-- Mermaid Curriculum Convergence Diagram -->
                        <div class="card reveal" style="padding: 14px 20px; margin-bottom: 16px; background: var(--card-bg);">
                            <div class="card-label" style="margin-bottom: 8px;">Convergencia Transversal de Competencias de Ingeniería</div>
                            <MermaidDiagram :code="curriculumDiagram" max-width="100%" />
                        </div>

                        <div class="grid-4" style="grid-template-columns: repeat(5, 1fr); gap: 18px;">
                            <div class="card reveal" style="padding: 22px 18px;">
                                <div class="card-label">Eje 1</div>
                                <div class="card-title" style="font-size: 17px;">Estadística II</div>
                                <div class="card-text" style="font-size: 13px;">
                                    Pruebas de hipótesis, inferencia multivariada, correlación bivariada, matrices de covarianza y autocorrelación espacial (Moran's I) sobre tiempos y demanda.
                                </div>
                            </div>

                            <div class="card reveal" style="padding: 22px 18px;">
                                <div class="card-label">Eje 2</div>
                                <div class="card-title" style="font-size: 17px;">Análisis Numérico</div>
                                <div class="card-text" style="font-size: 13px;">
                                    Métodos numéricos de aproximación funcional, interpolación de variables continuas de lluvia y algoritmos de optimización matricial iterativa.
                                </div>
                            </div>

                            <div class="card reveal" style="padding: 22px 18px;">
                                <div class="card-label">Eje 3</div>
                                <div class="card-title" style="font-size: 17px;">Programación Scripting</div>
                                <div class="card-text" style="font-size: 13px;">
                                    Pipelines de ingesta automatizados en Python, tratamiento de datos vectorizados, scripting de orquestación dbt y APIs de visualización geográfica.
                                </div>
                            </div>

                            <div class="card reveal" style="padding: 22px 18px;">
                                <div class="card-label">Eje 4</div>
                                <div class="card-title" style="font-size: 17px;">Optimización</div>
                                <div class="card-text" style="font-size: 13px;">
                                    Formulación MILP, programación matemática de transporte y asignación de flujos, dualidad, análisis de sensibilidad y resolución computacional.
                                </div>
                            </div>

                            <div class="card accent-card reveal" style="padding: 22px 18px;">
                                <div class="card-label" style="color: var(--accent-red);">Eje 5</div>
                                <div class="card-title" style="font-size: 17px; color: #fff;">BD Analíticas</div>
                                <div class="card-text" style="font-size: 13px; color: #cbd5e1;">
                                    Data Warehouse Kimball, paradigma ELT, dbt Core sobre PostgreSQL, llaves subrogadas hash deterministas y pruebas automatizadas de datos.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>COMPETENCIAS PROFESIONALES</div>
                        <div>PENSAMIENTO CRÍTICO • MODELACIÓN MATEMÁTICA • INGENIERÍA DE SOFTWARE ANALÍTICO • COMUNICACIÓN CIENTÍFICA</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>16:15 - 17:30</strong> | Duración: 1:15 min | <em>Fase: Integración Curricular</em></p>
      <p>Queremos destacar ante el jurado la <strong>convergencia curricular holística</strong> de Integrador IV:</p>
      <p>No son materias aisladas, sino un solo engranaje de ingeniería:</p>
      <p>- <strong>Bases de Datos II:</strong> Aportó el diseño dimensional Kimball, el almacenamiento transaccional y el linaje de datos con dbt Core.<br>
      - <strong>Estadística II:</strong> Fundamentó las pruebas de hipótesis, la inferencia multivariada y el análisis de autocorrelación espacial.<br>
      - <strong>Investigación de Operaciones:</strong> Brindó el rigor de formulación MILP, restricciones de red y resolución con solvers matemáticos.<br>
      - <strong>Metodología de la Investigación:</strong> Aseguró la validez epistemológica, la matriz de operacionalización y la delimitación del problema.<br>
      - <strong>Comunicación Científica:</strong> Estructuró la narrativa, la síntesis visual de datos y la capacidad de defensa oral rigurosa.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para finalizar, repasemos los hitos alcanzados y los pasos inmediatos hacia la entrega final."</p>
    </aside>
  </section>
</template>

<script setup>
import MermaidDiagram from '../components/MermaidDiagram.vue';

const curriculumDiagram = `
flowchart LR
    BD["<b>Bases de Datos II</b><br/>Kimball & dbt Core"] --> PROY
    EST["<b>Estadística II</b><br/>Moran's I & Chi²"] --> PROY
    PROY[("<b>INTEGRADOR IV</b><br/>Optimización Movi Go")]
    NUM["<b>Análisis Numérico</b><br/>Interpolación Pluvial"] --> PROY
    IO["<b>Investigación Operativa</b><br/>MILP & Solvers"] --> PROY
    PRG["<b>Prog. Scripting</b><br/>Pipelines & APIs"] --> PROY
`;
// Slide 14: 14. Integración Curricular
</script>
