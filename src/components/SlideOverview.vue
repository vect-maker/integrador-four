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
            <LayoutGrid :size="18" style="color: var(--accent-red); margin-right: 8px; flex-shrink: 0;" />
            <h2>Índice General de Diapositivas</h2>
            <span class="overview-total">{{ deckStore.totalSlides }} Láminas</span>
          </div>
          <button class="overview-close-btn" @click="deckStore.toggleOverview(false)" title="Cerrar índice (Esc u O)">
            <X :size="14" /> <span>Cerrar</span> <kbd>Esc</kbd>
          </button>
        </header>

        <!-- Grid of Slides -->
        <div class="overview-grid">
          <div
            v-for="(title, idx) in deckStore.slideTitles"
            :key="idx"
            class="slide-thumb"
            :class="{ 'is-active': deckStore.currentSlide === idx + 1 }"
            @click="selectSlide(idx + 1)"
          >
            <div class="thumb-header">
              <span class="thumb-number">{{ String(idx + 1).padStart(2, '0') }}</span>
              <span v-if="deckStore.currentSlide === idx + 1" class="thumb-active-badge">ACTIVA</span>
            </div>
            <div class="thumb-body">
              <h4 class="thumb-title">{{ title }}</h4>
            </div>
            <div class="thumb-footer">
              <span>Lámina {{ idx + 1 }} de {{ deckStore.totalSlides }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { useDeckStore } from '../stores/deck';
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
  background: rgba(17, 20, 24, 0.88);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
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
  padding-bottom: 24px;
  margin-bottom: 24px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.15);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.swiss-square {
  width: 14px;
  height: 14px;
  background: var(--accent-red, #d6001c);
  display: inline-block;
}

.header-left h2 {
  font-family: var(--font-display, 'Archivo', sans-serif);
  font-size: 24px;
  font-weight: 800;
  color: #ffffff;
  margin: 0;
  letter-spacing: -0.02em;
  text-transform: uppercase;
}

.overview-total {
  font-family: var(--font-mono, monospace);
  font-size: 13px;
  color: #94a3b8;
  background: rgba(255, 255, 255, 0.08);
  padding: 3px 10px;
  border-radius: 20px;
}

.overview-close-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.2);
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
}

.overview-close-btn:hover {
  background: var(--accent-red, #d6001c);
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
  padding-right: 8px;
}

@media (max-width: 1200px) {
  .overview-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 800px) {
  .overview-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

.slide-thumb {
  background: #1a1e24;
  border: 2px solid rgba(255, 255, 255, 0.12);
  border-radius: 12px;
  padding: 16px;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 140px;
  transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.slide-thumb:hover {
  border-color: var(--accent-red, #d6001c);
  transform: translateY(-3px);
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.5);
}

.slide-thumb.is-active {
  border-color: var(--accent-red, #d6001c);
  background: #222730;
  box-shadow: 0 0 0 2px var(--accent-red, #d6001c);
}

.thumb-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.thumb-number {
  font-family: var(--font-mono, monospace);
  font-weight: 800;
  font-size: 16px;
  color: var(--accent-red, #d6001c);
}

.thumb-active-badge {
  background: var(--accent-red, #d6001c);
  color: #fff;
  font-family: var(--font-mono, monospace);
  font-size: 10px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
}

.thumb-title {
  font-family: var(--font-display, 'Archivo', sans-serif);
  font-size: 14px;
  font-weight: 700;
  color: #f1f5f9;
  line-height: 1.35;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.thumb-footer {
  margin-top: 12px;
  padding-top: 8px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  color: #94a3b8;
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
