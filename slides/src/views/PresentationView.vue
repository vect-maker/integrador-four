<template>
  <div class="deck-root">
    <!-- Top Progress Bar -->
    <DeckProgressBar />

    <!-- Scaled 16:9 Design Canvas Deck -->
    <div
      ref="deckRef"
      class="deck"
      id="deck"
      data-w="1920"
      data-h="1080"
    >
      <component
        v-for="(slideComp, index) in slideComponents"
        :key="index"
        :is="slideComp"
        :class="{
          'is-active': index + 1 === deckStore.currentSlide,
          'is-prev': index + 1 < deckStore.currentSlide
        }"
      />
    </div>

    <!-- Floating Deck Hub Presentation Controls -->
    <DeckHub />

    <!-- Speaker Notes Overlay Drawer -->
    <NotesDrawer />

    <!-- Slide Overview Grid -->
    <SlideOverview />
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useDeckStore } from '../stores/deck';
import { useDeckBroadcast } from '../composables/useDeckBroadcast';
import { useDeckShortcuts } from '../composables/useDeckShortcuts';
import { useCanvasFit } from '../composables/useCanvasFit';
import { useDeckTouch } from '../composables/useDeckTouch';
import { slideComponents } from '../data/slides';

// Presentation Components
import DeckProgressBar from '../components/DeckProgressBar.vue';
import DeckHub from '../components/DeckHub.vue';
import NotesDrawer from '../components/NotesDrawer.vue';
import SlideOverview from '../components/SlideOverview.vue';

const route = useRoute();
const router = useRouter();
const deckStore = useDeckStore();
const deckRef = ref(null);

// Broadcast synchronization for display role
const broadcast = useDeckBroadcast({ role: 'display' });
deckStore.registerBroadcaster(broadcast);

// Keyboard navigation & canvas scaling
useDeckShortcuts();
useCanvasFit(1920, 1080);
useDeckTouch(deckRef);

// Sync route parameter :slide <-> deckStore.currentSlide
function syncFromRoute() {
  if (route.params.slide) {
    const num = parseInt(route.params.slide, 10);
    if (!isNaN(num) && num >= 1 && num <= deckStore.totalSlides) {
      deckStore.setSlideFromRemote(num);
    }
  }
}

deckStore.onSlideChange((newSlide) => {
  if (String(route.params.slide) !== String(newSlide)) {
    router.replace(`/${newSlide}`).catch(() => {});
  }
});

watch(() => route.params.slide, () => {
  syncFromRoute();
});

onMounted(() => {
  deckStore.initTheme();
  syncFromRoute();
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

@media print {
  .deck-root {
    width: 1920px !important;
    height: auto !important;
    min-height: 0 !important;
    max-height: none !important;
    display: block !important;
    overflow: visible !important;
    position: static !important;
    margin: 0 !important;
    padding: 0 !important;
  }
}
</style>
