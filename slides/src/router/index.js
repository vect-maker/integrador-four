import { createRouter, createWebHistory } from 'vue-router';
import PresentationView from '../views/PresentationView.vue';
import PresenterView from '../components/PresenterView.vue';

const routes = [
  {
    path: '/',
    redirect: '/1'
  },
  {
    path: '/:slide(\\d+)?',
    name: 'presentation',
    component: PresentationView
  },
  {
    path: '/presenter',
    redirect: '/presenter/1'
  },
  {
    path: '/presenter/:slide(\\d+)?',
    name: 'presenter',
    component: PresenterView
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/1'
  }
];

export const router = createRouter({
  history: createWebHistory(),
  routes
});

// Backward-compatible query redirect: /?presenter=true -> /presenter/1
router.beforeEach((to, from, next) => {
  if (to.query.presenter !== undefined || to.query.mode === 'presenter') {
    const slide = to.params.slide || 1;
    return next({ path: `/presenter/${slide}`, replace: true });
  }
  next();
});
