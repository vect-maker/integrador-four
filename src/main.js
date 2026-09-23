import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import 'katex/dist/katex.min.css';
import './styles/fonts.css';
import './styles/base.css';
import './styles/animations.css';
import './style.css';
import './styles/themes.css';

const app = createApp(App);
const pinia = createPinia();
app.use(pinia);
app.mount('#app');

