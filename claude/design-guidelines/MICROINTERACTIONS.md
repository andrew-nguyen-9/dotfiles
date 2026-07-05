# MICROINTERACTIONS

## Purpose

Rules for the small interactive moments — feedback, hover, loading, success/failure, haptics — and for deciding when a flourish is delight versus distraction. Load when designing any single-action response: button press, toggle, form submit, pull-to-refresh, notification.

## Principles

- Every microinteraction is a loop: trigger → rules → feedback → loops/modes (Saffer's model). Design all four explicitly; the failures users hate are almost always missing feedback or unconsidered repeat-loops, not bad triggers. [E]
- Feedback exists to answer exactly one question: "did the system receive my action, and what is it doing now?" Any animation that doesn't answer that question is decoration and must justify itself under the delight budget below. [H]
- Perceived response beats actual response. The brain binds action to reaction within ~100ms as "I did that" (sense of agency); past that window, causality weakens and users re-press, double-submit, and distrust. [E]
- Habituation is the governing curve: the 1st confetti burst delights, the 40th is noise the user resents. Emotional payoff of identical stimuli decays with repetition, so feedback intensity must be inversely proportional to action frequency. [E]
- State changes users cause should feel continuous, not teleporting: an element that morphs (checkbox → checkmark, button → spinner) preserves object permanence and reduces re-orientation cost versus a hard swap. [E]
- Microinteractions carry brand more durably than splash screens: a signature toggle sound, spring curve, or refresh gesture is encountered thousands of times and becomes identity. Pick 1–2 signature moments; keep the rest quiet. [H]
- Feedback must be multimodal-redundant at the moment of consequence: visual + (haptic or sound) for destructive or money-moving actions, because eyes are frequently elsewhere on mobile. Never encode outcome in one channel only. [E]

## Rules

### Feedback timing (the three thresholds)

- ≤100ms: respond to every input within 100ms or the action feels ignored (Nielsen/Miller response-time limits). The response may be trivial — pressed state, ripple, cursor change — but it must be visible. [E]
- 100ms–1s: show a state change but no progress indicator; the user's flow of thought survives ~1s uninterrupted. A spinner here is noise. [E]
- >1s: show an indeterminate indicator (spinner/skeleton); >10s (or variable/network-bound): show determinate progress + what's happening, and expect users to task-switch — design for return. [E]
- Touch feedback (pressed state) appears on touch-down, not touch-up: it confirms registration ~70–100ms earlier and lets the user slide off to cancel. [E]
- Debounce the trigger, not the feedback: disable re-submission within 500ms of a tap but show pressed state instantly; double-fire prevention must never delay acknowledgment. [H]

### Hover

- Hover is progressive disclosure for pointer devices only; every hover-revealed affordance needs a touch/keyboard-reachable equivalent (long-press, visible-on-focus, overflow menu). Media query on hover capability, not screen width. [E]
- Hover transitions: 100–200ms ease-out in, ~50–100ms out (or instant). Slower reads as lag; asymmetry works because attention leads the cursor on entry but has already left on exit. [H]
- Delay intent-triggered popovers (tooltips, preview cards) by 300–500ms of dwell; open on cursor-crossing and you punish travel paths across the UI. Once one tooltip is open, sibling tooltips open with ~0ms delay (warm-up pattern) so scanning stays fluid. [E]
- Hover must never be the only signifier of interactivity: affordance (cursor, contrast, shape) exists at rest; hover confirms, it doesn't reveal, clickability. [E]

### Loading

- Under ~1s expected wait: show nothing extra. A spinner that flashes for 200ms makes the app feel slower and jitterier than silence. If load may straddle the threshold, delay the spinner's appearance by 300–500ms. [E]
- 1–10s: prefer skeleton screens over spinners — they shift attention to the arriving content and lower perceived duration; spinners focus attention on the wait itself. Skeletons must match the real layout (mismatched skeletons feel like a bait-and-switch). [E]
- >10s or determinate work: progress bar with steadily advancing motion; bars that accelerate toward the end and never stall are perceived as faster (Harrison et al., CHI 2010). Never let a bar sit at 99%; reserve the last 10% for the actual final step. [E]
- Label long waits with the current operation ("Encrypting…", "Uploading 3 of 7") — knowing the cause of a wait measurably raises tolerance versus an unexplained spinner. [E]
- Use optimistic UI for high-success, low-cost actions (like, rename, reorder): commit visually at once, reconcile in background, and design the rollback state (undo toast) for the <1% failure. Never optimistic for payments or destructive actions. [H]
- One loading indicator per user action. Six skeleton regions pulsing independently reads as system chaos; group them under a single rhythm. [H]

### Success and failure

- Success confirmation is proportional to stakes and frequency: routine action → 100–300ms micro-animation on the element itself (checkmark morph); rare/high-stakes action (payment, publish, first-ever completion) → up to 1–2s celebratory moment. Nothing routine gets confetti. [H]
- Announce success where the eye already is — on the control that was pressed — not only in a corner toast; foveal attention spans roughly 1–2° and corner toasts routinely go unseen. [E]
- Failure feedback answers three things in one view: what failed, why, and the next action. An error state without a recovery affordance (retry, edit, contact) is a dead end and the top driver of rage-clicks. [E]
- Never encode success/failure by color alone — pair red/green with icon + text (≈8% of men are red-green colorblind); this is the multimodal rule applied to outcome states. [E]
- A brief horizontal shake (~300–500ms, 2–3 oscillations, small amplitude) is a well-established "rejected" idiom for invalid input — it mimics a head-shake — but must accompany, never replace, a textual reason. [H]
- Errors persist until resolved or dismissed; auto-dismissing an error toast after 3s assumes the user was looking. Success toasts may auto-dismiss (3–5s); error states may not. [E]
- Peak–end rule: users judge a flow by its emotional peak and its ending, so the success moment at the end of an effortful flow is the highest-leverage 500ms in the journey — spend the craft budget there, not on step 3's button hover. [E]

### Haptics

- Haptics confirm, they don't inform: pair every haptic with a visible change within ~20ms so the modalities fuse into a single perceived event; haptic-only signals are guesswork and inaccessible to users who disable vibration. [H]
- Match intensity to semantics: light tick for selection change, medium for action confirmation, heavy/double only for warnings and failures. A vocabulary of ≤4 distinguishable patterns is all users reliably learn implicitly. [H]
- Frequency cap: continuous or per-keystroke haptics beyond a detent-style tick fatigue quickly and drain battery; scrolling lists tick at detents (item boundaries), not per pixel. [E]
- Always respect the OS-level haptic/vibration setting and provide function without it — haptics are an enhancement layer, never load-bearing. [E]

### Delight vs distraction

- Budget rule: feedback duration ≤ the time the action bought. A 150ms toggle earns ≤150ms of animation; a completed 20-step wizard can afford 1.5s. Users repeat actions; latency added by feedback compounds. [H]
- Frequency test before shipping any flourish: estimate uses/day for your median active user. >10/day → feedback must be ≤200ms, subtle, and identical every time (predictability aids automaticity); <1/week → variation and character are welcome. [H]
- Interruption test: delight must never block input. If the user can't act until the animation finishes, it's a distraction regardless of beauty; make celebrations non-modal and input-interruptible. [E]
- Honor `prefers-reduced-motion` (and platform equivalents): replace movement-based feedback with opacity/color state changes, and keep haptics/sound available as alternates. Vestibular disorders make large motion physically noxious, not merely annoying. [E]
- Controlled imperfection beats sterile symmetry: a spring overshoot of 5–10%, a hand-tuned easing, a sound with organic texture reads as crafted; perfectly linear, perfectly uniform feedback reads as template. Cap overshoot near 10% — beyond that it reads as sloppy physics. [H]
- Kill criteria for an existing flourish: users disable it, support mentions it, task time regressed, or A/B shows completion drop. Sentimental attachment is not a metric. [H]

## Decision guide

| Situation | Do |
|---|---|
| Action completes in <100ms | Pressed/active state only; no spinner, no toast |
| Wait 1–10s, content-shaped result | Skeleton matching final layout, single rhythm |
| Wait >10s or measurable steps | Determinate bar, accelerating never stalling, labeled step |
| Variable network wait | Spinner appearance delayed 300–500ms; optimistic UI if low-stakes + reversible |
| Destructive / money-moving action | Explicit confirm; multimodal outcome (visual + haptic/sound + text); never optimistic |
| Deciding celebration size | Frequency test: >10/day subtle ≤200ms; rare milestone → peak–end moment |
| Hover-only affordance on touch device | Add long-press / visible-on-focus / menu equivalent |
| Error to display | State what + why + next action, at the point of interaction, persistent until handled |
| User has reduced-motion set | Swap motion for opacity/color; keep haptic and text channels |
| Flourish feels stale in review | Run kill criteria; cut or demote to first-run-only |

## Cross-refs

- [[INTERACTION_PSYCHOLOGY]] — the cognitive mechanisms (agency, habituation, feedback loops) these rules apply.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — easing curves, springs, and choreography for the animations specified here.
- [[PERFORMANCE_PERCEPTION]] — deeper treatment of waiting, perceived speed, and time-threshold psychology.
- [[EMOTIONAL_DESIGN]] — where delight fits in the visceral/behavioral/reflective stack and brand tone.
- [[SENSORY_DESIGN]] — sound design and haptic texture beyond the confirmation vocabulary here.
- [[ACCESSIBILITY_AND_INCLUSION]] — reduced motion, color-independence, and multimodal requirements in full.
