<template>
  <section class="slide" data-slide="12" data-title="12. Modelo Matemático MILP">
    <div class="slide-canvas">
      <div class="slide-header">
        <div class="header-left">
          <span class="swiss-square"></span>
          <span>11. Formulación Matemática</span>
        </div>
        <div class="header-right">
          <span>Programación Lineal Entera Mixta</span>
          <span class="slide-number-tag">12 / 16</span>
        </div>
      </div>

      <div class="slide-body">
        <div class="section-tag reveal">INVESTIGACIÓN DE OPERACIONES &amp; OPTIMIZACIÓN</div>
        <h2 class="slide-title reveal">Modelo Matemático <em>MILP</em> Multicriterio</h2>
        <p class="slide-subtitle reveal" style="margin-bottom: 16px;">
          Formulación orientada a equilibrar la eficiencia del usuario (esperas mínimas) con la viabilidad del transportista (mínimo deadhead y tarifas justas).
        </p>

        <!-- Math Formulation Hero Box -->
        <div class="math-block reveal">
          <div style="font-size: 13px; letter-spacing: 0.1em; color: var(--accent-red); margin-bottom: 6px; font-weight: 700;">
            FUNCIÓN OBJETIVO MULTICRITERIO:
          </div>
          <KatexMath
            block
            expr="\min Z = \alpha \sum_{i \in \mathcal{Z}} \sum_{t \in \mathcal{T}} \text{WaitTime}_{it}(y_{it}, D_{it}) + \beta \sum_{i,j \in \mathcal{Z}} \sum_{t \in \mathcal{T}} c_{ij} \cdot x_{ijt} - \gamma \sum_{i \in \mathcal{Z}} \sum_{t \in \mathcal{T}} \text{Revenue}_{it}(p_{it}, D_{it})"
          />
        </div>

        <div class="grid-3 reveal">
          <div class="card">
            <div class="card-label">Variables de Decisión</div>
            <div class="card-title" style="font-size: 18px;">Asignación &amp; Tarifas</div>
            <div class="card-text" style="font-size: 14px; line-height: 1.6;">
              <strong><KatexMath expr="x_{ijt} \in \mathbb{Z}^+" />:</strong> Cantidad de unidades vacías redistribuidas desde zona <KatexMath expr="i" /> hacia zona <KatexMath expr="j" /> en período <KatexMath expr="t" />.<br><br>
              <strong><KatexMath expr="y_{it} \in \mathbb{Z}^+" />:</strong> Unidades totales disponibles y operativas en zona <KatexMath expr="i" /> durante período <KatexMath expr="t" />.<br><br>
              <strong><KatexMath expr="p_{it} \in \mathbb{R}^+" />:</strong> Multiplicador de tarifa aplicable en zona <KatexMath expr="i" /> en intervalo <KatexMath expr="t" />.
            </div>
          </div>

          <div class="card">
            <div class="card-label">Restricciones de Red</div>
            <div class="card-title" style="font-size: 18px;">Flujo &amp; Capacidad de Flota</div>
            <div class="card-text" style="font-size: 14px; line-height: 1.5;">
              <strong style="color: var(--ink-primary);">1. Conservación de Flujo:</strong>
              <div style="margin: 6px 0 10px 0; background: var(--card-subtle); padding: 8px; border-radius: 4px;">
                <KatexMath block expr="y_{j, t+1} = y_{jt} + \sum_{i} x_{ijt} - \sum_{k} x_{jkt} + \text{Retornos}_{jt}" />
              </div>
              <strong style="color: var(--ink-primary);">2. Restricción de Flota Total:</strong>
              <div style="margin-top: 6px; background: var(--card-subtle); padding: 8px; border-radius: 4px;">
                <KatexMath block expr="\sum_{i \in \mathcal{Z}} y_{it} \le K_{\text{total}} \quad \forall t \in \mathcal{T}" />
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-label">Límites &amp; Clima</div>
            <div class="card-title" style="font-size: 18px;">Tarifas &amp; Velocidad</div>
            <div class="card-text" style="font-size: 14px; line-height: 1.5;">
              <strong style="color: var(--ink-primary);">3. Rango Tarifario Aceptable:</strong>
              <div style="margin: 6px 0 10px 0; background: var(--card-subtle); padding: 8px; border-radius: 4px;">
                <KatexMath block expr="P_{\min} \le p_{it} \le P_{\max} \quad \forall i, t" />
              </div>
              <strong style="color: var(--ink-primary);">4. Modificador Climático de Red:</strong>
              <p style="margin-top: 6px; font-size: 13px;">
                Los costos de viaje <KatexMath expr="c_{ij}" /> y tiempos de tránsito se ajustan en función de la lluvia horaria:
              </p>
              <div style="margin-top: 6px; background: var(--card-subtle); padding: 8px; border-radius: 4px;">
                <KatexMath block expr="v_{ij}(w) = v_{ij}^0 \cdot (1 - \lambda \cdot w_t)" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="slide-footer">
        <div>SOLVER DE OPTIMIZACIÓN</div>
        <div>RESOLUCIÓN EXACTA Y HEURÍSTICA MEDIANTE PULP / SCIPY EN PYTHON</div>
      </div>
    </div>

    <aside class="notes">
      <p class="notes-meta">⏱ <strong>13:45 - 15:00</strong> | Duración: 1:15 min | <em>Fase: Modelo MILP</em></p>
      <p>Llegamos a la formulación matemática central del proyecto: el <strong>Modelo MILP (Mixed-Integer Linear Programming) Multicriterio</strong>:</p>
      <p>Definimos dos variables binarias de decisión:</p>
      <p>1. $x_{ij} \in \{0, 1\}$: Asignación del vehículo $i$ al viaje $j$.<br>
      2. $y_{ik} \in \{0, 1\}$: Reubicación anticipada del vehículo vacío $i$ hacia el cuadrante con déficit $k$.</p>
      <p>La <strong>Función Objetivo Multiobjetivo</strong> busca minimizar una suma ponderada:</p>
      <p>$$\min Z = w_1 \sum T_{espera} + w_2 \sum D_{deadhead} - w_3 \sum Ingreso_{neto} + w_4 \sum Pen_{clima}$$</p>
      <p>Sujeto a restricciones de unicidad de asignación, capacidad de flota, límites de tiempo de espera aceptables y balance de flujo zonal.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> El término $Pen_{clima}$ penaliza severamente el cruce por corredores con riesgo de inundación alta, forzando rutas seguras aun si la distancia lineal es ligeramente mayor.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para contrastar la efectividad del modelo, veamos los resultados de la simulación en tres escenarios."</p>
    </aside>
  </section>
</template>

<script setup>
import KatexMath from '../components/KatexMath.vue';
// Slide 12: 12. Modelo Matemático MILP
</script>
