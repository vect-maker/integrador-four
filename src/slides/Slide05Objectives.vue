<template>
  <section class="slide" data-slide="5" data-title="05. Objetivos de Investigación">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>04. Objetivos del Estudio</span>
        </div>
        <div class="header-right">
          <span>Alcance &amp; Metas de Investigación</span>
          <span class="slide-number-tag">05 / 11</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">DIRECCIONAMIENTO CIENTÍFICO</div>
        <h2 class="slide-title reveal">Objetivo General &amp; <em>Específicos</em></h2>

        <!-- General Goal Box -->
        <div class="card accent-card reveal" style="margin-bottom: 24px; padding: 22px 28px; border-left: 8px solid var(--accent-red);">
          <div class="card-label" style="color: var(--accent-red); display: flex; align-items: center; gap: 6px;">
            <Target :size="15" />
            <span>Objetivo General</span>
          </div>
          <div style="font-family: var(--font-display); font-size: 22px; font-weight: 800; line-height: 1.35; color: var(--ink-primary);">
            Optimizar la distribución operativa de la flota vehicular y el esquema de tarifa dinámica del servicio de transporte selectivo Movi Go en el municipio de Managua mediante la ingesta de datos transaccionales y meteorológicos vía API REST y su modelado y transformación con dbt, evaluando patrones espaciotemporales y estrategias de asignación bajo condiciones variables de demanda y clima urbano.
          </div>
        </div>

        <!-- 4 Specific Goals in Grid Centered on Initial Action Verbs -->
        <div class="grid-4">
          <div class="card reveal">
            <div class="card-number">OE 1</div>
            <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
              <Database :size="13" style="color: var(--accent-red);" />
              <span>Objetivo Específico 1</span>
            </div>
            <div class="card-title" style="font-size: 20px; color: var(--accent-red); font-weight: 800; letter-spacing: -0.02em;">Estructurar</div>
            <div class="card-text" style="font-size: 13.5px; line-height: 1.55;">
              <strong>Estructurar</strong> un pipeline de ingeniería de datos analítico mediante <strong>dbt (Data Build Tool)</strong> sobre PostgreSQL a partir de los datos extraídos de la <strong>API REST (/movigo)</strong>, garantizando la consolidación, estandarización y auditoría del histórico operativo.
            </div>
          </div>

          <div class="card reveal">
            <div class="card-number">OE 2</div>
            <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
              <LineChart :size="13" style="color: var(--accent-red);" />
              <span>Objetivo Específico 2</span>
            </div>
            <div class="card-title" style="font-size: 20px; color: var(--accent-red); font-weight: 800; letter-spacing: -0.02em;">Analizar</div>
            <div class="card-text" style="font-size: 13.5px; line-height: 1.55;">
              <strong>Analizar</strong> la distribución espaciotemporal de los flujos de demanda, los tiempos de espera y la duración de los trayectos frente a eventos meteorológicos, condiciones de tráfico y disparidades territoriales entre las zonas de Managua.
            </div>
          </div>

          <div class="card reveal">
            <div class="card-number">OE 3</div>
            <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
              <Sliders :size="13" style="color: var(--accent-red);" />
              <span>Objetivo Específico 3</span>
            </div>
            <div class="card-title" style="font-size: 20px; color: var(--accent-red); font-weight: 800; letter-spacing: -0.02em;">Evaluar</div>
            <div class="card-text" style="font-size: 13.5px; line-height: 1.55;">
              <strong>Evaluar</strong> la dinámica del esquema de tarificación dinámica (<em>surge pricing</em>) y la sensibilidad de la oferta y la demanda vehicular ante variaciones en el multiplicador de precios bajo distintas condiciones y franjas horarias.
            </div>
          </div>

          <div class="card reveal">
            <div class="card-number">OE 4</div>
            <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
              <Cpu :size="13" style="color: var(--accent-red);" />
              <span>Objetivo Específico 4</span>
            </div>
            <div class="card-title" style="font-size: 20px; color: var(--accent-red); font-weight: 800; letter-spacing: -0.02em;">Formular</div>
            <div class="card-text" style="font-size: 13.5px; line-height: 1.55;">
              <strong>Formular</strong> modelos prescriptivos de optimización operativa para la asignación y el rebalanceo territorial de la flota vehicular, orientados a mitigar los recorridos improductivos en vacío (<em>deadhead</em>) y equilibrar tiempos de servicio.
            </div>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>ALCANCE DE LA INVESTIGACIÓN</div>
        <div>FUENTE: API REST /MOVIGO • TRANSFORMACIÓN: DBT CORE EN POSTGRESQL • VERBOS DE ACCIÓN UNÍVOCOS</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>04:00 - 05:00</strong> | Duración: 1:00 min | <em>Fase: Objetivos</em></p>
      <p>Cada objetivo de nuestra investigación se formula rigurosamente centrado en un único verbo de acción al inicio:</p>
      <p><strong>Objetivo General:</strong> <em>Optimizar</em> la distribución operativa de la flota y la tarifa dinámica a partir de la ingesta vía API REST y el modelado con dbt.</p>
      <p>Y cuatro <strong>Objetivos Específicos</strong> unívocos:</p>
      <p>1. <strong>Estructurar:</strong> El pipeline analítico con dbt sobre PostgreSQL a partir de los datos de la API REST.<br>
      2. <strong>Analizar:</strong> La distribución espaciotemporal de flujos, esperas y demoras frente a lluvia y tráfico.<br>
      3. <strong>Evaluar:</strong> La dinámica tarifaria de surge pricing y la sensibilidad entre oferta y demanda.<br>
      4. <strong>Formular:</strong> Modelos prescriptivos de asignación y rebalanceo de flota para mitigar el deadhead.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Pasemos a ver cómo operacionalizamos formalmente cada una de las variables involucradas."</p>
    </aside>
  </section>
</template>

<script setup>
import { Target, Database, LineChart, Sliders, Cpu } from '@lucide/vue';
// Slide 5: 05. Objetivos de Investigación
</script>
