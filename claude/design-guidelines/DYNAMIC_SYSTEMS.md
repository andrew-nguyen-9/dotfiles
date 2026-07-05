# DYNAMIC_SYSTEMS

## Purpose

Governs interfaces as systems that change over time: motion tokens, state machines, progressive disclosure, visual momentum across views, temporal pacing, adaptation rules, and emergent behavior. Load when designing anything whose behavior — not just appearance — must be specified.

## Principles

- An interface is a system evolving in time; a static mockup is one sample of it. Specify the rules of change (states, transitions, triggers), not just the frames — otherwise every unspecified moment gets improvised inconsistently in code. [H]
- Motion communicates causality. The visual system binds elements that move together (Gestalt common fate) and tracks moving objects as persistent things (object permanence), so an element that animates from its origin tells the user what caused it and where it lives — a teleporting element tells them nothing. [E]
- Progressive disclosure works because working memory holds roughly 4 chunks (Cowan, 2001). Showing everything at once doesn't inform, it forces triage; revealing on demand converts one impossible scan into several trivial ones. [E]
- Visual momentum (Woods, 1984): each view change costs reorientation effort proportional to how little carries over. Shared anchors — persistent elements, continuous motion, consistent placement — let users spend the transition updating a model instead of rebuilding it. [E]
- Time has hierarchy like space does. Sequence and duration signal importance: what appears first reads as primary, what moves longest reads as heaviest. An unplanned temporal order is still an order — just an accidental one. [H]
- Adaptation trades predictability for relevance, and predictability usually wins. Adaptive menus that reorder items slow users down because spatial memory beats recomputed relevance (Findlater & McGrenere, 2004). Adapt content and defaults; keep positions stable. [E]
- Complex, alive-feeling behavior is cheaper to build from simple local rules that compose (each component defines how it enters, exits, and reacts) than from choreographing every screen — flocking looks designed but is three rules. Emergence is a budget trick, not decoration. [H]
- Every animation is a promise about system state. Motion that lies — spinners over frozen work, bounces on failed saves — trains users to distrust all feedback. Animate only what is true. [H]

## Rules

### Motion tokens

- Define one duration scale and reuse it everywhere: ~100ms (micro feedback: hover, press), ~200ms (local element: dropdown, toggle), ~300ms (container: panel, modal), ~500ms (full-view transition). Nothing exceeds 700ms except deliberate narrative moments; sub-100ms transitions read as flicker, not motion. [E]
- Ease by direction: entering elements decelerate (ease-out — arrives fast, settles gently), exiting elements accelerate (ease-in), on-screen moves use ease-in-out. Linear easing only for continuous progress (spinners, marquees); eased progress bars misreport rate. [E]
- Scale duration with distance and size: an element crossing the full viewport gets the 500ms token, a 4px nudge gets 100ms. Same duration for all distances means wildly different perceived speeds. [E]
- Honor `prefers-reduced-motion` (or the platform equivalent): replace positional animation with a ≤150ms opacity crossfade. Vestibular disorders make large parallax and zoom physically nauseating — this token swap is an accessibility requirement, not a preference. [E]
- Stagger list entrances 20–50ms per item, capped at ~6 staggered items (rest appear together). Stagger under 20ms is invisible; over 50ms×n it becomes a queue users wait on. [E]

### State machines and transitions

- Every component ships all five canonical states: empty, loading, partial, ideal, error. The ideal state is one of five, not the design plus edge cases; an unspecified state is a developer-improvised state. [E]
- Draw the state graph and animate only along its edges. A transition between two states that share no edge (list → detail-of-other-item) routes through a shared intermediate (list) or a full-view transition — never a hard cut between unrelated layouts. [H]
- Every transition is interruptible: new input retargets the animation from its current position (position and velocity carry over — springs do this natively). Queued or input-blocking animations turn a 300ms polish into a 300ms tax per interaction. [E]
- Preserve at least one shared element across any view change (the tapped thumbnail becomes the detail header; the persistent nav stays put). Zero-continuity transitions force full reorientation — the visual-momentum cost from Principles, paid at every navigation. [E]
- Loading placeholders must reserve final layout: skeletons match content dimensions, cumulative layout shift < 0.1 (the Core Web Vitals threshold). Content that jumps after appearing breaks in-flight taps and re-triggers visual search. [E]

### Progressive disclosure

- Primary surface shows the ~20% of options that serve ~80% of use; everything else sits one disclosure behind a labeled affordance. Measure by frequency of use, not stakeholder seniority. [E]
- Maximum 2 disclosure levels for routine tasks (surface → expanded → full detail). At 3+, users lose the path back and scent of information decays; if a routine task needs level 3, the layering is wrong. [H]
- Any group exceeding ~7 simultaneous choices gets chunked or layered: recognition scan time grows with set size (Hick–Hyman law — decision time rises with the log of alternatives). [E]
- Disclosure must be signposted and reversible: the control that revealed content also collapses it, from the same location, with the count or scope of hidden content indicated (e.g. "+12 more" — never a bare ellipsis). [E]
- Disclose capability at the moment of relevance, not at first run: a feature explained in context of a matching task is retained; the same explanation in an onboarding carousel is skipped (see [[ONBOARDING_AND_LEARNING]]). [E]

### Temporal design

- Sequence by importance: on view entry, primary content settles first, secondary elements follow within 300ms total. Users commit attention to whatever renders first — don't let a sidebar win by loading order. [H]
- Response-time budgets (Nielsen, 1993, still holding): <100ms feels instant (no feedback needed beyond the result), <1s keeps flow (subtle indicator), >1s needs explicit progress, >10s needs a deferrable/backgroundable task. Design a distinct treatment per band, not one spinner for all. [E]
- Never flash a loading state: if expected latency is <300ms, show nothing rather than a sub-perceptual spinner blink. Delay indicator onset by ~300ms so fast paths stay clean. [E]
- Pace recurring dynamics (autosave pulses, refresh cycles, ambient updates) slower than user action rhythm — ambient change more frequent than roughly once per 10s competes with the task for attention. Batch and settle. [H]

### Adaptive interfaces

- Never automatically reorder or relocate persistent navigation and toolbars. Adapt by highlighting, suggesting, or pre-filling — additive layers on a stable frame — not by moving targets users have spatially memorized. [E]
- Separate ephemeral suggestions (dismissable, visually distinct, e.g. a "recently used" row) from persistent changes (defaults, saved layouts). Persistent changes require explicit user confirmation; silent permanent adaptation reads as the UI acting on its own. [H]
- Adapt only on ≥3 consistent signals of the same behavior, and make every adaptation reversible in one action from where it appears. One-off actions are noise; unreversible inference is a trap. [H]
- Frequency-adaptive content (recents, favorites) belongs in dedicated slots reserved for it from the start — an empty "recent items" region that fills is legible; list items reshuffling by usage is not. [E]

### Emergent behavior

- Specify component-level behavior rules (how any card enters, exits, reflows; how any list reorders) once, and let screens inherit them. Per-screen choreography diverges within weeks; local rules compose consistently by construction. [H]
- Dampen positive feedback loops: any mechanic where engagement triggers more of the same stimulus (autoplay chains, infinite feeds, notification-begets-notification) needs a decay term or a natural stopping point. Undamped loops maximize a metric while eroding trust and session quality. [H]
- Stress-test composed rules at the extremes before shipping: 0 items, 1 item, 1000 items, all animating at once. Emergence includes emergent failure — cap concurrent animations (~6 simultaneous moving elements) so composition degrades to batching, not chaos. [H]

## Decision guide

| Situation | Do |
|---|---|
| Picking any duration/easing | Use the token scale by element scope (micro 100 / local 200 / container 300 / view 500), ease-out in, ease-in out |
| New component spec | Write all five states + the transition graph before visual polish |
| View-to-view navigation | Identify the shared element first; no shared element → restructure or use a full-view transition |
| Too many options on one surface | Frequency-rank; top ~20% stay, rest go one labeled disclosure down (max depth 2) |
| Operation latency known | Map to the band: <100ms nothing, <1s subtle, >1s progress, >10s backgroundable; indicator onset delayed ~300ms |
| Tempted to auto-reorganize UI from usage data | Keep positions fixed; adapt via reserved slots, highlights, or confirmed defaults |
| Reduced-motion flag set | Swap positional animation for ≤150ms crossfade, keep all state feedback |
| Animation feels janky/blocking | Make it interruptible and retargetable; if it still blocks input, cut its duration or cut it |

## Cross-refs

- [[MOTION_AND_SPATIAL_BEHAVIOR]] — follow for easing curves, spatial models, and choreography detail beneath the token level set here.
- [[MICROINTERACTIONS]] — follow when designing the individual trigger-feedback loops these system rules govern in aggregate.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — follow when adaptation is model-driven or content is generated, beyond the rule-based adaptation here.
- [[PERFORMANCE_PERCEPTION]] — follow for waiting-state psychology and perceived-speed techniques behind the response-time bands.
- [[ONBOARDING_AND_LEARNING]] — follow when staging capability disclosure across sessions rather than within one view.
- [[HUMAN_PERCEPTION]] — follow for the attention and memory mechanics (working memory, motion perception) these rules apply.
