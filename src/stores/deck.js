import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { slidesMetadata } from '../data/slides';

export const useDeckStore = defineStore('deck', () => {
  // --- State ---
  const currentSlide = ref(1);
  const totalSlides = ref(slidesMetadata.length);
  const isNotesOpen = ref(false);
  const isOverviewOpen = ref(false);
  const isFullscreen = ref(false);
  const isHubMinimized = ref(false);
  const currentTheme = ref('swiss-grid');
  const availableThemes = ref([
    'swiss-grid',
    'corporate-clean',
    'tokyo-night',
    'academic-paper',
    'engineering-whiteprint'
  ]);

  const slideTitles = ref(slidesMetadata.map(s => s.title));
  const slideNotes = ref(slidesMetadata.map(s => s.notes));
  const isPreview = ref(typeof window !== 'undefined' && window.location.search.includes('preview'));

  // Registered outbound broadcaster functions
  let broadcaster = null;
  let onSlideChangeCallback = null;

  function registerBroadcaster(b) {
    broadcaster = b;
  }

  function onSlideChange(cb) {
    onSlideChangeCallback = cb;
  }

  // --- Getters ---
  const currentIndex = computed(() => currentSlide.value - 1);
  const formattedCurrent = computed(() => String(currentSlide.value).padStart(2, '0'));
  const formattedTotal = computed(() => String(totalSlides.value).padStart(2, '0'));
  const counterText = computed(() => `${formattedCurrent.value} / ${formattedTotal.value}`);
  const progressPercent = computed(() => {
    if (totalSlides.value <= 0) return 0;
    return (currentSlide.value / totalSlides.value) * 100;
  });
  const hasPrev = computed(() => currentSlide.value > 1);
  const hasNext = computed(() => currentSlide.value < totalSlides.value);
  const currentTitle = computed(() => {
    return slideTitles.value[currentIndex.value] || `Lámina ${currentSlide.value}`;
  });
  const nextTitle = computed(() => {
    if (hasNext.value) {
      return slideTitles.value[currentIndex.value + 1] || `Lámina ${currentSlide.value + 1}`;
    }
    return 'Fin de la presentación';
  });
  const currentNotesHtml = computed(() => {
    return slideNotes.value[currentIndex.value] || '';
  });

  // --- Actions ---

  /**
   * Local user navigation action: changes slide and broadcasts to peer tabs
   */
  function goToSlide(target) {
    const clamped = Math.max(1, Math.min(totalSlides.value, Number(target) || 1));
    if (currentSlide.value === clamped) return;

    currentSlide.value = clamped;

    // Notify registered router sync
    if (onSlideChangeCallback) {
      onSlideChangeCallback(clamped);
    }

    // Broadcast command to peer tabs
    if (broadcaster?.sendGoToSlide) {
      broadcaster.sendGoToSlide(clamped);
    }
  }

  /**
   * Remote peer update: changes slide WITHOUT re-broadcasting
   */
  function setSlideFromRemote(target) {
    const clamped = Math.max(1, Math.min(totalSlides.value, Number(target) || 1));
    if (currentSlide.value === clamped) return;

    currentSlide.value = clamped;

    if (onSlideChangeCallback) {
      onSlideChangeCallback(clamped);
    }
  }

  function nextSlide() {
    if (hasNext.value) {
      goToSlide(currentSlide.value + 1);
    }
  }

  function prevSlide() {
    if (hasPrev.value) {
      goToSlide(currentSlide.value - 1);
    }
  }

  function firstSlide() {
    goToSlide(1);
  }

  function lastSlide() {
    goToSlide(totalSlides.value);
  }

  function toggleNotes(force) {
    const nextVal = force !== undefined ? force : !isNotesOpen.value;
    isNotesOpen.value = nextVal;
    if (nextVal) {
      isOverviewOpen.value = false;
    }
  }

  function toggleOverview(force) {
    const nextVal = force !== undefined ? force : !isOverviewOpen.value;
    isOverviewOpen.value = nextVal;
    if (nextVal) {
      isNotesOpen.value = false;
    }
  }

  function toggleHubMinimized(force) {
    isHubMinimized.value = force !== undefined ? force : !isHubMinimized.value;
  }

  function toggleFullscreen() {
    if (typeof document === 'undefined') return;

    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().then(() => {
        isFullscreen.value = true;
        isHubMinimized.value = true;
      }).catch(err => {
        console.warn('[Fullscreen Error]', err);
      });
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen().then(() => {
          isFullscreen.value = false;
        }).catch(err => {
          console.warn('[Exit Fullscreen Error]', err);
        });
      }
    }
  }

  function cycleTheme() {
    const idx = availableThemes.value.indexOf(currentTheme.value);
    const nextIdx = (idx + 1) % availableThemes.value.length;
    setTheme(availableThemes.value[nextIdx]);
  }

  function applyThemeDom(themeName) {
    if (typeof document === 'undefined') return;
    document.documentElement.setAttribute('data-theme', themeName);
    if (document.body) {
      document.body.setAttribute('data-theme', themeName);
    }
    try {
      localStorage.setItem('deck-theme', themeName);
    } catch (e) {}

    let link = document.getElementById('theme-link');
    if (link) {
      link.href = `/assets/themes/${themeName}.css`;
    }
  }

  function setTheme(themeName) {
    if (!availableThemes.value.includes(themeName)) return;
    currentTheme.value = themeName;
    applyThemeDom(themeName);

    if (broadcaster?.sendSetTheme) {
      broadcaster.sendSetTheme(themeName);
    }
  }

  function setThemeFromRemote(themeName) {
    if (!availableThemes.value.includes(themeName)) return;
    currentTheme.value = themeName;
    applyThemeDom(themeName);
  }

  /**
   * Opens the presenter console in a separate tab or window with dedicated router URL
   */
  function openPresenter() {
    isNotesOpen.value = false;
    isOverviewOpen.value = false;
    const url = `/presenter/${currentSlide.value}`;
    window.open(url, 'html-ppt-presenter-window', 'width=1380,height=880,menubar=no,toolbar=no,resizable=yes');
  }

  /**
   * Opens or focuses the audience slide show in a separate window
   */
  function openDisplay() {
    const url = `/${currentSlide.value}`;
    window.open(url, 'html-ppt-display-window');
  }

  function initTheme() {
    if (typeof document === 'undefined') return;
    let initialTheme = 'swiss-grid';
    try {
      initialTheme = localStorage.getItem('deck-theme') ||
                     document.documentElement.getAttribute('data-theme') ||
                     'swiss-grid';
    } catch (e) {
      initialTheme = document.documentElement.getAttribute('data-theme') || 'swiss-grid';
    }
    currentTheme.value = initialTheme;
    applyThemeDom(initialTheme);
  }

  function scanAndInit() {
    initTheme();
  }

  return {
    // State
    currentSlide,
    totalSlides,
    isNotesOpen,
    isOverviewOpen,
    isFullscreen,
    isHubMinimized,
    currentTheme,
    availableThemes,
    slideTitles,
    slideNotes,
    isPreview,

    // Getters
    currentIndex,
    formattedCurrent,
    formattedTotal,
    counterText,
    progressPercent,
    hasPrev,
    hasNext,
    currentTitle,
    nextTitle,
    currentNotesHtml,

    // Actions
    goToSlide,
    setSlideFromRemote,
    nextSlide,
    prevSlide,
    firstSlide,
    lastSlide,
    toggleNotes,
    toggleOverview,
    toggleFullscreen,
    toggleHubMinimized,
    cycleTheme,
    setTheme,
    setThemeFromRemote,
    openPresenter,
    openDisplay,
    registerBroadcaster,
    onSlideChange,
    initTheme,
    scanAndInit
  };
});
