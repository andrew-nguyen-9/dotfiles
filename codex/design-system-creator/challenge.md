# challenge.md — the living-system pass

A design system that is only written decays into a template: safe, dated, increasingly generic as the product outgrows it. Challenge is the standing appointment that keeps it alive — a routine, adversarial pass that tries to make the system **more ambitious and more itself**, gated so it can never make the product less usable. Daring raises the ceiling; floors are untouchable.

## When it runs

- Cadence from `design/INDEX.md` §Cadence (set by interview P4.3) — orchestrating land steps and cleaning's docs-refresh flag it when overdue.
- On demand: "challenge the design system".
- Never as a side effect of a build mode — Update/Revamp change what the user asked; Challenge changes what nobody asked about yet.

## The pass

1. **Load** `design/INDEX.md` + `DECISIONS.md` first; JIT-load each North Star file a candidate target lives in, and each corpus doc a generator or gate names, at the step that uses it — start light, never bulk-load. The Brief's ambition and sacred list scope everything below; ambition 2 = refinement-only pass (skip generator classes marked ≥3). Any DECISIONS trial past its date is a **mandatory target** (slot 0) before the three below.
2. **Pick 3 targets:**
   - the decision with the oldest overdue `challenge-by` date,
   - the weakest differentiator — the token/component/pattern most likely to appear verbatim in any generated product (load ANTI_HOMOGENIZATION + the candidate's file to judge),
   - one wildcard, rotating FOUNDATIONS → UI-KIT → VOICE → PATTERNS: the file after the last `wildcard:<FILE>`-tagged DECISIONS entry (none → FOUNDATIONS). Tag this pass's entry the same way — DECISIONS is the rotation's memory.
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

   Alternatives must be concrete (new hex, named face, ms + easing — never "consider a bolder palette") and must strengthen the Brief's `anchor:` object, not just differ.
4. **Gate — auto-reject before the user sees anything:**
   - any §Floors breach (contrast, target size, reduced-motion, focus visibility),
   - pattern recognizability broken (a control users can no longer identify as itself — load PATTERN_LANGUAGE to judge),
   - change budget: a single pass may alter ≤20% of the table rows (`grep -c '^|'`) in any one of FOUNDATIONS / UI-KIT / VOICE / PATTERNS — identity drift comes from many small daring moves, not one rebrand-by-stealth (that's Revamp, which the user initiates). **DECISIONS.md is append-only and exempt** — the log rows this pass must append don't count against the budget.
   - **both alternatives for a target survive the gate → keep only the stronger as the single `proposed`** (never present two proposals for one target — one pass advances a target at most one step).
5. **Present** survivors as one manifest — `target | current | proposed | why stronger | risk` — via `request_user_input` per target: adopt / trial / reject (3 options, one per target — fits the 4-option limit even with slot 0). These answers ARE the approval (README invariant 4's one gate); step 6 executes them without re-asking. Trial = adopted with `challenge-by = <date + one cadence>` and a `trial` tag in DECISIONS — step 1's mandatory-target rule forces the next pass to keep or revert it on its merits (how it sits in the shipped product, user feedback if any, your own re-judgment against the Brief), never by default.
6. **Write** adopted changes through the standard manifest gate, append DECISIONS lines (rejections too — one line, so the next pass doesn't re-pitch them), stamp INDEX `last-challenged: <date>`, run `design/validate.sh`. **A trial re-judged as failed (slot-0 revert) is itself a gated write** — restore the pre-trial token/spec values (from the trial's DECISIONS row or git) in the same manifest; a "reverted" log line without the value restore leaves the failed trial shipped.

## Guarantees

- Zero adopted proposals is a valid outcome — an empty pass that re-confirmed the system still logs its rejects and re-arms the cadence. Forced change is churn, not life.
- A Challenge pass never grows the North Star's line count beyond its caps: every addition names what it replaces.
- Three consecutive empty passes → say so and recommend either lowering cadence or raising ambition; a system nobody can improve is either finished or unread.
