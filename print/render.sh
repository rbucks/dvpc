#!/usr/bin/env bash
# Render the event-day print pieces to PDF, plus PNG previews for checking.
#
#   print/render.sh              # render all three pieces, standard and press
#   print/render.sh --downloads  # ...and copy the PDFs to ~/Downloads
#
# Needs Google Chrome and python3. Run from anywhere; it starts its own local
# server on a free port and stops it when done. Every run uses a fresh Chrome
# profile and a cache-busting URL, because a reused profile can serve the old
# HTML and silently produce a PDF of the previous version.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
PIECES=(program certificates judge-tent-cards)
YEAR="$(grep -o 'Competition — [0-9]\{4\}' "$ROOT/print/program.html" | head -1 | grep -o '[0-9]\{4\}' || true)"
YEAR="${YEAR:-$(date +%Y)}"
COPY=0
[ "${1:-}" = "--downloads" ] && COPY=1

[ -x "$CHROME" ] || { echo "Chrome not found at $CHROME (set CHROME=...)"; exit 1; }

WORK="$(mktemp -d)"
PREVIEWS="$WORK/previews"
mkdir -p "$PREVIEWS"
PORT="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')"
( cd "$ROOT" && exec python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 ) &
SERVER=$!
trap 'kill $SERVER 2>/dev/null; rm -rf "$WORK/profile"' EXIT
for _ in $(seq 50); do curl -s -o /dev/null "http://127.0.0.1:$PORT/" && break; sleep 0.1; done

chrome() { "$CHROME" --headless --disable-gpu --hide-scrollbars --no-pdf-header-footer \
  --virtual-time-budget=8000 --user-data-dir="$WORK/profile" "$@" >/dev/null 2>&1; }

pages() { python3 -c 'import re,sys; print(len(re.findall(rb"/Type\s*/Page[^s]", open(sys.argv[1],"rb").read())))' "$1"; }

printf "%-44s %5s\n" "file" "pages"
for piece in "${PIECES[@]}"; do
  for mode in standard press; do
    query="?v=$RANDOM$RANDOM"; suffix=""; w=1056; h=816
    if [ "$mode" = press ]; then query="$query&bleed"; suffix="-press"; w=1128; h=888; fi
    out="$ROOT/print/4cd-pitch-$YEAR-$piece$suffix.pdf"
    url="http://127.0.0.1:$PORT/print/$piece.html$query"
    chrome --print-to-pdf="$out" "$url"
    n="$(pages "$out")"
    printf "%-44s %5s\n" "$(basename "$out")" "$n"
    # Preview: the sheets stack vertically, so one tall screenshot shows every page.
    chrome --screenshot="$PREVIEWS/$piece$suffix.png" --window-size="$w,$((h * n))" "$url"
  done
done

if [ "$COPY" = 1 ]; then
  cp "$ROOT"/print/4cd-pitch-"$YEAR"-*.pdf "$HOME/Downloads/"
  echo "Copied the PDFs to ~/Downloads"
fi
echo "Previews: $PREVIEWS"
