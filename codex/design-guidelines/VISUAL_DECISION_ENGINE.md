# VISUAL_DECISION_ENGINE

## Purpose

The arbitration layer for every visual decision: decision trees per domain (color, type, spacing, hierarchy, motion, interaction), a priority stack for resolving conflicts between them, an override protocol, and a context-adaptation model. Load with [[PHILOSOPHY]] at the start of any visual/UI work; route deeper via the trees below.

## Principles

- Decide by tree, not by taste-in-the-moment. Bounded search (satisficing, Simon 1956) matches unbounded deliberation in outcome quality once a good-enough threshold is defined, and it preserves decision budget for the few genuinely high-stakes calls. [E]
- Defaults do 80% of the work. Each tree terminates in a default; deliberation is reserved for the ~20% of decisions where defaults conflict or context flags fire. Every avoided decision is avoided fatigue — decision quality degrades measurably across a long session (ego depletion effects replicate weakly, but choice-overload effects are robust; Hick's law: choice time grows with log2 of options). [E]
- Conflicts are resolved by stratum, not by debate. A fixed priority stack (accessibility > legibility > usability > hierarchy > identity > novelty) converts most arguments into lookups. The mechanism: consistent arbitration produces consistent output, and users read consistency as intentionality and trustworthiness. [E]
- A visual lever only works if the difference is detectable. The visual system encodes relative difference, not absolute value (Weber–Fechner); a hierarchy step below the just-noticeable difference (~1.15–1.2× in size, ~2 weight steps in type) is paid for in complexity but invisible to the user. [E]
- Every rule is a default plus documented conditions under which it bends. A system with no override path gets abandoned; a system with free overrides isn't a system. The narrow gate (see Override protocol) keeps both failure modes out. [H]
- Context is an input, not an excuse. The same tree runs everywhere — dashboard, game HUD, marketing page — but a small context vector (distance, session length, stakes, environment, expertise) shifts thresholds by fixed, pre-declared amounts. Adaptation stays reproducible instead of ad hoc. [H]
- Prefer the reversible option under uncertainty. When scored alternatives land within 10% of each other, the tiebreak is reversibility: cheap-to-undo choices let the system learn from shipping instead of stalling on analysis. [H]

## Rules

### Decision protocol (run in order)

- 1) Name the decision and its blast radius (token/component/view/system). 2) Run the matching domain tree below. 3) If two trees disagree, arbitrate via the priority stack. 4) If still tied, score (see Tradeoff scoring). 5) Record any override per the Override protocol. Skipping straight to step 4 for every decision burns budget — steps 1–3 resolve most cases. [H]
- Priority stack, highest first: accessibility floor → legibility → usability → hierarchy clarity → brand identity → aesthetic novelty. Higher stratum wins conflicts outright; scoring applies only within a stratum. [H]
- Blast radius caps deliberation time: token-level ≤ minutes (take the default), component-level ≤ an hour, system-level = deliberate fully. Effort proportional to reversibility cost. [H]

### Color tree

- Text or essential icon? → contrast ≥4.5:1 against its background; ≥3:1 for text ≥24px (or ≥18.7px bold) and for UI component boundaries (WCAG 2.x). This branch terminates before any aesthetic consideration. [E]
- Communicating state (error/success/warning/info)? → use the palette's reserved semantic hues; never repurpose them decoratively, and never encode state in hue alone — pair with icon, text, or position (≈8% of men have red-green CVD). [E]
- Utility surface (tool, dashboard, form)? → neutrals + 1 accent hue; accent covers ≤10% of the viewport area and marks only interactive or primary elements. Expressive surface (marketing, game, editorial)? → up to 2 saturated hues + neutrals, distributed near 60-30-10 (dominant-secondary-accent). Mechanism: accent scarcity is what makes accents legible as signals. [E]
- Still choosing between palettes? → follow [[COLOR_SYSTEMS]]; default to the existing system's tokens before inventing a color — every new color is a maintenance liability and a hierarchy dilution. [H]

### Typography tree

- Body size floor: ≥16px equivalent at typical viewing distance; scale by distance (~+50% for TV/10ft, ~-1–2px acceptable for glanceable wrist UI). Line length 45–75 characters; line height 1.4–1.6 for body, 1.1–1.3 for headings. [E]
- Pick the modular scale ratio by density: 1.2 (minor third) for dense/data-heavy UI, 1.25–1.333 for balanced product UI, 1.414–1.618 for editorial/marketing where few sizes coexist. Larger ratios create stronger hierarchy but waste vertical space — that is the tradeoff axis. [E]
- Pairing: ≤2 families per product; pair only faces that contrast on ≥2 axes (serif-ness, weight range, width) — near-identical pairs read as a mistake, not a choice. One variable-font family covering both roles beats a mediocre pair. [H]
- Hierarchy within a family: a step must change ≥2 of {size, weight, color} or clear the size JND (≥1.2×) to register as a distinct level. [E]
- Face selection beyond these gates → [[TYPOGRAPHY_SYSTEMS]]; for distinctive but proven faces → [[UNDISCOVERED_TYPE_LIBRARY]]. [H]

### Spacing tree

- All spacing from one base unit (4 or 8px); values on the scale {0.5, 1, 2, 3, 4, 6, 8, 12}× base. Arbitrary pixel values are the first symptom of a system decaying. [E]
- Proximity encodes relation: within-group gap ≤ 0.5× between-group gap. If two gaps are equal, the grouping is undefined and the user pays the parsing cost (Gestalt proximity). [E]
- Spacing grows with hierarchy level: roughly double the gap per level up (item→group→section). Denser context (pro dashboard) may compress to 1.5× per level; never below — sub-JND steps again. [H]
- Container widths, grids, and ratio math → [[LAYOUT_MATHEMATICS]] and [[MATHEMATICAL_DESIGN]]. [H]

### Hierarchy tree

- One primary focal point per view. Test: blur/squint — if the eye lands nowhere or everywhere, hierarchy failed regardless of how each element looks alone. [E]
- ≤3 attention levels per view (primary/secondary/tertiary); more levels collapse into noise because relative difference per step falls under the JND. [E]
- Choose the cheapest sufficient lever, in cost order: position (free — top/left bias in LTR scan patterns) → size → weight → color → motion (most expensive; peripheral vision is motion-sensitive, so motion always wins and therefore must be rationed hardest). [E]
- Emphasis is zero-sum: to promote one element, demote neighbors instead of stacking levers on the target. If everything is bold, nothing is (contrast is relative, not additive). [E]

### Motion tree

- Should it move at all? Only if motion explains causality (where did this come from), preserves continuity (what changed), or signals affordance. Decoration-only motion defaults to no. [H]
- Duration by scale: micro-feedback 100–200ms; local transitions 200–300ms; full-view or spatial reorientation 300–500ms; >500ms only when teaching a spatial model, and only the first times. Below 100ms reads as a glitch; above the band reads as lag. [E]
- Easing: ease-out for entrances (fast arrival mimics responsive causality), ease-in for exits, ease-in-out for on-screen moves; linear only for continuous progress indicators. [E]
- `prefers-reduced-motion` honored unconditionally: replace movement with opacity/instant state change; never merely shorten. This branch outranks all motion aesthetics (vestibular disorders — priority stack stratum 1). [E]
- Choreography, spatial models, shared-element continuity → [[MOTION_AND_SPATIAL_BEHAVIOR]]; springs and interruptibility → [[DYNAMIC_SYSTEMS]]. [H]

### Interaction tree

- Target size ≥44×44px touch / ≥24×24px pointer, with ≥8px between adjacent targets; smaller targets shift errors onto the user (Fitts's law: acquisition time rises as targets shrink). [E]
- Feedback latency: acknowledge input <100ms (perceived-instant threshold) even if completion takes longer; >1s shows progress; >10s must be cancelable and survive navigation. [E]
- Destructive actions: prefer undo (5–10s window) over confirmation dialogs; confirmations habituate within a handful of exposures and stop preventing errors, while undo preserves flow and actually recovers mistakes. Reserve confirmation for irreversible + rare actions. [E]
- Detail patterns and reward mechanics → [[MICROINTERACTIONS]] and [[INTERACTION_PSYCHOLOGY]]. [H]

### Tradeoff scoring (within-stratum ties only)

- Score each option 1–5 on the axes the decision touches (clarity, speed-to-ship, identity, flexibility, maintenance cost), weight axes by the context vector, sum. Highest wins; within 10%, pick the more reversible option. Timebox: one pass, no re-scoring — the method exists to end deliberation, not extend it. [H]

### Override protocol

- The accessibility floor (contrast minima, reduced-motion, target sizes, non-hue state encoding) is never overridable. Everything else can bend through the gate below. [E]
- Overriding an `[E]` rule requires all four: (1) named reason tied to a mechanism, (2) evidence from this product (test, recording, support data — not preference), (3) scope declared (component/view — never a silent global change), (4) expiry or review date recorded next to the deviation. `[H]` rules need only (1) and (3). [H]
- Two overrides of the same rule in one product = the rule is wrong for this context: change the rule (and its documented conditions) instead of accumulating exceptions. Exception piles are how systems die. [H]
- Deliberate rule-breaking for identity is legitimate — but it must be loud, singular, and chosen (one signature violation, per [[ANTI_HOMOGENIZATION]]), never the accidental residue of many small overrides. [H]

### Context adaptation

- Declare the context vector once per surface: viewing distance (wrist/phone/desktop/TV), session length (glance/task/all-day), stakes (leisure/commerce/safety), environment (glare, motion, noise), user expertise (novice/mixed/expert). [H]
- Apply fixed threshold shifts, not vibes: all-day expert tools → type ratio down to 1.2, muted accents, denser spacing (1.5× per level), motion durations at band minimums. Glance contexts (wrist, driving, TV) → sizes +25–50%, contrast ≥7:1, one action per view. High-stakes flows → confirmation+undo both, no decorative motion, hierarchy levels capped at 2. Outdoor/mobile → contrast ≥7:1 and targets +25% (glare and hand motion degrade both). [H]
- Emotional stakes modulate tone, not structure: celebration and personality live at low-stakes moments; error and payment flows run at maximum sobriety. Same trees, shifted weights — see [[EMOTIONAL_DESIGN]]. [H]

## Decision guide

| Situation | Run |
|---|---|
| Any new visual decision | Decision protocol steps 1–3; escalate to scoring only on a within-stratum tie |
| Two domain trees disagree (e.g. brand color fails contrast) | Priority stack — higher stratum wins, no scoring |
| Options scored within 10% | Reversibility tiebreak — pick the cheaper-to-undo option |
| Default feels wrong for this product | Override protocol; if the same override recurs twice, rewrite the rule |
| New surface or platform | Declare the context vector, apply its threshold shifts, then run trees normally |
| Everything looks uniformly fine but flat | Hierarchy tree — demote neighbors; check steps against the ≥1.2× JND |
| Motion request from stakeholder | Motion tree first question: causality/continuity/affordance, or decoration? |
| Pre-ship sanity pass | [[CHECKLISTS]], with the priority stack as audit order |

## Cross-refs

- [[PHILOSOPHY]] — the stance layer; load alongside this doc before any visual work.
- [[COLOR_SYSTEMS]] / [[TYPOGRAPHY_SYSTEMS]] / [[LAYOUT_MATHEMATICS]] — the deep ends of the color, type, and spacing trees.
- [[UNDISCOVERED_TYPE_LIBRARY]] — distinctive face candidates once the typography tree gates pass.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] / [[DYNAMIC_SYSTEMS]] — choreography and physics past the motion tree.
- [[MICROINTERACTIONS]] / [[INTERACTION_PSYCHOLOGY]] — interaction detail patterns and the psychology behind them.
- [[HUMAN_PERCEPTION]] — JND, Weber–Fechner, attention mechanics underpinning the thresholds here.
- [[ACCESSIBILITY_AND_INCLUSION]] — the full floor that the priority stack's top stratum summarizes.
- [[EMOTIONAL_DESIGN]] — tone modulation referenced by context adaptation.
- [[ANTI_HOMOGENIZATION]] — the signature-violation rule the override protocol points at.
- [[MATHEMATICAL_DESIGN]] — ratio and grid math behind the spacing and type scales.
- [[CHECKLISTS]] — audit companion for the pre-ship pass.
