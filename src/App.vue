<template>
  <div class="deck-root">
    <!-- Top Progress Bar (Native Vue Component) -->
    <DeckProgressBar />

    <!-- Scaled 16:9 Design Canvas Deck -->
    <div
      ref="deckRef"
      class="deck"
      id="deck"
      data-w="1920"
      data-h="1080"
    >
      <Slide01Cover />
      <Slide02Context />
      <Slide03Literature />
      <Slide04Problem />
      <Slide05Objectives />
      <Slide06Variables />
      <Slide07Theory />
      <Slide08Methodology />
      <Slide09Pipeline />
      <Slide10Conclusion />
      <Slide11Questions />
    </div>

    <!-- Floating Deck Hub Presentation Controls (Pinia Powered) -->
    <DeckHub />

    <!-- Speaker Notes Overlay Drawer (Native Vue Component) -->
    <NotesDrawer />

    <!-- Slide Overview Grid (Native Vue Component) -->
    <SlideOverview />
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useDeckStore } from './stores/deck';
import { useDeckShortcuts } from './composables/useDeckShortcuts';
import { useCanvasFit } from './composables/useCanvasFit';
import { useDeckTouch } from './composables/useDeckTouch';

// Control & Presentation Components
import DeckProgressBar from './components/DeckProgressBar.vue';
import DeckHub from './components/DeckHub.vue';
import NotesDrawer from './components/NotesDrawer.vue';
import SlideOverview from './components/SlideOverview.vue';

// 11 Individual Slide Components
import Slide01Cover from './slides/Slide01Cover.vue';
import Slide02Context from './slides/Slide02Context.vue';
import Slide03Literature from './slides/Slide03Literature.vue';
import Slide04Problem from './slides/Slide04Problem.vue';
import Slide05Objectives from './slides/Slide05Objectives.vue';
import Slide06Variables from './slides/Slide06Variables.vue';
import Slide07Theory from './slides/Slide07Theory.vue';
import Slide08Methodology from './slides/Slide08Methodology.vue';
import Slide09Pipeline from './slides/Slide09Pipeline.vue';
import Slide10Conclusion from './slides/Slide10Conclusion.vue';
import Slide11Questions from './slides/Slide11Questions.vue';

const deckStore = useDeckStore();
const deckRef = ref(null);

// Initialize keyboard shortcuts via useMagicKeys (@vueuse/core)
useDeckShortcuts();

// Initialize responsive canvas scaling (1920x1080)
useCanvasFit(1920, 1080);

// Initialize mobile/touch gestures
useDeckTouch(deckRef);

onMounted(async () => {
  await nextTick();
  requestAnimationFrame(() => {
    deckStore.scanAndInit();
  });
});
</script>

<style scoped>
.deck-root {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
}
</style>
