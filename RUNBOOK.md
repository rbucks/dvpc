# Annual runbook — resetting the site for a new competition year

Everything the site needs for a new cycle lives in five places: `index.html`,
`assets/images/event/`, `flyers/`, `slides/`, and `print/` (the event-day
program, certificates, and judges' name tents — Phase 6c). There is no build step, no framework, and
no CMS. Edit, preview locally, commit, push — GitHub Pages serves `main` at
[4cdpitch.com](https://www.4cdpitch.com).

Work through the phases in order. Each one is independent enough to ship on its
own, so you can push the date changes in the spring and come back for the
gallery in December.

---

## Before you start

```bash
git pull
python3 -m http.server 8777
```

Then open <http://localhost:8777>. Leave the server running while you edit;
refresh to see changes. Kill it with `pkill -f "http.server 8777"` when done.

**The one rule:** the live application form is the source of truth for every
rule, date, and deadline on this site. If the form and the site disagree, the
form wins and the site gets corrected — not the other way round.

The 2026 form is <https://forms.cloud.microsoft/r/RB7gvjDQPZ>.

---

## Phase 1 — Roll the dates

Five dates drive the whole page. Work out the new ones first, then search and
replace. Write them down here before you touch anything:

| What | 2026 | New year |
|---|---|---|
| Applications open | Sept 15 | |
| Application deadline | Mon, Nov 2, 11:59pm PT | |
| Finalists announced | Fri, Nov 6 | |
| Live final | Fri, Nov 20 — doors 8:30am, welcome 9:00am, pitches 9:15am | |
| Year label | 2026 | |

### Constraints to respect

- **The final is a Friday.** Check the day of week before you commit to a date.
- **Finalists must be named exactly two weeks before the final.** The site
  promises "a full two weeks of intensive support" in three separate places and
  the timeline literally reads `Nov 6 → 20`. If you shorten the gap, that copy
  becomes a lie — fix it or move the announcement date.
- **The deadline is a Monday at 11:59pm PT**, and the timeline says the
  screening panel "begins review the next morning." Keep those consistent.

### Where the dates appear

Search for each old string and replace every hit. Rough counts from the 2026
cycle, so you know when you've found them all:

| Search for | Hits | Notes |
|---|---|---|
| `Nov 20` | ~15 | Also `<title>`, the hero save-the-date card, section headings |
| `Nov 2` | ~10 | Careful: `Nov 20` contains `Nov 2` — search `Nov 2<`, `Nov 2,`, `Nov 2.`, `Nov 2 ` |
| `11:59pm` | 11 | Key-dates rail, timeline, scoring lede, entry rules, rubric band, FAQ (×3), apply CTA |
| `Nov 6` | ~8 | |
| `Sept 15` | ~3 | |
| `2026` | ~20 | Includes the `2026` year chips on the flyers |

Then check these by eye, because they are worded rather than templated:

- `<title>` and the `<meta name="description">` in the `<head>`
- The `KEY DATES RAIL` — three `.date-cell` blocks
- The `TIMELINE` section — five `.tl-row` blocks
- The final’s date in the Timeline section (`#timeline`)
- The `.rules-strip` entry-rules panel in Scoring (`#scoring`)
- The `.deadline` line in the `APPLY` CTA
- The FAQ entry "How do I apply?", which repeats the deadline

**Verify:** `grep -c "Nov 20" index.html` should return zero hits for the old
date after you're done. Run `grep -in "nov \|sept \|11:59" index.html` and read
every line.

---

## Phase 2 — Confirm the rules against the application form

Open the live application form and read it top to bottom. For the 2026 cycle
the rules were:

- Enrolled at Contra Costa College, Diablo Valley College, or Los Medanos
  College — any course, credit or non-credit Community Education
- Existing businesses eligible under $25,000 in total assets or annual revenue
- No more than five people on a team; solo founders permitted
- Repeat entrants must submit a different concept
- Multiple applications allowed, but a finalist pitches only once
- Submission is a short description of the business idea plus a slide
  presentation of no more than 15 slides
- Top 10 finalists advance

Anything that changed needs updating in **both** places, which must always
agree:

1. The `.rules-strip` panel at the top of Scoring (`#scoring`) — the one-glance
   summary
2. The FAQ entries — "Does my idea need to be a real business already?", "Can I
   apply with a co-founder or team?", "What does the application include?",
   "Can I submit more than one application?", "I entered a previous year…"

If the number of finalists changes from ten, note that "ten" is spelled out in
the scoring section, the rubric bands, the timeline, and the key-dates rail.

---

## Phase 2b — Point every CTA at the new form

A new cycle means a new form and a new URL. The old one is
<https://forms.cloud.microsoft/r/RB7gvjDQPZ>; find every hit with:

```bash
grep -rn RB7gvjDQPZ index.html slides/
```

Nine in `index.html`, four in `slides/index.html`. Replace them all in one pass
— a half-updated site sends some people to last year's closed form, and the
form itself will not tell them it is the wrong year.

Where they are in `index.html`:

1. The nav button in the `TOP BAR`
2. The hero button
3. The `Application` cell in the `KEY DATES RAIL` (`p.cell-link`)
4. The `Sept 15` row in the `TIMELINE`
5. The `Where to apply` bullet in `.rules-strip`
6. FAQ — "How do I apply?"
7. FAQ — "What does the application include?"
8. The `APPLY` CTA button
9. The footer's `Event` list

And in `slides/index.html`: the closing `foot-note` on slide 2, the `Sept 15`
row on slide 4, the `.applyline` block on slide 11, and the `Apply →` link in
the bottom bar. The slides print the URL as visible text as well as linking it,
so the text has to change too.

**Before the form opens.** If you are shipping the site ahead of the form going
live, the pre-launch state is three edits: nav button reads `Applications
soon`, hero button reads `Applications coming soon`, and the `APPLY` CTA
becomes a non-clickable `<span class="cta-btn lg is-soon">` with a `.note-line`
paragraph pointing people at the Discord. The `.is-soon` rule was deleted from
the stylesheet when the 2026 form went live — restore it alongside
`.apply .note-line` if you need it. Also set the `.deadline` line in the `APPLY`
CTA back to `Not open yet · …`.

---

## Phase 3 — Update the prizes

The `PRIZES` section has four `.prize` cards. Each has an `.amount` div. There
is a caveat paragraph under the grid noting the amounts are from the previous
year — **once the current year's prizes are confirmed, delete that caveat and
state them plainly.** Leaving a stale hedge on confirmed numbers is worse than
having no hedge.

The prize amounts are also printed on both flyers, so Phase 6 has to follow
this one.

---

## Phase 4 — Move last year's finalists into the archive

The `PAST FINALISTS` section is a stack of `.year-block` divs, newest first.

1. Copy the most recent `.year-block` as a template and put the new one at the
   top of the stack.
2. Set `.year-head .y` to the year, `.label` to the event name, and `.meta` to
   the venue and date.
3. One `.finalist` div per team. Winners get a `winner-1` / `winner-2` /
   `winner-3` / `winner-pc` class, which colors the rank badge; everyone else
   is a plain `.finalist` with a "Finalist" badge.
4. Each card is: rank badge, `<h4>` team name, `<p>` one-sentence description,
   `.by` line with the founder names and their city.

Keep descriptions to one sentence. Use the words the team used about
themselves, not a rewrite.

If a past winner comes back and places again, it's worth saying so — the 2024
entry for Scholarise.org notes it returned and placed third in 2025.

---

## Phase 5 — Add photos to the gallery

Photos live in `assets/images/event/`. Full-resolution camera originals go in
`assets/images/event/_originals/`, which is **gitignored and never published**.
Only the web derivatives get committed.

### Generate the derivatives

From `assets/images/event/`, for each photo (`NN` = 01, 02, 03…):

```bash
magick IN.JPG -auto-orient -strip -resize 1600x -unsharp 0x0.6+0.6+0.01 -quality 78 -define webp:method=6 event-YYYY-NN.webp
magick IN.JPG -auto-orient -strip -resize 800x  -unsharp 0x0.6+0.6+0.01 -quality 76 -define webp:method=6 event-YYYY-NN-800.webp
magick IN.JPG -auto-orient -strip -resize 1200x -unsharp 0x0.6+0.6+0.01 -quality 80 -sampling-factor 4:2:0 -interlace JPEG event-YYYY-NN.jpg
```

`-strip` removes EXIF, including camera model and any GPS coordinates. Keep it.
The 2024 set went from 31MB to 1.3MB this way.

### Wire them into the page

Copy a `<figure class="shot">` block in the `GALLERY` section and change the six
filenames, the `alt` text, the `data-caption`, and the `<figcaption>`. The
`data-caption` and the `<figcaption>` must carry identical text — one shows in
the grid, the other in the lightbox.

- Keep `width="1600" height="1067"` on the `<img>` if the crop is 3:2, so the
  page doesn't shift while images load.
- Six photos fills two rows of three cleanly. Nine fills three rows.
- Update the `.gallery-meta` line above the grid with the new year, venue, date.

### Before you publish anyone's face

Get permission. Photos of identifiable students go on a public site indexed by
search engines. Write real `alt` text describing what's in the frame — it is
what a screen-reader user gets instead of the photo. Don't name individuals in
captions unless they've said yes to being named.

---

## Phase 6 — Rebuild the flyers

Sources are `flyers/flyer-full.html` and `flyers/flyer-quarter.html`. They are
self-contained apart from Google Fonts and the logo at `../assets/`, and they
carry their own copy of the brand palette — they do **not** read `index.html`,
so every date, rule, and prize has to be updated in them separately.

### Edit

- **Full page** (`flyer-full.html`) — one `.sheet` at exactly 8.5×11in. Sections
  top to bottom: district bar, green hero, navy date strip, four `.fact` cards,
  four `.tl` timeline columns, four `.prize` cards, navy footer.
- **Quarter page** (`flyer-quarter.html`) — four identical `.card` divs, each
  4.25×5.5in, in a 2×2 grid with dashed cut lines. **Edit one card, then paste
  it over the other three.** They must match.

### Check it still fits before rendering

The full-page sheet has no slack — content sums to exactly 1056px. If you add a
line, something else has to give. With the local server running:

```bash
open http://localhost:8777/flyers/flyer-full.html
```

In the browser console:

```js
const s = document.querySelector('.sheet');
[...s.children].reduce((h, c) => h + c.getBoundingClientRect().height, 0)
```

Must be **≤ 1056**. If it's over, the footer silently falls off the bottom of
the render. Trim padding in `.hero`, `.body`, or `.foot`.

Same check for the quarter page, against **528** per `.card`.

### Render to JPEG

With the server running:

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
for f in full quarter; do
  "$CHROME" --headless --disable-gpu --hide-scrollbars --virtual-time-budget=8000 \
    --screenshot="/tmp/$f.png" --window-size=816,1056 --force-device-scale-factor=3.125 \
    "http://localhost:8777/flyers/flyer-$f.html"
  magick "/tmp/$f.png" -background white -alpha remove -alpha off \
    -quality 92 -density 300 -units PixelsPerInch "flyers/4cd-pitch-flyer-$f.jpg"
done
magick identify flyers/*.jpg   # must both be 2550x3300
```

816×1056 CSS px at scale 3.125 is 2550×3300 — exactly 300 dpi on US Letter.
`--virtual-time-budget` gives Google Fonts time to load; without it you get
Impact instead of Anton.

**Look at both JPEGs before committing.** A missing font or a dropped footer is
obvious to the eye and invisible to the tooling.

### Print test

Print one of each at 100% / actual size — not "fit to page". Confirm the
quarter-page cut lines land on the halves and that nothing important sits within
a quarter inch of the paper edge.

The filenames are linked from the FAQ ("Is there a flyer I can print about this
competition?"), so keep them exactly as they are and the links keep working.

---

## Phase 6b — Update the slide deck

`slides/index.html` is one self-contained file: eleven 16:9 slides, one per nav
section, plus a cover and a closing card. Like the flyers, it carries its own
copy of the palette and does **not** read `index.html` — every date, rule, and
prize has to be changed here too.

Open it at <http://localhost:8777/slides/>. Arrow keys or space advance,
<kbd>F</kbd> is full screen, `#7` in the URL jumps to slide 7.

### What's on each slide

| # | Slide | Pulls from |
|---|---|---|
| 1 | Cover | Hero + save-the-date card |
| 2 | About | `#about`: eligibility and the three colleges |
| 3 | The Room | `#room`: Main Street, trades, science and product |
| 4 | Timeline | `#timeline`: all five dates |
| 5 | Prizes | `#prizes`: four prize cards and caveat |
| 6 | Scoring | `#judges` / `#scoring`: both rubrics, five categories each |
| 7 | Finalists | `#finalists`: last year's four winners |
| 8 | Gallery | `#gallery`: three photos from `assets/images/event/` |
| 9 | FAQ | `#faq`: eight rules as Q&A |
| 10 | Community | Discord and what it's for |
| 11 | Closing | URL + the three key dates |

### What to change each year

- **Slides 1, 4, 11** carry dates. Slide 11 repeats the three key dates, so it
  is the easiest one to forget.
- **Slides 2, 4, 11** print the application URL as visible text, not just as a
  link — see Phase 2b. So does the `Apply →` link in the bottom bar.
- **The `← 4cdpitch.com` link** at the top left is the only way out of the deck
  for anyone who opened it directly; the FAQ link on the main site opens the
  deck in a new tab. Leave both in place.
- **Slide 5** must match the prize cards in `index.html` and both flyers.
- **Slide 9** must match the `.rules-strip` panel and the FAQ.
- **Slide 7** needs last year's winners moved in — same content you wrote in
  Phase 4, cut to one sentence each.
- **Slide 8** needs three new photo filenames from Phase 5. It uses the
  `-800.webp` variants; the paths are relative (`../assets/images/event/…`).
- **Slide 6** only changes if the official rubric changes.

### Check nothing overflows

Slides silently clip at 720px. With the deck open, in the console:

```js
[...document.querySelectorAll('.slide')]
  .map((s, i) => [i + 1, s.scrollHeight])
  .filter(([, h]) => h > 720)
```

Must return an empty array. If a slide is over, cut a bullet — don't shrink the
type below 15px, because it has to read from the back of a room.

### Presenting and exporting

The deck is meant to be presented from the browser, full screen. The **Print**
button in the bottom bar (or ⌘P) lays it out one slide per page in landscape —
"Save as PDF" from there gives you a shareable deck. Turn on "Background
graphics" in the print dialog or every slide comes out white.

The deck is linked from the FAQ ("Is there a flyer I can print about this
competition?"), and the URL `4cdpitch.com/slides/` depends on the file staying
at `slides/index.html`. Don't rename it.

---

## Phase 6c — Event-day print pieces

Three documents are printed for the live final. They live in `print/` and, like
the flyers and the deck, carry their own copy of the palette and do **not**
read `index.html`.

| Source | Output | Pages | What it is |
|---|---|---|---|
| `print/program.html` | `4cd-pitch-YYYY-program.pdf` | 2 | Half-fold program: Letter landscape, page 1 is the outside (back cover left, front cover right), page 2 the inside (agenda, keynote, judges left; finalists, prizes right) |
| `print/certificates.html` | `4cd-pitch-YYYY-certificates.pdf` | one per finalist **person** | Finalist certificates, Letter landscape |
| `print/judge-tent-cards.html` | `4cd-pitch-YYYY-judge-tent-cards.pdf` | one per judge | Name tents: Letter landscape folded along the long centre line; the top half prints upside down so the name reads from both sides |

Each also renders a `-press.pdf` version for a print shop (see *Render*
below). `print/press.js` handles that; `print/render.sh` does all the
rendering.

### When to do this

Start once finalists are named (Phase 1's "finalists announced" date) and the
judges and keynote are confirmed. Expect to re-run it several times: in 2026
two finalists withdrew and two alternates were added, and a judge named a
stand-in, all in the last two weeks. Every change is an edit plus one
`print/render.sh`. Leave at least three working days for a print shop.

### Gather the inputs first

Write these down before editing. Ask the organizer for anything you can't find.

| Input | Where it comes from |
|---|---|
| Finalist teams: name, founders, college, one-line description | The 2026 finalists `year-block` in `#finalists` in `index.html`, which you update first (Phase 4). For a late addition, the application export from the Microsoft Form (a CSV the organizer downloads, e.g. `~/Downloads/4CD Business Pitch Competition (Fall YYYY)(Sheet1).csv`, columns *What is your name?*, *Which college(s)…*, *What is the name of your business idea?*, *Describe your business idea…*) and the applicant's pitch deck linked in that row. If the form's description is thin, write the line from the deck. |
| Agenda times | Organizer. 2026: doors 8:30, welcome 9:00, pitches 9:15, judges' deliberation and keynote 11:00, awards and lunch 11:30. |
| Pitch format | Organizer. 2026: five minutes to pitch, five for questions. This also appears on the website, the deck, and the full flyer — change all of them together. |
| Keynote speaker: name, title, photo | Organizer; photo from the speaker's official bio page. |
| Judges, including any stand-ins | Organizer. |
| Prize amounts and sponsors | `#prizes` in `index.html`. |

**Treat applicants' contact details as private.** The CSV holds student email
addresses; never copy them into the repo.

### What to change in `print/program.html`

- **Year and date** — `grep -n -i "nov 20\|2026" print/program.html`. They
  appear on the cover, the date strip, and the agenda heading.
- **Team count** — the word ("Ten") appears three times: the cover `<h1>`, the
  agenda's 9:15 `<small>` line, and the inside `<h2>`. It must match the
  number of `.team` blocks and the current year’s cards under `#finalists` in `index.html`.
  `grep -n -i -w "eight\|nine\|ten\|eleven\|twelve" print/program.html`.
- **Cover lede** (`p.lede`) — states the pitch format.
- **Agenda** — one `div.ag` per row; the pitches row is `div.ag.hot`.
- **Keynote** — the `.keynote` block. Put the photo at
  `assets/images/speakers/<first>-<last>.jpg` and `.webp`, cropped square,
  640px, EXIF stripped:
  ```bash
  magick IN.jpg -auto-orient -strip -gravity center -crop "%[fx:min(w,h)]x%[fx:min(w,h)]+0+0" +repage \
    -resize 640x640 -quality 82 -interlace JPEG assets/images/speakers/first-last.jpg
  ```
  The website's Agenda section shows the same photo.
- **Judges** — the `<ul>` inside `.judges`, one `<li>` each. It lays out in two
  columns that read left to right.
- **Finalists** — one `div.team` each (`h3` team, `p` one line, `.by` founders ·
  college), in alphabetical order. Keep each description to about 100
  characters so ten or more teams fit. A team name starting with "The" was
  sorted under its next word in 2026.
- **Prizes and sponsors** — the `.prize` cards on the inside, and the sponsor
  logos on the back cover (`assets/sponsors/`).
- **District logo** — `assets/4cd-logo.png`, the only image the district
  publishes, 200px wide. It prints at about 210 dpi, slightly soft. If the
  district's communications office can supply a vector or larger file, swap
  it in.

### What to change in `print/certificates.html`

Edit the `FINALISTS` list at the bottom of the file: **one row per person**,
`["Full Name", "Team name"]`. A team of three founders gets three
certificates — in 2026 ten teams made twelve certificates. The page count of
the rendered PDF must equal the number of rows. The wording ("one of the YYYY
finalists") and the date band are in the `<template>`. Long names shrink
automatically to fit the line.

### What to change in `print/judge-tent-cards.html`

Edit the `JUDGES` list at the bottom. Include confirmed stand-ins as extra
entries (the organizer prints only the cards needed on the day). Long names
shrink automatically.

### Render

```bash
print/render.sh              # all three pieces, standard and press
print/render.sh --downloads  # ...and copy the PDFs to ~/Downloads
```

It starts its own local server, renders each piece twice — standard (11×8.5in
pages, for an office printer) and press (`?bleed`: 0.125in bleed, crop marks,
fold marks, 11.75×9.25in pages, for a print shop) — and prints a page-count
table. It also writes a tall PNG preview of every page and prints the folder.

Check the table: program **2**, certificates **= rows in `FINALISTS`**, tent
cards **= entries in `JUDGES`**. Then **look at every preview page.** Things
the table cannot catch:

- the program's finalist list running into "The prizes" (trim descriptions,
  or reduce `.team p` font size slightly);
- a name or team that wrapped badly;
- Anton missing (headlines in Impact means fonts didn't load — re-run).

Do not render by hand with a long-lived Chrome profile. In 2026 a reused
profile served cached HTML and produced a byte-identical PDF of the previous
version; the script avoids that with a fresh profile and a cache-busting URL.

### Print instructions to pass on

- Print everything at **actual size**, never "fit to page".
- **Program**: double-sided, flip on the **short edge**, then fold in half.
- **Tent cards**: card stock, fold along the centre marks.
- **Press files** are RGB; most shops convert to CMYK automatically, but ask
  for a proof if the greens must match exactly.

### Ship

Commit the HTML sources and the six PDFs together. The PDFs are published at
`4cdpitch.com/print/…` (nothing links to them), so judges' names are public
once pushed.

---

## Phase 7 — Judges, mentors, and sponsors

- Judges (`#judges`) has a `.panel-list` of past judges. Add the previous
  year's panel; the note underneath says when the new panel is announced —
  update that month.
- The scoring rubrics in `#scoring` come from the official rubric document. Do not
  reword them to fit the layout. If the rubric changes, change the tables, the
  `tfoot` totals, and the `.rubric-head .max` badge together.

---

## Phase 8 — Ship it

```bash
grep -rin "11:59\|nov \|sept \|2026" index.html | less   # read every line
python3 -c "import html.parser; html.parser.HTMLParser().feed(open('index.html').read())"
```

Then click through the live-ish local copy at three widths — 375px, 880px, and
1400px — and check:

- No horizontal scrollbar at any width (`document.documentElement.scrollWidth`
  should equal `clientWidth`)
- The gallery lightbox opens, arrows work, Esc closes
- Every FAQ `<details>` opens
- The flyer links download the right files, and `/slides/` opens and pages through

Then:

```bash
git add -A
git commit -m "Roll the site to the YYYY cycle"
git push origin main
```

GitHub Pages rebuilds on push. Give it a minute, then load
<https://www.4cdpitch.com> and check the deadline in the hero rail — it's the
single most consequential number on the page.

---

## Section headings and navigation

Use a plain heading for each section rather than numbering it. Keep section IDs
stable so navigation and shared links keep working. If you change the nav,
check the top bar just above the desktop breakpoint and at a wide viewport.
