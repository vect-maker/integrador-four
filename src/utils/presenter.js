/**
 * Presenter Mode Popup Window Utility
 * Creates a synchronized magnetic-card presenter view with current slide preview,
 * next slide preview, speaker notes, and presentation timer.
 */

let presenterWin = null;

export function openPresenterWindow({
  slides = [],
  currentSlide = 1,
  totalSlides = 16,
  currentTheme = 'swiss-grid',
  channelName = 'html-ppt-presenter'
} = {}) {
  if (presenterWin && !presenterWin.closed) {
    presenterWin.focus();
    return presenterWin;
  }

  const deckUrl = window.location.protocol + '//' + window.location.host + window.location.pathname;

  const slideMeta = slides.map((s, i) => {
    return {
      title: s.title || `Slide ${i + 1}`,
      notes: s.notes || ''
    };
  });

  const presenterHTML = buildPresenterHTML(deckUrl, slideMeta, totalSlides, currentSlide - 1, channelName, currentTheme);

  presenterWin = window.open('', 'html-ppt-presenter', 'width=1280,height=820,menubar=no,toolbar=no');
  if (!presenterWin) {
    alert('Por favor permita ventanas emergentes (popups) en el navegador para abrir la vista del expositor.');
    return null;
  }

  presenterWin.document.open();
  presenterWin.document.write(presenterHTML);
  presenterWin.document.close();
  return presenterWin;
}

function buildPresenterHTML(deckUrl, slideMeta, total, startIdx, channelName, currentTheme) {
  const embed = (v) => JSON.stringify(v).replace(/</g, '\\u003c');
  const metaJSON = embed(slideMeta);
  const deckUrlJSON = embed(deckUrl);
  const channelJSON = embed(channelName);
  const themeJSON = embed(currentTheme || '');
  const storageKey = 'html-ppt-presenter:' + window.location.pathname;

  return `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Vista de Expositor • Movi Go</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    width: 100%; height: 100%; overflow: hidden;
    background: #111418;
    color: #e6edf3;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Nunito", sans-serif;
  }
  #stage { position: absolute; inset: 0; overflow: hidden; }
  .pcard {
    position: absolute;
    background: #1a1e24;
    border: 1px solid rgba(255,255,255,.12);
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0,0,0,.5);
    display: flex; flex-direction: column;
    overflow: hidden;
    min-width: 180px; min-height: 100px;
  }
  #card-cur   { left: 16px; top: 16px; width: calc(55% - 24px); height: calc((100% - 36px) * 0.62 - 16px); }
  #card-nxt   { left: calc(55% + 8px); top: 16px; width: calc(45% - 24px); height: calc((100% - 36px) * 0.42 - 16px); }
  #card-notes { left: calc(55% + 8px); top: calc((100% - 36px) * 0.42 + 8px); width: calc(45% - 24px); height: calc((100% - 36px) * 0.58 - 16px); }
  #card-timer { left: 16px; top: calc((100% - 36px) * 0.62 + 8px); width: calc(55% - 24px); height: calc((100% - 36px) * 0.38 - 16px); }
  
  .pcard-header {
    height: 36px; padding: 0 14px; background: rgba(255,255,255,.05);
    border-bottom: 1px solid rgba(255,255,255,.08);
    display: flex; align-items: center; justify-content: space-between;
    font-size: 11px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: #94a3b8;
  }
  .pcard-body { flex: 1; position: relative; overflow: hidden; }
  .preview-wrap { width: 100%; height: 100%; overflow: hidden; position: relative; background: #000; }
  .preview-wrap iframe {
    width: 1920px; height: 1080px; border: none; position: absolute;
    top: 0; left: 0; transform-origin: top left; pointer-events: none;
  }
  #notes-body {
    padding: 18px 20px; overflow-y: auto; height: 100%; font-size: 15px; line-height: 1.65; color: #f1f5f9;
  }
  #notes-body code { background: rgba(255,255,255,.1); padding: 2px 6px; border-radius: 4px; font-family: monospace; }
  .timer-content {
    display: flex; align-items: center; justify-content: space-around; height: 100%; padding: 12px;
  }
  .timer-digits { font-size: 48px; font-weight: 800; font-family: monospace; color: #ffffff; }
  .timer-controls { display: flex; gap: 8px; }
  .pbtn {
    background: rgba(255,255,255,.1); border: 1px solid rgba(255,255,255,.2); color: #fff;
    padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer;
  }
  .pbtn:hover { background: #d6001c; border-color: #d6001c; }
</style>
</head>
<body>
<div id="stage">
  <div class="pcard" id="card-cur">
    <div class="pcard-header"><span>Lámina Actual</span><span id="cur-meta">1/${total}</span></div>
    <div class="pcard-body"><div class="preview-wrap"><iframe id="iframe-cur"></iframe></div></div>
  </div>
  <div class="pcard" id="card-nxt">
    <div class="pcard-header"><span>Siguiente Lámina</span><span id="nxt-meta">2/${total}</span></div>
    <div class="pcard-body"><div class="preview-wrap"><iframe id="iframe-nxt"></iframe></div></div>
  </div>
  <div class="pcard" id="card-notes">
    <div class="pcard-header"><span>Notas del Orador</span></div>
    <div class="pcard-body"><div id="notes-body"></div></div>
  </div>
  <div class="pcard" id="card-timer">
    <div class="pcard-header"><span>Cronómetro & Navegación</span><span id="timer-count">1 / ${total}</span></div>
    <div class="pcard-body">
      <div class="timer-content">
        <div class="timer-digits" id="timer-display">00:00</div>
        <div class="timer-controls">
          <button class="pbtn" id="btn-prev">‹ Anterior</button>
          <button class="pbtn" id="btn-next">Siguiente ›</button>
          <button class="pbtn" id="btn-reset">Reiniciar</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var slideMeta = ${metaJSON};
  var deckUrl = ${deckUrlJSON};
  var total = ${total};
  var idx = ${startIdx};
  var channelName = ${channelJSON};
  var currentTheme = ${themeJSON};

  var bc = null;
  try { bc = new BroadcastChannel(channelName); } catch(e){}

  var iframeCur = document.getElementById('iframe-cur');
  var iframeNxt = document.getElementById('iframe-nxt');
  var notesBody = document.getElementById('notes-body');
  var timerDisplay = document.getElementById('timer-display');
  var timerCount = document.getElementById('timer-count');
  var curMeta = document.getElementById('cur-meta');
  var nxtMeta = document.getElementById('nxt-meta');

  function rescale() {
    [iframeCur, iframeNxt].forEach(function(f){
      if(!f) return;
      var w = f.parentElement.clientWidth;
      var h = f.parentElement.clientHeight;
      var s = Math.min(w/1920, h/1080);
      f.style.transform = 'scale(' + s + ')';
    });
  }
  window.addEventListener('resize', rescale);

  function update(n) {
    n = Math.max(0, Math.min(total - 1, n));
    idx = n;
    curMeta.textContent = (n + 1) + '/' + total;
    nxtMeta.textContent = (n + 2 <= total ? n + 2 : '-') + '/' + total;
    timerCount.textContent = (n + 1) + ' / ' + total;
    var meta = slideMeta[n] || {};
    notesBody.innerHTML = meta.notes || '<span style="color:#94a3b8">(Esta lámina no tiene notas del expositor)</span>';

    try {
      iframeCur.contentWindow.postMessage({ type: 'preview-goto', idx: n }, '*');
      if (n + 1 < total) {
        iframeNxt.contentWindow.postMessage({ type: 'preview-goto', idx: n + 1 }, '*');
      }
    } catch(e){}
    rescale();
  }

  function go(n) {
    update(n);
    if (bc) bc.postMessage({ type: 'go', idx: idx });
  }

  document.getElementById('btn-prev').addEventListener('click', function(){ go(idx - 1); });
  document.getElementById('btn-next').addEventListener('click', function(){ go(idx + 1); });

  var t0 = Date.now();
  setInterval(function(){
    var s = Math.floor((Date.now() - t0)/1000);
    var mm = String(Math.floor(s/60)).padStart(2,'0');
    var ss = String(s%60).padStart(2,'0');
    timerDisplay.textContent = mm + ':' + ss;
  }, 1000);
  document.getElementById('btn-reset').addEventListener('click', function(){
    t0 = Date.now();
    timerDisplay.textContent = '00:00';
  });

  if (bc) {
    bc.onmessage = function(e){
      if (!e.data) return;
      if (e.data.type === 'go') update(e.data.idx);
    };
  }

  document.addEventListener('keydown', function(e){
    if (e.key === 'ArrowRight' || e.key === ' ') { go(idx + 1); e.preventDefault(); }
    if (e.key === 'ArrowLeft') { go(idx - 1); e.preventDefault(); }
    if (e.key === 'Escape') window.close();
  });

  iframeCur.src = deckUrl + '?preview=' + (idx + 1);
  if (idx + 1 < total) iframeNxt.src = deckUrl + '?preview=' + (idx + 2);
  iframeCur.onload = rescale;
  iframeNxt.onload = rescale;
  update(idx);
})();
</script>
</body>
</html>`;
}
