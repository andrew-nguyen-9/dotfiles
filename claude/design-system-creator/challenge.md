# challenge.md — the living-system pass

A design system that is only written decays into a template: safe, dated, increasingly generic as the product outgrows it. Challenge is the standing appointment that keeps it alive — a routine, adversarial pass that tries to make the system **more ambitious and more itself**, gated so it can never make the product less usable. Daring raises the ceiling; floors are untouchable.

## When it runs

- Cadence from `design/INDEX.md` §Cadence (set by interview P4.3) — orchestrating land steps and cleaning's docs-refresh flag it when overdue.
- On demand: "challenge the design system".
- Never as a side effect of a build mode — Update/Revamp change what the user asked; Challenge changes what nobody asked about yet.

## The pass

1. **Load** `design/INDEX.md` + `DECISIONS.md` only. Ambition level (P4.1) and sacred list (P4.2) scope everything below; ambition 2 = refinement-only pass (skip generator classes marked ≥3).
2. **Pick 3 targets:**
   - the decision with the oldest overdue `challenge-by` date,
   - the weakest differentiator — the token/component/pattern most likely to appear verbatim in any generated product (judged against ANTI_HOMOGENIZATION),
   - one wildcard, rotating by file so every North Star file is hit over a cycle of passes: FOUNDATIONS → UI-KIT → VOICE → PATTERNS.
   Sacred elements are skipped even when they match.
3. **Generate 2 alternatives per target**, each grounded in a corpus doc loaded JIT for it:

   | Generator | Corpus doc | Min ambition |
   |-----------|-----------|--------------|
   | Structural steal from a natural system | BIOMIMICRY | 4 |
   | Type voice swap (distinctive over safe) | UNDISCOVERED_TYPE_LIBRARY | 3 |
   | Motion signature (own the transition) | MOTION_AND_SPATIAL_BEHAVIOR | 3 |
   | De-homogenize (kill the template look) | ANTI_HOMOGENIZATION | 2 |
   | Emotional reweight (what should this moment feel like?) | EMOTIONAL_DESIGN | 2 |
   | Sensory channel add (sound/haptic where silent) | SENSORY_DESIGN | 4 |
   | Adaptive behavior (interface changes itself) | GENERATIVE_AND_ADAPTIVE_UI | 5 |
   | Mathematical re-derivation (grid/scale from a better constant) | MATHEMATICAL_DESIGN | 3 |

   Alternatives must be concrete (new hex, named face, ms + easing — never "consider a bolder palette") and must strengthen the P1.2 anchor object, not just differ.
4. **Gate — auto-reject before the user sees anything:**
   - any §Floors breach (contrast, target size, reduced-motion, focus visibility),
   - pattern recognizability broken (a control users can no longer identify as itself — PATTERN_LANGUAGE),
   - change budget: a single pass may alter ≤20% of FOUNDATIONS token lines — identity drift comes from many small daring moves, not one rebrand-by-stealth (that's Revamp, which the user initiates).
5. **Present** survivors as one manifest — `target | current | proposed | why stronger | risk` — via `AskUserQuestion` per target: adopt / trial / reject. Trial = adopted with `trial until <date + one cadence>` in DECISIONS; next pass keeps or reverts it by evidence (usage, feedback, your own re-judgment), never by default.
6. **Write** adopted changes through the standard manifest gate, append DECISIONS lines (rejections too — one line, so the next pass doesn't re-pitch them), stamp INDEX `last-challenged: <date>`, run `design/validate.sh`.

## Guarantees

- Zero adopted proposals is a valid outcome — an empty pass that re-confirmed the system still logs its rejects and re-arms the cadence. Forced change is churn, not life.
- A Challenge pass never grows the North Star's line count beyond its caps: every addition names what it replaces.
- Three consecutive empty passes → say so and recommend either lowering cadence or raising ambition; a system nobody can improve is either finished or unread.
