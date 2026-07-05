# CHECKLISTS

## Purpose

Pre-ship audit gates. Load at review time — feature-complete, design review, or pre-deploy — and run only the checklists the Decision guide routes to. Every item is binary: pass, fail, or explicitly waived with a written reason.

## Principles

- Checklists catch omission errors, not judgment errors: experts skip steps under load, and externalizing the steps removes reliance on working memory (WHO surgical checklist cut complication rates ~36%; Gawande, *The Checklist Manifesto*). Use them for "did we forget", never as a substitute for design thinking. [E]
- Items must be binary and observable. "Is the contrast good?" invites motivated reasoning; "body text ≥4.5:1?" has one answer. Fuzzy items decay into rubber-stamping because each pass without consequence lowers perceived importance. [E]
- Run at gates, not continuously. Mid-creation auditing triggers premature convergence and kills exploration; the gate creates a distinct evaluative mindset separate from the generative one. [H]
- Order items by cost-of-late-discovery: structural failures (IA, identity, a11y semantics) before surface failures (copy, polish), because rework cost grows with how much is built on top of the flaw. [E]
- A waived item needs a named owner and a one-line reason. Silent skips make the checklist lie, and the next reader inherits a false "all green". [E]
- Cap any checklist at ~12 items. Beyond that, completion rates drop and items get pencil-whipped; split by domain instead of growing one master list. [H]

## Rules

### Running a checklist

- Run each item against the artifact, not the plan — screenshots, builds, live URLs. Claims about intent always pass; evidence sometimes fails. [E]
- Record result per item: `pass` / `fail` / `waived(owner, reason)`. Any `fail` blocks ship until fixed or converted to a waiver. [E]
- The person who built it does not solo-run the audit: creators see intent, not artifact (inattentional blindness to own work). Pair or swap. [E]

### New-feature checklist

- Problem statement exists: one sentence naming the user, the trigger, and the outcome — features without one optimize for the builder, not the user. [E]
- The feature is reachable in ≤3 taps/clicks from its natural trigger context, or has an explicit deep-link/notification path. Each extra step loses users (drop-off compounds per screen). [E]
- Empty, loading, error, and success states are all designed — four states minimum; the default happy-path-only build fails the first real user. [E]
- Destructive or irreversible actions require confirmation or undo; undo preferred (confirmation fatigue makes people click through, undo forgives the slip after it happens). [E]
- Every new UI element uses existing tokens/components from [[PATTERN_LANGUAGE]]; a new component is justified in writing or rejected. Entropy grows one "just this once" at a time. [E]
- Copy is in product voice, no placeholder text ("Lorem", "TODO", "Coming soon") anywhere in the build. [E]
- The feature has a kill/measure plan: one metric that says it worked, checked at a named date. Unmeasured features accrete forever. [H]

### Accessibility checklist

- Text contrast ≥4.5:1; ≥3:1 for large text (≥24px or ≥19px bold) and for essential non-text UI (borders, icons, focus rings) — WCAG 2.2 AA. [E]
- All functionality operable by keyboard alone: tab order follows visual order, no traps, visible focus indicator ≥3:1 against adjacent colors. [E]
- Touch/pointer targets ≥44×44px (24×24 absolute WCAG minimum) with ≥8px spacing — motor-precision floor for tremor, gloves, transit use. [E]
- Nothing conveyed by color alone: every color signal doubled by icon, text, weight, or pattern (~8% of men have color-vision deficiency; see [[COLOR_SYSTEMS]]). [E]
- Images carry alt text (or `alt=""` if decorative); form fields have programmatic labels; page/screen has a logical heading hierarchy. Screen readers navigate structure, not pixels. [E]
- All motion respects reduced-motion preference; nothing flashes >3 times/second (photosensitive seizure threshold); auto-playing media is pausable. [E]
- Content reflows at 200% zoom / 320px width without horizontal scrolling or loss of function. [E]
- Time limits are extendable or absent; session expiry warns before data loss. [E]
- Full inclusion model — cognitive, situational, temporary disability — per [[ACCESSIBILITY_AND_INCLUSION]]; this list is the mechanical floor, not the ceiling. [E]

### Emotional-design checklist

- The intended feeling at each key moment is named (calm, competent, delighted, urgent) — unnamed tone drifts to neutral-corporate. [H]
- First-use moment contains one designed positive surprise (peak) and the last step ends clean (peak–end rule: memory is dominated by peak and end, not average). [E]
- Error messages blame the system, not the user, and name the next action ("Couldn't save — retry?" not "Invalid input"). Blame triggers defensiveness; direction restores control. [E]
- Waiting and empty states carry personality or usefulness, never blank silence — dead air reads as broken and erodes trust. [E]
- Delight is placed off the critical path: sparingly in repeated flows (charm decays to annoyance with repetition), freely in rare moments. See [[EMOTIONAL_DESIGN]], [[MICROINTERACTIONS]]. [H]
- Nothing manipulative shipped: no fake urgency, no confirm-shaming, no hidden opt-outs. Short-term conversion, long-term distrust. [E]

### Performance checklist

- Interaction feedback within 100ms (perceived-instant ceiling); flows keep pace at 1s; anything >10s needs progress + escape hatch (Nielsen/Card thresholds). [E]
- First meaningful content <2s on the median target device/network — not the dev machine; test throttled. [E]
- Every wait >300ms shows state: skeletons for structure-known loads, spinner + label otherwise, determinate progress bar when duration is estimable. Uncertainty, not duration, drives abandonment — see [[PERFORMANCE_PERCEPTION]]. [E]
- Layout is stable during load: no content shifts after first paint (CLS <0.1); late-arriving elements reserve their space. Shifts cause mis-taps and read as jank. [E]
- Animations hold 60fps on the low-end target device; drop the effect rather than the frame rate — stutter is more noticeable than absence. [E]
- Optimistic UI for high-success actions (likes, toggles, sends) with visible reconciliation on failure. [H]

### UX checklist

- Every screen answers in <5s of looking: where am I, what can I do, how do I get back. Fails → IA problem; see [[INFORMATION_ARCHITECTURE]]. [H]
- Primary action is visually singular per screen — one dominant CTA; competing peers split decision and depress action rates (Hick's law: choice time grows with option count). [E]
- System status is always visible: current location marked in nav, in-progress operations shown, sync/save state legible. [E]
- User input is never lost: forms survive navigation/refresh, drafts persist, back button never destroys work without warning. Loss events are trust cliffs. [E]
- Language is the user's, not the org's — no internal jargon, feature codenames, or DB field names in UI copy. [E]
- Common tasks tested end-to-end with a person who didn't build it; task success and wrong-turn count recorded, not vibes. Five users expose ~85% of usability problems (Nielsen). [E]
- Recognition over recall: options visible or suggested, never memorized across screens (working-memory span ~4 chunks). [E]

### Identity checklist

- Squint test: blur the screen (or stand 2m back) — is it recognizably yours by color, type, and shape alone, or could any competitor's logo sit on it? [H]
- At least one intentional signature element per surface — a distinctive type choice, color relationship, motion behavior, or compositional habit that recurs across the product; see [[ANTI_HOMOGENIZATION]]. [H]
- Zero banned clichés present: purple-gradient-on-dark, glassmorphism-everywhere, emoji-bullet walls, stock-generic illustration style. [E]
- Every visual choice traceable to the design system or a written exception — same input produces same output across screens ([[VISUAL_DECISION_ENGINE]]). [H]
- Tone of copy passes the mask test: with the logo removed, would a regular user still identify the voice? [H]
- Controlled imperfection is present and deliberate — one place where the grid, palette, or rhythm intentionally breaks to create memorability, per [[PHILOSOPHY]]. [H]

### Deployment checklist

- Rollback path exists and was exercised — a revert someone has actually run, within the last quarter, not a theory. [E]
- Feature-flagged or staged rollout for anything touching a core flow: 1–5% canary before 100%; blast radius is a choice you make in advance. [E]
- Monitoring in place before launch: error rate, latency, and the feature's success metric on one dashboard with alert thresholds set. [E]
- Analytics events for the new surface fire and are verified in the pipeline pre-launch — you can't retro-instrument the launch spike. [E]
- Cross-environment sweep done: the supported browser/device/OS matrix from [[MULTI_DEVICE_ECOSYSTEMS]] actually loaded and exercised, not assumed. [E]
- Legal/privacy surface reviewed if data collection changed: consent copy, retention, regional rules ([[CULTURAL_AND_GLOBAL_DESIGN]] for regional norms). [E]
- Support is briefed: known limitations, FAQ, and escalation path written before users can hit them. [H]
- Launch timed for recovery: ship when the team is present the following 24–48h (not Friday 6pm) — mean-time-to-recovery beats mean-time-between-failures. [E]

## Decision guide

| Situation | Run |
|---|---|
| Feature reached "done" in tracker | New-feature + UX + Accessibility |
| Design review before build | Identity + Emotional-design (cheapest to fix pre-build) |
| Anything ships to production | Deployment, always |
| Perceived slowness reported or new heavy surface | Performance |
| Full periodic audit (quarterly) | All seven, structural-first: UX → Accessibility → Performance → Identity → Emotional-design |
| Item fails but ship is urgent | `waived(owner, reason)` in writing, ticket filed — never silent skip |
| Checklist feels too long to run | Split it or cut weakest items; do not skim it |

## Cross-refs

- [[ACCESSIBILITY_AND_INCLUSION]] — full inclusion model when any a11y item fails or scope is unclear.
- [[EMOTIONAL_DESIGN]] — mechanisms behind the emotional-design items; load when tone is being designed, not just audited.
- [[PERFORMANCE_PERCEPTION]] — perceived-speed techniques when performance items fail but backend budget is spent.
- [[ANTI_HOMOGENIZATION]] — remediation when the identity checklist fails the squint test.
- [[VISUAL_DECISION_ENGINE]] — the decision system the identity checklist audits against.
- [[PATTERN_LANGUAGE]] — component reuse rules referenced by the new-feature checklist.
- [[INFORMATION_ARCHITECTURE]] — when UX items fail on orientation/navigation.
- [[MULTI_DEVICE_ECOSYSTEMS]] — the device/browser matrix the deployment sweep runs against.
