# CONVENTIONS

## Purpose

Binding authoring contract for every doc in `claude/design-guidelines/`. `validate.sh` enforces the mechanical subset (skeleton, tags, refs, length); everything else here is reviewed by humans. Read this whole file before writing or editing any guideline doc. This file obeys its own rules and passes `validate.sh`.

## Principles

- Voice is dense and imperative: principles and mechanisms, never tutorials, never filler. If a sentence survives deletion without information loss, delete it. [E]
- Every rule is measurable where possible: number/ratio/threshold + unit + the condition under which it bends. "Adequate contrast" is banned; "4.5:1 minimum, 3:1 for ≥24px text" is the format. [E]
- Every pattern states WHY it works — the psychological, visual, or behavioral mechanism. Bare "best practice" claims are banned. [E]
- Content is transferable: frameworks, heuristics, equations, decision trees. No framework-specific UI recipes; everything must apply across web, mobile, games, dashboards. [E]
- Optimize for: human-centered, emotional resonance, visual intelligence, mathematical rigor, adaptability, originality, signal-to-noise, practical implementation, dynamic systems, maintainability. [H]
- Banned: AI-aesthetic clichés (purple-gradient-on-dark, glassmorphism-everywhere, emoji-bullet walls), generic advice ("keep it simple"), trend-chasing. Favor distinctive identity, controlled imperfection, memorable over sterile. [E]
- Each doc is independently usable: a reader holding ONLY that doc can act on its domain. Cross-refs deepen, never gate, understanding. [H]

## Rules

### Section skeleton (validator-enforced)

Every doc carries an H1 title line (`# <DOC_NAME>`, matching the filename) plus these five H2 headings, exactly spelled, in this order:

- `## Purpose` — 1–3 lines: what this doc decides and when to load it. [E]
- `## Principles` — the why-layer: mechanisms and stances, as tagged bullets. [E]
- `## Rules` — the what-layer: measurable directives, as tagged bullets; `###` subheadings allowed for grouping. [E]
- `## Decision guide` — if/then routing for applying the rules: a table or decision tree, no new rules. [E]
- `## Cross-refs` — pointers to sibling docs with one line on when to follow each; write `none` if empty. [E]

The validator checks heading presence and exact spelling (`^## Purpose$` etc.); ordering and the H1-matches-filename rule are convention, enforced by review. Additional H2 sections are discouraged — content belongs in the five. `###` subheadings inside any section are free.

### Evidence tags

- Placement rule: every top-level bullet (a line starting with `- ` at column 0) inside the `## Principles` and `## Rules` sections ends with ` [E]` or ` [H]` as its final token. Validator-enforced. [E]
- Indented sub-bullets, prose paragraphs, tables, and code blocks inherit the nearest tagged parent and carry no tag of their own. [E]
- `[E]` = evidence-backed: published research, replicated findings, or strong cross-industry consensus. `[H]` = hypothesis: plausible mechanism, weak or absent sourcing. If you cannot name the study or consensus, tag `[H]` — an honest `[H]` beats an inflated `[E]`. [H]

### Cross-refs

- One syntax only: `[[DOC_NAME]]` — double square brackets, target name in caps, no `.md` suffix. Example: [[COLOR_SYSTEMS]]. Relative markdown links to sibling docs are banned. Refs inside backtick code spans or fenced code blocks are treated as syntax examples and skipped by the validator. [E]
- Resolution rule: a ref resolves iff its target appears in the [[INDEX]] doc table with status `planned` or `live` — NOT if the file exists. Sibling docs are authored in parallel on separate branches, so file-existence checks would fail every branch; the INDEX listing is the single source of truth. `CONVENTIONS` and `INDEX` are always valid targets. Validator-enforced. [E]
- Never delete a cross-ref because the target file is absent on your branch; check the [[INDEX]] listing instead. [E]

### Size and hygiene

- ≤250 lines per doc, measured by `wc -l`. The budget forces density; if exceeded, cut filler first, weakest `[H]` bullets second, never the skeleton. Validator-enforced. [E]
- Every `*.md` file in this directory except `INDEX.md` and `CONVENTIONS.md` must be listed in the INDEX doc table (those two are infrastructure, exempt from listing and not doc content). `INDEX.md` is exempt from per-doc checks; `CONVENTIONS.md` is not — it passes its own rules. Do not add stray `.md` files: the validator sweeps the whole directory. [E]
- Run `bash claude/design-guidelines/validate.sh <FILE>` while writing and the full `bash claude/design-guidelines/validate.sh` before done; exit 0 required. [E]

## Decision guide

| Situation | Do |
|---|---|
| Writing a new doc | Copy the five-heading skeleton, write Purpose first, tag every Principles/Rules bullet, run `validate.sh <FILE>` |
| Citing a sibling doc | Write `[[NAME]]`; confirm NAME is in the INDEX doc table; ignore whether the file exists |
| Unsure `[E]` vs `[H]` | Can you name the study or consensus? yes → `[E]`; no → `[H]` |
| Doc exceeds 250 lines | Cut filler → cut weakest `[H]` bullets → propose a doc split via INDEX; never drop skeleton sections |
| Rule has no number | Find the threshold or demote the rule to a `[H]` principle |
| Validator red, cause unclear | Read the `FAIL:` lines — each names the doc, the check, and (for tag failures) the line number |

## Cross-refs

- [[INDEX]] — the router and the listing that cross-refs resolve against; load it before any doc.
