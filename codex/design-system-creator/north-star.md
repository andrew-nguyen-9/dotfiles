# north-star.md — the target `design/` folder

What the build modes write into the target repo. Seven files, hard caps, one router — the same JIT model as the corpus: agents load `INDEX.md` plus at most one role file, never the folder. Every skeleton below is a starting shape, not a straitjacket: keep the headings and caps, cut anything the project doesn't need, never pad to fill.

## Files and caps

| File | Cap (wc -l) | Holds | Loaded by |
|------|------------|-------|-----------|
| `design/INDEX.md` | 80 | brief, floors, load map, cadence, version | every session, always first |
| `design/FOUNDATIONS.md` | 150 | color/type/space/radius/elevation/breakpoint tokens | UI build, data-viz |
| `design/UI-KIT.md` | 250 | component specs (per `ui-kit.md` format) | UI build |
| `design/VOICE.md` | 100 | tone, terminology, microcopy patterns | content, UX writing |
| `design/PATTERNS.md` | 150 | nav model, page archetypes, interaction + motion rules | UX flows, UI build |
| `design/DECISIONS.md` | append-only | decision log: what, why, challenge-by | Challenge pass; disputes |
| `design/validate.sh` | 60 | structural + floor self-check | DoD, CI if wired |

## Agent load map

The token-efficiency contract. Written into INDEX so every future session self-serves:

| Session doing | Loads |
|---------------|-------|
| building UI | INDEX + FOUNDATIONS + UI-KIT |
| UX flow / IA work | INDEX + PATTERNS |
| writing product copy | INDEX + VOICE |
| data visualization | INDEX + FOUNDATIONS (+ corpus DATA_VISUALIZATION) |
| design review / pre-ship | INDEX (+ corpus CHECKLISTS) |
| challenging the system | INDEX + DECISIONS (per `challenge.md`) |

## Skeletons

Format rules inherited from the corpus's CONVENTIONS: dense and imperative; every rule measurable (number + unit + bend condition); tables over prose; decisions, not alternatives. No evidence tags here — the Brief is the evidence.

### design/INDEX.md

```markdown
# Design North Star — <product>

v1 — YYYY-MM-DD. Read this file first; then load per §Load map. Full system: FOUNDATIONS,
UI-KIT, VOICE, PATTERNS, DECISIONS. Never bulk-load the folder.

## Brief
product: <one sentence>
users: <role + context + frequency>
platforms: <now / 12mo>
feels-like: <adj, adj, adj> — never <adj, adj, adj>
anchor: <the non-digital object/place/material>
not-like: <products to not resemble>
sliders: serious <n>/5 · calm <n>/5 · dense <n>/5 · classic <n>/5
density: <comfortable|dense|airy>   motion: <purposeful|expressive|minimal>
ambition: <1-5>   sacred: <list>

## Floors — never regress, any mode, any challenge
- contrast: body ≥4.5:1, large(≥24px)/bold(≥18.7px) ≥3:1, UI parts ≥3:1
- targets: ≥44×44px touch, ≥24×24px pointer
- motion: every animation has a reduced-motion variant; nothing essential moves-only
- focus: visible indicator ≥3:1 against adjacent colors on every interactive element
- <project-specific floors from interview P2.4>

## Load map
| doing | load |
|-------|------|
| UI build | INDEX + FOUNDATIONS + UI-KIT |
| UX / flows | INDEX + PATTERNS |
| copy | INDEX + VOICE |
| data viz | INDEX + FOUNDATIONS (+ corpus DATA_VISUALIZATION) |
| review | INDEX + corpus CHECKLISTS |
| challenge | INDEX + DECISIONS |

## Cadence
challenge: <each release|monthly|quarterly|manual>   last-challenged: YYYY-MM-DD
```
Overdue semantics (siblings + Challenge read this): `monthly`/`quarterly` = overdue when `today − last-challenged` exceeds the interval; **`each release` = flag at every orchestrating/cleaning land step regardless of age** (no date math); **`manual` = never auto-overdue**. Build modes (Scratch/Extract/Revamp) stamp `last-challenged:` = the build date (Challenge is not the only stamper — an unstamped fresh system reads as perpetually overdue).

### design/FOUNDATIONS.md

```markdown
# FOUNDATIONS

Tokens are the only source — components reference tokens, never raw values.
Naming: role-based (--color-surface, not --gray-100).

## Color
| token | light | dark | role | contrast vs |
|-------|-------|------|------|-------------|
| --color-ink | #… | #… | body text | surface ≥4.5:1 |
| --color-surface | #… | #… | page ground | — |
| --color-accent | #… | #… | primary actions | surface ≥3:1 |
…(full role set: ink/muted/surface/raised/line/accent/accent-ink/ok/warn/danger/focus)
Derivation: <one line — seed + method + corpus rule used>.
Extract repos add a `source key` column mapping each token to its mined origin (e.g. blue-600).

## Type
faces: <display face> / <text face> — pairing rationale: <one line>
scale: base 16px · ratio <1.2|1.25|1.333> → <the computed steps for the chosen ratio, e.g. 1.25 → 13/16/20/25/31/39>
weights: <400/600/…>   line-height: text 1.5 · display 1.15   measure: 45–75ch

## Space
base: <4|8>px · scale: 4/8/12/16/24/32/48/64   density: <from Brief>

## Shape & elevation
radius: <none|4|8|…>px (+ where it bends)   shadows/borders: <the system's depth language, ≤3 levels>

## Breakpoints
<the set + what reflows at each>
```

### design/UI-KIT.md

```markdown
# UI-KIT

Specs use tokens only (values live in FOUNDATIONS). Format, states, a11y minimums
per the creator's ui-kit.md; each full spec ≤10 lines.

## Inventory
| component | status | code |
|-----------|--------|------|
| buttons | specced | planned |
| <every core-tier row + Brief-triggered extended rows; statuses live/specced/planned — `live`+code path only when the component is already built (Extract), never on a greenfield Scratch> | | |

## Specs
### Button — live
<per-component blocks for the specced set>
```

### design/VOICE.md

```markdown
# VOICE

## Tone
formality n/5 · jargon n/5 · humor n/5 — <one line on when each bends>

## Terminology
| always say | never say | because |

## Microcopy patterns
errors: <shape: what happened + what to do next; tone>
empty states: <shape; first-run vs cleared>
confirmations/CTAs: <verb style, person, length caps>
```

### design/PATTERNS.md

```markdown
# PATTERNS

## Navigation model
<the one model + where it bends per platform>

## Page archetypes
| archetype | layout | used for |

## Interaction rules
<selection, editing, saving, undo — the recurring verbs and their contracts>

## Motion
durations: micro 100–150ms · transition 200–300ms · spatial 300–500ms · reduced-motion ≤150ms crossfade (the §Floors variant)
easing: <the signature curve(s)>   meaning: <what moves, why, reduced-motion behavior>
```

### design/DECISIONS.md

```markdown
# DECISIONS — append-only

challenge-by = decision date + one INDEX cadence interval, unless the decider sets longer (cadence `each release` → `next release`; `manual` → `manual` — neither is a duration).
Tags in the decision cell: `wildcard:<FILE>` (challenge rotation memory), `trial`, `defaulted`.

| date | decision | why | challenge-by |
|------|----------|-----|--------------|
| YYYY-MM-DD | chose direction "<name>"; rejected <A>, <B> | <one line> | YYYY-MM-DD |

## Drift — shipped code vs system (Extract findings; append resolutions, never rewrite rows)
| where | code says | system says | resolved |
```

### design/validate.sh

```bash
#!/usr/bin/env bash
# design/ self-check: structure, caps, floors. Exit 0 = green.
set -u; cd "$(dirname "$0")"; fail=0
say(){ echo "FAIL: $1"; fail=1; }
# file:cap pairs (bash-3.2-safe: macOS default bash has no associative arrays)
for spec in INDEX.md:80 FOUNDATIONS.md:150 UI-KIT.md:250 VOICE.md:100 PATTERNS.md:150; do
  f=${spec%%:*}; cap=${spec##*:}
  [ -f "$f" ] || { say "$f missing"; continue; }
  n=$(wc -l < "$f"); [ "$n" -le "$cap" ] || say "$f $n lines > cap $cap"
done
[ -f DECISIONS.md ] || say "DECISIONS.md missing"
grep -q '^## Floors' INDEX.md 2>/dev/null || say "INDEX.md lacks §Floors"
grep -q '^## Brief'  INDEX.md 2>/dev/null || say "INDEX.md lacks §Brief"
grep -q 'last-challenged:' INDEX.md 2>/dev/null || say "INDEX.md lacks last-challenged stamp"
# tokens-only discipline: raw color values outside FOUNDATIONS are a leak.
# KNOWN FP: a hex-shaped word/ref (#cafe, #decaf, #123456 issue ref) also trips it —
# reword the prose or move the value into a FOUNDATIONS token.
leaks=$(grep -lE '#[0-9a-fA-F]{3,8}\b|rgba?\(|hsla?\(' UI-KIT.md VOICE.md PATTERNS.md 2>/dev/null || true)
[ -z "$leaks" ] || say "raw color outside FOUNDATIONS: $leaks"
exit $fail
```

## Placement notes

- Folder goes at the target repo root as `design/` — **canonical, single location** (`design/` is source-adjacent, not docs; a single root home is what lets every sibling system — lite/medium/big/cleaning — find it with one literal `design/INDEX.md` test instead of each carrying a `docs/design/` fallback). A repo whose convention forbids root dirs symlinks `design/` → its docs tree; the North Star's own path stays `design/`.
- If the target repo has a AGENTS.md, add one line to it: `Design: design/INDEX.md is the North Star — load per its map before any UI/UX/copy work.` That line is what makes the system findable by sessions that never heard of this creator.
- Optional live kit (`design/ui-kit/` preview HTML + design workspace sync): see `ui-kit.md`.
