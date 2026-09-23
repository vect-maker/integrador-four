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
                            <span class="slide-number-tag">06 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">SISTEMATIZACIÓN DE VARIABLES</div>
                        <h2 class="slide-title reveal">Variables Conceptuales, <em>Dimensiones e Indicadores</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 14px;">
                            Estructura de correspondencia entre objetivos específicos, dimensiones analíticas, métricas cuantificables e instrumentos de recolección.
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
                                        <td><strong>Demanda y Distribución Territorial</strong></td>
                                        <td>Dinámica temporal y espacial de solicitudes frente a vehículos disponibles en Managua.</td>
                                        <td>Demanda, flota activa, zonas urbanas, clima histórico.</td>
                                        <td>Solicitudes/zona/hora, ratio demanda/flota, tiempo de espera, distancia en vacío, mm de lluvia.</td>
                                        <td>Análisis documental, Entrevista técnica.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>02</strong></td>
                                        <td><strong>Comportamiento Analítico del Servicio</strong></td>
                                        <td>Correlaciones y patrones entre oferta, localización, precios y entorno para detectar anomalías.</td>
                                        <td>Relación oferta-demanda, autocorrelación espacial, volatilidad tarifaria.</td>
                                        <td>Índice de Moran, correlación bivariada, dispersión tarifaria, outliers de espera y cancelación.</td>
                                        <td>Análisis documental, Modelos estadísticos.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>03</strong></td>
                                        <td><strong>Escenarios de Optimización</strong></td>
                                        <td>Representaciones cuantitativas comparativas del desempeño bajo distintas reglas de operación.</td>
                                        <td>Redistribución territorial, políticas tarifarias, restricciones.</td>
                                        <td>% Cobertura de solicitudes, reducción de tiempo de aproximación, deadhead reducido, margen neto.</td>
                                        <td>Simulación computacional, Entrevista.</td>
                                    </tr>
                                    <tr>
                                        <td><strong>04</strong></td>
                                        <td><strong>Modelo de Optimización Cuantitativa</strong></td>
                                        <td>Estructura matemática prescriptiva para asignación de flota y regulación de tarifas.</td>
                                        <td>Variables de decisión, función objetivo, restricciones de red.</td>
                                        <td>Formulación MILP, asignación $x_{ijt}$, multiplicador $p_{it}$, reducción de coste total.</td>
                                        <td>Modelación matemática, Validación.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>INSTRUMENTOS DE INVESTIGACIÓN</div>
                        <div>ANÁLISIS DOCUMENTAL DE LOGS + ENTREVISTAS DE OPERACIÓN + MODELACIÓN NUMÉRICA EN PYTHON</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>06:15 - 07:30</strong> | Duración: 1:15 min | <em>Fase: Variables</em></p>
      <p>Esta tabla resume la <strong>Matriz de Descriptores</strong> con la que garantizamos la trazabilidad entre el problema, los conceptos y los datos de la API:</p>
      <p>Dividimos el sistema en <strong>cuatro dimensiones clave</strong>:</p>
      <p>1. <em>Dimensión Operativa:</em> Medida a través del tiempo de recogida ($T_{wait}$), tiempo de viaje ($T_{trip}$) y el ratio de deadhead ($D_{ratio}$).<br>
      2. <em>Dimensión Espacial:</em> Discretización territorial por cuadrantes urbanos, estrato socioeconómico y coordenadas centroidales WGS84.<br>
      3. <em>Dimensión Tarifaria:</em> Bajada de bandera base, costo por kilómetro/minuto y el multiplicador de surge ($1.00\times$ a $3.20\times$).<br>
      4. <em>Dimensión Meteorológica:</em> Nivel de precipitación pluvial en mm/h e impacto en la velocidad promedio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos ahora los conceptos teóricos de transporte y clima que rigen estas relaciones."</p>
    </aside>
  </section>
</template>

<script setup>
// Slide 6: 06. Matriz de Variables y Descriptores
</script>
