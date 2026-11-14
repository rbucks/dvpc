// Press mode for the print pieces. Open any of them with ?bleed in the URL
// (e.g. program.html?bleed) to get a print-shop version: each 11 x 8.5in page
// gains 0.125in of bleed on every side and sits on an 11.75 x 9.25in page with
// crop marks at the trim corners. Without ?bleed this script does nothing.
//
// Each piece extends its own backgrounds into the bleed with `html.bleed` rules
// in its stylesheet. Set <html data-fold="v"> or "h" to add fold marks at the
// vertical or horizontal centre line.
(function () {
  if (!new URLSearchParams(location.search).has("bleed")) return;
  const root = document.documentElement;
  root.classList.add("bleed");

  const css = document.createElement("style");
  css.textContent = `
    @page { size: 11.75in 9.25in; margin: 0; }
    .press { position: relative; width: 11.75in; height: 9.25in; overflow: hidden; background: #fff;
             page-break-after: always; break-after: page; }
    .press:last-child { page-break-after: auto; break-after: auto; }
    .press > .sheet { position: absolute; left: 0.25in; top: 0.25in; width: 11.25in; height: 8.75in;
                      page-break-after: auto; break-after: auto; }
    .press i { position: absolute; background: #000; }
    .press i.v { width: 0.5pt; height: 0.19in; }
    .press i.h { height: 0.5pt; width: 0.19in; }
    .press i.fold { background: none; border: 0 dashed #000; }
    .press i.fold.v { border-left-width: 0.5pt; }
    .press i.fold.h { border-top-width: 0.5pt; }
  `;
  document.head.appendChild(css);

  const W = 11.75, H = 9.25, T = 0.375; // page size and trim inset, inches
  function mark(page, cls, x, y) {
    const m = document.createElement("i");
    m.className = cls;
    m.style.left = x + "in";
    m.style.top = y + "in";
    page.appendChild(m);
  }

  for (const sheet of [...document.querySelectorAll(".sheet")]) {
    const page = document.createElement("div");
    page.className = "press";
    sheet.replaceWith(page);
    page.appendChild(sheet);
    for (const x of [T, W - T]) { mark(page, "v", x, 0); mark(page, "v", x, H - 0.19); }
    for (const y of [T, H - T]) { mark(page, "h", 0, y); mark(page, "h", W - 0.19, y); }
    if (root.dataset.fold === "v") { mark(page, "v fold", W / 2, 0); mark(page, "v fold", W / 2, H - 0.19); }
    if (root.dataset.fold === "h") { mark(page, "h fold", 0, H / 2); mark(page, "h fold", W - 0.19, H / 2); }
  }
})();
