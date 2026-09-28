<template>
  <transition name="drawer-slide">
    <div v-if="deckStore.isNotesOpen && !deckStore.isPreview" class="notes-drawer-backdrop" @click.self="deckStore.toggleNotes(false)">
      <div class="notes-drawer" role="dialog" aria-modal="true" aria-labelledby="notes-title">
        <div class="drawer-header">
          <div class="drawer-title-group">
            <span class="drawer-tag"><FileText :size="11" style="display: inline-block; vertical-align: -1px; margin-right: 4px;" /> ORADOR</span>
            <h3 id="notes-title" class="drawer-heading">
              Notas • {{ deckStore.formattedCurrent }} / {{ deckStore.formattedTotal }}
            </h3>
            <span class="drawer-slide-title">{{ deckStore.currentTitle }}</span>
          </div>
          <button class="drawer-close-btn" @click="deckStore.toggleNotes(false)" title="Cerrar panel de notas (Escape o N)">
            <X :size="14" /> <kbd>Esc</kbd>
          </button>
        </div>

        <div class="drawer-body">
          <div v-if="deckStore.currentNotesHtml" class="notes-content" v-html="deckStore.currentNotesHtml"></div>
          <div v-else class="notes-empty">
            <em>(Esta diapositiva no tiene notas del expositor registradas)</em>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { useDeckStore } from '../stores/deck';
import { FileText, X } from '@lucide/vue';

const deckStore = useDeckStore();
</script>

<style scoped>
.notes-drawer-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  z-index: 9990;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.notes-drawer {
  width: 100%;
  max-width: 1200px;
  max-height: 48vh;
  background: #111418;
  border-top: 3px solid var(--accent-red, #d6001c);
  border-radius: 20px 20px 0 0;
  box-shadow: 0 -12px 40px rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  color: #f1f5f9;
  font-family: var(--font-body, 'Nunito', sans-serif);
}

.drawer-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: rgba(255, 255, 255, 0.04);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.drawer-title-group {
  display: flex;
  align-items: center;
  gap: 14px;
}

.drawer-tag {
  background: var(--accent-red, #d6001c);
  color: #ffffff;
  font-family: var(--font-mono, monospace);
  font-size: 11px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 4px;
  letter-spacing: 0.1em;
}

.drawer-heading {
  font-family: var(--font-mono, monospace);
  font-size: 15px;
  font-weight: 700;
  color: #ffffff;
  margin: 0;
}

.drawer-slide-title {
  color: #94a3b8;
  font-size: 13px;
  border-left: 1px solid rgba(255, 255, 255, 0.2);
  padding-left: 12px;
}

.drawer-close-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #f1f5f9;
  padding: 6px 12px;
  border-radius: 20px;
  cursor: pointer;
  font-family: var(--font-mono, monospace);
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s ease;
}

.drawer-close-btn:hover {
  background: var(--accent-red, #d6001c);
  border-color: var(--accent-red, #d6001c);
}

.drawer-close-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--accent-red, #d6001c), 0 0 0 4px rgba(214, 0, 28, 0.4);
}

.drawer-close-btn kbd {
  background: rgba(0, 0, 0, 0.4);
  padding: 1px 6px;
  border-radius: 4px;
  font-size: 10px;
}

.drawer-body {
  padding: 20px 28px;
  overflow-y: auto;
  font-size: 16px;
  line-height: 1.7;
}

.notes-content :deep(p) {
  margin-bottom: 12px;
}

.notes-content :deep(strong) {
  color: #ffffff;
}

.notes-content :deep(code) {
  background: rgba(255, 255, 255, 0.12);
  padding: 2px 6px;
  border-radius: 4px;
  font-family: var(--font-mono, monospace);
  color: #38bdf8;
}

.notes-empty {
  color: #94a3b8;
  text-align: center;
  padding: 24px;
}

/* Slide Transition */
.drawer-slide-enter-active,
.drawer-slide-leave-active {
  transition: all 0.28s cubic-bezier(0.16, 1, 0.3, 1);
}

.drawer-slide-enter-from,
.drawer-slide-leave-to {
  opacity: 0;
  transform: translateY(100%);
}
</style>
