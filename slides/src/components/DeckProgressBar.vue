<template>
  <div v-if="!deckStore.isPreview" class="deck-progress-bar" aria-hidden="true">
    <div
      class="deck-progress-fill"
      :style="{ width: deckStore.progressPercent + '%' }"
    ></div>
  </div>
</template>

<script setup>
import { useDeckStore } from '../stores/deck';

const deckStore = useDeckStore();
</script>

<style scoped>
.deck-progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 4px;
  background: rgba(0, 0, 0, 0.08);
  z-index: 10000;
  pointer-events: none;
}

.deck-progress-fill {
  height: 100%;
  background: var(--accent-red, #d6001c);
  transition: width 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  box-shadow: 0 0 10px rgba(214, 0, 28, 0.5);
}

@media print {
  .deck-progress-bar {
    display: none !important;
  }
}
</style>
