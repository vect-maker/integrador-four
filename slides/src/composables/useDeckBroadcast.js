import { ref, watch, onMounted } from 'vue';
import { useBroadcastChannel } from '@vueuse/core';
import { useDeckStore } from '../stores/deck';

// Unique client identifier per browser tab instance
const clientId = 'tab_' + Math.random().toString(36).slice(2, 9) + '_' + Date.now();

// Static, unified channel name shared by both audience and presenter tabs
const CHANNEL_NAME = 'html-ppt-movigo-sync-channel';

/**
 * Robust Cross-Tab Presentation Synchronization Composable
 * Separates commands from state and eliminates self-listening / echo loops.
 */
export function useDeckBroadcast({ role = 'display' } = {}) {
  const deckStore = useDeckStore();
  const isConnected = ref(false);

  const {
    isSupported,
    data,
    post,
    error
  } = useBroadcastChannel({ name: CHANNEL_NAME });

  if (isSupported.value) {
    isConnected.value = true;
  }

  // Handle incoming messages
  watch(data, (msg) => {
    // 1. Strictly ignore empty messages or messages broadcasted by this same tab
    if (!msg || typeof msg !== 'object' || msg.senderId === clientId) {
      return;
    }

    console.debug(`[DeckBroadcast][${role}] Received ${msg.type} from ${msg.senderRole}:`, msg.payload);

    switch (msg.type) {
      case 'CMD_GO_TO_SLIDE':
        if (typeof msg.payload?.slide === 'number') {
          // Apply slide from remote peer without triggering an outbound command loop
          deckStore.setSlideFromRemote(msg.payload.slide);
        }
        break;

      case 'CMD_SET_THEME':
        if (typeof msg.payload?.theme === 'string') {
          deckStore.setThemeFromRemote(msg.payload.theme);
        }
        break;

      case 'SYNC_REQUEST':
        // A peer instance requested state initialization
        if (isSupported.value) {
          post({
            type: 'SYNC_STATE',
            senderId: clientId,
            senderRole: role,
            payload: {
              slide: deckStore.currentSlide,
              theme: deckStore.currentTheme
            },
            timestamp: Date.now()
          });
        }
        break;

      case 'SYNC_STATE':
        // Receive initial state synchronization from an already active tab
        if (typeof msg.payload?.slide === 'number') {
          deckStore.setSlideFromRemote(msg.payload.slide);
        }
        if (typeof msg.payload?.theme === 'string') {
          deckStore.setThemeFromRemote(msg.payload.theme);
        }
        break;
    }
  });

  // Outbound Command: Go to slide
  function sendGoToSlide(slideNumber) {
    if (!isSupported.value) return;
    console.debug(`[DeckBroadcast][${role}] Sending CMD_GO_TO_SLIDE:`, slideNumber);
    post({
      type: 'CMD_GO_TO_SLIDE',
      senderId: clientId,
      senderRole: role,
      payload: { slide: slideNumber },
      timestamp: Date.now()
    });
  }

  // Outbound Command: Set theme
  function sendSetTheme(themeName) {
    if (!isSupported.value) return;
    console.debug(`[DeckBroadcast][${role}] Sending CMD_SET_THEME:`, themeName);
    post({
      type: 'CMD_SET_THEME',
      senderId: clientId,
      senderRole: role,
      payload: { theme: themeName },
      timestamp: Date.now()
    });
  }

  // Request sync on boot
  function requestSync() {
    if (!isSupported.value) return;
    post({
      type: 'SYNC_REQUEST',
      senderId: clientId,
      senderRole: role,
      timestamp: Date.now()
    });
  }

  onMounted(() => {
    requestSync();
  });

  return {
    clientId,
    isSupported,
    isConnected,
    error,
    sendGoToSlide,
    sendSetTheme,
    requestSync
  };
}
