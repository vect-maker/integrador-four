<template>
  <div class="presenter-root" :data-theme="deckStore.currentTheme">
    <!-- Top Header Bar -->
    <header class="p-header">
      <div class="p-header-left">
        <span class="p-badge-live">
          <span class="live-dot"></span>
          <span>MODO EXPOSITOR</span>
        </span>
        <div class="p-title-group">
          <h1 class="p-deck-title">Movi Go • Integrador IV</h1>
          <span class="p-slide-badge">{{ deckStore.formattedCurrent }} / {{ deckStore.formattedTotal }}</span>
          <span class="p-slide-name">{{ deckStore.currentTitle }}</span>
        </div>
      </div>

      <div class="p-header-right">
        <!-- Theme Selector -->
        <div class="theme-selector-group">
          <Palette :size="14" class="theme-icon" />
          <select
            class="theme-select"
            :value="deckStore.currentTheme"
            @change="handleThemeChange"
            title="Cambiar tema visual (sincronizado con audiencia)"
          >
            <option v-for="t in deckStore.availableThemes" :key="t" :value="t">
              Tema: {{ friendlyThemeNames[t] || t }}
            </option>
          </select>
        </div>

        <!-- Audience Window Launcher / Switcher -->
        <button
          class="p-header-btn"
          @click="deckStore.openDisplay"
          title="Abrir o enfocar ventana de audiencia"
        >
          <ExternalLink :size="14" />
          <span>Pantalla Audiencia</span>
        </button>

        <!-- Fullscreen Button -->
        <button
          class="p-header-btn icon-only"
          @click="toggleFullscreen"
          :title="isFullscreen ? 'Salir de pantalla completa' : 'Pantalla completa'"
        >
          <component :is="isFullscreen ? Minimize2 : Maximize2" :size="15" />
        </button>
      </div>
    </header>

    <!-- Main Grid Workspace -->
    <main class="p-grid">
      <!-- Top Left: Current Slide Live Preview -->
      <section class="p-card p-cur-card">
        <div class="p-card-header">
          <div class="card-header-left">
            <span class="status-indicator"></span>
            <span class="card-label">Lámina Actual</span>
            <span class="card-counter">{{ deckStore.formattedCurrent }} / {{ deckStore.formattedTotal }}</span>
          </div>
          <span class="card-title-hint">{{ deckStore.currentTitle }}</span>
        </div>
        <div class="p-card-body preview-stage">
          <!-- Reusable Abstracted SlideViewer Component -->
          <SlideViewer :slide-index="deckStore.currentSlide" />
        </div>
      </section>

      <!-- Top Right: Next Slide Preview -->
      <section class="p-card p-nxt-card">
        <div class="p-card-header">
          <div class="card-header-left">
            <span class="card-label">Siguiente Lámina</span>
            <span class="card-counter" v-if="deckStore.hasNext">
              {{ String(deckStore.currentSlide + 1).padStart(2, '0') }} / {{ deckStore.formattedTotal }}
            </span>
          </div>
          <span class="card-title-hint">{{ deckStore.nextTitle }}</span>
        </div>
        <div class="p-card-body preview-stage">
          <!-- Reusable Abstracted SlideViewer Component -->
          <SlideViewer
            v-if="deckStore.hasNext"
            :slide-index="deckStore.currentSlide + 1"
          />
          <div v-else class="preview-end-card">
            <CheckCircle2 :size="48" style="color: var(--accent-red, #d6001c);" />
            <h3>Fin de la Presentación</h3>
            <p>Has llegado a la última lámina. ¡Excelente defensa!</p>
          </div>
        </div>
      </section>

      <!-- Bottom Left: Stopwatch & Presentation Controls -->
      <section class="p-card p-timer-card">
        <div class="p-card-header">
          <span class="card-label">Cronómetro y Navegación</span>
          <div class="timer-pace-badge">
            <Clock :size="13" />
            <span>Paso {{ deckStore.formattedCurrent }} de {{ deckStore.formattedTotal }}</span>
          </div>
        </div>
        <div class="p-card-body timer-body">
          <div class="timer-display-area">
            <div class="timer-digits" :class="{ 'is-paused': !timerStore.isRunning }">
              {{ timerStore.formattedTime }}
            </div>
            <div class="timer-controls">
              <button
                class="timer-btn"
                :class="{ 'is-running': timerStore.isRunning }"
                @click="timerStore.toggle"
                :title="timerStore.isRunning ? 'Pausar Cronómetro (P)' : 'Iniciar Cronómetro (P)'"
              >
                <component :is="timerStore.isRunning ? Pause : Play" :size="15" />
                <span>{{ timerStore.isRunning ? 'Pausar' : 'Iniciar' }}</span>
              </button>
              <button
                class="timer-btn secondary"
                @click="timerStore.reset"
                title="Reiniciar Cronómetro (R)"
              >
                <RotateCcw :size="14" />
                <span>Reiniciar</span>
              </button>
            </div>
          </div>

          <div class="nav-control-area">
            <div class="nav-buttons-row">
              <button
                class="nav-btn-action"
                :disabled="!deckStore.hasPrev"
                @click="deckStore.prevSlide"
                title="Lámina Anterior (← / Flecha Izquierda)"
              >
                <ChevronLeft :size="18" />
                <span>Anterior</span>
                <kbd>←</kbd>
              </button>

              <button
                class="nav-btn-action primary"
                :disabled="!deckStore.hasNext"
                @click="deckStore.nextSlide"
                title="Siguiente Lámina (→ / Espacio)"
              >
                <span>Siguiente</span>
                <ChevronRight :size="18" />
                <kbd>→</kbd>
              </button>
            </div>

            <!-- Slide Quick Selector -->
            <div class="quick-jump-container">
              <select
                class="quick-jump-select"
                :value="deckStore.currentSlide"
                @change="(e) => deckStore.goToSlide(Number(e.target.value))"
              >
                <option v-for="(title, idx) in deckStore.slideTitles" :key="idx" :value="idx + 1">
                  {{ String(idx + 1).padStart(2, '0') }}. {{ title }}
                </option>
              </select>
            </div>
          </div>
        </div>
      </section>

      <!-- Bottom Right: Speaker Notes -->
      <section class="p-card p-notes-card">
        <div class="p-card-header">
          <div class="card-header-left">
            <FileText :size="14" style="color: var(--accent-red, #d6001c);" />
            <span class="card-label">Notas del Orador</span>
          </div>
          <div class="font-size-controls">
            <button
              class="font-btn"
              @click="adjustFontSize(-1)"
              title="Disminuir tamaño de fuente"
              :disabled="notesFontSize <= 12"
            >
              A-
            </button>
            <span class="font-size-val">{{ notesFontSize }}px</span>
            <button
              class="font-btn"
              @click="adjustFontSize(1)"
              title="Aumentar tamaño de fuente"
              :disabled="notesFontSize >= 24"
            >
              A+
            </button>
          </div>
        </div>
        <div class="p-card-body notes-stage" ref="notesBoxRef" :style="{ fontSize: `${notesFontSize}px` }">
          <div
            v-if="deckStore.currentNotesHtml"
            class="notes-content-view"
            v-html="deckStore.currentNotesHtml"
          ></div>
          <div v-else class="notes-empty-view">
            <FileText :size="32" style="opacity: 0.3; margin-bottom: 10px;" />
            <p>No hay notas del orador registradas para esta lámina.</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useDeckStore } from '../stores/deck';
import { useTimerStore } from '../stores/timer';
import { useDeckBroadcast } from '../composables/useDeckBroadcast';
import { useDeckShortcuts } from '../composables/useDeckShortcuts';
import SlideViewer from './SlideViewer.vue';
import {
  ChevronLeft,
  ChevronRight,
  Play,
  Pause,
  RotateCcw,
  Clock,
  FileText,
  Palette,
  ExternalLink,
  Maximize2,
  Minimize2,
  CheckCircle2
} from '@lucide/vue';

const route = useRoute();
const router = useRouter();
const deckStore = useDeckStore();
const timerStore = useTimerStore();

// Initialize BroadcastChannel sync for presenter role
const broadcast = useDeckBroadcast({ role: 'presenter' });
deckStore.registerBroadcaster(broadcast);

// Keyboard shortcuts for presenter console
useDeckShortcuts({ isPresenter: true });

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
    router.replace(`/presenter/${newSlide}`).catch(() => {});
  }
});

watch(() => route.params.slide, () => {
  syncFromRoute();
});

const notesBoxRef = ref(null);

// Notes Font Size
const notesFontSize = ref(16);
function adjustFontSize(delta) {
  notesFontSize.value = Math.max(12, Math.min(24, notesFontSize.value + delta));
}

// Auto-scroll notes to top on slide change
watch(
  () => deckStore.currentSlide,
  async () => {
    await nextTick();
    if (notesBoxRef.value) {
      notesBoxRef.value.scrollTop = 0;
    }
  }
);

// Theme names friendly map
const friendlyThemeNames = {
  'swiss-grid': 'Suizo',
  'corporate-clean': 'Clean',
  'tokyo-night': 'Tokyo',
  'academic-paper': 'Paper',
  'engineering-whiteprint': 'Blueprint'
};

function handleThemeChange(e) {
  deckStore.setTheme(e.target.value);
}

// Fullscreen
const isFullscreen = ref(false);
function toggleFullscreen() {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen().then(() => {
      isFullscreen.value = true;
    }).catch(() => {});
  } else {
    document.exitFullscreen().then(() => {
      isFullscreen.value = false;
    }).catch(() => {});
  }
}

onMounted(() => {
  deckStore.initTheme();
  syncFromRoute();
});
</script>

<style scoped>
.presenter-root {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #0f1216;
  color: #e2e8f0;
  font-family: var(--font-sans, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif);
  overflow: hidden;
  user-select: none;
}

/* Header */
.p-header {
  height: 52px;
  background: #161b22;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  flex-shrink: 0;
  z-index: 10;
}

.p-header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.p-badge-live {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(214, 0, 28, 0.15);
  border: 1px solid rgba(214, 0, 28, 0.4);
  color: #ff4d61;
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  padding: 3px 8px;
  border-radius: 6px;
}

.live-dot {
  width: 7px;
  height: 7px;
  background: #ff4d61;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(0.85); }
  100% { opacity: 1; transform: scale(1); }
}

.p-title-group {
  display: flex;
  align-items: center;
  gap: 12px;
}

.p-deck-title {
  font-size: 14px;
  font-weight: 800;
  color: #ffffff;
  margin: 0;
  letter-spacing: -0.01em;
}

.p-slide-badge {
  background: rgba(255, 255, 255, 0.1);
  font-family: var(--font-mono, monospace);
  font-size: 12px;
  font-weight: 700;
  padding: 2px 7px;
  border-radius: 4px;
  color: #38bdf8;
}

.p-slide-name {
  font-size: 13px;
  color: #94a3b8;
  max-width: 400px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.p-header-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.theme-selector-group {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 6px;
  padding: 2px 8px;
}

.theme-icon {
  color: #94a3b8;
}

.theme-select {
  background: transparent;
  border: none;
  color: #f1f5f9;
  font-family: var(--font-mono, monospace);
  font-size: 12px;
  outline: none;
  cursor: pointer;
}

.theme-select option {
  background: #1a1e24;
  color: #f1f5f9;
}

.p-header-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #f1f5f9;
  padding: 5px 12px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.p-header-btn:hover {
  background: rgba(255, 255, 255, 0.16);
  border-color: rgba(255, 255, 255, 0.3);
}

.p-header-btn.icon-only {
  padding: 6px;
}

/* Workspace Grid: 2x2 asymmetric layout */
.p-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 55% 45%;
  grid-template-rows: 60% 40%;
  gap: 12px;
  padding: 12px;
  overflow: hidden;
}

.p-card {
  background: #161b22;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
}

.p-card-header {
  height: 38px;
  background: rgba(255, 255, 255, 0.03);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  padding: 0 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
}

.card-header-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--accent-red, #d6001c);
}

.card-label {
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #cbd5e1;
}

.card-counter {
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  color: #94a3b8;
  background: rgba(255, 255, 255, 0.08);
  padding: 2px 6px;
  border-radius: 4px;
}

.card-title-hint {
  font-size: 11px;
  color: #94a3b8;
  max-width: 250px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.p-card-body {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.preview-stage {
  width: 100%;
  height: 100%;
  background: #000000;
}

.preview-end-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 20px;
  height: 100%;
  color: #94a3b8;
}

.preview-end-card h3 {
  color: #ffffff;
  margin: 12px 0 6px 0;
  font-size: 18px;
}

/* Timer & Controls */
.timer-pace-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  color: #94a3b8;
}

.timer-body {
  display: flex;
  padding: 14px 18px;
  gap: 20px;
  align-items: center;
}

.timer-display-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 10px;
  padding: 10px 18px;
  min-width: 200px;
}

.timer-digits {
  font-family: var(--font-mono, monospace);
  font-size: 42px;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 0.04em;
  line-height: 1;
  margin-bottom: 8px;
}

.timer-digits.is-paused {
  color: #f59e0b;
}

.timer-controls {
  display: flex;
  gap: 8px;
}

.timer-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #ffffff;
  padding: 5px 10px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 700;
  font-family: var(--font-mono, monospace);
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.timer-btn:hover {
  background: rgba(255, 255, 255, 0.16);
}

.timer-btn.is-running {
  background: rgba(214, 0, 28, 0.2);
  border-color: rgba(214, 0, 28, 0.5);
  color: #ff6b7e;
}

.timer-btn.secondary {
  opacity: 0.8;
}

.nav-control-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.nav-buttons-row {
  display: flex;
  gap: 10px;
}

.nav-btn-action {
  flex: 1;
  height: 48px;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 8px;
  color: #ffffff;
  font-size: 14px;
  font-weight: 700;
  font-family: var(--font-mono, monospace);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.nav-btn-action:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.14);
  transform: translateY(-1px);
}

.nav-btn-action.primary {
  background: var(--accent-red, #d6001c);
  border-color: var(--accent-red, #d6001c);
}

.nav-btn-action.primary:hover:not(:disabled) {
  background: #b50017;
  border-color: #b50017;
}

.nav-btn-action:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.nav-btn-action kbd {
  background: rgba(0, 0, 0, 0.35);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  padding: 1px 5px;
  font-size: 11px;
}

.quick-jump-container {
  width: 100%;
}

.quick-jump-select {
  width: 100%;
  height: 34px;
  background: rgba(0, 0, 0, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 6px;
  color: #e2e8f0;
  font-family: var(--font-mono, monospace);
  font-size: 12px;
  padding: 0 10px;
  outline: none;
  cursor: pointer;
}

.quick-jump-select option {
  background: #1a1e24;
  color: #f1f5f9;
}

/* Notes */
.font-size-controls {
  display: flex;
  align-items: center;
  gap: 6px;
}

.font-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #ffffff;
  padding: 2px 7px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 700;
  cursor: pointer;
}

.font-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.font-size-val {
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  color: #94a3b8;
}

.notes-stage {
  padding: 16px 20px;
  overflow-y: auto;
  line-height: 1.65;
  color: #f1f5f9;
  user-select: text;
}

.notes-content-view :deep(p) {
  margin-bottom: 12px;
}

.notes-content-view :deep(strong) {
  color: #ffffff;
}

.notes-content-view :deep(code) {
  background: rgba(255, 255, 255, 0.12);
  padding: 2px 6px;
  border-radius: 4px;
  font-family: var(--font-mono, monospace);
  color: #38bdf8;
}

.notes-content-view :deep(.notes-meta) {
  background: rgba(56, 189, 248, 0.1);
  border-left: 3px solid #38bdf8;
  padding: 6px 12px;
  border-radius: 0 6px 6px 0;
  font-family: var(--font-mono, monospace);
  font-size: 0.9em;
}

.notes-content-view :deep(.notes-transition) {
  background: rgba(214, 0, 28, 0.1);
  border-left: 3px solid var(--accent-red, #d6001c);
  padding: 6px 12px;
  border-radius: 0 6px 6px 0;
  margin-top: 16px;
}

.notes-content-view :deep(.notes-tip) {
  background: rgba(245, 158, 11, 0.1);
  border-left: 3px solid #f59e0b;
  padding: 6px 12px;
  border-radius: 0 6px 6px 0;
}

.notes-empty-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #64748b;
  text-align: center;
}
</style>
