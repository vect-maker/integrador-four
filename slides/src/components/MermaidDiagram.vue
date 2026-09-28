<template>
  <div class="mermaid-wrapper" :style="{ maxWidth: maxWidth, textAlign: align }">
    <div
      v-if="svgContent"
      ref="containerRef"
      class="mermaid-container"
      v-html="svgContent"
    ></div>
    <div v-else-if="errorMessage" class="mermaid-error">
      <span>Error al renderizar diagrama:</span>
      <code>{{ errorMessage }}</code>
    </div>
    <div v-else class="mermaid-loading">
      Cargando diagrama...
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, useSlots, nextTick } from 'vue';
import mermaid from 'mermaid';

const props = defineProps({
  code: {
    type: String,
    default: ''
  },
  chart: {
    type: String,
    default: ''
  },
  maxWidth: {
    type: String,
    default: '100%'
  },
  align: {
    type: String,
    default: 'center'
  }
});

const slots = useSlots();
const svgContent = ref('');
const errorMessage = ref('');
const containerRef = ref(null);

// Render counter for unique IDs
let renderCounter = 0;

const diagramCode = computed(() => {
  if (props.code) return props.code.trim();
  if (props.chart) return props.chart.trim();
  if (slots.default) {
    const nodes = slots.default();
    return nodes
      .map(node => (typeof node.children === 'string' ? node.children : ''))
      .join('')
      .trim();
  }
  return '';
});

let isInitialized = false;

function initMermaid() {
  if (isInitialized) return;
  mermaid.initialize({
    startOnLoad: false,
    securityLevel: 'loose',
    theme: 'base',
    themeVariables: {
      primaryColor: '#ffffff',
      primaryTextColor: '#111418',
      primaryBorderColor: '#111418',
      lineColor: '#111418',
      secondaryColor: '#f9fafb',
      tertiaryColor: '#ffffff',
      background: 'transparent',
      mainBkg: '#ffffff',
      nodeBorder: '#111418',
      clusterBkg: 'rgba(243, 244, 246, 0.7)',
      clusterBorder: '#111418',
      edgeLabelBackground: '#ffffff',
      fontFamily: "'Space Mono', 'Nunito', monospace, sans-serif",
      fontSize: '13px',
      arrowheadColor: '#d6001c',
      textColor: '#111418'
    }
  });
  isInitialized = true;
}

async function renderDiagram() {
  const raw = diagramCode.value;
  if (!raw) return;

  try {
    initMermaid();
    errorMessage.value = '';
    const renderId = `mmd-${Math.random().toString(36).slice(2, 7)}-${Date.now()}-${++renderCounter}`;
    const { svg, bindFunctions } = await mermaid.render(renderId, raw);
    svgContent.value = svg;
    await nextTick();
    if (bindFunctions && containerRef.value) {
      bindFunctions(containerRef.value);
    }
  } catch (err) {
    console.warn('[Mermaid Render Error]', err);
    errorMessage.value = err.message || 'Sintaxis de diagrama inválida';
  }
}

onMounted(() => {
  renderDiagram();
});

watch(diagramCode, () => {
  renderDiagram();
});
</script>

<style>
.mermaid-wrapper {
  margin: 0 auto;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.mermaid-container {
  width: 100%;
  display: flex;
  justify-content: center;
}

.mermaid-container svg {
  max-width: 100%;
  height: auto;
  filter: drop-shadow(2px 2px 0px rgba(17, 20, 24, 0.15));
}

.mermaid-container .node rect,
.mermaid-container .node polygon,
.mermaid-container .node circle {
  stroke-width: 2px !important;
  stroke: #111418 !important;
}

.mermaid-container .edgePath path.path {
  stroke: #111418 !important;
  stroke-width: 2px !important;
}

.mermaid-container .marker {
  fill: #d6001c !important;
  stroke: #d6001c !important;
}

.mermaid-container .cluster rect {
  stroke-width: 2px !important;
  stroke: #111418 !important;
  stroke-dasharray: 4 2;
  fill: rgba(243, 244, 246, 0.6) !important;
}

.mermaid-error {
  padding: 10px 14px;
  background: #fee2e2;
  border-left: 4px solid #d6001c;
  color: #991b1b;
  font-family: var(--font-mono);
  font-size: 12px;
}

.mermaid-loading {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--ink-muted);
}
</style>
