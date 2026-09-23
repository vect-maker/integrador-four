<template>
  <section class="slide title-slide-layout active visible is-active active visible" data-slide="1" data-title="01. Portada: Caso Movi Go">
<div class="title-axis">
                    <span>CIENCIAS BÁSICAS Y TECNOLOGÍA</span>
                    <span>12°08′11″ N &nbsp; 86°15′05″ O</span>
                    <span>INTEGRADOR IV • 2026</span>
                </div>

                <div class="title-top">
                    <div class="header-left">
                        <span class="swiss-square"></span>
                        <strong>INGENIERÍA EN CIENCIA DE DATOS</strong>
                    </div>
                    <div>AVANCE DE INVESTIGACIÓN • SEGUNDO SEMESTRE 2026</div>
                </div>

                <div class="title-hero">
                    <div class="section-tag reveal">CASO DE ESTUDIO: MOVI GO • TRANSPORTE SELECTIVO</div>
                    <h1 class="slide-title reveal" style="font-size: 54px; line-height: 1.06; margin-bottom: 24px;">
                        Optimización territorial de la flota y del <em>sistema tarifario</em> en Managua
                    </h1>
                    <p class="slide-subtitle reveal" style="font-size: 24px; line-height: 1.45; max-width: 980px;">
                        Articulación analítica de dimensiones operativas, heterogeneidad territorial y factores climáticos para la eficiencia del servicio selectivo.
                    </p>
                    <div class="reveal" style="display: flex; gap: 20px; font-family: var(--font-mono); font-size: 13px; text-transform: uppercase;">
                        <span style="background: var(--ink-primary); color: #fff; padding: 6px 14px; font-weight: 700;">Integrador IV</span>
                        <span style="border: 2px solid var(--border-bold); padding: 4px 12px; font-weight: 700;">Segundo Año • S2</span>
                        <span style="padding: 6px 0; color: var(--ink-secondary);">Managua, Nicaragua</span>
                    </div>
                </div>

                <div class="title-aside">
                    <div class="card reveal" style="border-left: 6px solid var(--accent-red); margin-bottom: 16px;">
                        <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                            <Activity :size="13" style="color: var(--accent-red);" />
                            <span>Dimensión Operativa</span>
                        </div>
                        <div class="card-title" style="font-size: 20px;">Flota &amp; Deadhead</div>
                        <div class="card-text">Reducción de tiempos muertos y recorridos en vacío mediante asignación dinámica.</div>
                    </div>
                    <div class="card reveal" style="border-left: 6px solid var(--border-bold); margin-bottom: 16px;">
                        <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                            <MapPin :size="13" style="color: var(--ink-primary);" />
                            <span>Dimensión Territorial</span>
                        </div>
                        <div class="card-title" style="font-size: 20px;">Matrices OD &amp; Moran</div>
                        <div class="card-text">Discretización urbana en zonas operativas y detección de clusters espaciales.</div>
                    </div>
                    <div class="card reveal" style="border-left: 6px solid var(--accent-blue);">
                        <div class="card-label" style="display: flex; align-items: center; gap: 6px;">
                            <CloudRain :size="13" style="color: var(--accent-blue);" />
                            <span>Dimensión Climática</span>
                        </div>
                        <div class="card-title" style="font-size: 20px;">API Clima & Tráfico</div>
                        <div class="card-text">Modelación de velocidad y variabilidad de demanda ante precipitaciones en Managua.</div>
                    </div>
                </div>

                <div class="title-bottom">
                    <div class="reveal">
                        <div style="font-family: var(--font-mono); font-size: 11px; color: var(--ink-muted); text-transform: uppercase; display: flex; align-items: center; gap: 4px;">
                            <GraduationCap :size="12" /> Carrera
                        </div>
                        <div style="font-weight: 800; font-size: 16px;">Ingeniería en Ciencia de Datos</div>
                    </div>
                    <div class="reveal">
                        <div style="font-family: var(--font-mono); font-size: 11px; color: var(--ink-muted); text-transform: uppercase; display: flex; align-items: center; gap: 4px;">
                            <Calendar :size="12" /> Nivel Académico
                        </div>
                        <div style="font-weight: 800; font-size: 16px;">Segundo Año • 2026</div>
                    </div>
                    <div class="reveal">
                        <div style="font-family: var(--font-mono); font-size: 11px; color: var(--ink-muted); text-transform: uppercase; display: flex; align-items: center; gap: 4px;">
                            <Database :size="12" /> Metodología / Stack
                        </div>
                        <div style="font-weight: 800; font-size: 16px;">API REST • dbt • Inferencia • Optimización</div>
                    </div>
                    <div class="reveal">
                        <div style="font-family: var(--font-mono); font-size: 11px; color: var(--ink-muted); text-transform: uppercase; display: flex; align-items: center; gap: 4px;">
                            <Map :size="12" /> Ubicación de Análisis
                        </div>
                        <div style="font-weight: 800; font-size: 16px;">Municipio de Managua</div>
                    </div>
                </div>
    <aside class="notes">
      <p class="notes-meta">⏱ <strong>00:00 - 01:15</strong> | Duración: 1:15 min | <em>Fase: Introducción</em></p>
      <p>Buenos días, estimado comité evaluador y profesores. Hoy presentamos la defensa de avance de nuestro Proyecto Integrador IV en Ingeniería en Ciencia de Datos: <strong>Optimización territorial de la flota y diseño de un sistema tarifario dinámico multi-criterio para Movi Go en Managua</strong>.</p>
      <p>El núcleo de nuestra investigación es articular tres dimensiones que tradicionalmente se tratan de forma aislada: la <strong>eficiencia operativa</strong> de la flota (reduciendo recorridos en vacío o <em>deadhead</em>), la <strong>heterogeneidad territorial</strong> de Managua (con su estructura policéntrica y asimétrica), y el <strong>impacto climático</strong> (precipitaciones severas que alteran la velocidad de la red vial).</p>
      <p>Trabajamos sobre una base de más de <strong>65,000 registros sintéticos</strong> modelados a través de la API REST oficial de Movi Go.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para comprender la complejidad del desafío, veamos cómo interactúan estas tres dimensiones en la operación diaria."</p>
    </aside>
  </section>
</template>

<script setup>
import { Activity, MapPin, CloudRain, GraduationCap, Calendar, Database, Map } from '@lucide/vue';
// Slide 1: 01. Portada: Caso Movi Go
</script>
