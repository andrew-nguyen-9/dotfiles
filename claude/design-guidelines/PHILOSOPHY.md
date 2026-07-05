# PHILOSOPHY

## Purpose

Root doc of the guideline system: the value hierarchy every other doc serves, the tie-breaking order when values conflict, and the rules for simplicity, tradeoffs, optimization, and the function–beauty balance. Load first on any visual or interaction decision; when two sibling docs disagree, this doc arbitrates.

## Principles

### Core stance

- Design is decision-making under constraint, not decoration. Every visual choice allocates a scarce resource — attention, working memory, trust, time — and is judged by what it buys the user, not by how it looks in a portfolio shot. [E]
- Users satisfice: they act on the first option that looks good enough, not the best one (Simon's satisficing; Krug's "don't make me think"). Design for the scanning, distracted, first-time user; the careful reader is the rare case. [E]
- Perceived quality is mostly pre-attentive: aesthetic judgment forms in ~50 ms, before any content is read (Lindgaard et al., 2006), and that first impression biases everything after (halo effect). Craft in the first screenful is therefore functional, not vanity. [E]
- Attractive things work better: positive affect broadens thinking and raises tolerance for minor friction (Norman's emotion–usability link; aesthetic–usability effect, Kurosu & Kashimura). Beauty is a usability input, not its rival. [E]
- Consistency is a loan from the user's existing knowledge (Jakob's Law: users spend most of their time on other products). Break a convention only when the payoff is visible to the user, not just to the designer. [E]
- Character is a requirement, not a garnish: a product that is merely correct is forgettable, and forgettable products lose to distinctive ones at equal utility. One deliberate signature element per product minimum — see [[ANTI_HOMOGENIZATION]]. [H]
- Every element is guilty until proven necessary. The default answer to "should we add X?" is no; the burden of proof sits on addition, never on omission. [H]

### Decision hierarchy

- When values conflict, resolve in this fixed order — a lower value may never override a higher one: 1) safety and accessibility, 2) task success (can the user do the thing), 3) comprehension (do they understand state and options), 4) efficiency (time, steps, effort), 5) emotional resonance and delight, 6) brand and self-expression, 7) novelty. [H]
- The hierarchy is a veto chain, not a weighting: a 10% gain at level 5 never justifies a 1% loss at level 2. Mechanism: losses at fundamental levels compound (a failed task ends the session; a bland one merely dulls it), while gains at higher levels only polish. [H]
- Ties within a level break toward the lower-numbered neighbor's proxy metric: e.g., two equally efficient layouts → pick the more comprehensible one; two equally delightful motions → pick the faster one. [H]

## Rules

### Simplicity

- Simplicity is measured, not felt: count interactive elements, choices, and visual groups per screen. Choices per decision point ≤ 5±2 before chunking or staging is mandatory (working-memory span, Miller/Cowan); each added option measurably slows choice (Hick's Law: T = b·log2(n+1)). [E]
- Remove before you shrink, shrink before you hide, hide before you nest. Rationale: removal cuts cognitive load to zero; hiding merely defers it and adds a discovery cost paid by every new user. [H]
- Simplify the task, not just the screen: fewer steps beats prettier steps. A flow change that removes one screen outranks any visual polish on the screens that remain. [H]
- Tesler's Law bound: total task complexity has a floor — you can move complexity between user and system but not delete it. Push complexity toward the system when the cost is one-time engineering; leave it with the user only when their control is the point (expert tools). [E]
- The 80/20 gate: the primary action of a screen must be identifiable by a first-time viewer in ≤ 5 seconds (five-second test). If it fails, demote or remove secondary elements until it passes — never fix it by making the primary element louder while keeping the noise. [E]
- Progressive disclosure over amputation: when a feature serves <20% of users but serves them critically, stage it behind one deliberate step rather than deleting it or foregrounding it. [E]

### Tradeoffs

- Never trade silently: every accepted cost is written down as "we accept X to get Y, revisit when Z". Unrecorded tradeoffs get re-litigated forever and drift toward the loudest stakeholder. [H]
- Density vs. clarity: raise information density until comprehension degrades, then step back one notch. Data-rich screens for repeat professional use tolerate 2–3× the density of first-run consumer screens because users amortize learning cost over sessions (see [[DATA_VISUALIZATION]]). [H]
- Consistency vs. optimality: a locally-better-but-inconsistent control must beat the consistent one by a wide margin (rule of thumb: ≥ 2× on the metric it targets) to pay for the system-wide predictability it breaks. [H]
- Speed vs. certainty: for reversible actions optimize speed (act, then allow undo); for irreversible ones optimize certainty (confirm, preview, or delay). Undo beats confirmation dialogs wherever technically possible — confirmations are habituated away within days, undo is not. [E]
- Flexibility vs. usability: every axis of user configurability adds testing surface and decision cost; each new option must name the user segment that needs it. Defaults do the flexing — 90%+ of users never change a default, so the default IS the design. [E]
- Novelty budget: at most one unfamiliar interaction pattern per flow. Novelty spends comprehension (level 3) to buy distinctiveness (level 6); two unknowns in sequence and the user loses the ability to attribute confusion. [H]

### Optimization

- Optimize the perceived, not the measured: perceived wait, perceived control, perceived progress. A 3 s wait with honest progress feels shorter than 1.5 s of frozen UI (see [[PERFORMANCE_PERCEPTION]]). Instrument both, but rank fixes by the perceived metric. [E]
- Optimize the distribution, not the average: design to the 95th-percentile session (slow network, long name, 200 items, screen reader), and the median gets better for free. The reverse is false — median-first design breaks at the edges where trust is decided. [H]
- One primary metric per screen, declared before designing (task completion, time-to-first-action, error rate — pick one). Screens optimized for "everything" optimize nothing; secondary metrics become guardrails with explicit floors, not co-targets. [H]
- Local maxima are the default failure mode of iteration: A/B-style tweaks hill-climb the current design. Schedule structural alternatives (different layout archetype, different flow shape) at fixed intervals, not only when metrics stall. [H]
- Stop conditions are part of the optimization: define "good enough" numerically before starting (e.g., completion ≥ 95%, error < 2%), then stop. Past that point, effort spent polishing has higher return at levels 5–6 (resonance, character) than at levels 2–4. [H]
- Never optimize a level below its veto threshold for a gain above it (see hierarchy). Dark-pattern check: if the "optimization" raises the business metric by lowering user comprehension or control, it is a defection, not a design improvement. [E]

### Function–beauty balance

- Sequence rule: function first in structure, beauty first in impression. Layout, hierarchy, and flow are derived from the task; surface (color, type, texture, motion) is where character lives. Never invert — decorative structure is the signature AI-slop failure. [H]
- Beauty must be load-bearing: every aesthetic move also does functional work — color encodes state, type scale encodes hierarchy, motion encodes causality, texture encodes affordance. Ornament that encodes nothing is the first cut under any budget pressure. [H]
- The aesthetic–usability effect is a loan, not a gift: attractive interfaces get forgiveness for early friction, but the debt comes due — sustained failure under a beautiful surface reads as deception and craters trust below plain-but-honest levels. Cash the loan by fixing the friction it hides. [E]
- MAYA rule (most advanced, yet acceptable — Loewy): push distinctiveness to the edge of familiarity, not past it. Test: a first-time user should say "unusual, but I know what to do", never "what is this?". [E]
- Controlled imperfection beats sterile perfection: optical corrections over geometric truth (overshoot round glyphs, optically center icons), slight asymmetry over dead symmetry where it aids scanning. Mechanism: human perception normalizes geometry; hand-tuned deviation reads as craft (see [[HUMAN_PERCEPTION]], [[MATHEMATICAL_DESIGN]]). [E]
- Budget beauty explicitly: fixed share of screen real estate and motion time may serve character alone — up to ~10% of either. 0% yields sterile; >10% competes with the task. Spend it in one place (a signature moment), not smeared thin everywhere. [H]

## Decision guide

| Situation | Do |
|---|---|
| Two docs/rules conflict | Apply the decision hierarchy: lower-numbered value wins; record the tradeoff |
| Stakeholder wants to add an element | Demand the necessity proof; offer removal or progressive disclosure first |
| Screen fails the 5-second primary-action test | Remove/demote secondary elements; do not amplify the primary |
| Choosing between fast-but-risky and slow-but-safe interaction | Reversible → fast + undo; irreversible → preview/confirm |
| Design feels generic | Spend the novelty budget on one signature element — [[ANTI_HOMOGENIZATION]] |
| Metric improves but users seem confused | Check the veto chain; suspect a dark pattern; revert if comprehension dropped |
| Iteration stalls at "fine but flat" | Stop polishing levels 2–4; invest in levels 5–6 ([[EMOTIONAL_DESIGN]]) |
| Unsure whether beauty move is justified | Ask what it encodes; if nothing, it competes for the ≤10% character budget |
| Need concrete scoring for a visual call | Route to [[VISUAL_DECISION_ENGINE]] |
| Pre-ship sanity check | Run [[CHECKLISTS]] |

## Cross-refs

- [[VISUAL_DECISION_ENGINE]] — operationalizes this hierarchy into scoreable steps; follow for any concrete visual call.
- [[ANTI_HOMOGENIZATION]] — how to spend the novelty budget and pick a signature element.
- [[EMOTIONAL_DESIGN]] — designing levels 5–6 (resonance, delight) once fundamentals pass.
- [[HUMAN_PERCEPTION]] — the perceptual mechanisms behind the 50 ms impression and optical correction.
- [[MATHEMATICAL_DESIGN]] — quantitative tools for the "measurable simplicity" rules.
- [[PERFORMANCE_PERCEPTION]] — perceived-speed optimization referenced under Optimization.
- [[DATA_VISUALIZATION]] — density–clarity tradeoff applied to data-heavy screens.
- [[CHECKLISTS]] — pre-ship audit that enforces the veto chain.
