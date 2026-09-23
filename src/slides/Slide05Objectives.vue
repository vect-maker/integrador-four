<template>
  <section class="slide " data-slide="5" data-title="05. Objetivos de Investigación">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>04. Objetivos del Estudio</span>
                        </div>
                        <div class="header-right">
                            <span>Alcance &amp; Metas de Investigación</span>
                            <span class="slide-number-tag">05 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">DIRECCIONAMIENTO CIENTÍFICO</div>
                        <h2 class="slide-title reveal">Objetivo General &amp; <em>Específicos</em></h2>

                        <!-- General Goal Box -->
                        <div class="card accent-card reveal" style="margin-bottom: 24px; padding: 24px 32px; border-left: 8px solid var(--accent-red);">
                            <div class="card-label" style="color: var(--accent-red);">Objetivo General</div>
                            <div style="font-family: var(--font-display); font-size: 24px; font-weight: 800; line-height: 1.3;">
                                Optimizar la distribución territorial de la flota vehicular y el sistema tarifario del servicio de transporte selectivo de la empresa Movi Go en el municipio de Managua, considerando factores operativos, territoriales y climáticos.
                            </div>
                        </div>

                        <!-- 4 Specific Goals in Grid -->
                        <div class="grid-4">
                            <div class="card reveal">
                                <div class="card-number">OE 1</div>
                                <div class="card-label">Ingesta &amp; DW</div>
                                <div class="card-title" style="font-size: 19px;">Construir</div>
                                <div class="card-text" style="font-size: 14px;">
                                    Construir un pipeline en Python para extraer datos de la API REST (/movigo), estructurar el Data Warehouse dimensional en PostgreSQL/dbt y auditar > 65,000 viajes.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">OE 2</div>
                                <div class="card-label">Inferencia</div>
                                <div class="card-title" style="font-size: 19px;">Analizar</div>
                                <div class="card-text" style="font-size: 14px;">
                                    Analizar el impacto de la lluvia, congestión y estrato mediante regresión lineal múltiple con verificación Gauss-Markov y contrastes de hipótesis formalizados.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">OE 3</div>
                                <div class="card-label">Métodos Numéricos</div>
                                <div class="card-title" style="font-size: 19px;">Implementar</div>
                                <div class="card-text" style="font-size: 14px;">
                                    Implementar métodos de raíces (Bisección y Newton-Raphson) para el multiplicador de equilibrio ^*$, elasticidad $\mathcal{O}(h^2)$ y regla de Simpson 1/3.
                                </div>
                            </div>

                            <div class="card reveal">
                                <div class="card-number">OE 4</div>
                                <div class="card-label">Optimización</div>
                                <div class="card-title" style="font-size: 19px;">Desarrollar</div>
                                <div class="card-text" style="font-size: 14px;">
                                    Desarrollar modelos prescriptivos con Algoritmo Húngaro (despacho), Dijkstra (rutas con lluvia/congestión) y Mochila 0/1 (campañas con presupuesto C$ 120,000 NIO).
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>ARTICULACIÓN ACADÉMICA</div>
                        <div>INTEGRADOR IV: ESTADÍSTICA • ANÁLISIS NUMÉRICO • SCRIPTING • OPTIMIZACIÓN • DATA WAREHOUSE</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>05:00 - 06:15</strong> | Duración: 1:15 min | <em>Fase: Objetivos</em></p>
      <p>Definimos nuestro <strong>Objetivo General</strong> de manera muy clara y medible:</p>
      <p>Diseñar e implementar un <strong>modelo matemático de optimización MILP multicriterio</strong> y un sistema tarifario dinámico adaptativo para la plataforma Movi Go, equilibrando tiempos de espera, kilometraje en vacío y sostenibilidad tarifaria ante variaciones climáticas en Managua.</p>
      <p>Este objetivo se desglosa en <strong>cuatro objetivos específicos</strong>:</p>
      <p>1. Construir el pipeline de <strong>ingesta y modelado dimensional ELT</strong> con dbt Core y PostgreSQL.<br>
      2. Realizar el <strong>análisis espacio-temporal</strong> mediante matrices Origen-Destino e índices de autocorrelación espacial (Moran's I).<br>
      3. Formular el <strong>modelo MILP</strong> con funciones de penalización pluvial.<br>
      4. <strong>Simular y contrastar tres escenarios</strong> operacionales para validar la hipótesis de mejora.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Pasemos a ver cómo operacionalizamos formalmente cada una de las variables involucradas."</p>
    </aside>
  </section>
</template>

<script setup>
// Slide 5: 05. Objetivos de Investigación
</script>
