#!/bin/bash
# validate.sh — design-guidelines validator. macOS bash-3.2-safe; grep/awk/sed only.
#
# Modes:
#   validate.sh            all docs in this dir + repo-level INDEX check
#   validate.sh FILE.md    per-doc checks on FILE only (FILE = INDEX.md -> repo-level check only)
#
# Per-doc checks (every *.md here except INDEX.md; CONVENTIONS.md included):
#   1. <= 250 lines (wc semantics via awk NR)
#   2. H1 present; exact H2s present: Purpose, Principles, Rules, Decision guide, Cross-refs
#   3. every top-level '- ' bullet inside '## Principles' / '## Rules' ends with [E] or [H]
#   4. at least one [E]/[H] tag somewhere in the doc
#   5. every [[REF]] resolves: target listed in INDEX doc table (planned|live),
#      or is CONVENTIONS/INDEX. File existence is deliberately NOT checked —
#      sibling docs are authored in parallel on separate branches. Refs inside
#      fenced code blocks or inline `code spans` are ignored (syntax examples).
# Repo-level check:
#   every *.md in the dir except INDEX.md and CONVENTIONS.md (infrastructure,
#   exempt) is listed in the INDEX doc table.
# Exit 0 = green, including on the bare skeleton (zero content docs).

set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
INDEX="$DIR/INDEX.md"
FAIL=0
err() { echo "FAIL: $1"; FAIL=1; }

[ -f "$INDEX" ] || { echo "FAIL: INDEX.md missing at $INDEX"; exit 1; }

# Doc names listed in the INDEX doc table with status planned|live.
LISTED="$(awk -F'|' '{
    name=$2; st=$3
    gsub(/[[:space:]]/, "", name); gsub(/[[:space:]]/, "", st)
    if ((st == "planned" || st == "live") && name ~ /^[A-Z][A-Z0-9_]*$/) print name
}' "$INDEX")"

is_listed() {
    case "$1" in CONVENTIONS|INDEX) return 0 ;; esac
    echo "$LISTED" | grep -qx "$1"
}

check_doc() {
    f="$1"
    b="$(basename "$f" .md)"
    [ -f "$f" ] || { err "$b: no such file: $f"; return; }

    n="$(awk 'END{print NR}' "$f")"
    [ "$n" -le 250 ] || err "$b: $n lines (max 250)"

    grep -q '^# ' "$f" || err "$b: missing H1 title"
    for h in "Purpose" "Principles" "Rules" "Decision guide" "Cross-refs"; do
        grep -q "^## $h\$" "$f" || err "$b: missing heading '## $h'"
    done

    grep -Eq '\[(E|H)\]' "$f" || err "$b: no [E]/[H] evidence tags"

    awk -v doc="$b" '
        /^## / { insec = ($0 == "## Principles" || $0 == "## Rules") }
        insec && /^- / && $0 !~ /\[[EH]\][[:space:]]*$/ {
            printf "FAIL: %s:%d untagged bullet in Principles/Rules (must end with [E] or [H])\n", doc, NR
            bad = 1
        }
        END { exit bad }
    ' "$f" || FAIL=1

    # Refs inside fenced code blocks or inline `code spans` are syntax
    # examples, not refs — strip them before extraction.
    refs="$(awk '/^```/ { fence = !fence; next } !fence' "$f" \
        | sed 's/`[^`]*`//g' \
        | grep -o '\[\[[A-Za-z0-9_]*\]\]' | sed 's/^\[\[//; s/\]\]$//' | sort -u)"
    for r in $refs; do
        is_listed "$r" || err "$b: unresolved cross-ref [[$r]] (not in INDEX doc table)"
    done
}

repo_check() {
    for f in "$DIR"/*.md; do
        [ -f "$f" ] || continue
        b="$(basename "$f" .md)"
        case "$b" in INDEX|CONVENTIONS) continue ;; esac
        echo "$LISTED" | grep -qx "$b" || err "INDEX.md does not list existing doc $b.md"
    done
}

if [ "$#" -ge 1 ]; then
    if [ "$(basename "$1")" = "INDEX.md" ]; then
        repo_check
    else
        check_doc "$1"
    fi
else
    for f in "$DIR"/*.md; do
        [ -f "$f" ] || continue
        [ "$(basename "$f")" = "INDEX.md" ] && continue
        check_doc "$f"
    done
    repo_check
fi

[ "$FAIL" -eq 0 ] && echo "OK"
exit "$FAIL"
