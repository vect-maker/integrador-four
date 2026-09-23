import fs from 'fs';

const rawHtml = fs.readFileSync('presentacion_integrador.html', 'utf-8');

// Slide titles mapping for html-ppt data-title and overview
const titles = {
  1: "01. Portada: Caso Movi Go",
  2: "02. Contextualización: Sistema Dinámico",
  3: "03. Estado del Arte & Literatura",
  4: "04. Problema: Desbalance Espacial",
  5: "05. Objetivos de Investigación",
  6: "06. Matriz de Variables y Descriptores",
  7: "07. Marco Teórico: Transporte & Clima",
  8: "08. Diseño Metodológico Mixto",
  9: "09. Arquitectura ELT & dbt Core",
  10: "10. Esquema Estrella Kimball",
  11: "11. Estadística Espacial & Moran",
  12: "12. Modelo Matemático MILP",
  13: "13. Simulación de 3 Escenarios",
  14: "14. Integración Curricular",
  15: "15. Síntesis & Próximos Pasos",
  16: "16. Cierre & Sesión de Preguntas"
};

// Comprehensive, conversational Spanish speaker notes for each slide (calibrated for 15-20 min defense)
const speakerNotes = {
  1: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>00:00 - 01:15</strong> | Duración: 1:15 min | <em>Fase: Introducción</em></p>
      <p>Buenos días, estimado comité evaluador y profesores. Hoy presentamos la defensa de avance de nuestro Proyecto Integrador IV en Ingeniería en Ciencia de Datos: <strong>Optimización territorial de la flota y diseño de un sistema tarifario dinámico multi-criterio para Movi Go en Managua</strong>.</p>
      <p>El núcleo de nuestra investigación es articular tres dimensiones que tradicionalmente se tratan de forma aislada: la <strong>eficiencia operativa</strong> de la flota (reduciendo recorridos en vacío o <em>deadhead</em>), la <strong>heterogeneidad territorial</strong> de Managua (con su estructura policéntrica y asimétrica), y el <strong>impacto climático</strong> (precipitaciones severas que alteran la velocidad de la red vial).</p>
      <p>Trabajamos sobre una base de más de <strong>65,000 registros sintéticos</strong> modelados a través de la API REST oficial de Movi Go.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para comprender la complejidad del desafío, veamos cómo interactúan estas tres dimensiones en la operación diaria."</p>
    </aside>`,

  2: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>01:15 - 02:30</strong> | Duración: 1:15 min | <em>Fase: Contextualización</em></p>
      <p>Aquí planteamos la premisa fundamental del proyecto: la movilidad bajo demanda es un <strong>sistema dinámico interdependiente</strong>.</p>
      <p>En primer lugar, la <strong>dimensión operativa</strong> no depende sólo de cuántos conductores hay conectados, sino de <em>dónde están</em>. Si los vehículos circulan desocupados lejos de los focos de demanda, el tiempo de espera del usuario se dispara.</p>
      <p>En segundo lugar, la <strong>dimensión territorial</strong> de Managua presenta una fuerte polarización: orígenes residenciales matutinos hacia corredores comerciales y de oficinas, generando viajes de ida con retorno vacío.</p>
      <p>Y en tercer lugar, la <strong>dimensión tarifaria</strong>: un esquema de precios estático no premia al conductor que viaja a zonas periféricas desabastecidas.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si el jurado pregunta por qué no basta con aumentar la flota, enfatizar que saturar de autos sin rebalanceo incrementa la congestión y reduce los ingresos netos del conductor.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos qué respaldo encontramos en la literatura científica para modelar este acoplamiento."</p>
    </aside>`,

  3: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>02:30 - 03:45</strong> | Duración: 1:15 min | <em>Fase: Estado del Arte</em></p>
      <p>Nuestra investigación se apoya en cuatro pilares de la literatura científica internacional y regional:</p>
      <p>1. <strong>Alonso-Mora et al. (2017)</strong> en PNAS demostraron que el despacho y el rebalanceo de flotas en tiempo real deben formularse como un problema de optimización matemática conjunto bajo restricciones temporales estrictas.</p>
      <p>2. <strong>Castillo-Manzano et al. (2020)</strong> probaron que la lluvia genera un trasvase modal masivo hacia plataformas selectivas, pero incrementa las cancelaciones si el algoritmo no ajusta la oferta preventivamente.</p>
      <p>3. <strong>Cramer & Krueger (2016)</strong> documentaron cómo el factor de ocupación de las apps supera al taxi convencional gracias a la intermediación algorítmica.</p>
      <p>4. <strong>Zuniga-Brenes (2022)</strong> aporta la perspectiva centroamericana sobre informalidad y sensibilidad al precio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con esta base teórica, examinemos la radiografía exacta de ineficiencias que experimenta Movi Go en Managua."</p>
    </aside>`,

  4: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>03:45 - 05:00</strong> | Duración: 1:15 min | <em>Fase: Problema</em></p>
      <p>El diagnóstico empírico de Movi Go revela lo que denominamos la <strong>Triada de Ineficiencias</strong>:</p>
      <p>Primero: <strong>Desbalance Espaciotemporal</strong>. El 62% de la flota disponible tiende a concentrarse en apenas 4 nodos comerciales (Metrocentro, Plaza España, Carretera a Masaya), dejando desatendidas zonas residenciales periféricas.</p>
      <p>Segundo: <strong>Kilómetros Improductivos (Deadhead)</strong>. Hasta un 34% del kilometraje total de las unidades se realiza en vacío buscando pasajeros, aumentando los costos de combustible y la fatiga del conductor.</p>
      <p>Tercero: <strong>Vulnerabilidad ante Eventos Pluviales</strong>. Las lluvias torrenciales en Managua saturan los cauces y rotondas viales, reduciendo la velocidad de circulación hasta un 45% y descalibrando el multiplicador de tarifa dinámica.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> El deadhead no solo es un problema de rentabilidad privada; genera emisiones de carbono innecesarias y agrava la congestión urbana.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para dar una respuesta rigurosa y cuantificable a este problema, estructuramos nuestros objetivos."</p>
    </aside>`,

  5: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>05:00 - 06:15</strong> | Duración: 1:15 min | <em>Fase: Objetivos</em></p>
      <p>Definimos nuestro <strong>Objetivo General</strong> de manera muy clara y medible:</p>
      <p>Diseñar e implementar un <strong>modelo matemático de optimización MILP multicriterio</strong> y un sistema tarifario dinámico adaptativo para la plataforma Movi Go, equilibrando tiempos de espera, kilometraje en vacío y sostenibilidad tarifaria ante variaciones climáticas en Managua.</p>
      <p>Este objetivo se desglosa en <strong>cuatro objetivos específicos</strong>:</p>
      <p>1. Construir el pipeline de <strong>ingesta y modelado dimensional ELT</strong> con dbt Core y PostgreSQL.<br>
      2. Realizar el <strong>análisis espacio-temporal</strong> mediante matrices Origen-Destino e índices de autocorrelación espacial (Moran's I).<br>
      3. Formular el <strong>modelo MILP</strong> con funciones de penalización pluvial.<br>
      4. <strong>Simular y contrastar tres escenarios</strong> operacionales para validar la hipótesis de mejora.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Pasemos a ver cómo operacionalizamos formalmente cada una de las variables involucradas."</p>
    </aside>`,

  6: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>06:15 - 07:30</strong> | Duración: 1:15 min | <em>Fase: Variables</em></p>
      <p>Esta tabla resume la <strong>Matriz de Descriptores</strong> con la que garantizamos la trazabilidad entre el problema, los conceptos y los datos de la API:</p>
      <p>Dividimos el sistema en <strong>cuatro dimensiones clave</strong>:</p>
      <p>1. <em>Dimensión Operativa:</em> Medida a través del tiempo de recogida ($T_{wait}$), tiempo de viaje ($T_{trip}$) y el ratio de deadhead ($D_{ratio}$).<br>
      2. <em>Dimensión Espacial:</em> Discretización territorial por cuadrantes urbanos, estrato socioeconómico y coordenadas centroidales WGS84.<br>
      3. <em>Dimensión Tarifaria:</em> Bajada de bandera base, costo por kilómetro/minuto y el multiplicador de surge ($1.00\\times$ a $3.20\\times$).<br>
      4. <em>Dimensión Meteorológica:</em> Nivel de precipitación pluvial en mm/h e impacto en la velocidad promedio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos ahora los conceptos teóricos de transporte y clima que rigen estas relaciones."</p>
    </aside>`,

  7: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>07:30 - 08:45</strong> | Duración: 1:15 min | <em>Fase: Marco Teórico</em></p>
      <p>En el marco teórico profundizamos en tres fenómenos estructurales propios de Managua:</p>
      <p>Primero, la <strong>morfología urbana y vial</strong>. Managua no es una cuadrícula; es un trazado irregular articulado por rotondas (Centroamérica, Rubén Darío, Cristo Rey). Cuando una rotonda colapsa, el efecto dominó estrangula las arterias conectoras.</p>
      <p>Segundo, la <strong>economía de plataformas de dos lados (Two-Sided Markets)</strong>. La tarifa debe mantener un equilibrio delicado: si el surge sube demasiado, el pasajero de estrato popular o medio cancela; si baja demasiado, el conductor prefiere desconectarse ante la lluvia.</p>
      <p>Tercero, la <strong>hidrología vial urbana</strong>. La escorrentía superficial convierte calles en cauces temporales, obligando a recalibrar las matrices de tiempo de viaje de forma no lineal.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con el sustento teórico establecido, expliquemos el diseño metodológico de la investigación."</p>
    </aside>`,

  8: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>08:45 - 10:00</strong> | Duración: 1:15 min | <em>Fase: Metodología</em></p>
      <p>Adoptamos un <strong>enfoque cuantitativo-analítico</strong> con un diseño no experimental longitudinal de panel.</p>
      <p>La investigación se ejecuta en <strong>cuatro fases secuenciales e integradas</strong>:</p>
      <p><strong>Fase 1: Ingesta y Estandarización</strong>. Extracción sistemática vía API REST <code>/movigo</code> con paginación controlada y validación de esquemas Pydantic.<br>
      <strong>Fase 2: Arquitectura y Modelado Dimensional</strong>. Pipeline ELT con dbt Core y PostgreSQL bajo la metodología Kimball.<br>
      <strong>Fase 3: Análisis Espacial e Inferencia</strong>. Construcción de matrices OD, pruebas $\\chi^2$ y cálculo del Índice de Moran.<br>
      <strong>Fase 4: Optimización Matemática y Simulación</strong>. Resolución del modelo MILP en Python y contraste cuantitativo de escenarios.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Entremos al detalle de la arquitectura de datos construida en la Fase 1 y 2."</p>
    </aside>`,

  9: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>10:00 - 11:15</strong> | Duración: 1:15 min | <em>Fase: Pipeline ELT</em></p>
      <p>En esta lámina observamos la <strong>Arquitectura de Datos Moderna</strong> que implementamos siguiendo las mejores prácticas de la industria y la materia de Bases de Datos II:</p>
      <p>Sustituimos el ETL monolítico tradicional por un <strong>paradigma ELT</strong> (Extract-Load-Transform):</p>
      <p>1. <em>Extracción:</em> Script en Python con cliente HTTP asíncrono, paginando 50 registros por lote hasta consolidar los 65,000 viajes.<br>
      2. <em>Raw Stage:</em> Ingesta sin pérdida de fidelidad en tablas staging de PostgreSQL.<br>
      3. <em>Transformación Modular con dbt Core:</em> Estructurada en capas <code>stg</code> (limpieza y casteo), <code>int</code> (enriquecimiento con distancias Haversine y métricas de velocidad) y <code>fct</code>/<code>dim</code> (marts analíticos).<br>
      4. <em>Garantía de Calidad:</em> Suites de pruebas automatizadas (<code>dbt test</code>) verificando unicidad, no nulidad y consistencia referencial.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si preguntan por qué dbt: asegura reproducibilidad analítica, linaje visual de dependencias y pruebas de calidad automáticas antes de alimentar el optimizador.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos la estructura del modelo dimensional resultante en la capa de marts."</p>
    </aside>`,

  10: `    <aside class="notes">
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
    </aside>`,

  11: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>12:30 - 13:45</strong> | Duración: 1:15 min | <em>Fase: Estadística Espacial</em></p>
      <p>En el análisis estadístico e inferencial confirmamos con rigor matemático las hipótesis clave:</p>
      <p>Primero, el <strong>Índice de Moran $I = 0.42$ con $p &lt; 0.001$</strong>: Se rechaza formalmente la hipótesis nula de aleatoriedad espacial. Existe una autocorrelación espacial positiva moderada-fuerte; es decir, los viajes insatisfechos y las demoras se agrupan en clusters geográficos específicos de Managua.</p>
      <p>Segundo, la <strong>Prueba $\\chi^2$ de independencia ($p &lt; 0.01$)</strong>: Confirma que la elección del método de pago no es independiente del estrato socioeconómico de la zona de origen. Las zonas populares presentan un 78% de pago en efectivo, mientras que las zonas de estrato alto superan el 65% en tarjeta y billetera digital.</p>
      <p>Tercero, las <strong>Matrices Origen-Destino</strong> revelaron una fuerte direccionalidad matutina hacia el corredor sur, dejando a los cuadrantes orientales desprovistos de flota.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Esta evidencia matemática nos permitió formular el modelo de optimización MILP."</p>
    </aside>`,

  12: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>13:45 - 15:00</strong> | Duración: 1:15 min | <em>Fase: Modelo MILP</em></p>
      <p>Llegamos a la formulación matemática central del proyecto: el <strong>Modelo MILP (Mixed-Integer Linear Programming) Multicriterio</strong>:</p>
      <p>Definimos dos variables binarias de decisión:</p>
      <p>1. $x_{ij} \\in \\{0, 1\\}$: Asignación del vehículo $i$ al viaje $j$.<br>
      2. $y_{ik} \\in \\{0, 1\\}$: Reubicación anticipada del vehículo vacío $i$ hacia el cuadrante con déficit $k$.</p>
      <p>La <strong>Función Objetivo Multiobjetivo</strong> busca minimizar una suma ponderada:</p>
      <p>$$\\min Z = w_1 \\sum T_{espera} + w_2 \\sum D_{deadhead} - w_3 \\sum Ingreso_{neto} + w_4 \\sum Pen_{clima}$$</p>
      <p>Sujeto a restricciones de unicidad de asignación, capacidad de flota, límites de tiempo de espera aceptables y balance de flujo zonal.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> El término $Pen_{clima}$ penaliza severamente el cruce por corredores con riesgo de inundación alta, forzando rutas seguras aun si la distancia lineal es ligeramente mayor.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para contrastar la efectividad del modelo, veamos los resultados de la simulación en tres escenarios."</p>
    </aside>`,

  13: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>15:00 - 16:15</strong> | Duración: 1:15 min | <em>Fase: Simulación</em></p>
      <p>Evaluamos cuantitativamente el impacto de la optimización a través de <strong>tres escenarios comparativos</strong>:</p>
      <p><strong>Escenario 1 (Operación Base Empírica):</strong> Despacho reactivo convencional por distancia mínima. Tiempo de espera promedio de <strong>8.2 minutos</strong>, <strong>34.2% de deadhead</strong> y un 18% de viajes cancelados en hora punta.</p>
      <p><strong>Escenario 2 (Optimizado MILP + Tarifa Dinámica):</strong> Asignación conjunta y rebalanceo preventivo. El tiempo de espera cae a <strong>4.3 minutos (-47%)</strong>, el kilometraje en vacío se reduce al <strong>21.5% (-37%)</strong>, y la tasa de conversión sube al <strong>94.6%</strong>.</p>
      <p><strong>Escenario 3 (Estrés Pluvial - Tormenta de 35 mm/h):</strong> Sin optimización el sistema colapsaría. Con nuestro modelo adaptativo y penalizaciones de riesgo pluvial, la espera se amortigua a 6.8 minutos y se retiene el 89% de conductores activos.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Este proyecto es el reflejo directo de la integración académica del semestre."</p>
    </aside>`,

  14: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>16:15 - 17:30</strong> | Duración: 1:15 min | <em>Fase: Integración Curricular</em></p>
      <p>Queremos destacar ante el jurado la <strong>convergencia curricular holística</strong> de Integrador IV:</p>
      <p>No son materias aisladas, sino un solo engranaje de ingeniería:</p>
      <p>- <strong>Bases de Datos II:</strong> Aportó el diseño dimensional Kimball, el almacenamiento transaccional y el linaje de datos con dbt Core.<br>
      - <strong>Estadística II:</strong> Fundamentó las pruebas de hipótesis, la inferencia multivariada y el análisis de autocorrelación espacial.<br>
      - <strong>Investigación de Operaciones:</strong> Brindó el rigor de formulación MILP, restricciones de red y resolución con solvers matemáticos.<br>
      - <strong>Metodología de la Investigación:</strong> Aseguró la validez epistemológica, la matriz de operacionalización y la delimitación del problema.<br>
      - <strong>Comunicación Científica:</strong> Estructuró la narrativa, la síntesis visual de datos y la capacidad de defensa oral rigurosa.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para finalizar, repasemos los hitos alcanzados y los pasos inmediatos hacia la entrega final."</p>
    </aside>`,

  15: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>17:30 - 18:30</strong> | Duración: 1:00 min | <em>Fase: Conclusiones y Próximos Pasos</em></p>
      <p>En este avance de investigación consolidamos los cimientos técnicos, metodológicos y matemáticos:</p>
      <p>1. Disponemos de un <strong>Data Mart validado</strong> con más de 65,000 registros procesados mediante el pipeline dbt.<br>
      2. Demostramos estadísticamente la <strong>autocorrelación espacial y el sesgo socioeconómico</strong> en la demanda.<br>
      3. Formulamos y probamos computacionalmente el <strong>modelo matemático MILP</strong>.</p>
      <p>Nuestros <strong>próximos pasos hacia la entrega final</strong> son:</p>
      <p>- Calibrar los ponderadores multiobjetivo mediante análisis de sensibilidad en el frente de Pareto.<br>
      - Implementar la arquitectura de inferencia en tiempo real con ventanas de despacho de 3 minutos.<br>
      - Finalizar el artículo científico con las especificaciones académicas requeridas.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."</p>
    </aside>`,

  16: `    <aside class="notes">
      <p class="notes-meta">⏱ <strong>18:30+</strong> | Duración: Sesión Q&A | <em>Fase: Defensa ante el Jurado</em></p>
      <p>Muchas gracias a los profesores y miembros del jurado evaluador. Abrimos con gusto la sesión de preguntas y retroalimentación.</p>
      <p><strong>🎯 Respuestas de Defensa Preparadas para Preguntas Comunes:</strong></p>
      <p>• <em>¿Por qué MILP y no solo una heurística como Algoritmos Genéticos?</em><br>
      "El MILP nos garantiza optimalidad matemática global o un gap de optimalidad acotado demostrable. Para ventanas de despacho de 3 minutos sobre cuadrantes de Managua, el solver PuLP con CBC o HiGHS resuelve en menos de 1.8 segundos, por lo que no es necesario sacrificar optimalidad con una heurística ciega."</p>
      <p>• <em>¿Cómo afecta la informalidad del transporte en Managua?</em><br>
      "La modelamos en la elasticidad precio y en la matriz de métodos de pago en efectivo, lo que justifica por qué el surge pricing no puede ser puramente multiplicativo en zonas periféricas sin generar deserción masiva."</p>
      <p>• <em>¿Cómo se garantiza la reproducibilidad de los datos?</em><br>
      "Todo el pipeline está versionado en Git, con seeds de dbt, scripts de ingesta idempotentes y semillas pseudoaleatorias fijadas para la simulación sintética."</p>
    </aside>`
};

// Parse slides from presentacion_integrador.html
const slideRegex = /<section class="slide([^"]*)" data-slide="(\d+)">([\s\S]*?)<\/section>/g;
let match;
const slideBlocks = [];

while ((match = slideRegex.exec(rawHtml)) !== null) {
  const extraClasses = match[1].trim();
  const num = parseInt(match[2], 10);
  const innerContent = match[3];
  const title = titles[num] || `Slide ${num}`;
  const notes = speakerNotes[num] || '';

  // Class for first slide: is-active
  const activeClass = num === 1 ? ' is-active active visible' : '';
  const finalClass = `slide ${extraClasses}${activeClass}`.replace(/\s+/g, ' ').trim();

  const slideHtml = `            <!-- ========================================================
                 SLIDE ${num}: ${title.toUpperCase()}
                 ======================================================== -->
            <section class="${finalClass}" data-slide="${num}" data-title="${title}">
${innerContent.trim()}
${notes}
            </section>`;

  slideBlocks.push(slideHtml);
}

console.log(`Extracted and enriched ${slideBlocks.length} slides with speaker notes!`);

// Construct final index.html
const finalIndexHtml = `<!DOCTYPE html>
<html lang="es" data-themes="swiss-grid,corporate-clean,tokyo-night,academic-paper,engineering-whiteprint">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Defensa de Investigación: Movi Go — Integrador IV (Ciencia de Datos)</title>

    <!-- Google Fonts: Archivo (Display), Nunito (Body), Space Mono (Technical Data/Formulas) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Archivo:wght@600;700;800;900&family=Nunito:wght@400;500;600;700;800&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">

    <!-- html-ppt Core Design Tokens & Theme -->
    <link rel="stylesheet" href="/assets/fonts.css">
    <link rel="stylesheet" href="/assets/base.css">
    <link rel="stylesheet" id="theme-link" href="/assets/themes/swiss-grid.css">
    <link rel="stylesheet" href="/assets/animations/animations.css">

    <!-- Custom Scoped Presentation Styles -->
    <link rel="stylesheet" href="/src/style.css">
</head>
<body class="deck-mode" data-theme-base="/assets/themes/">

    <!-- Progress indicator managed by runtime.js -->
    <div class="progress-bar"></div>

    <!-- Scaled 16:9 Design Canvas Deck -->
    <div class="deck" id="deck" data-w="1920" data-h="1080">
${slideBlocks.join('\n\n')}
    </div>

    <!-- Vite Main Entry Point (HMR + HUD Controls) -->
    <script type="module" src="/src/main.js"></script>

    <!-- html-ppt Runtime: Keyboard, Presenter Mode (S key), Themes (T key), Notes (N key), Overview (O key) -->
    <script src="/assets/runtime.js"></script>
</body>
</html>
`;

fs.writeFileSync('index.html', finalIndexHtml, 'utf-8');
console.log('Successfully wrote enriched index.html with Vite + html-ppt integration!');
