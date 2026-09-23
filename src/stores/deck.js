import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { openPresenterWindow } from '../utils/presenter';

export const useDeckStore = defineStore('deck', () => {
  // --- State ---
  const currentSlide = ref(1);
  const totalSlides = ref(11);
  const isNotesOpen = ref(false);
  const isOverviewOpen = ref(false);
  const isFullscreen = ref(false);
  const currentTheme = ref('swiss-grid');
  const availableThemes = ref([
    'swiss-grid',
    'corporate-clean',
    'tokyo-night',
    'academic-paper',
    'engineering-whiteprint'
  ]);
  const slideTitles = ref([]);
  const slideNotes = ref([]);
  const isPreview = ref(typeof window !== 'undefined' && window.location.search.includes('preview'));

  // BroadcastChannel for cross-window presenter synchronization
  let bc = null;
  const channelName = typeof window !== 'undefined'
    ? 'html-ppt-presenter-' + window.location.pathname
    : 'html-ppt-presenter';

  if (typeof window !== 'undefined' && window.BroadcastChannel) {
    try {
      bc = new BroadcastChannel(channelName);
      bc.onmessage = (e) => {
        if (!e.data) return;
        if (e.data.type === 'go' && typeof e.data.idx === 'number') {
          goToSlide(e.data.idx + 1, true);
        } else if (e.data.type === 'theme' && e.data.name) {
          setTheme(e.data.name);
        }
      };
    } catch (err) {
      console.warn('[BroadcastChannel Error]', err);
    }
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
  const currentNotesHtml = computed(() => {
    return slideNotes.value[currentIndex.value] || '';
  });

  // --- Actions ---

  /**
   * Navigate directly to a 1-based slide index
   */
  function goToSlide(target, fromRemote = false) {
    const clamped = Math.max(1, Math.min(totalSlides.value, target));
    currentSlide.value = clamped;

    if (typeof document !== 'undefined') {
      const slides = document.querySelectorAll('.deck .slide');
      slides.forEach((s, i) => {
        const isActive = (i === clamped - 1);
        s.classList.toggle('is-active', isActive);
        s.classList.toggle('is-prev', i < clamped - 1);
        if (isPreview.value) {
          s.style.display = isActive ? '' : 'none';
        }
      });

      // Trigger CSS animations on newly active slide
      const activeEl = slides[clamped - 1];
      if (activeEl) {
        activeEl.querySelectorAll('[data-anim]').forEach((el) => {
          const a = el.getAttribute('data-anim');
          el.classList.remove('anim-' + a);
          void el.offsetWidth;
          el.classList.add('anim-' + a);
        });
      }

      // Sync URL hash
      const hashTarget = `#/${clamped}`;
      if (window.location.hash !== hashTarget && !isPreview.value) {
        history.replaceState(null, '', hashTarget);
      }
    }

    // Broadcast to presenter window
    if (!fromRemote && bc) {
      bc.postMessage({ type: 'go', idx: clamped - 1 });
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

  function syncSlideFromExternal(index1Based) {
    const clamped = Math.max(1, Math.min(totalSlides.value, index1Based));
    if (currentSlide.value !== clamped) {
      currentSlide.value = clamped;
    }
  }

  function toggleNotes(force) {
    isNotesOpen.value = force !== undefined ? force : !isNotesOpen.value;
  }

  function toggleOverview(force) {
    isOverviewOpen.value = force !== undefined ? force : !isOverviewOpen.value;
  }

  function toggleFullscreen() {
    if (typeof document === 'undefined') return;

    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().then(() => {
        isFullscreen.value = true;
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

  function setTheme(themeName) {
    currentTheme.value = themeName;
    if (typeof document !== 'undefined') {
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

    if (bc) {
      bc.postMessage({ type: 'theme', name: themeName });
    }
  }

  function openPresenter() {
    openPresenterWindow({
      slides: slideTitles.value.map((title, i) => ({
        title,
        notes: slideNotes.value[i] || ''
      })),
      currentSlide: currentSlide.value,
      totalSlides: totalSlides.value,
      currentTheme: currentTheme.value,
      channelName
    });
  }

  function scanAndInit() {
    if (typeof document === 'undefined') return;

    // Detect slides and notes
    const slides = document.querySelectorAll('.deck .slide');
    if (slides.length) {
      totalSlides.value = slides.length;
      slideTitles.value = Array.from(slides).map((s, i) => {
        return s.getAttribute('data-title') ||
          (s.querySelector('h1,h2,h3') || {}).textContent?.trim() ||
          `Lámina ${i + 1}`;
      });

      slideNotes.value = Array.from(slides).map((s) => {
        const n = s.querySelector('.notes, aside.notes, .speaker-notes');
        return n ? n.innerHTML : '';
      });

      // Preview mode parameter check: ?preview=N
      const previewMatch = /[?&]preview=(\d+)/.exec(window.location.search || '');
      if (previewMatch) {
        const previewIdx = parseInt(previewMatch[1], 10);
        goToSlide(previewIdx, true);
        return;
      }

      // Check hash
      const hashMatch = /^#\/(\d+)/.exec(window.location.hash || '');
      if (hashMatch) {
        const hashSlide = parseInt(hashMatch[1], 10);
        if (hashSlide >= 1 && hashSlide <= totalSlides.value) {
          goToSlide(hashSlide, true);
        } else {
          goToSlide(1, true);
        }
      } else {
        // Initial slide 1 activation
        goToSlide(1, true);
      }
    }

    // Check saved theme or initial data-theme
    let initialTheme = 'swiss-grid';
    try {
      initialTheme = localStorage.getItem('deck-theme') ||
                     document.documentElement.getAttribute('data-theme') ||
                     'swiss-grid';
    } catch (e) {
      initialTheme = document.documentElement.getAttribute('data-theme') || 'swiss-grid';
    }
    setTheme(initialTheme);

    // Check fullscreen
    isFullscreen.value = !!document.fullscreenElement;
    document.addEventListener('fullscreenchange', () => {
      isFullscreen.value = !!document.fullscreenElement;
    });

    // Handle hash change from browser buttons
    window.addEventListener('hashchange', () => {
      const m = /^#\/(\d+)/.exec(window.location.hash || '');
      if (m) {
        const s = parseInt(m[1], 10);
        if (s !== currentSlide.value) {
          goToSlide(s, true);
        }
      }
    });

    // Expose for debugging and external interop
    window.__deckStore = {
      syncSlideFromExternal,
      isNotesOpen,
      isOverviewOpen,
      currentTheme,
      goToSlide
    };
  }

  return {
    // State
    currentSlide,
    totalSlides,
    isNotesOpen,
    isOverviewOpen,
    isFullscreen,
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
    currentNotesHtml,

    // Actions
    goToSlide,
    nextSlide,
    prevSlide,
    firstSlide,
    lastSlide,
    syncSlideFromExternal,
    toggleNotes,
    toggleOverview,
    toggleFullscreen,
    cycleTheme,
    setTheme,
    openPresenter,
    scanAndInit
  };
});
