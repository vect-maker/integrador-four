<template>
  <transition name="overview-fade">
    <div
      v-if="deckStore.isOverviewOpen && !deckStore.isPreview"
      class="overview-overlay"
      role="dialog"
      aria-modal="true"
      aria-label="Resumen de diapositivas"
      @click.self="deckStore.toggleOverview(false)"
    >
      <div class="overview-container">
        <!-- Top Toolbar -->
        <header class="overview-header">
          <div class="header-left">
            <LayoutGrid :size="18" :stroke-width="2.2" style="color: var(--accent-red); margin-right: 8px; flex-shrink: 0;" />
            <h2>Índice General de Diapositivas</h2>
            <span class="overview-total">{{ deckStore.totalSlides }} Láminas</span>
          </div>
          <button
            class="overview-close-btn"
            @click="deckStore.toggleOverview(false)"
            title="Cerrar índice (Esc u O)"
            aria-label="Cerrar vista de resumen"
          >
            <X :size="14" :stroke-width="2.2" /> <span>Cerrar</span> <kbd>Esc</kbd>
          </button>
        </header>

        <!-- Grid of Slides with Live Visual Previews -->
        <div class="overview-grid" role="listbox" aria-label="Seleccionar lámina">
          <div
            v-for="(title, idx) in deckStore.slideTitles"
            :key="idx"
            class="slide-thumb"
            :class="{ 'is-active': deckStore.currentSlide === idx + 1 }"
            role="option"
            :aria-selected="deckStore.currentSlide === idx + 1"
            tabindex="0"
            @click="selectSlide(idx + 1)"
            @keydown.enter="selectSlide(idx + 1)"
            @keydown.space.prevent="selectSlide(idx + 1)"
          >
            <!-- Visual Live Slide Preview -->
            <div class="thumb-preview-box">
              <SlideViewer :slide-index="idx + 1" />
              <div v-if="deckStore.currentSlide === idx + 1" class="thumb-active-badge">
                ACTIVA
              </div>
            </div>

            <!-- Thumbnail Information -->
            <div class="thumb-info">
              <div class="thumb-header">
                <span class="thumb-number">{{ String(idx + 1).padStart(2, '0') }}</span>
                <span class="thumb-step">Lámina {{ idx + 1 }} / {{ deckStore.totalSlides }}</span>
              </div>
              <h4 class="thumb-title">{{ title }}</h4>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { useDeckStore } from '../stores/deck';
import SlideViewer from './SlideViewer.vue';
import { LayoutGrid, X } from '@lucide/vue';

const deckStore = useDeckStore();

function selectSlide(num) {
  deckStore.goToSlide(num);
  deckStore.toggleOverview(false);
}
</script>

<style scoped>
.overview-overlay {
  position: fixed;
  inset: 0;
  background: rgba(15, 18, 22, 0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  z-index: 9995;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px;
  overflow-y: auto;
}

.overview-container {
  width: 100%;
  max-width: 1500px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.overview-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 20px;
  margin-bottom: 20px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.12);
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-left h2 {
  font-family: var(--font-display, 'Archivo', sans-serif);
  font-size: 22px;
  font-weight: 800;
  color: #ffffff;
  margin: 0;
  letter-spacing: -0.02em;
  text-transform: uppercase;
}

.overview-total {
  font-family: var(--font-mono, monospace);
  font-size: 12px;
  font-weight: 700;
  color: #94a3b8;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.12);
  padding: 3px 10px;
  border-radius: 20px;
}

.overview-close-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.18);
  color: #ffffff;
  padding: 8px 16px;
  border-radius: 24px;
  cursor: pointer;
  font-family: var(--font-mono, monospace);
  font-size: 13px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
  outline: none;
}

.overview-close-btn:hover {
  background: var(--accent-red, #d6001c);
  border-color: var(--accent-red, #d6001c);
}

.overview-close-btn:focus-visible {
  box-shadow: 0 0 0 3px rgba(214, 0, 28, 0.5);
  border-color: var(--accent-red, #d6001c);
}

.overview-close-btn kbd {
  background: rgba(0, 0, 0, 0.4);
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 11px;
}

/* Grid */
.overview-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  overflow-y: auto;
  padding: 8px 6px 16px 2px;
}

@media (max-width: 1300px) {
  .overview-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 860px) {
  .overview-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 540px) {
  .overview-grid {
    grid-template-columns: 1fr;
  }
}

.slide-thumb {
  background: #161b22;
  border: 2px solid rgba(255, 255, 255, 0.12);
  border-radius: 12px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.4);
  outline: none;
}

.slide-thumb:hover {
  border-color: var(--accent-red, #d6001c);
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.6);
}

.slide-thumb:focus-visible {
  border-color: var(--accent-red, #d6001c);
  box-shadow: 0 0 0 3px rgba(214, 0, 28, 0.5);
  transform: translateY(-2px);
}

.slide-thumb.is-active {
  border-color: var(--accent-red, #d6001c);
  background: #1c222b;
  box-shadow: 0 0 0 2px var(--accent-red, #d6001c), 0 8px 24px rgba(0, 0, 0, 0.5);
}

.thumb-preview-box {
  width: 100%;
  aspect-ratio: 16 / 9;
  position: relative;
  background: #000000;
  overflow: hidden;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.thumb-active-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  background: var(--accent-red, #d6001c);
  color: #fff;
  font-family: var(--font-mono, monospace);
  font-size: 10px;
  font-weight: 800;
  padding: 3px 8px;
  border-radius: 4px;
  letter-spacing: 0.08em;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
  z-index: 5;
}

.thumb-info {
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.thumb-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.thumb-number {
  font-family: var(--font-mono, monospace);
  font-weight: 800;
  font-size: 15px;
  color: var(--accent-red, #d6001c);
}

.thumb-step {
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  color: #94a3b8;
}

.thumb-title {
  font-family: var(--font-display, 'Archivo', sans-serif);
  font-size: 13px;
  font-weight: 700;
  color: #f1f5f9;
  line-height: 1.35;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Transitions */
.overview-fade-enter-active,
.overview-fade-leave-active {
  transition: opacity 0.25s ease;
}

.overview-fade-enter-from,
.overview-fade-leave-to {
  opacity: 0;
}
</style>
