<template>
  <div v-if="!deckStore.isPreview" class="deck-hub-container">
    <!-- Floating Hub Bar -->
    <nav class="deck-hub" aria-label="Controles de la presentación">
      <!-- Group 1: Navigation -->
      <div class="hub-group">
        <button
          class="hub-btn nav-btn"
          :disabled="!deckStore.hasPrev"
          @click="deckStore.prevSlide()"
          title="Diapositiva Anterior (← / Tecla Flecha Izquierda)"
        >
          <ChevronLeft :size="16" :stroke-width="2.5" />
        </button>

        <div
          class="hub-counter"
          :title="deckStore.currentTitle"
          @click="toggleDropdown"
        >
          <span class="counter-num">{{ deckStore.counterText }}</span>
          <span class="counter-title-hint">{{ truncatedTitle }}</span>
        </div>

        <button
          class="hub-btn nav-btn"
          :disabled="!deckStore.hasNext"
          @click="deckStore.nextSlide()"
          title="Siguiente Diapositiva (→ / Espacio / Tecla Flecha Derecha)"
        >
          <ChevronRight :size="16" :stroke-width="2.5" />
        </button>
      </div>

      <div class="hub-divider"></div>

      <!-- Group 2: Mode & Tools -->
      <div class="hub-group">
        <button
          class="hub-btn tool-btn"
          @click="deckStore.openPresenter()"
          title="Modo Presentador con Notas y Cronómetro (Tecla S)"
        >
          <Presentation :size="15" :stroke-width="2" class="btn-icon" />
          <span class="btn-label">Presentador <kbd>S</kbd></span>
        </button>

        <button
          class="hub-btn tool-btn"
          :class="{ 'is-active': deckStore.isNotesOpen }"
          @click="deckStore.toggleNotes()"
          title="Panel Rápido de Notas del Orador (Tecla N)"
        >
          <FileText :size="15" :stroke-width="2" class="btn-icon" />
          <span class="btn-label">Notas <kbd>N</kbd></span>
        </button>

        <button
          class="hub-btn tool-btn"
          :class="{ 'is-active': deckStore.isOverviewOpen }"
          @click="deckStore.toggleOverview()"
          title="Malla / Resumen de Diapositivas (Tecla O)"
        >
          <LayoutGrid :size="15" :stroke-width="2" class="btn-icon" />
          <span class="btn-label">Resumen <kbd>O</kbd></span>
        </button>

        <button
          class="hub-btn tool-btn theme-btn"
          @click="deckStore.cycleTheme()"
          :title="`Cambiar Tema Visual (Actual: ${deckStore.currentTheme}) - Tecla T`"
        >
          <Palette :size="15" :stroke-width="2" class="btn-icon" />
          <span class="btn-label">{{ friendlyThemeName }} <kbd>T</kbd></span>
        </button>

        <button
          class="hub-btn tool-btn"
          :class="{ 'is-active': deckStore.isFullscreen }"
          @click="deckStore.toggleFullscreen()"
          title="Pantalla Completa (Tecla F)"
        >
          <component :is="deckStore.isFullscreen ? Minimize2 : Maximize2" :size="15" :stroke-width="2" class="btn-icon" />
          <span class="btn-label"><kbd>F</kbd></span>
        </button>
      </div>

      <!-- Integrated Mini Progress Bar -->
      <div class="hub-progress">
        <div class="hub-progress-fill" :style="{ width: deckStore.progressPercent + '%' }"></div>
      </div>
    </nav>

    <!-- Quick Jump Slide Drawer / Dropdown -->
    <transition name="hub-fade">
      <div v-if="showJumpList" class="hub-jump-menu">
        <div class="jump-header">
          <span>Índice de Diapositivas</span>
          <button class="jump-close" @click="showJumpList = false" title="Cerrar"><X :size="14" /></button>
        </div>
        <ul class="jump-list">
          <li
            v-for="(title, idx) in deckStore.slideTitles"
            :key="idx"
            :class="{ active: deckStore.currentSlide === idx + 1 }"
            @click="jumpTo(idx + 1)"
          >
            <span class="jump-idx">{{ String(idx + 1).padStart(2, '0') }}</span>
            <span class="jump-title">{{ title }}</span>
          </li>
        </ul>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useDeckStore } from '../stores/deck';
import {
  ChevronLeft,
  ChevronRight,
  Presentation,
  FileText,
  LayoutGrid,
  Palette,
  Maximize2,
  Minimize2,
  X
} from '@lucide/vue';

const deckStore = useDeckStore();
const showJumpList = ref(false);

const friendlyThemeNames = {
  'swiss-grid': 'Suizo',
  'corporate-clean': 'Clean',
  'tokyo-night': 'Tokyo',
  'academic-paper': 'Paper',
  'engineering-whiteprint': 'Blueprint'
};

const friendlyThemeName = computed(() => {
  return friendlyThemeNames[deckStore.currentTheme] || deckStore.currentTheme;
});

const truncatedTitle = computed(() => {
  const t = deckStore.currentTitle;
  if (!t) return '';
  return t.length > 28 ? t.slice(0, 26) + '...' : t;
});

function toggleDropdown() {
  showJumpList.value = !showJumpList.value;
}

function jumpTo(slideNum) {
  deckStore.goToSlide(slideNum);
  showJumpList.value = false;
}

onMounted(() => {
  deckStore.scanAndInit();
});
</script>

<style scoped>
.deck-hub-container {
  position: fixed;
  bottom: 18px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  user-select: none;
}

.deck-hub {
  position: relative;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 14px;
  background: rgba(17, 20, 24, 0.94);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 40px;
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  box-shadow: 0 12px 36px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 255, 255, 0.05);
  color: #ffffff;
  font-family: var(--font-mono);
  font-size: 13px;
  overflow: hidden;
  transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
}

.deck-hub:hover {
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 16px 42px rgba(0, 0, 0, 0.6), 0 0 0 1px rgba(255, 255, 255, 0.1);
}

.hub-group {
  display: flex;
  align-items: center;
  gap: 6px;
}

.hub-divider {
  width: 1px;
  height: 20px;
  background: rgba(255, 255, 255, 0.18);
  margin: 0 4px;
}

/* Counter & Title Hint */
.hub-counter {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4px 10px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s ease;
  min-width: 80px;
}

.hub-counter:hover {
  background: rgba(255, 255, 255, 0.1);
}

.counter-num {
  font-weight: 700;
  font-size: 13px;
  letter-spacing: 0.05em;
  color: #f8fafc;
}

.counter-title-hint {
  font-size: 10px;
  color: #94a3b8;
  max-width: 160px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-top: -2px;
}

/* Hub Buttons */
.hub-btn {
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.14);
  color: #f1f5f9;
  padding: 5px 10px;
  border-radius: 20px;
  cursor: pointer;
  font-family: var(--font-mono);
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
  outline: none;
}

.hub-btn:hover:not(:disabled) {
  background: var(--accent-red, #d6001c);
  border-color: var(--accent-red, #d6001c);
  color: #ffffff;
  transform: translateY(-1px);
}

.hub-btn:active:not(:disabled) {
  transform: translateY(1px);
}

.hub-btn:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}

.nav-btn {
  width: 28px;
  height: 28px;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 18px;
  line-height: 1;
}

.tool-btn kbd {
  background: rgba(0, 0, 0, 0.35);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  padding: 1px 5px;
  font-size: 10px;
  color: #cbd5e1;
  font-weight: 700;
}

.hub-btn.is-active {
  background: var(--accent-red, #d6001c);
  border-color: var(--accent-red, #d6001c);
  color: #ffffff;
}

.hub-btn.is-active kbd {
  background: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.4);
  color: #ffffff;
}

/* Bottom Progress Bar inside Hub */
.hub-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: rgba(255, 255, 255, 0.08);
}

.hub-progress-fill {
  height: 100%;
  background: var(--accent-red, #d6001c);
  transition: width 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Quick Jump List Drawer */
.hub-jump-menu {
  position: absolute;
  bottom: calc(100% + 12px);
  width: 380px;
  max-height: 400px;
  background: rgba(17, 20, 24, 0.96);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.6);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.jump-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
  font-family: var(--font-mono);
  font-size: 12px;
  font-weight: 700;
  color: #cbd5e1;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.jump-close {
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  font-size: 14px;
}

.jump-close:hover {
  color: #ffffff;
}

.jump-list {
  list-style: none;
  margin: 0;
  padding: 6px 0;
  overflow-y: auto;
  max-height: 340px;
}

.jump-list li {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  font-family: var(--font-mono);
  font-size: 12px;
  color: #e2e8f0;
  cursor: pointer;
  transition: all 0.15s ease;
}

.jump-list li:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #ffffff;
}

.jump-list li.active {
  background: rgba(214, 0, 28, 0.2);
  border-left: 3px solid var(--accent-red, #d6001c);
  color: #ffffff;
  font-weight: 700;
}

.jump-idx {
  color: var(--accent-red, #d6001c);
  font-weight: 700;
}

.jump-title {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Animations */
.hub-fade-enter-active,
.hub-fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.hub-fade-enter-from,
.hub-fade-leave-to {
  opacity: 0;
  transform: translateY(8px);
}

@media (max-width: 900px) {
  .btn-label {
    display: none;
  }
}
</style>
