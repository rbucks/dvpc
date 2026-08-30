# The 4CD Pitch Competition — Website

Single-page static site for The 4CD Pitch Competition — the pitch competition of the Contra Costa Community College District. Production domain: **www.4cdpitch.com**.

## Hosting on GitHub Pages

1. Create a new repository on GitHub (e.g. `diablo-valley-pitch`).
2. Push this folder to it:
   ```bash
   git init
   git add .
   git commit -m "Initial site"
   git branch -M main
   git remote add origin git@github.com:<your-username>/diablo-valley-pitch.git
   git push -u origin main
   ```
3. In the repo on github.com → **Settings → Pages**:
   - **Source:** Deploy from a branch
   - **Branch:** `main` / `/ (root)`
4. Wait ~1 minute. Your site will be live at `https://<your-username>.github.io/diablo-valley-pitch/`.

To use the custom domain, add a `CNAME` file containing `www.4cdpitch.com` on a single line, then point a CNAME record for `www` at `<your-username>.github.io` in your DNS provider. (No `CNAME` file is committed right now — add it when DNS is ready.)

## Editing the site

Everything lives in `index.html`. There is no build step, no framework, no dependencies beyond Google Fonts (loaded from a CDN at runtime).

Major sections, in order, marked with HTML comments:

- `DISTRICT BAR` — spells out 4CD and lists the three member colleges
- `TOP BAR` — sticky nav
- `HERO` — headline, lede, save-the-date card
- `KEY DATES RAIL` — the three milestone dates
- `ABOUT` — regional expansion explanation + city list
- `THE ROOM` — the "Diablo Valley, not Silicon Valley" statement band (`.valley-statement`) + the Main Street / science-and-product columns (`.kinds`)
- `TIMELINE` — Sept 15 → Nov 20
- `PRIZES` — four cash prizes
- `JUDGING + CRITERIA` — past judges, how scoring works
- `SCORING RUBRIC` — the two published rubrics (screening elevator pitch, final presentations), 50 points each
- `PAST WINNERS` — 2025 results
- `GALLERY` — photos from the 2024 final, with a `<dialog>` lightbox
- `FAQ` — accordion
- `APPLY` — bottom CTA
- `FOOTER`

### Common edits

- **Update the dates / year** — search `Nov 20` (live final, Friday), `Nov 2` (application deadline, 11:59pm PT), `Nov 6` (finalists named), `2026`. Note the two-week mentoring claim is load-bearing: finalists must be named on Nov 6 for `Nov 6 → 20` to be a true fourteen days.
- **Application contents** — per the application itself, an entry is exactly two things: a short description of the business idea and a slide presentation of no more than 15 slides. No video at this stage; a video appears only at the finalist stage (optional 1-minute YouTube). Search `15 slides` and `video` before changing either.
- **Entry rules** — the rules from the live application form (enrollment, the 11:59pm PT Nov 2 deadline, the two deliverables, max 5 per team, the $25,000 assets/revenue ceiling for existing businesses, repeat entrants needing a new concept, multiple entries but one pitch) are stated in the `.rules-strip` block in the `SCORING RUBRIC` section and answered individually in the FAQ. Change both together — the application form is the source of truth.
- **Eligibility copy** — the rule is "enrolled in any 4CD course, credit or non-credit Community Education." It appears in the hero lede, About, both track cards, and the first three FAQ entries.
- **Add or remove colleges** — find the `<ul class="city-list">` block in the About section (still uses the `city-list` class; the items are now 4CD campuses).
- **Edit the Main Street / science example lists** — find the `.kinds-cols` block in the `THE ROOM` section.
- **Edit the city line** — the `.vs-places` div inside `.valley-statement`.
- **Positioning** — the "Diablo Valley, not Silicon Valley" argument lives in one place, `.valley-statement`. The About section deliberately defers to it rather than repeating it.
- **Change the application link** — search for `Start application` and replace the `href="#"` with the real URL (e.g. a Google Form or Typeform).
- **Update prize amounts** — find the `prizes-grid` block. Each `.prize` card has an `.amount` div.
- **Edit the scoring rubrics** — find the `SCORING RUBRIC` section. Each stage is a `.rubric` block (`.rubric.final` is the green live-final variant) wrapping one `<table>`: category `<th>`, `td.desc`, and `td.pts`. If you change point values, update the `tfoot` total and the `.rubric-head .max` badge to match.
- **Swap accent color** — change the `--accent` and `--accent-ink` CSS custom properties at the top of the `<style>` block.
- **Edit the FAQ** — each Q is a `<details>` element; the `<summary>` is the question, the `<p>` is the answer.
- **Add gallery photos** — put the full-resolution originals in `assets/images/event/_originals/` (gitignored, never published), then generate the three web derivatives per photo with ImageMagick:

  ```
  magick IN.JPG -auto-orient -strip -resize 1600x -unsharp 0x0.6+0.6+0.01 -quality 78 -define webp:method=6 event-YYYY-NN.webp
  magick IN.JPG -auto-orient -strip -resize 800x  -unsharp 0x0.6+0.6+0.01 -quality 76 -define webp:method=6 event-YYYY-NN-800.webp
  magick IN.JPG -auto-orient -strip -resize 1200x -unsharp 0x0.6+0.6+0.01 -quality 80 -sampling-factor 4:2:0 -interlace JPEG event-YYYY-NN.jpg
  ```

  `-strip` drops EXIF (camera and any GPS data) — keep it. Then copy a `<figure class="shot">` block in the `GALLERY` section: the 800px WebP is the grid image, the 1600px WebP is what the lightbox opens (the `href`), and the JPEG is the fallback. Keep `width`/`height` on the `<img>` matching the 3:2 crop so the page does not shift while loading, and keep the `data-caption` and `<figcaption>` text identical.
- **The lightbox** — one `<dialog id="lightbox">` near the end of `<body>` plus ~35 lines of vanilla JS. It is the only script on the site. With JS off, each photo is still a plain link to the full-size WebP.

### Type stack

- Display: Newsreader (Google Fonts)
- Body: IBM Plex Sans (Google Fonts)
- Mono / labels: JetBrains Mono (Google Fonts)

All three are free for commercial use.

## License / credit

Site copy and event details are based on the 2025 4CD Business Pitch Competition recap (East Bay Times, January 2026) and the existing DVC Business Pitch Competition Notion page.
