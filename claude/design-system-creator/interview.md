# interview.md — question bank

What to ask, in what order, and what never to ask. The interview is the system's single largest quality lever: user answers become the North Star's Brief, and every later decision traces back to them. It is also the largest annoyance lever — so mine the repo first, batch hard, and always offer a recommended default.

## Rules

- **Mine before asking.** Auto-answer from the repo first: `package.json` / lockfiles (stack, framework), tailwind/theme config + CSS custom properties (existing tokens), asset folders (logo, fonts), README/marketing copy (voice), deployed URL or screenshots if reachable. A question the repo answers is never asked.
- **Batch.** `AskUserQuestion`, ≤4 questions per call. Round budget: Scratch ≤3 rounds, Extract ≤2, Revamp ≤2, Update ≤1. Overflow questions → take the recommended default and note it in `DECISIONS.md` as `defaulted`.
- **Recommended default first** in every option list, derived from mined evidence — never from generic taste.
- **Options carry consequences**, not adjectives: "AAA — body text 7:1, restricts mid-tone palettes" beats "high accessibility".
- **Record verbatim-compact.** Answers land in `design/INDEX.md` §Brief as `key: value` lines (see `north-star.md`). The Brief is the contract; do not paraphrase away constraints.
- **Contradictions surface immediately.** "Playful" + "enterprise procurement buyers" → name the tension in one line and ask which wins where (marketing surfaces vs product surfaces is the usual split).

## Phases

### P0 — Context (mine first; ask only holes)

| # | Ask | Typical options | Feeds |
|---|-----|-----------------|-------|
| 0.1 | What is the product, in one sentence? | free text | everything |
| 0.2 | Who uses it, in what situation? | free text (role + context + frequency) | density, tone, floors |
| 0.3 | Platforms now / in 12 months? | web · web+mobile · native · desktop · TV/embedded | breakpoints, input models |
| 0.4 | Existing brand assets that are fixed? | none · logo only · logo+colors · full brand book | how much P2 is open |

### P1 — Identity (the differentiation core)

| # | Ask | Typical options | Feeds |
|---|-----|-----------------|-------|
| 1.1 | Three adjectives this product must feel like — and three it must never feel like | free text, 3+3 | all foundations |
| 1.2 | One non-digital object, place, or material it should feel like | free text (e.g. "a field notebook", "a bank vault", "a chef's knife") | the anti-generic anchor; drives texture, motion, color temperature |
| 1.3 | Which products should it explicitly NOT resemble? | free text (usually category leaders) | ANTI_HOMOGENIZATION targets |
| 1.4 | Personality sliders: serious↔playful · calm↔energetic · dense↔airy · classic↔experimental | 1–5 each | type, motion, spacing, voice |

### P2 — Foundations

| # | Ask | Typical options | Feeds |
|---|-----|-----------------|-------|
| 2.1 | Color seed: brand color(s) fixed, or generate from identity? | fixed hex(es) · generate · generate-around-logo | FOUNDATIONS color |
| 2.2 | Color schemes shipped? | light+dark (rec) · light only · dark only · auto+user-toggle | token structure |
| 2.3 | Type appetite? | distinctive open-source (rec) · system stack (perf/enterprise) · licensed custom | TYPOGRAPHY_SYSTEMS + UNDISCOVERED_TYPE_LIBRARY |
| 2.4 | Accessibility bar? | WCAG AA (rec, 4.5:1 body) · AAA (7:1) · AA + specific needs (name them) | §Floors — permanent |
| 2.5 | Motion appetite? | purposeful-only (rec) · expressive signature · minimal (reduced-motion default) | PATTERNS motion rules |
| 2.6 | Information density? | comfortable (rec consumer) · dense (pro tools) · airy (marketing) | spacing scale, component sizing |

### P3 — Scope

| # | Ask | Typical options | Feeds |
|---|-----|-----------------|-------|
| 3.1 | First 8 components you need working? | pick from `ui-kit.md` inventory | UI-KIT build order |
| 3.2 | Content voice: formality, jargon, humor? | sliders 1–5 + banned-words list | VOICE |
| 3.3 | Data visualization needed? | none · basic charts · analytics-core | whether FOUNDATIONS gets a viz palette |
| 3.4 | Error/empty/loading tone? | reassuring · matter-of-fact · playful | VOICE microcopy patterns |

### P4 — Ambition (feeds Challenge)

| # | Ask | Typical options | Feeds |
|---|-----|-----------------|-------|
| 4.1 | How daring may the system get, 1–5? | 2 = refine only · 3 (rec) = challenge visuals, keep patterns · 5 = challenge everything above floors | challenge.md scope |
| 4.2 | Sacred elements — never challenged? | free text (logo, brand color, nav model…) | challenge.md exclusions |
| 4.3 | Challenge cadence? | each release (rec, active repos) · monthly · quarterly · manual only | INDEX §Cadence |

## Mode → phase matrix

| Mode | P0 | P1 | P2 | P3 | P4 |
|------|----|----|----|----|----|
| Scratch | ask holes | full | full | full | full |
| Extract | mine | full | confirm mined | confirm mined | full |
| Update | — | — | delta only | delta only | — |
| Revamp | confirm | full | full | keep unless asked | confirm |

Extract's "confirm mined": present the mined value as the recommended default in one batched round — the user corrects, not dictates from zero.
