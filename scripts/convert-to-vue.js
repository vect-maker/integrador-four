import fs from 'fs';
import path from 'path';

const html = fs.readFileSync('index.html', 'utf-8');

const slideNames = [
  'Slide01Cover',
  'Slide02Context',
  'Slide03Literature',
  'Slide04Problem',
  'Slide05Objectives',
  'Slide06Variables',
  'Slide07Theory',
  'Slide08Methodology',
  'Slide09Pipeline',
  'Slide10Kimball',
  'Slide11SpatialAnalysis',
  'Slide12OptimizationMILP',
  'Slide13Simulation',
  'Slide14CurriculumIntegration',
  'Slide15Conclusion',
  'Slide16Questions',
];

const slideRegex = /<section class="slide([^"]*)" data-slide="(\d+)" data-title="([^"]*)">([\s\S]*?)<\/section>/g;
let match;
let i = 0;

fs.mkdirSync('src/slides', { recursive: true });
fs.mkdirSync('src/components', { recursive: true });

while ((match = slideRegex.exec(html)) !== null) {
  const extraClasses = match[1].trim();
  const num = parseInt(match[2], 10);
  const title = match[3];
  const inner = match[4].trim();
  const componentName = slideNames[num - 1] || `Slide${String(num).padStart(2, '0')}`;

  const vueContent = `<template>
  <section class="slide ${extraClasses}" data-slide="${num}" data-title="${title}">
${inner}
  </section>
</template>

<script setup>
// Slide ${num}: ${title}
</script>
`;

  const filePath = path.join('src/slides', `${componentName}.vue`);
  fs.writeFileSync(filePath, vueContent, 'utf-8');
  console.log(`Generated: ${filePath}`);
  i++;
}

console.log(`Successfully generated ${i} Vue slide components in src/slides/!`);
