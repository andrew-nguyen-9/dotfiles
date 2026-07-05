# MOTION_AND_SPATIAL_BEHAVIOR

## Purpose

Decides how anything moves: durations, easing, choreography, what a transition means, and how the interface's implied 3D space stays coherent. Load when designing transitions, animated state changes, scroll behavior, or any spatial navigation model.

## Principles

- Motion is information first, decoration second. Every animation answers one of: where did this come from, where did it go, what caused it, what can I do now. An animation answering none of these is noise — cut it. [E]
- The visual system is tuned for motion onset: peripheral vision detects movement far better than detail, and abrupt onset captures attention involuntarily (attentional capture, Yantis & Jonides 1984). Motion is therefore the loudest channel you own — spend it like a scarce budget, not a garnish. [E]
- Objects that move share a fate: elements animating together on the same trajectory are perceived as one group (Gestalt common fate). Choreograph related items with shared direction/timing to bind them; desynchronize unrelated items to keep them separate. [E]
- Physical plausibility lowers comprehension cost. Users carry lifelong intuitions about mass, momentum, and friction; easing that mimics them (accelerate from rest, decelerate to stop) lets the motor-prediction system track the object instead of re-parsing the frame. Linear easing reads as mechanical/broken for spatial movement. [E]
- Spatial memory outlasts visual memory. Users remember WHERE things went better than what they looked like; a consistent spatial model (hierarchy has an axis, peers share a plane) lets navigation run on cheap spatial recall instead of expensive re-orientation. [E]
- Perceived speed beats actual speed. Motion masks latency: a 300ms transition that starts instantly feels faster than a 150ms response after a 150ms blank freeze, because the system visibly reacted. See [[PERFORMANCE_PERCEPTION]] for the waiting-state layer. [E]
- Duration should scale with distance and size, but sublinearly: doubling travel distance should add roughly 30–50% duration, not 100% — constant-duration feels frantic at large distances, linear-scaled feels sluggish. [H]
- More motion is not more polish. Past the point where causality is legible, added animation raises time-on-task and irritation (users disable it). The ceiling of good motion design is invisibility: users report the app "feels fast/smooth" and cannot name a single animation. [E]

## Rules

### Motion hierarchy

- Rank every animation into one tier and budget accordingly: 1 = structural (navigation, layout change; always animated), 2 = feedback (press states, form responses; animated, subtle), 3 = decorative (ambient, brand flourish; ≤1 concurrently visible, first thing cut under performance or accessibility constraints). [H]
- One primary mover per transition. A single element (the "hero") carries the large movement; everything else supports at ≤50% of its displacement or opacity delta. Two simultaneous heroes split attention and double perceived duration. [H]
- Concurrent-motion cap: ≤3 independently timed element groups moving at once. Beyond that, common fate breaks down and the scene reads as visual noise. Stagger overflow items into the same group instead. [H]
- Ambient/looping motion (spinners excepted) must sit below attention-capture threshold: no hard onsets, cycle period ≥3s, displacement ≤4px or opacity delta ≤10%. Anything stronger competes with tier-1/2 motion for peripheral attention. [H]

### Timing systems

- Build durations as a token scale, not per-case values: e.g. 100/200/300/500ms steps (a ~1.5–2× ratio scale, same logic as type scales — see [[MATHEMATICAL_DESIGN]]). Ad-hoc durations drift and make the product feel inconsistent even when no single screen is wrong. [H]
- Operating band: 100–500ms for UI motion. <100ms reads as instantaneous (fine for feedback, wasted on spatial cues); >500ms is perceived as waiting and users start re-tapping. Micro-feedback 100–150ms; local transitions 150–300ms; full-screen/spatial transitions 300–500ms. [E]
- Easing defaults: ease-out (fast start, slow settle) for elements entering or responding to user input — the instant onset acknowledges the action; ease-in for exits the user dismissed; ease-in-out for on-screen relocation. Reserve linear for opacity-only fades and continuous progress. [E]
- Overshoot/spring is an emphasis marker: reserve bounce for tier-2 feedback celebrating success or drawing the eye; never on structural navigation (adds 100–200ms of settle and reads as unstable architecture). Damping ratio ≥0.7 keeps springs ≤1 visible overshoot. [H]
- Stagger list/grid entrances at 20–50ms per item, cap total cascade at ~300ms (drop per-item delay as count grows). Staggering converts a wall of simultaneous movement into a readable sequence; past 300ms it becomes a queue the user waits on. [H]
- Animate only compositable properties (transform, opacity) for anything tier-1; layout-triggering properties (width, top, margin) drop frames on low-end devices. Sustained <60fps (or <90 on high-refresh) is worse than no animation: judder breaks the physical-plausibility illusion. [E]

### Attention steering

- Motion onset is the strongest involuntary attention magnet you control — stronger than color or size. Use it only where you want the eye NOW (new message, destructive-action confirm, error field); every incidental animation drains the same channel. [E]
- To redirect attention across the screen, move a bridging element along the path (e.g. item flies to cart): the eye tracks trajectory, arriving where you need it. A thing appearing in a new place without trajectory forces a visual search costing ~200–600ms plus the chance of missing it entirely. [E]
- Urgency maps to frequency and onset sharpness: gentle 1–2 cycle pulse = "when you get a chance"; sharp repeated motion = "now". Match the signal to actual urgency — crying-wolf animation trains users to ignore your alert channel. [H]
- Never move content the user is currently reading or about to tap. Late layout shifts cause mis-taps and lost reading position (why CLS is a core web metric); reserve space, or animate only elements below/outside the user's engagement point. [E]

### Transition semantics

- Fix a transition vocabulary and never reuse a meaning: fade = existence change (appear/disappear, no spatial relation); slide/push = peer navigation on one axis; scale-up-from-source = parent→child (detail grows out of its trigger); shared-element morph = same object, new state. Consistent grammar lets users read structure from motion alone. [H]
- Every transition must be semantically reversible: back must mirror forward (slide-left in → slide-right out; scale-up in → scale-down out to the source). Asymmetric pairs break the mental map — the user "returns" to a place they never saw themselves leave. [H]
- Modal/overlay entry must not use the peer-navigation gesture (e.g. horizontal slide): overlays sit on a Z-layer above the page, signaled by fade+scale or bottom-sheet rise plus scrim. Using the navigation gesture implies the user traveled somewhere, so they look for "back" instead of "dismiss". [H]
- Destructive or irreversible outcomes get distinct exit motion (e.g. collapse/shrink-away) never shared with recoverable dismissals. If delete and archive look identical in motion, users learn nothing from having watched one happen. [H]

### Spatial continuity

- Declare one spatial model per product — which axis means hierarchy (usually Z or scale), which means peer sequence (usually X), which means content flow (usually Y) — and document it beside your motion tokens. Violations cost re-orientation on every navigation. [H]
- Shared-element transitions: an element present in both views must travel continuously between its two positions/sizes, never blink out and reappear. Object permanence is pre-attentive; teleporting elements force a re-search and sever the causal link between views. [E]
- Origin honesty: expanding content grows from the element that spawned it (the tapped card, the pressed button), and collapses back to it on dismissal. The trigger→result trajectory is what encodes causality. [H]
- Scroll is direct manipulation: content tracks the finger/wheel 1:1 with no added easing while engaged; inertia and snap apply only after release. Snap points must sit ≥1 viewport apart and never fight reading — a scroll that overrides intent reads as a broken input device. [E]
- Preserve scroll and spatial state on back-navigation. Returning to a reset list discards the user's spatial memory of "where I was" — the single most common continuity break in feed-style products. [E]

### Interaction movement

- Pressed elements respond within 100ms — even if the real response is pending, start the press state immediately; that window is the perceptual boundary for "I caused that". See [[MICROINTERACTIONS]] for the feedback-loop layer. [E]
- Draggable elements track the pointer 1:1 during drag; on release, animate to the resolved position in 150–300ms ease-out. Constrained drags (edge of range, invalid target) apply resistance — displacement ∝ 0.3–0.5× pointer delta — so the boundary is felt before it is hit. [H]
- Gesture-driven transitions are scrubbed, not triggered: swipe-back progresses proportionally with the finger and is cancelable mid-gesture; commit/rollback at release based on velocity + displacement threshold. A gesture that fires a fixed animation on touch-start feels like a tripwire. [E]
- Cancelled or invalid actions animate the rollback (snap-back, shake ≤300ms, ≤3 oscillations): the return trajectory tells the user the system understood but refused, distinguishing "rejected" from "broken". [H]
- Honor `prefers-reduced-motion` (and platform equivalents): replace tier-1 spatial movement with ≤150ms opacity fades, kill tier-3 entirely, keep tier-2 feedback minimal and displacement-free. Vestibular disorders make large parallax/zoom physically nauseating — this is a hard requirement, not a preference. See [[ACCESSIBILITY_AND_INCLUSION]]. [E]

## Decision guide

| Situation | Do |
|---|---|
| New animation proposed | Which question does it answer (origin/destination/cause/affordance)? None → cut. Then assign tier 1/2/3 |
| Picking a duration | Feedback 100–150ms · local 150–300ms · full-screen 300–500ms; snap to nearest token |
| Picking easing | Entering/responding → ease-out · dismissed exit → ease-in · relocation → ease-in-out · fade/progress → linear |
| Navigation transition | Peer → slide on peer axis · child → scale from source · overlay → fade/rise + scrim · back mirrors forward |
| Element exists in both views | Shared-element morph — travel, never teleport |
| Need the user to look somewhere | Bridge with trajectory or a single sharp onset at the target; check nothing else moves that frame |
| Animation feels janky | Compositable properties only; still <60fps → shorten or drop to fade |
| Scene feels chaotic | Count movers: >3 groups or >1 hero → merge into common-fate groups or cut tier-3 |
| `prefers-reduced-motion` set | Spatial movement → ≤150ms fades · tier-3 off · feedback displacement-free |

## Cross-refs

- [[DYNAMIC_SYSTEMS]] — motion as ongoing system behavior (live data, ambient state) rather than discrete transitions.
- [[MICROINTERACTIONS]] — the trigger→feedback→loop anatomy that interaction movement rules plug into.
- [[HUMAN_PERCEPTION]] — attentional capture, peripheral vision, and object permanence mechanisms cited here.
- [[PERFORMANCE_PERCEPTION]] — latency masking, skeletons, and waiting states where motion covers real delay.
- [[ACCESSIBILITY_AND_INCLUSION]] — reduced-motion requirements and vestibular safety in depth.
- [[SENSORY_DESIGN]] — pairing motion with haptics/sound for multi-channel feedback.
