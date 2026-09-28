<template>
  <section class="slide " data-slide="6" data-title="06. Matriz de Variables y Descriptores">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>05. Operacionalización</span>
                        </div>
                        <div class="header-right">
                            <span>Matriz Metodológica de Descriptores</span>
                            <span class="slide-number-tag">06 / 11</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">SISTEMATIZACIÓN DE VARIABLES</div>
                        <h2 class="slide-title reveal">Variables Conceptuales, <em>Dimensiones e Indicadores</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 14px;">
                            Estructura de correspondencia entre objetivos específicos, dimensiones analíticas, métricas cuantificables e instrumentos de ingeniería y modelación.
                        </p>

                        <div class="reveal">
                            <table class="swiss-table">
                                <thead>
                                    <tr>
                                        <th style="width: 50px;">OE</th>
                                        <th style="width: 220px;">Variable Conceptual</th>
                                        <th style="width: 260px;">Definición Operativa</th>
                                        <th>Dimensiones / Subvariables</th>
                                        <th>Indicadores Clave de Medición</th>
                                        <th style="width: 140px;">Técnicas</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>01</strong></td>
                                        <td><strong>Estructurar</strong><br><span style="font-size: 12px; color: var(--ink-secondary);">Pipeline dbt &amp; API REST</span></td>
                                        <td>Extracción paginada vía API REST, consolidación relacional y estructuración analítica gobernada con dbt.</td>
                                        <td>Ingesta API REST, capa cruda PostgreSQL, staging y marts dimensionales.</td>
                                        <td>Registros procesados (>65k), integridad referencial, pruebas dbt superadas, Parquet SHA-256.</td>
                                        <td>API REST, dbt Core, SQL.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>02</strong></td>
                                        <td><strong>Analizar</strong><br><span style="font-size: 12px; color: var(--ink-secondary);">Factores Espaciotemporales</span></td>
                                        <td>Comportamiento de la demanda, cancelaciones y tiempos ante factores exógenos (clima, tráfico, zonas).</td>
                                        <td>Flujos horarios, eventos de lluvia, índice de congestión vial, estratos territoriales.</td>
                                        <td>Volumen de viajes, variación de duración por lluvia/tráfico, tasa de cancelaciones, comparativas zonales.</td>
                                        <td>Inferencia estadística, Series temporales.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>03</strong></td>
                                        <td><strong>Evaluar</strong><br><span style="font-size: 12px; color: var(--ink-secondary);">Dinámica Tarifaria y Sensibilidad</span></td>
                                        <td>Respuesta de oferta y demanda ante variaciones del multiplicador dinámico y aproximación de equilibrio.</td>
                                        <td>Multiplicador surge, sensibilidad de demanda, relación oferta/demanda, métodos de pago.</td>
                                        <td>Distribución de multiplicadores ($m$), elasticidad estimada, balance de mercado, dispersión zonal.</td>
                                        <td>Modelación analítica, Métodos numéricos.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>04</strong></td>
                                        <td><strong>Formular</strong><br><span style="font-size: 12px; color: var(--ink-secondary);">Optimización y Rebalanceo</span></td>
                                        <td>Modelos prescriptivos de despacho y rebalanceo de flota para mitigar recorridos en vacío y demoras.</td>
                                        <td>Emparejamiento unidad-solicitud, tiempos de recogida, ruteo en red vial, incentivos.</td>
                                        <td>Tiempo de espera promedio, km en vacío (deadhead) reducidos, cobertura de zonas críticas, escenarios comparados.</td>
                                        <td>Optimización matemática, Simulación.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>INSTRUMENTOS Y HERRAMIENTAS</div>
                        <div>API REST (/movigo) + PIPELINE DBT EN POSTGRESQL + MODELACIÓN ANALÍTICA Y PRESCRIPTIVA EN PYTHON</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>05:00 - 06:15</strong> | Duración: 1:15 min | <em>Fase: Variables</em></p>
      <p>Esta tabla resume la <strong>Matriz de Descriptores</strong> estructurada a partir de los verbos rectores de cada objetivo:</p>
      <p>1. <em>OE1 (Estructurar):</em> Base inmutable que extrae los datos de la API REST y los transforma con dbt para garantizar calidad e integridad.<br>
      2. <em>OE2 (Analizar):</em> Examina cómo la lluvia, el tráfico y las zonas impactan tiempos de espera y cancelaciones.<br>
      3. <em>OE3 (Evaluar):</em> Explora la sensibilidad de oferta y demanda frente al multiplicador dinámico.<br>
      4. <em>OE4 (Formular):</em> Diseña modelos prescriptivos para reducir recorridos en vacío (deadhead) y equilibrar tiempos de servicio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos ahora el marco teórico que fundamenta cada una de estas áreas."</p>
    </aside>
  </section>
</template>

<script setup>
// Slide 6: 06. Matriz de Variables y Descriptores
</script>
