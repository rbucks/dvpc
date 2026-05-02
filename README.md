# Diablo Valley Pitch Competition — Website

Single-page static site for the regional Diablo Valley Pitch Competition.

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

To use a custom domain (e.g. `pitch.diablovalley.org`), add a `CNAME` file with the bare domain on a single line and configure a CNAME record at your DNS provider pointing to `<your-username>.github.io`.

## Editing the site

Everything lives in `index.html`. There is no build step, no framework, no dependencies beyond Google Fonts (loaded from a CDN at runtime).

Major sections, in order, marked with HTML comments:

- `TOP BAR` — sticky nav
- `HERO` — headline, lede, save-the-date card
- `KEY DATES RAIL` — the three milestone dates
- `ABOUT` — regional expansion explanation + city list
- `TRACKS` — Open + Student
- `TIMELINE` — Sept 15 → Nov 19
- `PRIZES` — four cash prizes
- `JUDGING + WINNERS` — past judges, scoring criteria
- `PAST WINNERS` — 2025 results
- `FAQ` — accordion
- `APPLY` — bottom CTA
- `FOOTER`

### Common edits

- **Update the dates / year** — search `Nov 19`, `Oct 26`, `Nov 2`, `2026`.
- **Add or remove cities** — find the `<ul class="city-list">` block in the About section.
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
