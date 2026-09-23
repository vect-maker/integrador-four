import { useMagicKeys, whenever } from '@vueuse/core';
import { useDeckStore } from '../stores/deck';

/**
 * Deck Shortcuts Composable
 * Handles all presentation keyboard navigation using @vueuse/core's useMagicKeys
 */
export function useDeckShortcuts() {
  const deckStore = useDeckStore();

  const keys = useMagicKeys({
    passive: false,
    onEventFired(e) {
      // Don't intercept shortcuts when user is typing in form elements
      if (['INPUT', 'TEXTAREA', 'SELECT'].includes(e.target?.tagName)) return;

      // Prevent scrolling on navigation keys
      if (['ArrowRight', 'ArrowLeft', ' ', 'PageDown', 'PageUp'].includes(e.key)) {
        e.preventDefault();
      }
    }
  });

  // Next slide shortcuts (→, Space, PageDown, Enter)
  whenever(keys.ArrowRight, () => deckStore.nextSlide());
  whenever(keys.space, () => deckStore.nextSlide());
  whenever(keys.PageDown, () => deckStore.nextSlide());
  whenever(keys.Enter, () => deckStore.nextSlide());

  // Previous slide shortcuts (←, PageUp, Backspace)
  whenever(keys.ArrowLeft, () => deckStore.prevSlide());
  whenever(keys.PageUp, () => deckStore.prevSlide());
  whenever(keys.Backspace, () => deckStore.prevSlide());

  // Extrema (Home, End)
  whenever(keys.Home, () => deckStore.firstSlide());
  whenever(keys.End, () => deckStore.lastSlide());

  // Presentation Mode toggles
  whenever(keys.s, () => deckStore.openPresenter());
  whenever(keys.n, () => deckStore.toggleNotes());
  whenever(keys.o, () => deckStore.toggleOverview());
  whenever(keys.t, () => deckStore.cycleTheme());
  whenever(keys.f, () => deckStore.toggleFullscreen());

  // Close overlays with Escape
  whenever(keys.escape, () => {
    deckStore.toggleOverview(false);
    deckStore.toggleNotes(false);
  });
}
