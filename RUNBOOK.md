# Annual runbook — resetting the site for a new competition year

Everything the site needs for a new cycle lives in four places: `index.html`,
`assets/images/event/`, `flyers/`, and `slides/`. There is no build step, no framework, and
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

---

## Phase 1 — Roll the dates

Five dates drive the whole page. Work out the new ones first, then search and
replace. Write them down here before you touch anything:

| What | 2026 | New year |
|---|---|---|
| Applications open | Sept 15 | |
| Application deadline | Mon, Nov 2, 11:59pm PT | |
| Finalists announced | Fri, Nov 6 | |
| Live final | Fri, Nov 20, 9:00am | |
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
| `Nov 2` | ~9 | Careful: `Nov 20` contains `Nov 2` — search `Nov 2<`, `Nov 2,`, `Nov 2.`, `Nov 2 ` |
| `11:59pm` | 8 | Key-dates rail, timeline, scoring lede, entry rules, rubric band, FAQ, apply CTA |
| `Nov 6` | ~8 | |
| `Sept 15` | ~3 | |
| `2026` | ~20 | Includes the `2026` year chips on the flyers |

Then check these by eye, because they are worded rather than templated:

- `<title>` and the `<meta name="description">` in the `<head>`
- The `KEY DATES RAIL` — three `.date-cell` blocks
- The `TIMELINE` section — five `.tl-row` blocks
- The `§ 03 — Timeline` heading, which names the final's date
- The `.rules-strip` entry-rules panel in `§ 06 — Scoring`
- The `.deadline` line in the `APPLY` CTA

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

1. The `.rules-strip` panel at the top of `§ 06 — Scoring` — the one-glance
   summary
2. The FAQ entries — "Does my idea need to be a real business already?", "Can I
   apply with a co-founder or team?", "What does the application include?",
   "Can I submit more than one application?", "I entered a previous year…"

If the number of finalists changes from ten, note that "ten" is spelled out in
the scoring section, the rubric bands, the timeline, and the key-dates rail.

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
| 2 | About | § 01 — eligibility, the three colleges |
| 3 | The Room | § 02 — Main Street vs science & product |
| 4 | Timeline | § 03 — all five dates |
| 5 | Prizes | § 04 — four prize cards + caveat |
| 6 | Scoring | § 05–06 — both rubrics, five categories each |
| 7 | Finalists | § 07 — last year's four winners |
| 8 | Gallery | § 08 — three photos from `assets/images/event/` |
| 9 | FAQ | § 09 — eight rules as Q&A |
| 10 | Community | Discord and what it's for |
| 11 | Closing | URL + the three key dates |

### What to change each year

- **Slides 1, 4, 11** carry dates. Slide 11 repeats the three key dates, so it
  is the easiest one to forget.
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

## Phase 7 — Judges, mentors, and sponsors

- `§ 05 — How it's judged` has a `.panel-list` of past judges. Add the previous
  year's panel; the note underneath says when the new panel is announced —
  update that month.
- The scoring rubrics in `§ 06` come from the official rubric document. Do not
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

## Section numbering

Sections are numbered `§ 01` through `§ 09` in `.section-head .index`. If you
add or remove one, renumber the rest and update the nav links in `.topbar`.
There are nine nav links; the nav hides below 1080px because a tenth would
overflow the bar. If you add one, re-test the top bar at 1100px.
