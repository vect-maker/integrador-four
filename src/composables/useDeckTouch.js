import { useSwipe } from '@vueuse/core';
import { useDeckStore } from '../stores/deck';

/**
 * Deck Touch Composable
 * Handles touch swipe gestures for mobile / tablet slide navigation using @vueuse/core's useSwipe
 */
export function useDeckTouch(targetEl) {
  const deckStore = useDeckStore();

  useSwipe(targetEl, {
    threshold: 60,
    onSwipeEnd(e, direction) {
      // Don't swipe if touching inside scrollable interactive overlays
      if (e.target?.closest('.notes-drawer, .slide-overview, button, a, input, textarea')) {
        return;
      }

      if (direction === 'left') {
        deckStore.nextSlide();
      } else if (direction === 'right') {
        deckStore.prevSlide();
      }
    }
  });
}
