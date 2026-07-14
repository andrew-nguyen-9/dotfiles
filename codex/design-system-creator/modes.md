# modes.md — build spine + mode deltas

All four build modes run the same spine; each section below states only its deltas. Challenge is not a build mode — it lives in `challenge.md`.

## The spine

1. **Survey.** Repo root tree, stack files, existing `design/` or brand assets, deployed URL if named. A scan, not an index.
2. **Interview.** Per the mode→phase matrix in `interview.md`. Record answers as the Brief.
3. **Corpus load (JIT).** Open `~/.codex/design-guidelines/INDEX.md`, take the matching task rows, load ONLY those docs. Scratch/Revamp baseline: the "new brand / visual identity" row (PHILOSOPHY, COLOR_SYSTEMS, TYPOGRAPHY_SYSTEMS, ANTI_HOMOGENIZATION) + LAYOUT_MATHEMATICS (step 5 derives the type/space scales from it). Extract baseline: COLOR_SYSTEMS + TYPOGRAPHY_SYSTEMS + LAYOUT_MATHEMATICS — codification, not invention (add PHILOSOPHY/ANTI_HOMOGENIZATION only for `correct-in-system` rows). Add rows the Brief triggers (data-viz needed → DATA_VISUALIZATION; native apps → MULTI_DEVICE_ECOSYSTEMS; motion signature → MOTION_AND_SPATIAL_BEHAVIOR).
4. **Directions.** Draft 2–3 genuinely distinct design directions. Each = palette seed (5 hex) + type pairing + spacing base + one line tying it to the Brief's anchor object. Present via `request_user_input` using its per-option `preview` field, one direction per option (text spec: the 5 hex + faces + base, no mockup files); the pick becomes the system's spine. One direction must be the daring one — never three safe variants. Skip when P0.4 = full brand book (the book is the direction). Extract: collapses to ONE choice — codify the mined direction as-is vs one corrected direction (mined + census inconsistencies resolved), presented the same way.
5. **Fill.** Write the target files from the skeletons in `north-star.md`, components per `ui-kit.md`. Derive, don't invent: every token traces to Brief + chosen direction + corpus rule (e.g. type scale ratio from LAYOUT_MATHEMATICS, contrast pairs validated per COLOR_SYSTEMS).
6. **Floors self-check.** Fill `design/INDEX.md` §Floors from P2.4 + platform minimums; verify every FOUNDATIONS contrast pair and UI-KIT target size against them before showing the user anything.
7. **Manifest + approve.** One `action | path | reason` table of all `design/` writes → one approval → write.
8. **Validate.** `bash design/validate.sh` green (script written as part of the manifest, from the template in `north-star.md`).
9. **Handoff.** Print the one paragraph future sessions need: where the North Star lives, the agent load map line, the challenge cadence. Ran inside an orchestrating cycle → print its cleaning kickoff line: `Read ~/.codex/cleaning/README.md and run it.`

## §Scratch

- Full interview (P0–P4), full spine.
- No repo evidence for step 1 beyond stack choice — the P1.2 anchor object and adjective pairs carry the differentiation weight; push on them until they'd embarrass a template.
- Build order: INDEX → FOUNDATIONS → UI-KIT (P3.1's eight components only; inventory rows beyond that get `planned` status) → VOICE → PATTERNS → DECISIONS (first entry: the chosen direction + rejected directions, one line each) → validate.sh.

## §Extract

- Mine first, ask second: census existing UI — CSS custom properties, tailwind/theme config, component directory listing, the 5 primary screens (nav entries / route-tree centrality; browser tools if reachable, else source). Build a `found | value | confidence` table: high-confidence rows seed confirm-round defaults, low-confidence rows become the confirm-round's open questions, and the table lands verbatim as a manifest appendix (its afterlife is git history).
- Interview per matrix: P1 + P4 full; P2–P3 presented as confirm-rounds seeded with mined values.
- **Utility-class stacks are tokens in disguise.** No `--color-*` vars but a tailwind/theme config → that config IS the FOUNDATIONS source: map each mined value to its role token and record the mapping as a `token → source key` column in FOUNDATIONS (e.g. `--color-accent → blue-600`), so codified components satisfy "tokens only" without a rewrite.
- **Code vs intent conflicts** (mined button uses 6 grays, user says "calm and minimal") are findings, not silent fixes: they ride the step-7 manifest as per-row `codify-as-is` vs `correct-in-system` picks (one request_user_input, exempt from the interview round budget). The North Star records intent; a `## Drift` section in DECISIONS names where shipped code disagrees, as future cleanup units.
- Components: every existing component gets an inventory row (status `live`, `code:` pointer). Full ≤10-line specs for the P3.1 eight only; remaining `live` rows stay one line until an Update touches them — 40 full specs would blow UI-KIT's 250-line cap. Gaps the user needs → `planned`. Never spec-from-imagination what code already answers.

## §Update

- Bounded: one new component, a token adjustment, a new platform target. One delta question max (`interview.md` round budget); no re-interview.
- Edit only the files the delta touches + append one DECISIONS line. Blast radius check: token changes list every UI-KIT spec consuming that token in the manifest.
- Floors and Brief are read-only in this mode — an update that wants to move either is a Revamp; say so, get user go, and re-route to §Revamp in the same run (rounds already spent count toward Revamp's budget). Same continuation as §Escalation below — don't terminate the session.

## §Revamp

- Direction change with continuity: re-run P1–P2 (P0 confirm only), keep §Floors (they may tighten, never loosen) and the component inventory. **P2.4 is re-asked as a confirm-round offering only the current bar or tighter** (never the generic AA default — that would loosen an AAA floor, which Invariant 3 forbids over Invariant 1's "answers outrank taste"); a user who explicitly demands a looser floor owns it via a DECISIONS entry, it is not a defaultable pick.
- Full spine including step 4 directions — but each direction preview also shows the delta from the current system (old→new palette and type, side by side).
- Ship a migration map in the manifest: `old token → new token | affected specs` for every changed foundation. UI-KIT specs re-point to new tokens in the same pass — a revamp that leaves dangling tokens is red.
- DECISIONS entry names what the revamp rejected from the old system and why; version line in INDEX bumps (`v2 — YYYY-MM-DD — <one-line reason>`).

## Escalation

Update discovering it needs new foundations → Revamp (say so, re-route mid-run). Extract → Scratch only when the census finds NO shared source of truth at all (no theme config, no common CSS, styles per-page ad hoc) — a messy-but-shared tailwind config is still Extract; inconsistent component usage is Extract's normal workload, not an escape hatch. `design/` present but `validate.sh` missing (hand-made folder) → write it from the `north-star.md` template first; present but red → fix structure first; then run the routed mode.
