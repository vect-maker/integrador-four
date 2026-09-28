<template>
  <span
    v-if="!isBlock"
    class="katex-inline"
    v-html="renderedHtml"
  ></span>
  <div
    v-else
    class="katex-block"
    v-html="renderedHtml"
  ></div>
</template>

<script setup>
import { computed, useSlots } from 'vue';
import katex from 'katex';

const props = defineProps({
  expr: {
    type: String,
    default: ''
  },
  latex: {
    type: String,
    default: ''
  },
  block: {
    type: Boolean,
    default: false
  },
  displayMode: {
    type: Boolean,
    default: false
  },
  errorColor: {
    type: String,
    default: '#d6001c'
  }
});

const slots = useSlots();

const formula = computed(() => {
  if (props.expr) return props.expr;
  if (props.latex) return props.latex;
  if (slots.default) {
    const nodes = slots.default();
    return nodes
      .map(node => (typeof node.children === 'string' ? node.children : ''))
      .join('')
      .trim();
  }
  return '';
});

const isBlock = computed(() => props.block || props.displayMode);

const renderedHtml = computed(() => {
  const code = formula.value;
  if (!code) return '';
  try {
    return katex.renderToString(code, {
      displayMode: isBlock.value,
      throwOnError: false,
      output: 'html',
      errorColor: props.errorColor
    });
  } catch (err) {
    console.warn('[KaTeX Render Warning]', err);
    return `<span style="color:${props.errorColor}">${code}</span>`;
  }
});
</script>

<style>
.katex-block {
  display: block;
  text-align: center;
  margin: 8px 0;
  overflow-x: auto;
  overflow-y: hidden;
}

.katex-inline {
  display: inline-block;
  vertical-align: baseline;
}

.math-block .katex-block {
  margin: 0;
}

.math-block .katex {
  color: #f8fafc;
}
</style>
