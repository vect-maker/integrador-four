<template>
  <div
    v-if="!deckStore.isPreview"
    class="deck-hub-container"
    :class="{
      'is-notes-mode': deckStore.isNotesOpen,
      'is-overview-mode': deckStore.isOverviewOpen,
      'is-minimized': isMinimized
    }"
  >
    <!-- Floating Hub Bar -->
    <nav
      class="deck-hub"
      :class="{ 'is-compact': isMinimized }"
      aria-label="Controles de la presentación"
    >
      <!-- Group 1: Navigation (Always accessible) -->
      <div class="hub-group">
        <button
          class="hub-btn nav-btn"
          :disabled="!deckStore.hasPrev"
          @click="deckStore.prevSlide()"
          title="Diapositiva Anterior (← / Tecla Flecha Izquierda)"
          aria-label="Diapositiva anterior"
        >
          <ChevronLeft :size="16" :stroke-width="2.2" />
        </button>

        <div
          class="hub-counter"
          :class="{ 'is-clickable': !deckStore.isOverviewOpen && !deckStore.isNotesOpen }"
          :title="counterTooltip"
          :aria-expanded="showJumpList"
          aria-haspopup="listbox"
          tabindex="0"
          role="button"
          @click="handleCounterClick"
          @keydown.enter="handleCounterClick"
          @keydown.space.prevent="handleCounterClick"
        >
          <span class="counter-num">{{ deckStore.counterText }}</span>
          <span v-if="!isMinimized && !deckStore.isOverviewOpen && !deckStore.isNotesOpen" class="counter-title-hint">
            {{ truncatedTitle }}
          </span>
          <span v-else-if="!isMinimized && deckStore.isOverviewOpen" class="counter-mode-badge">
            RESUMEN
          </span>
          <span v-else-if="!isMinimized && deckStore.isNotesOpen" class="counter-mode-badge">
            NOTAS
          </span>
        </div>

        <button
          class="hub-btn nav-btn"
          :disabled="!deckStore.hasNext"
          @click="deckStore.nextSlide()"
          title="Siguiente Diapositiva (→ / Espacio / Tecla Flecha Derecha)"
          aria-label="Siguiente diapositiva"
        >
          <ChevronRight :size="16" :stroke-width="2.2" />
        </button>
      </div>

      <div class="hub-divider"></div>

      <!-- Minimized State: Single Expand Button -->
      <template v-if="isMinimized">
        <button
          class="hub-btn tool-btn min-toggle-btn"
          @click="toggleMinimize"
          title="Expandir barra de controles (Tecla H)"
        >
          <ChevronUp :size="15" :stroke-width="2.5" class="btn-icon" />
          <span class="btn-label">Herramientas <kbd>H</kbd></span>
        </button>
      </template>

      <!-- Expanded State: Adapts tools dynamically according to active mode -->
      <template v-else>
        <!-- 1. OVERVIEW MODE: Contextual slide-selection & preview tools -->
        <div v-if="deckStore.isOverviewOpen" class="hub-group">
          <button
            class="hub-btn tool-btn theme-btn"
            @click="deckStore.cycleTheme()"
            :title="`Cambiar Tema Visual (Actual: ${deckStore.currentTheme}) - Tecla T`"
          >
            <Palette :size="15" :stroke-width="2" class="btn-icon" />
            <span class="btn-label">{{ friendlyThemeName }} <kbd>T</kbd></span>
          </button>

          <button
            class="hub-btn tool-btn is-active close-mode-btn"
            @click="deckStore.toggleOverview(false)"
            title="Cerrar vista resumen (Tecla Esc u O)"
          >
            <X :size="15" :stroke-width="2" class="btn-icon" />
            <span class="btn-label">Cerrar Resumen <kbd>Esc</kbd></span>
          </button>

          <button
            class="hub-btn tool-btn icon-only"
            @click="toggleMinimize"
            title="Minimizar barra de controles (Tecla H)"
          >
            <ChevronDown :size="15" :stroke-width="2" />
          </button>
        </div>

        <!-- 2. NOTES MODE: Speaker reference tools (Elevated above drawer) -->
        <div v-else-if="deckStore.isNotesOpen" class="hub-group">
          <button
            class="hub-btn tool-btn"
            @click="deckStore.openPresenter()"
            title="Abrir Ventana de Presentador con Cronómetro (Tecla S)"
          >
            <Presentation :size="15" :stroke-width="2" class="btn-icon" />
            <span class="btn-label">Doble Pantalla <kbd>S</kbd></span>
          </button>

          <button
            class="hub-btn tool-btn is-active close-mode-btn"
            @click="deckStore.toggleNotes(false)"
            title="Cerrar panel de notas (Tecla Esc o N)"
          >
            <X :size="15" :stroke-width="2" class="btn-icon" />
            <span class="btn-label">Cerrar Notas <kbd>Esc</kbd></span>
          </button>

          <button
            class="hub-btn tool-btn icon-only"
            :class="{ 'is-active': deckStore.isFullscreen }"
            @click="deckStore.toggleFullscreen()"
            title="Pantalla Completa (Tecla F)"
          >
            <component :is="deckStore.isFullscreen ? Minimize2 : Maximize2" :size="15" :stroke-width="2" />
          </button>

          <button
            class="hub-btn tool-btn icon-only"
            @click="toggleMinimize"
            title="Minimizar barra de controles (Tecla H)"
          >
            <ChevronDown :size="15" :stroke-width="2" />
          </button>
        </div>

        <!-- 3. NORMAL MODE: Standard Presentation Toolbar -->
        <div v-else class="hub-group">
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
            @click="printDeck"
            title="Imprimir / Exportar a PDF (Tecla P o Ctrl+P)"
          >
            <Printer :size="15" :stroke-width="2" class="btn-icon" />
            <span class="btn-label">PDF <kbd>P</kbd></span>
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

          <button
            class="hub-btn tool-btn icon-only"
            @click="toggleMinimize"
            title="Minimizar barra de controles (Tecla H)"
          >
            <ChevronDown :size="15" :stroke-width="2" />
          </button>
        </div>
      </template>

      <!-- Integrated Mini Progress Bar -->
      <div class="hub-progress">
        <div class="hub-progress-fill" :style="{ width: deckStore.progressPercent + '%' }"></div>
      </div>
    </nav>

    <!-- Quick Jump Slide Drawer / Dropdown (Only in normal presentation mode) -->
    <transition name="hub-fade">
      <div v-if="showJumpList && !deckStore.isOverviewOpen && !deckStore.isNotesOpen" class="hub-jump-menu">
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
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
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
  X,
  Printer,
  ChevronDown,
  ChevronUp
} from '@lucide/vue';

const deckStore = useDeckStore();
const showJumpList = ref(false);

const isMinimized = computed(() => deckStore.isHubMinimized);

function toggleMinimize() {
  deckStore.toggleHubMinimized();
}

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

const counterTooltip = computed(() => {
  if (deckStore.isOverviewOpen) return 'Modo Resumen General (Malla)';
  if (deckStore.isNotesOpen) return 'Modo Notas del Orador Activo';
  return `Diapositiva ${deckStore.currentSlide} - Clic para ver índice rápido`;
});

function handleCounterClick() {
  if (deckStore.isOverviewOpen || deckStore.isNotesOpen) return;
  showJumpList.value = !showJumpList.value;
}

function jumpTo(slideNum) {
  deckStore.goToSlide(slideNum);
  showJumpList.value = false;
}

function printDeck() {
  showJumpList.value = false;
  deckStore.toggleOverview(false);
  deckStore.toggleNotes(false);
  window.print();
}

function handleOutsideClick(e) {
  if (showJumpList.value && !e.target.closest('.hub-counter') && !e.target.closest('.hub-jump-menu')) {
    showJumpList.value = false;
  }
}

// Ensure jump dropdown closes immediately whenever modes change
watch(
  () => [deckStore.isOverviewOpen, deckStore.isNotesOpen],
  ([overview, notes]) => {
    if (overview || notes) {
      showJumpList.value = false;
    }
  }
);

onMounted(() => {
  deckStore.scanAndInit?.();
  document.addEventListener('click', handleOutsideClick);
});

onUnmounted(() => {
  document.removeEventListener('click', handleOutsideClick);
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
  transition: bottom 0.3s cubic-bezier(0.16, 1, 0.3, 1), transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Elevated when speaker notes drawer is open so it sits right above it */
.deck-hub-container.is-notes-mode {
  bottom: calc(48vh + 14px);
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

.deck-hub.is-compact {
  padding: 5px 10px;
  gap: 8px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
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
  transition: background 0.2s ease;
  min-width: 80px;
}

.hub-counter.is-clickable {
  cursor: pointer;
}

.hub-counter.is-clickable:hover {
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

.counter-mode-badge {
  font-size: 9px;
  font-weight: 800;
  letter-spacing: 0.08em;
  color: var(--accent-red, #d6001c);
  text-transform: uppercase;
  margin-top: -1px;
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

.hub-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--accent-red, #d6001c), 0 0 0 4px rgba(214, 0, 28, 0.4);
}

.hub-btn:active:not(:disabled) {
  transform: translateY(1px);
}

.hub-btn:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}

.nav-btn {
  width: 32px;
  height: 32px;
  min-width: 32px;
  min-height: 32px;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 18px;
  line-height: 1;
}

.hub-btn.icon-only {
  padding: 5px 8px;
  justify-content: center;
}

.tool-btn kbd {
  background: rgba(255, 255, 255, 0.14);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 4px;
  padding: 2px 6px;
  font-size: 10px;
  color: #f8fafc;
  font-weight: 700;
  letter-spacing: 0.02em;
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

.min-toggle-btn {
  background: rgba(255, 255, 255, 0.1);
  color: #f8fafc;
}

.close-mode-btn {
  background: rgba(214, 0, 28, 0.25);
  border-color: var(--accent-red, #d6001c);
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

@media print {
  .deck-hub-container {
    display: none !important;
  }
}
</style>
