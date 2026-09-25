/**
 * Presenter Mode Window Launcher Utility
 * Centralized delegation to deck store
 */
import { useDeckStore } from '../stores/deck';

export function openPresenterWindow() {
  const deckStore = useDeckStore();
  return deckStore.openPresenter();
}
