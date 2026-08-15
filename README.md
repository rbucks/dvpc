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
- `JUDGING + WINNERS` — past judges, scoring criteria
- `PAST WINNERS` — 2025 results
- `FAQ` — accordion
- `APPLY` — bottom CTA
- `FOOTER`

### Common edits

- **Update the dates / year** — search `Nov 20` (live final, Friday), `Nov 2` (application deadline, noon PT), `Nov 6` (finalists named), `2026`. Note the two-week mentoring claim is load-bearing: finalists must be named on Nov 6 for `Nov 6 → 20` to be a true fourteen days.
- **Application contents** — the application is a written form plus a deck, deliberately no video. A video appears only at the finalist stage (optional 1-minute YouTube). Search `video` before changing either.
- **Eligibility copy** — the rule is "enrolled in any 4CD course, credit or non-credit Community Education." It appears in the hero lede, About, both track cards, and the first three FAQ entries.
- **Add or remove colleges** — find the `<ul class="city-list">` block in the About section (still uses the `city-list` class; the items are now 4CD campuses).
- **Edit the Main Street / science example lists** — find the `.kinds-cols` block in the `THE ROOM` section.
- **Edit the city line** — the `.vs-places` div inside `.valley-statement`.
- **Positioning** — the "Diablo Valley, not Silicon Valley" argument lives in one place, `.valley-statement`. The About section deliberately defers to it rather than repeating it.
- **Change the application link** — search for `Start application` and replace the `href="#"` with the real URL (e.g. a Google Form or Typeform).
- **Update prize amounts** — find the `prizes-grid` block. Each `.prize` card has an `.amount` div.
- **Swap accent color** — change the `--accent` and `--accent-ink` CSS custom properties at the top of the `<style>` block.
- **Edit the FAQ** — each Q is a `<details>` element; the `<summary>` is the question, the `<p>` is the answer.

### Type stack

- Display: Newsreader (Google Fonts)
- Body: IBM Plex Sans (Google Fonts)
- Mono / labels: JetBrains Mono (Google Fonts)

All three are free for commercial use.

## License / credit

Site copy and event details are based on the 2025 4CD Business Pitch Competition recap (East Bay Times, January 2026) and the existing DVC Business Pitch Competition Notion page.
