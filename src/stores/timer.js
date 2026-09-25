import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useTimerStore = defineStore('timer', () => {
  const elapsedSeconds = ref(0);
  const isRunning = ref(true); // Auto-start presentation timer by default
  let timerInterval = null;

  function tick() {
    if (isRunning.value) {
      elapsedSeconds.value += 1;
    }
  }

  function start() {
    if (!timerInterval) {
      timerInterval = setInterval(tick, 1000);
    }
    isRunning.value = true;
  }

  function pause() {
    isRunning.value = false;
  }

  function toggle() {
    if (isRunning.value) {
      pause();
    } else {
      start();
    }
  }

  function reset() {
    elapsedSeconds.value = 0;
  }

  // Format MM:SS or HH:MM:SS
  const formattedTime = computed(() => {
    const total = elapsedSeconds.value;
    const hours = Math.floor(total / 3600);
    const minutes = Math.floor((total % 3600) / 60);
    const seconds = total % 60;

    const mm = String(minutes).padStart(2, '0');
    const ss = String(seconds).padStart(2, '0');

    if (hours > 0) {
      const hh = String(hours).padStart(2, '0');
      return `${hh}:${mm}:${ss}`;
    }
    return `${mm}:${ss}`;
  });

  // Start timer on store creation
  if (typeof window !== 'undefined') {
    start();
  }

  return {
    elapsedSeconds,
    isRunning,
    formattedTime,
    start,
    pause,
    toggle,
    reset
  };
});
