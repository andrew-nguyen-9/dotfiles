# GENERATIVE_AND_ADAPTIVE_UI

## Purpose

Decides when and how an interface may change itself: context-aware behavior, personalized layouts, dynamic density, and generative (model-composed) UI. Load when a design adapts to user, environment, or model output instead of staying static.

## Principles

- Adaptivity spends predictability to buy efficiency, and predictability usually wins: users build spatial-motor memory of stable layouts (location learning drops target-acquisition to near-ballistic movement), so every relocation resets that learning. Adapt content before you adapt position. [E]
- Adaptable (user-configures) beats adaptive (system-decides) when prediction accuracy is uncertain — Findlater & McGrenere's menu studies showed user-controlled customization outperforming system adaptation on both speed and preference. Default to adaptable; earn adaptive. [E]
- Mixed-initiative rule (Horvitz): the system should act autonomously only when expected benefit of acting exceeds expected cost of interrupting or surprising the user. Model both sides — an unrequested change is an interruption even when silent. [E]
- Adaptation payoff is asymmetric: a wrong adaptation costs more trust and time than a right one saves, because losses loom roughly 2x gains (loss aversion) and errors demand diagnosis. Bias every threshold toward inaction. [E]
- Context is a hierarchy — device capability, environment (light, motion, network), task state, then individual history. Adapt to the coarsest signal that solves the problem; per-user modeling is the last resort, not the first. [H]
- Generative UI is a materials problem: treat model output as untrusted input that selects and fills vetted components, never as freeform markup. The design system is the safety boundary; the model gets a vocabulary, not a canvas. [H]
- Self-evolving systems need homeostasis: fixed anchor elements, bounded drift per interval, and a canonical default state to return to. Unbounded personalization converges on incoherence, not fit. [H]
- Users forgive a static mediocre layout faster than an adaptive one that guesses wrong, because agency misattribution turns system errors into felt betrayals ("it moved my button"). Explain or don't adapt. [H]

## Rules

### When to adapt at all

- Ship adaptive suggestions only when offline prediction precision ≥70%; below that, studies of adaptive interfaces (Gajos et al.) show static or adaptable variants win on speed and satisfaction. Measure before enabling. [E]
- Never relocate a control the user has activated ≥3 times from its current position; promote via duplication into a dedicated adaptive zone (top slot, "frequent" row) and leave the original in place — split-menu designs beat reordering ones for exactly this reason. [E]
- Apply visible layout changes only at natural boundaries — app launch, session start, explicit refresh — never mid-task; cap structural change at 1 per session. Mid-task mutation destroys the plan the user is executing. [H]
- Cold start: personalize nothing until ≥5 observations of the relevant behavior exist; before that, serve the device-class default. Early guesses are noise and cost trust per the asymmetry principle. [H]

### User control and legibility

- Every adaptation ships with: a visible cause ("Pinned because you open this daily"), a one-tap undo, and a "reset to default" that restores canonical state. Explanations convert surprise into perceived cooperation; unexplained adaptation reads as instability. [E]
- Manual override is permanent: once a user repositions, resizes, or dismisses an adapted element, the system never re-adapts that element without new explicit consent. Overriding an override is how trust dies. [H]
- Expose adaptivity as a setting with three levels — off / suggest (system proposes, user confirms) / auto — defaulting to suggest. Confirmation keeps the user's model synchronized with the system's. [H]

### Dynamic density

- Offer density as 2–3 discrete named tiers (e.g., compact / comfortable), not a continuous slider: comfortable ≥44px row height and touch targets (48px on Android guidance), compact ≥32px rows for pointer-only contexts. Discrete tiers stay testable and communicable; sliders create untested intermediate states. [E]
- Auto-select density only from device signals (pointer type, viewport, input modality), never from inferred user preference; let users override per the control rules above. Coarse-pointer detection is reliable; taste inference is not. [H]
- Density changes scale spacing and type together via the modular scale — line-height ≥1.3 even in compact — never by clipping padding alone; per [[LAYOUT_MATHEMATICS]], broken rhythm reads as a bug, not a mode. [H]

### Generative (model-composed) UI

- Constrain generation to a whitelist: vetted component set + design tokens + slot-based layout templates. The model chooses among parts and fills content; it never emits raw markup, styles, or novel components. This bounds the blast radius of any bad generation. [H]
- Validate every generated screen against machine-checkable contracts before render — contrast ≥4.5:1 body text, every interactive element labeled, focus order defined, tap targets ≥44px — and reject to fallback on any failure. Generated output inherits zero manual QA, so the contract is the QA (see [[ACCESSIBILITY_AND_INCLUSION]]). [E]
- Every generative surface has a deterministic fallback rendered within a fixed budget: if composition exceeds 400ms, show the static default and swap only at the next natural boundary. Blank-waiting on a model is worse than a generic screen ([[PERFORMANCE_PERCEPTION]] territory). [H]
- Keep generated UI inside the brand's constraint system — palette, type, spacing tokens only; per [[ANTI_HOMOGENIZATION]], unconstrained generation regresses to the training-set mean, which is the definition of generic. [H]
- Log every generation with its inputs and the rendered composition; sample ≥1% for human review weekly. Silent generative drift is unauditable by construction unless you build the audit trail. [H]

### Measurement and rollback

- Every adaptive or generative feature ships behind an experiment: compare against the static control on task time, error rate, and retention; auto-disable if any metric degrades >5%. Adaptivity is a hypothesis, so instrument it like one. [H]
- Personalization data: process on-device where feasible, collect behavioral profiles only with explicit opt-in, and make deleting the profile equal resetting to default. Privacy failures retroactively poison the adaptation's perceived intent. [E]

## Decision guide

| Situation | Do |
|---|---|
| Feature "could adapt automatically" | Check precision ≥70% and benefit > interruption cost; otherwise make it adaptable (user-set) |
| Want to promote a frequent action | Duplicate into a stable adaptive slot; never reorder or relocate the original |
| Choosing density behavior | Discrete tiers; auto-pick from pointer/viewport only; user override wins permanently |
| Adding model-generated UI | Whitelist components + tokens, contract-validate pre-render, 400ms fallback budget, log + sample |
| Adaptation guessed wrong (user undid it) | Freeze that element; require new explicit consent before re-adapting |
| New user, no history | Serve device-class default; wait for ≥5 observations |
| Metrics dipped after enabling adaptivity | Auto-rollback to static control; re-ship only with a revised model and a fresh experiment |

## Cross-refs

- [[DYNAMIC_SYSTEMS]] — rule-driven runtime behavior and state machines underlying adaptive changes.
- [[ANTI_HOMOGENIZATION]] — keeping generated output distinctive instead of training-set average.
- [[ACCESSIBILITY_AND_INCLUSION]] — the contracts generated UI must validate against.
- [[LAYOUT_MATHEMATICS]] — modular scale and rhythm that density tiers must preserve.
- [[PERFORMANCE_PERCEPTION]] — fallback timing and perceived wait during generation.
- [[MULTI_DEVICE_ECOSYSTEMS]] — device-class signals that drive context-aware defaults.
