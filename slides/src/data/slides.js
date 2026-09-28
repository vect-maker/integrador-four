import Slide01Cover from '../slides/Slide01Cover.vue';
import Slide02Context from '../slides/Slide02Context.vue';
import Slide03Literature from '../slides/Slide03Literature.vue';
import Slide04Problem from '../slides/Slide04Problem.vue';
import Slide05Objectives from '../slides/Slide05Objectives.vue';
import Slide06Variables from '../slides/Slide06Variables.vue';
import Slide07Theory from '../slides/Slide07Theory.vue';
import Slide08Methodology from '../slides/Slide08Methodology.vue';
import Slide09Pipeline from '../slides/Slide09Pipeline.vue';
import Slide10Conclusion from '../slides/Slide10Conclusion.vue';
import Slide11Questions from '../slides/Slide11Questions.vue';

export const slideComponents = [
  Slide01Cover,
  Slide02Context,
  Slide03Literature,
  Slide04Problem,
  Slide05Objectives,
  Slide06Variables,
  Slide07Theory,
  Slide08Methodology,
  Slide09Pipeline,
  Slide10Conclusion,
  Slide11Questions
];

export const slidesMetadata = [
  {
    id: 1,
    title: '01. Portada: Caso Movi Go',
    notes: `<p class="notes-meta">⏱ <strong>00:00 - 01:15</strong> | Duración: 1:15 min | <em>Fase: Introducción</em></p>
      <p>Buenos días, estimado comité evaluador y profesores. Hoy presentamos la defensa de avance de nuestro Proyecto Integrador IV en Ingeniería en Ciencia de Datos: <strong>Optimización territorial de la flota y diseño de un sistema tarifario dinámico multi-criterio para Movi Go en Managua</strong>.</p>
      <p>El núcleo de nuestra investigación es articular tres dimensiones que tradicionalmente se tratan de forma aislada: la <strong>eficiencia operativa</strong> de la flota (reduciendo recorridos en vacío o <em>deadhead</em>), la <strong>heterogeneidad territorial</strong> de Managua (con su estructura policéntrica y asimétrica), y el <strong>impacto climático</strong> (precipitaciones severas que alteran la velocidad de la red vial).</p>
      <p>Trabajamos sobre una base de más de <strong>65,000 registros sintéticos</strong> modelados a través de la API REST oficial de Movi Go.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para comprender la complejidad del desafío, veamos cómo interactúan estas tres dimensiones en la operación diaria."</p>`
  },
  {
    id: 2,
    title: '02. Contextualización: Sistema Dinámico',
    notes: `<p class="notes-meta">⏱ <strong>01:15 - 02:30</strong> | Duración: 1:15 min | <em>Fase: Contextualización</em></p>
      <p>Aquí planteamos la premisa fundamental del proyecto: la movilidad bajo demanda es un <strong>sistema dinámico interdependiente</strong>.</p>
      <p>En primer lugar, la <strong>dimensión operativa</strong> no depende sólo de cuántos conductores hay conectados, sino de <em>dónde están</em>. Si los vehículos circulan desocupados lejos de los focos de demanda, el tiempo de espera del usuario se dispara.</p>
      <p>En segundo lugar, la <strong>dimensión territorial</strong> de Managua presenta una fuerte polarización: orígenes residenciales matutinos hacia corredores comerciales y de oficinas, generando viajes de ida con retorno vacío.</p>
      <p>Y en tercer lugar, la <strong>dimensión tarifaria</strong>: un esquema de precios estático no premia al conductor que viaja a zonas periféricas desabastecidas.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si el jurado pregunta por qué no basta con aumentar la flota, enfatizar que saturar de autos sin rebalanceo incrementa la congestión y reduce los ingresos netos del conductor.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos qué respaldo encontramos en la literatura científica para modelar este acoplamiento."</p>`
  },
  {
    id: 3,
    title: '03. Estado del Arte & Literatura',
    notes: `<p class="notes-meta">⏱ <strong>02:30 - 03:45</strong> | Duración: 1:15 min | <em>Fase: Estado del Arte</em></p>
      <p>Nuestra investigación se apoya en cuatro pilares de la literatura científica internacional y regional:</p>
      <p>1. <strong>Alonso-Mora et al. (2017)</strong> en PNAS demostraron que el despacho y el rebalanceo de flotas en tiempo real deben formularse como un problema de optimización matemática conjunto bajo restricciones temporales estrictas.</p>
      <p>2. <strong>Castillo-Manzano et al. (2020)</strong> probaron que la lluvia genera un trasvase modal masivo hacia plataformas selectivas, pero incrementa las cancelaciones si el algoritmo no ajusta la oferta preventivamente.</p>
      <p>3. <strong>Cramer & Krueger (2016)</strong> documentaron cómo el factor de ocupación de las apps supera al taxi convencional gracias a la intermediación algorítmica.</p>
      <p>4. <strong>Zuniga-Brenes (2022)</strong> aporta la perspectiva centroamericana sobre informalidad y sensibilidad al precio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con esta base teórica, examinemos la radiografía exacta de ineficiencias que experimenta Movi Go en Managua."</p>`
  },
  {
    id: 4,
    title: '04. Problema: Desbalance Espacial',
    notes: `<p class="notes-meta">⏱ <strong>03:45 - 05:00</strong> | Duración: 1:15 min | <em>Fase: Problema</em></p>
      <p>El diagnóstico empírico de Movi Go revela lo que denominamos la <strong>Triada de Ineficiencias</strong>:</p>
      <p>Primero: <strong>Desbalance Espaciotemporal</strong>. El 62% de la flota disponible tiende a concentrarse en apenas 4 nodos comerciales (Metrocentro, Plaza España, Carretera a Masaya), dejando desatendidas zonas residenciales periféricas.</p>
      <p>Segundo: <strong>Kilómetros Improductivos (Deadhead)</strong>. Hasta un 34% del kilometraje total de las unidades se realiza en vacío buscando pasajeros, aumentando los costos de combustible y la fatiga del conductor.</p>
      <p>Tercero: <strong>Vulnerabilidad ante Eventos Pluviales</strong>. Las lluvias torrenciales en Managua saturan los cauces y rotondas viales, reduciendo la velocidad de circulación hasta un 45% y descalibrando el multiplicador de tarifa dinámica.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> El deadhead no solo es un problema de rentabilidad privada; genera emisiones de carbono innecesarias y agrava la congestión urbana.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Para dar una respuesta rigurosa y cuantificable a este problema, estructuramos nuestros objetivos."</p>`
  },
  {
    id: 5,
    title: '05. Objetivos de Investigación',
    notes: `<p class="notes-meta">⏱ <strong>05:00 - 06:15</strong> | Duración: 1:15 min | <em>Fase: Objetivos</em></p>
      <p>Definimos nuestro <strong>Objetivo General</strong> de manera muy clara y medible:</p>
      <p>Diseñar e implementar un <strong>modelo analítico y prescriptivo</strong> para la plataforma Movi Go que integre factores operativos, espaciales y climáticos de Managua, optimizando la asignación de flota y formulando directrices tarifarias transparentes.</p>
      <p>Este objetivo se desglosa en <strong>cuatro objetivos específicos</strong>:</p>
      <p>1. <strong>Estructurar</strong> la base de datos analítica con dbt y PostgreSQL.<br>
      2. <strong>Analizar</strong> la relación espaciotemporal entre demanda, demoras y factores climáticos.<br>
      3. <strong>Evaluar</strong> el impacto de la tarificación dinámica en la oferta y la aceptación.<br>
      4. <strong>Formular</strong> lineamientos para la asignación eficiente de flota y reducción de deadhead.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Pasemos a ver cómo operacionalizamos formalmente cada una de las variables involucradas."</p>`
  },
  {
    id: 6,
    title: '06. Matriz de Variables y Descriptores',
    notes: `<p class="notes-meta">⏱ <strong>05:00 - 06:15</strong> | Duración: 1:15 min | <em>Fase: Variables</em></p>
      <p>Esta tabla resume la <strong>Matriz de Descriptores</strong> estructurada a partir de los verbos rectores de cada objetivo:</p>
      <p>1. <em>OE1 (Estructurar):</em> Base inmutable que extrae los datos de la API REST y los transforma con dbt para garantizar calidad e integridad.<br>
      2. <em>OE2 (Analizar):</em> Examina cómo la lluvia, el tráfico y las zonas impactan tiempos de espera y cancelaciones.<br>
      3. <em>OE3 (Evaluar):</em> Explora la sensibilidad de oferta y demanda frente al multiplicador dinámico.<br>
      4. <em>OE4 (Formular):</em> Diseña modelos prescriptivos para reducir recorridos en vacío (deadhead) y equilibrar tiempos de servicio.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Veamos ahora el marco teórico que fundamenta cada una de estas áreas."</p>`
  },
  {
    id: 7,
    title: '07. Marco Teórico: Transporte & Clima',
    notes: `<p class="notes-meta">⏱ <strong>07:30 - 08:45</strong> | Duración: 1:15 min | <em>Fase: Marco Teórico</em></p>
      <p>En el marco teórico profundizamos en tres fenómenos estructurales propios de Managua:</p>
      <p>Primero, la <strong>morfología urbana y vial</strong>. Managua no es una cuadrícula; es un trazado irregular articulado por rotondas (Centroamérica, Rubén Darío, Cristo Rey). Cuando una rotonda colapsa, el efecto dominó estrangula las arterias conectoras.</p>
      <p>Segundo, la <strong>economía de plataformas de dos lados (Two-Sided Markets)</strong>. La tarifa debe mantener un equilibrio delicado: si el surge sube demasiado, el pasajero de estrato popular o medio cancela; si baja demasiado, el conductor prefiere desconectarse ante la lluvia.</p>
      <p>Tercero, la <strong>hidrología vial urbana</strong>. La escorrentía superficial convierte calles en cauces temporales, obligando a recalibrar las matrices de tiempo de viaje de forma no lineal.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Con el sustento teórico establecido, expliquemos el diseño metodológico de la investigación."</p>`
  },
  {
    id: 8,
    title: '08. Diseño Metodológico Mixto',
    notes: `<p class="notes-meta">⏱ <strong>07:30 - 08:45</strong> | Duración: 1:15 min | <em>Fase: Metodología</em></p>
      <p>Adoptamos un <strong>enfoque cuantitativo-analítico</strong> con un diseño no experimental longitudinal.</p>
      <p>La investigación se articula en <strong>cuatro fases secuenciales</strong> alineadas a los objetivos específicos:</p>
      <p><strong>Fase 1: Ingesta de Datos</strong>. Extracción sistemática vía API REST <code>/movigo</code> con paginación controlada.<br>
      <strong>Fase 2: Transformación y Calidad con dbt</strong>. Modelado analítico dimensional y auditoría con dbt Core sobre PostgreSQL.<br>
      <strong>Fase 3: Análisis Espaciotemporal y Tarifario</strong>. Caracterización de fluctuaciones de demanda, factores climáticos y sensibilidad del surge.<br>
      <strong>Fase 4: Optimización Operativa</strong>. Formulación y contraste de modelos prescriptivos de asignación de flota y reducción de deadhead.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Entremos al detalle de la arquitectura del pipeline de datos con API y dbt."</p>`
  },
  {
    id: 9,
    title: '09. Arquitectura ELT & dbt Core',
    notes: `<p class="notes-meta">⏱ <strong>08:45 - 10:00</strong> | Duración: 1:15 min | <em>Fase: Pipeline ELT</em></p>
      <p>En esta lámina observamos la <strong>Arquitectura de Datos Moderna</strong> que planteamos e implementaremos como base firme del proyecto:</p>
      <p>Sustituimos el ETL monolítico tradicional por un <strong>paradigma ELT</strong> (Extract-Load-Transform):</p>
      <p>1. <em>Extracción:</em> Script en Python con cliente HTTP asíncrono, paginando registros hasta consolidar el histórico completo.<br>
      2. <em>Raw Stage:</em> Ingesta sin pérdida de fidelidad en tablas staging de PostgreSQL.<br>
      3. <em>Transformación Modular con dbt Core:</em> Estructurada en capas <code>stg</code> (limpieza y casteo), <code>int</code> (enriquecimiento geográfico) y <code>fct</code>/<code>dim</code> (marts analíticos).<br>
      4. <em>Garantía de Calidad:</em> Suites de pruebas automatizadas (<code>dbt test</code>) verificando unicidad, no nulidad y consistencia referencial.</p>
      <p class="notes-tip">💡 <em>Tip de Defensa:</em> Si preguntan por qué dbt: asegura reproducibilidad analítica, linaje visual de dependencias y pruebas de calidad automáticas antes de alimentar cualquier modelo.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Pasemos ahora a la síntesis de la propuesta y la ruta de implementación."</p>`
  },
  {
    id: 10,
    title: '10. Síntesis & Plan de Implementación',
    notes: `<p class="notes-meta">⏱ <strong>10:00 - 11:00</strong> | Duración: 1:00 min | <em>Fase: Síntesis y Ruta de Implementación</em></p>
      <p>En esta propuesta de investigación hemos definido las bases técnicas, metodológicas y analíticas que se van a implementar:</p>
      <p>1. Se ha diseñado la <strong>arquitectura ELT</strong> con ingesta desde la API REST de Movi Go y transformación dimensional mediante dbt a implementarse en PostgreSQL.<br>
      2. Se definieron las directrices para el <strong>análisis espaciotemporal y contextual</strong> de la demanda frente al clima.<br>
      3. Se formuló el <strong>modelo de optimización multiobjetivo</strong> para apoyar la gestión operativa y tarifaria.</p>
      <p>Los <strong>siguientes pasos de implementación</strong> contemplan:</p>
      <p>- Desplegar el pipeline de datos y materializar los modelos analíticos en dbt.<br>
      - Calibrar y simular los escenarios de asignación de flota en el contexto de Managua.<br>
      - Desarrollar el informe final y la herramienta interactiva de soporte a decisiones.</p>
      <p class="notes-transition">👉 <em>Transición:</em> "Agradecemos su atención y quedamos a su entera disposición para la sesión de preguntas."</p>`
  },
  {
    id: 11,
    title: '11. Cierre & Sesión de Preguntas',
    notes: `<p class="notes-meta">⏱ <strong>11:00+</strong> | Duración: Sesión Q&A | <em>Fase: Defensa ante el Jurado</em></p>
      <p>Muchas gracias a los profesores y miembros del jurado evaluador. Abrimos con gusto la sesión de preguntas y retroalimentación.</p>
      <p><strong>🎯 Respuestas de Defensa Preparadas para Preguntas Comunes:</strong></p>
      <p>• <em>¿Por qué la ingesta con API REST y dbt es la base fija?</em><br>
      "Porque los datos provienen del servicio real/emulado en la API /movigo, y dbt garantiza reproducibilidad total, linaje formal y pruebas de integridad referencial antes de alimentar cualquier modelo analítico o prescriptivo."</p>
      <p>• <em>¿Por qué los modelos matemáticos y estadísticos se presentan como exploratorios?</em><br>
      "Porque las técnicas numéricas, de inferencia y optimización deben contrastarse y calibrarse según la distribución empírica de los datos observados en Managua, sin asumir métodos rígidos a priori."</p>
      <p>• <em>¿Cómo se garantiza la reproducibilidad de los datos?</em><br>
      "Todo el pipeline está versionado en Git, con seeds y modelos de dbt, scripts de ingesta estructurados y documentación técnica completa."</p>`
  }
];
