# PERFORMANCE_PERCEPTION

## Purpose

Decides how waiting is experienced: perceived vs actual speed, which waiting-state treatment fits which latency band, and how to mask latency you cannot remove. Load when designing loading states, transitions around slow operations, or when users report "slow" despite acceptable metrics.

## Principles

- Perceived duration, not measured duration, drives satisfaction — users judge speed by felt experience and remembered experience, and both are manipulable independently of wall-clock time. Fix perception first when actual latency is already under interaction thresholds; fix latency first when it is not. [E]
- Three response-time bands govern cognition (Miller 1968; Nielsen 1993): ≤0.1s feels instantaneous (direct manipulation holds); ≤1s keeps flow of thought (delay noticed, no feedback needed); ≤10s holds attention (feedback mandatory). Beyond 10s users task-switch and the session is mentally abandoned. [E]
- System response under ~400ms sustains user engagement and raises the user's own input tempo — productivity compounds (Doherty threshold, IBM 1982). Budget interactive round-trips against 400ms, not 1s. [E]
- Occupied time feels shorter than idle time; uncertain waits feel longer than known waits; unexplained waits feel longer than explained ones (Maister 1985, service-queue psychology — mechanisms replicate in UI). Every waiting state should occupy, bound, or explain. [E]
- Memory of a wait follows peak-end, not average (Kahneman & Fredrickson duration neglect): the worst moment and the final moment dominate recall. A wait that visibly accelerates at the end is remembered as fast even when total time is unchanged. [E]
- Duration changes below ~20% are not noticeable — Weber's law applied to time perception. Optimizations under that threshold are invisible to users; spend them on the perception layer instead, or bank them until they compound past 20%. [E]
- Active feedback resets the patience clock: users tolerate roughly 2–3x longer waits when given determinate progress plus a mechanism ("indexing 400 files…") than when facing a static screen, because visible causality signals the system is working, not hung. [H]
- Expectation is half of perception: experienced speed is judged against promised speed. Underpromise durations ("about 30 seconds" for a 20s job) so reality beats the anchor; overpromising converts an acceptable wait into a broken promise. [E]

## Rules

### Latency bands and treatments

- 0–100ms: render the result or a state change directly; any spinner here reads as slowness that does not exist. Touch/click acknowledgment (pressed state) must land inside this band or input feels dropped. [E]
- 100–300ms: no progress indicator — mask with the interaction's own transition (element morph, view slide). Indicators this brief register as flicker and make the product feel busier than it is. [E]
- 300ms–1s: local feedback on the triggering control (button enters working state, label swap); still no global spinner or skeleton. [E]
- 1–10s: mandatory visible progress. 1–3s: indeterminate indicator or skeleton; 3–10s: determinate progress (percent, count, or step N of M) — indeterminate spinners past ~4s read as hangs. [E]
- >10s: move the work to the background — let the user leave, keep a live status affordance, and notify on completion. Always expose cancel for waits >3s; trapped waiting is the peak-pain moment peak-end memory keeps. [E]
- Delay every indicator's appearance by 100–300ms so responses that arrive fast never flash a loading state; a skeleton shown for 150ms is pure noise (perceived as jank, communicates nothing). [E]

### Skeleton screens

- Use skeletons for structured content loads (feeds, cards, detail pages) expected to take 500ms–3s; use spinners only for unstructured or unpredictable-shape waits. Skeletons work by pre-committing layout — the brain starts parsing structure before content arrives, so arrival feels like completion, not start. [H]
- Skeleton geometry must match final layout: same block count, positions, and dimensions within ~10%. Target zero layout shift on content arrival (CLS contribution 0); a skeleton that reflows on fill is worse than a spinner because it breaks the pre-parsed model. [E]
- Animate skeletons with a slow left-to-right shimmer (1.0–1.5s cycle) rather than opacity pulse; wave motion is perceived as shorter waiting than pulse or static placeholders. Faster cycles read as urgency and lengthen perceived wait. [H]
- Fill skeletons progressively as fragments arrive (text before images, first items before later ones) — never hold rendered data hostage to the slowest fragment. Each fill event is evidence of progress and resets the patience clock. [E]

### Progress indication

- Determinate progress must be monotonic: never move backwards, never sit at 100%. If estimation is uncertain, map real progress onto a curve that accelerates toward the end — end-accelerating bars are perceived as faster than linear ones at identical duration (Harrison et al., CHI 2007), and a fast finish is what peak-end memory stores. [E]
- Never let a bar stall >2s without a state change; on stall, switch to explanatory text ("still working — large file") rather than freezing. A frozen bar is read as a crash within ~3s. [H]
- For multi-stage waits, show stage labels ("uploading → processing → done"): explanation converts unexplained wait to explained wait, and stage transitions provide the change-events retrospective time estimates are built from — more events, shorter remembered wait. [E]
- Time estimates: show only when accuracy is within ±30%; round up and finish early. "About 1 minute" that ends at 40s beats "30 seconds" that ends at 45s — the anchor, not the duration, sets the verdict. [E]

### Latency masking and progressive rendering

- Render in visual-hierarchy order: layout frame, above-the-fold text, interactive controls, images, below-fold. Users judge "loaded" by the largest visible content block and by when they can act — align with Core Web Vitals thresholds: LCP <2.5s, INP <200ms, CLS <0.1. [E]
- Start work before the user finishes asking: prefetch on hover/press-intent (hover-to-click gap averages 150–300ms), preload the next likely view during idle, warm caches during animations. Latency hidden inside the user's own motor time is free. [E]
- Use transition animations of 200–400ms to absorb operation latency: a view change that animates while data loads converts dead wait into occupied time. Never stretch an animation past 500ms to hide slower work — users detect padding and it becomes the lie that poisons trust in all your motion. [H]
- Optimistic UI: apply the user's mutation locally at interaction time and reconcile with the server after, when operation success rate exceeds ~99%; below that, rollbacks are frequent enough to breach trust. On failure, revert visibly with an undo path — never silently. [H]
- Cache and replay the previous state during refresh (stale-while-revalidate): showing slightly old data instantly beats showing fresh data in 2s for glanceable content. Mark staleness only when the data is decision-critical. [H]
- Split perceived start from actual start: acknowledge the command instantly (band 0–100ms), even if the backend queues it. First feedback latency, not completion latency, sets the "responsive vs sluggish" verdict. [E]

## Decision guide

| Situation | Do |
|---|---|
| Operation ≤100ms | Show result directly; no indicator, no transition padding |
| 100–300ms | Mask inside the interaction's transition; nothing extra |
| 300ms–1s | Working state on the triggering control only |
| 1–3s, structured content | Skeleton matching final layout, shimmer 1.0–1.5s |
| 1–3s, unpredictable shape | Indeterminate spinner, appearance delayed 100–300ms |
| 3–10s | Determinate progress + stage labels; expose cancel |
| >10s | Background the work; status affordance + completion notification |
| Users say "slow", metrics fine | Audit first-feedback latency, indicator flicker, end-of-wait experience (peak-end) |
| Optimization gains <20% | Ship perception fixes instead; bank gains until >20% |
| Duration estimate unreliable (±>30%) | Show stages or counts, not time |
| Mutation succeeds >99% | Optimistic UI with visible revert + undo on failure |

## Cross-refs

- [[HUMAN_PERCEPTION]] — underlying attention and time-perception mechanisms these rules exploit.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — transition durations and easing used for latency masking.
- [[MICROINTERACTIONS]] — designing the acknowledgment and working states themselves.
- [[INTERACTION_PSYCHOLOGY]] — expectation-setting, trust, and the cost of broken promises.
