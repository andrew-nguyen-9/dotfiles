# Design System Creator

A pick-the-right-weight system for giving a repo its design **North Star** — one `design/` folder that tells every future session (UX, UI, content, dev) how this product looks, moves, and speaks. Same shape as `~/.claude/orchestrating/`: a router sizes the ask and runs the matching mode. Built on `~/.claude/design-guidelines/` (the generic corpus): the North Star is its **project-specific distillation** — decisions, not options. Once it exists, sessions load 2 small files instead of re-deriving taste from the 26-doc corpus every time.

## Start

Fresh Claude Code chat **in the target repo**:
`Read ~/.claude/design-system-creator/README.md and run it.`
(Orchestrating routes UI-heavy wishlists here; you can also run it directly.)

---

**INSTRUCTIONS TO CLAUDE — do not edit this block:**

```
Activate /caveman:caveman ultra + /ponytail:ponytail ultra if available; proceed without missing ones,
note it once. Never compress AskUserQuestion text — interview options carry consequences.
DETECT: test -f design/INDEX.md at the target repo root (canonical single location — see north-star.md Placement; a repo that forbids root dirs symlinks design/ → its docs tree, so this test still resolves).
PRESENT → also read its §Cadence: overdue = last-challenged older than the interval (monthly/quarterly); `each release` = always flag at land steps; `manual` = never auto-overdue.
Then ROUTE by state + ask:

- ABSENT, repo has no UI code        → SCRATCH  — read ~/.claude/design-system-creator/modes.md §Scratch
- ABSENT, repo has UI code/screens   → EXTRACT  — read ~/.claude/design-system-creator/modes.md §Extract
- PRESENT, bounded ask (new component, token tweak, new platform) → UPDATE — read ~/.claude/design-system-creator/modes.md §Update
- PRESENT, direction change (rebrand, pivot, "feels wrong/stale") → REVAMP — read ~/.claude/design-system-creator/modes.md §Revamp
- PRESENT, no build ask / "challenge it"                          → CHALLENGE — read ~/.claude/design-system-creator/challenge.md

A build ask (UPDATE/REVAMP) wins even when the cadence is overdue — run the ask, add a one-line "challenge overdue" flag to the handoff; a bare overdue with no build ask is the only trigger that routes straight to CHALLENGE.

State mode + one-line why naming the repo root + the evidence (INDEX present/absent, UI code found).
Ambiguous update↔revamp → UPDATE (cheap to escalate mid-run). Deliberately invoking this file IS
consent to build — but INDEX absent + zero product context to mine or ask from (empty repo, no
description) → get P0 answers before routing, don't invent a product.
```

---

## The ladder

| Mode | File | For | Interview load |
|------|------|-----|----------------|
| **Scratch** | `modes.md` §Scratch | no product design exists yet | full (P0–P4) |
| **Extract** | `modes.md` §Extract | UI exists in code, system undocumented | gaps only (P1, P4) |
| **Update** | `modes.md` §Update | North Star exists, bounded change | delta question only |
| **Revamp** | `modes.md` §Revamp | North Star exists, direction changes | identity redo (P1–P2) |
| **Challenge** | `challenge.md` | routine daring pass — keep the system alive | none (user gates output) |

## Invariants — every mode

1. **Interview before invention.** User answers outrank model taste. Question bank + batching rules in `interview.md`; `AskUserQuestion`, ≤4 questions per call, recommended default first. Never ask what the repo already answers.
2. **Corpus-grounded.** Every foundation choice loads its `~/.claude/design-guidelines/` doc first — JIT via that folder's `INDEX.md` task tables, never bulk-load. The North Star records the *decision*; the corpus keeps the *reasoning*.
3. **Floors never regress.** Accessibility, target size, motion-reduction, focus visibility live in `design/INDEX.md` §Floors. Any mode's output breaching a floor is auto-rejected — including (especially) Challenge. Daring is a ceiling game, not a floor game.
4. **One manifest.** All writes into `design/` go into one `action | path | reason` table → one approval → execute. Mirrors cleaning's approval gate.
5. **Living, versioned in-place.** Every accepted decision appends one line to `design/DECISIONS.md` (`date | decision | why | challenge-by`). Git history is the archive — no `design/v2/` folders.
6. **DoD.** `bash design/validate.sh` green (structure, caps, floors present) before "done". Created by Scratch/Extract from the template in `north-star.md`.
7. **Written for strangers.** The North Star assumes zero chat context: any future independent session, human or agent, must be able to act on it alone. No AI attribution anywhere.

## Files

- `README.md` — this file: entry + router
- `interview.md` — phased question bank + mode→phase matrix + answer recording format
- `modes.md` — shared build spine + Scratch / Extract / Update / Revamp deltas
- `challenge.md` — the living-system pass: routine, adversarial, floor-gated
- `north-star.md` — target `design/` folder: file skeletons, caps, agent load map, validate.sh template
- `ui-kit.md` — component inventory, spec format, states/a11y minimums, optional Claude Design sync
- `validate.sh` — self-check for THIS folder (pointers resolve, caps, portable paths)

## Token economics

Creation is paid once (~one session). Every later session then loads `design/INDEX.md` (≤80 lines) plus at most one role file — instead of re-loading corpus docs and re-litigating taste. Levers baked in: JIT agent load map (`north-star.md`), hard line caps per file, tables over prose, decisions-not-alternatives (rejected options live only in `DECISIONS.md` one-liners), repo-mined answers over interview rounds, and Challenge's ≤20%-change budget keeping diffs small.

## Sibling systems

- `~/.claude/orchestrating/` — UI-touching units load the target repo's `design/INDEX.md`; UI-heavy wishlist with no North Star → router suggests this system first.
- `~/.claude/cleaning/` — medium+ docs-refresh verifies `design/` claims against shipped UI and flags an overdue challenge cadence.
- `~/.claude/design-guidelines/` — the corpus underneath; load via its INDEX task tables only.
