<template>
  <div class="slide-viewer-host" ref="hostRef">
    <div
      class="deck slide-viewer-canvas"
      :style="canvasStyle"
    >
      <component
        v-if="currentSlideComponent"
        :is="currentSlideComponent"
        class="is-active"
      />
      <div v-else class="slide-not-found">
        <span>Lámina {{ slideIndex }} no encontrada</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useElementSize } from '@vueuse/core';
import { slideComponents } from '../data/slides';

const props = defineProps({
  slideIndex: {
    type: Number,
    required: true,
    default: 1
  },
  scale: {
    type: Number,
    default: null
  },
  autoFit: {
    type: Boolean,
    default: true
  },
  interactive: {
    type: Boolean,
    default: false
  }
});

const hostRef = ref(null);
const { width: hostW, height: hostH } = useElementSize(hostRef);

const computedScale = computed(() => {
  if (props.scale !== null && props.scale > 0) {
    return props.scale;
  }
  if (!props.autoFit) {
    return 1;
  }
  const w = hostW.value || 1920;
  const h = hostH.value || 1080;
  return Math.min(w / 1920, h / 1080);
});

const offsetX = computed(() => {
  if (!props.autoFit) return 0;
  const w = hostW.value || 1920;
  return Math.max(0, (w - 1920 * computedScale.value) / 2);
});

const offsetY = computed(() => {
  if (!props.autoFit) return 0;
  const h = hostH.value || 1080;
  return Math.max(0, (h - 1080 * computedScale.value) / 2);
});

const canvasStyle = computed(() => ({
  width: '1920px',
  height: '1080px',
  transform: `translate(${offsetX.value}px, ${offsetY.value}px) scale(${computedScale.value})`,
  transformOrigin: 'top left',
  pointerEvents: props.interactive ? 'auto' : 'none'
}));

const currentSlideComponent = computed(() => {
  const idx = props.slideIndex - 1;
  if (idx >= 0 && idx < slideComponents.length) {
    return slideComponents[idx];
  }
  return null;
});
</script>

<style scoped>
.slide-viewer-host {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg, #000000);
}

.slide-viewer-canvas {
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  flex: none;
}

/* Force slide inside this viewer to be active and visible */
.slide-viewer-canvas :deep(.slide) {
  opacity: 1 !important;
  pointer-events: auto !important;
  transform: none !important;
  position: absolute;
  inset: 0;
  display: flex;
}

.slide-not-found {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
  font-family: var(--font-mono, monospace);
  font-size: 24px;
}
</style>
