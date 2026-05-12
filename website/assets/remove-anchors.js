window.addEventListener('DOMContentLoaded', () => {
  const anchors = document.querySelectorAll("a[href^='#fig'], a[href^='#tbl']");
  anchors.forEach(a => {
    const span = document.createElement('span');
    span.textContent = a.textContent;
    a.replaceWith(span);
  });
});