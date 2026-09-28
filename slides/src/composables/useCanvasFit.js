import { watchEffect } from 'vue';
import { useWindowSize } from '@vueuse/core';

/**
 * Canvas Fit Composable
 * Reactively scales a fixed 16:9 canvas (1920x1080) to fit any viewport using CSS variable --deck-scale.
 */
export function useCanvasFit(designWidth = 1920, designHeight = 1080) {
  const { width, height } = useWindowSize();

  watchEffect(() => {
    if (typeof document === 'undefined') return;

    const scale = Math.min(width.value / designWidth, height.value / designHeight);
    const deck = document.querySelector('.deck') || document.documentElement;

    deck.style.setProperty('--deck-w', `${designWidth}px`);
    deck.style.setProperty('--deck-h', `${designHeight}px`);
    deck.style.setProperty('--deck-scale', String(scale));
  });
}
