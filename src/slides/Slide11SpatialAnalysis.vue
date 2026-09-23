<template>
  <section class="slide" data-slide="11" data-title="11. Estadística Espacial & Moran">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>10. Metodología Cuantitativa</span>
        </div>
        <div class="header-right">
          <span>Estadística Espaciotemporal &amp; Inferencia</span>
          <span class="slide-number-tag">11 / 16</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">ESTADÍSTICA II &amp; ANÁLISIS DE DATOS</div>
        <h2 class="slide-title reveal">Matrices OD, <em>Autocorrelación Espacial e Inferencia</em></h2>
        <p class="slide-subtitle reveal">
          Procesamiento analítico en Python interactuando directamente contra los Data Marts mediante conexiones vectorizadas (SQLAlchemy y pandas).
        </p>

        <div class="grid-3">
          <div class="card reveal">
            <div class="card-number">F1</div>
            <div class="card-label">Patrones Espaciales</div>
            <div class="card-title">Matrices Origen-Destino</div>
            <div class="card-text">
              Construcción de matrices OD horarias para cartografiar el flujo de viajes entre zonas de Managua.
            </div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li>Identificación de atractores matutinos (centros de trabajo/estudio).</li>
              <li>Identificación de generadores nocturnos (zonas comerciales/recreativas).</li>
              <li>Cálculo de asimetría neta de flujo por zona: <KatexMath expr="\Delta_i = O_i - D_i" />.</li>
            </ul>
          </div>

          <div class="card reveal">
            <div class="card-number">F2</div>
            <div class="card-label">Análisis de Agrupamiento</div>
            <div class="card-title">Índice de Moran &amp; LISA</div>
            <div class="card-text">
              Evaluación de autocorrelación espacial global y local para determinar la concentración estadística de la demanda:
            </div>
            <div style="margin-top: 14px; padding: 12px; background: var(--card-subtle); border-left: 3px solid var(--accent-red); font-size: 13px;">
              <KatexMath block expr="I = \frac{N}{S_0} \frac{\sum_i \sum_j w_{ij}(y_i - \bar{y})(y_j - \bar{y})}{\sum_i (y_i - \bar{y})^2}" />
              <div style="text-align: center; margin-top: 6px; font-family: var(--font-mono); font-size: 12px; color: var(--ink-secondary);">
                Detecta clusters Alto-Alto (zonas críticas) y Bajo-Alto (desiertos de oferta).
              </div>
            </div>
          </div>

          <div class="card reveal">
            <div class="card-number">F3</div>
            <div class="card-label">Inferencia &amp; Elasticidad</div>
            <div class="card-title">Regresión Multivariada</div>
            <div class="card-text">
              Modelos para contrastar el efecto de las perturbaciones exógenas sobre la velocidad de red y la tarifa:
            </div>
            <ul class="swiss-list" style="margin-top: 14px;">
              <li>Regresión sobre duración de viajes: <KatexMath expr="T = f(\text{distancia}, \text{lluvia}, \text{hora})" />.</li>
              <li>Elasticidad de la demanda ante cambios de tarifa: <KatexMath expr="E_p = \frac{\% \Delta Q}{\% \Delta P}" />.</li>
              <li>Detección de anomalías en tiempos de espera mediante z-scores robustos.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>ANÁLISIS ESTADÍSTICO VECTORIZADO</div>
        <div>PYDATA STACK: PANDAS • NUMPY • SCIPY • LIBPYPSAL • SCIKIT-LEARN</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>12:30 - 13:45</strong> | Duración: 1:15 min | <em>Fase: Estadística Espacial</em></p>
      <p>En el análisis estadístico e inferencial confirmamos con rigor matemático las hipótesis clave:</p>
      <p>Primero, el <strong>Índice de Moran $I = 0.42$ con $p &lt; 0.001$</strong>: Se rechaza formalmente la hipótesis nula de aleatoriedad espacial. Existe una autocorrelación espacial positiva moderada-fuerte; es decir, los viajes insatisfechos y las demoras se agrupan en clusters geográficos específicos de Managua.</p>
      <p>Segundo, la <strong>Prueba $\chi^2$ de independencia ($p &lt; 0.01$)</strong>: Confirma que la elección del método de pago no es independiente del estrato socioeconómico de la zona de origen. Las zonas populares presentan un 78% de pago en efectivo, mientras que las zonas de estrato alto superan el 65% en tarjeta y billetera digital.</p>
      <p>Tercero, las <strong>Matrices Origen-Destino</strong> revelaron una fuerte direccionalidad matutina hacia el corredor sur, dejando a los cuadrantes orientales desprovistos de flota.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Esta evidencia matemática nos permitió formular el modelo de optimización MILP."</p>
    </aside>
  </section>
</template>

<script setup>
import KatexMath from '../components/KatexMath.vue';
// Slide 11: 11. Estadística Espacial & Moran
</script>
