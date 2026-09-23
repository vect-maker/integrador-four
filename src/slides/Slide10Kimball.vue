<template>
  <section class="slide " data-slide="10" data-title="10. Esquema Estrella Kimball">
<div class="slide-canvas">
                    <div class="slide-header">
                        <div class="header-left">
                            <span class="swiss-square"></span>
                            <span>09. Modelado Dimensional</span>
                        </div>
                        <div class="header-right">
                            <span>Data Warehouse • Esquema en Estrella</span>
                            <span class="slide-number-tag">10 / 16</span>
                        </div>
                    </div>

                    <div class="slide-body">
                        <div class="section-tag reveal">ESQUEMA EN ESTRELLA KIMBALL</div>
                        <h2 class="slide-title reveal">Grano Atómico de Hechos: <em>fct_trips</em></h2>
                        <p class="slide-subtitle reveal" style="margin-bottom: 14px;">
                            Separación conceptual entre acontecimientos medibles (tabla de hechos de viajes) y el contexto descriptivo que permite interpretarlos analíticamente.
                        </p>

                        <!-- Mermaid Star Schema Diagram -->
                        <div class="card reveal" style="padding: 14px 20px; margin-bottom: 16px; background: var(--card-bg);">
                            <div class="card-label" style="margin-bottom: 8px;">Topología del Modelo Dimensional en Estrella Kimball</div>
                            <MermaidDiagram :code="starSchemaDiagram" max-width="100%" />
                        </div>

                        <div class="grid-1-2">
                            <!-- Left: Fact Table -->
                            <div class="card accent-card reveal" style="border-left: 8px solid var(--accent-red);">
                                <div class="card-label" style="color: var(--accent-red);">Tabla de Hechos Central</div>
                                <div class="card-title" style="font-size: 26px; color: #fff;">fct_trips</div>
                                <p style="font-size: 14px; color: #cbd5e1; margin-bottom: 16px;">
                                    <strong>Grano:</strong> Una fila por cada solicitud o viaje registrado en el sistema.
                                </p>
                                <div style="font-family: var(--font-mono); font-size: 13px; line-height: 1.7; color: #f1f5f9;">
                                    <div>🔑 <strong>trip_sk</strong> (Hash PK)</div>
                                    <div>🔗 vehicle_sk, zone_origin_sk, zone_dest_sk</div>
                                    <div>🔗 date_sk, time_sk, weather_sk</div>
                                    <div style="border-top: 1px solid rgba(255,255,255,0.2); margin: 8px 0; padding-top: 8px;">
                                        📊 wait_time_sec (Tiempo espera)<br>
                                        📊 trip_duration_min (Duración viaje)<br>
                                        📊 distance_km (Distancia efectiva)<br>
                                        📊 deadhead_km (Distancia en vacío)<br>
                                        📊 fare_amount (Tarifa aplicada)<br>
                                        📊 operating_cost (Costo operativo)
                                    </div>
                                </div>
                            </div>

                            <!-- Right: Conformed Dimensions Grid -->
                            <div class="grid-2 reveal">
                                <div class="card">
                                    <div class="card-label">Dimensión Territorial</div>
                                    <div class="card-title" style="font-size: 19px;">dim_zones</div>
                                    <div class="card-text" style="font-size: 14px;">
                                        Identificador de zona, nombre de cuadrante en Managua, delimitación poligonal, tipología de suelo (comercial, residencial, mixto), densidad vial y centroide espacial.
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-label">Dimensión Flota</div>
                                    <div class="card-title" style="font-size: 19px;">dim_vehicles</div>
                                    <div class="card-text" style="font-size: 14px;">
                                        Identificador de vehículo, tipo de unidad, capacidad, año de fabricación, rendimiento promedio de combustible por kilómetro y estado de operatividad.
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-label">Dimensión Temporal</div>
                                    <div class="card-title" style="font-size: 19px;">dim_date / dim_time</div>
                                    <div class="card-text" style="font-size: 14px;">
                                        Fecha calendario, día de semana, indicador de fin de semana/feriado, hora exacta, minuto, franja operativa (Punta Mañana, Valle, Punta Tarde, Nocturno).
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-label">Dimensión Meteorológica</div>
                                    <div class="card-title" style="font-size: 19px;">dim_weather</div>
                                    <div class="card-text" style="font-size: 14px;">
                                        Datos del endpoint /movigo/clima: precipitación acumulada (mm), temperatura (°C), índice de congestión vial (1.00 a 3.50) y condición atmosférica.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="slide-footer">
                        <div>DISEÑO KIMBALL CERTIFICADO</div>
                        <div>LLAVES SUBROGADAS DETERMINISTAS • DESACOPLE ANALÍTICO • ACCESO DE ALTO RENDIMIENTO</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>11:15 - 12:30</strong> | Duración: 1:15 min | <em>Fase: Esquema Kimball</em></p>
      <p>Este es el <strong>Esquema en Estrella Kimball</strong> que diseñamos para responder a las preguntas analíticas de negocio y optimización:</p>
      <p>El <strong>Grano Atómico</strong> de la tabla central de hechos <code>fct_trips</code> es: <em>una fila por cada solicitud de viaje registrada en la plataforma</em>.</p>
      <p>Alrededor de los hechos se conectan cinco dimensiones conformadas:</p>
      <p>- <code>dim_zonas</code>: Cuadrante de origen y destino con atributos de estrato, latitud, longitud y tarifa base.<br>
      - <code>dim_conductores</code>: Perfil del conductor, categoría vehicular (estándar, confort, moto) y tasa de aceptación.<br>
      - <code>dim_usuarios</code>: Antigüedad, método de pago habitual y frecuencia de viaje.<br>
      - <code>dim_clima</code>: Precipitación horaria en mm/h, velocidad de viento y alerta hidrológica.<br>
      - <code>dim_fecha_hora</code>: Franja horaria, día de semana y flag de hora pico.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con esta base de datos optimizada, realizamos el análisis exploratorio y la inferencia espacial."</p>
    </aside>
  </section>
</template>

<script setup>
import MermaidDiagram from '../components/MermaidDiagram.vue';

const starSchemaDiagram = `
flowchart LR
    DZ["<b>dim_zones</b><br/>🔑 zone_sk<br/>cuadrante, estrato"] -->|zone_origin_sk<br/>zone_dest_sk| FT
    DV["<b>dim_vehicles</b><br/>🔑 vehicle_sk<br/>tipo, capacidad"] -->|vehicle_sk| FT
    FT[("<b>fct_trips</b> (Hechos Atómicos)<br/>🔑 <b>trip_sk</b> (Hash PK)<br/>• wait_time_sec • distance_km<br/>• deadhead_km • fare_amount")]
    DT["<b>dim_date_time</b><br/>🔑 date_sk, time_sk<br/>franja, hora_pico"] -->|date_sk, time_sk| FT
    DW["<b>dim_weather</b><br/>🔑 weather_sk<br/>lluvia_mm, congestión"] -->|weather_sk| FT
`;
// Slide 10: 10. Esquema Estrella Kimball
</script>
