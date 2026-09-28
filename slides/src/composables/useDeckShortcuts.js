import { useMagicKeys, whenever } from '@vueuse/core';
import { useDeckStore } from '../stores/deck';
import { useTimerStore } from '../stores/timer';

/**
 * Deck Shortcuts Composable
 * Handles presentation and presenter keyboard navigation using @vueuse/core's useMagicKeys
 */
export function useDeckShortcuts(options = {}) {
  const deckStore = useDeckStore();
  const timerStore = useTimerStore();

  const isPresenter = options.isPresenter ?? (
    typeof window !== 'undefined' && window.location.pathname.startsWith('/presenter')
  );

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

  // Theme cycle (T)
  whenever(keys.t, () => deckStore.cycleTheme());

  // Fullscreen (F)
  whenever(keys.f, () => deckStore.toggleFullscreen());

  // Context-aware shortcuts: Presenter vs Display mode
  whenever(keys.p, () => {
    if (isPresenter) {
      timerStore.toggle();
    } else {
      deckStore.toggleOverview(false);
      deckStore.toggleNotes(false);
      window.print();
    }
  });

  whenever(keys.r, () => {
    if (isPresenter) {
      timerStore.reset();
    }
  });

  // Display mode only overlays
  whenever(keys.s, () => {
    if (!isPresenter) {
      deckStore.openPresenter();
    }
  });

  whenever(keys.n, () => {
    if (!isPresenter) {
      deckStore.toggleNotes();
    }
  });

  whenever(keys.o, () => {
    if (!isPresenter) {
      deckStore.toggleOverview();
    }
  });

  whenever(keys.h, () => {
    if (!isPresenter) {
      deckStore.toggleHubMinimized();
    }
  });

  // Close overlays with Escape
  whenever(keys.escape, () => {
    if (!isPresenter) {
      deckStore.toggleOverview(false);
      deckStore.toggleNotes(false);
    }
  });
}
