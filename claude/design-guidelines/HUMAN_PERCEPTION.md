# HUMAN_PERCEPTION

## Purpose

How human vision, attention, memory, emotion, and decision machinery actually process an interface. Load when deciding what users will notice, group, remember, feel, or choose — before styling anything.

## Principles

- Perception is inference, not photography: the brain predicts scenes from sparse retinal data and fills gaps with priors (predictive processing). Designs that match priors feel instant; designs that violate them cost a double-take. Violate priors only on purpose, one element at a time. [E]
- Preattentive features — color hue, luminance contrast, size, orientation, motion — are detected in parallel in under 250ms before conscious attention. Anything encoded in one of these pops out regardless of clutter; anything requiring conjunction of two features forces a serial search (~40–60ms per item). [E]
- Gestalt grouping is automatic and hierarchical: proximity beats similarity, similarity beats common region, closure and continuity fill in what is not drawn. Users read structure from geometry before reading a single word — spacing IS information architecture. [E]
- Working memory holds ~4 chunks (Cowan, 2001; Miller's 7±2 measured spans, not chunks). Every item a user must hold to complete a step consumes a slot; exceed 4 and errors and abandonment climb. Externalize state instead of asking users to remember it. [E]
- Attention is a spotlight with inhibition: focusing on one region actively suppresses surroundings (biased competition). One strong focal point sharpens everything; two competing focal points blur both — salience is zero-sum. [E]
- Emotion precedes cognition: affective judgment of a screen forms in ~50ms from color, density, and symmetry (Lindgaard et al., 2006), and this first impression anchors trust and perceived usability (aesthetic-usability effect). You cannot argue a user out of a bad 50ms. [E]
- Recognition beats recall by an order of magnitude in speed and accuracy: showing options is cheaper than asking users to generate them. Menus, autocompletes, and recently-used lists are memory prosthetics, not conveniences. [E]
- Peak–end rule: users remember the emotional peak and the final moment of an experience, not its average. Budget polish for the hardest step and the exit, not uniformly. [E]
- Change blindness: alterations outside the attention spotlight go unseen, especially across view transitions or scroll. If state changes off-focus, users behave as if it never happened — motion or persistence must escort the change into the spotlight. [E]
- Decisions are made by fast heuristic System 1 and audited (rarely) by slow System 2 (Kahneman). Defaults, framing, and option order decide most outcomes; explicit deliberation is the exception. Design the default path as the recommendation it effectively is. [E]
- Perceived quality is mostly processing fluency: high figure-ground contrast, aligned edges, and consistent rhythm are metabolically cheap to parse, and the brain misattributes that ease to "good" and "trustworthy". [E]
- Foveal vision covers ~2° (about a thumbnail at arm's length); everything else is low-resolution peripheral vision tuned to motion and luminance change. Detail placed outside the current fixation is invisible until fixated — peripheral elements communicate through contrast and motion only. [E]

## Rules

### Gestalt and grouping

- Space between groups ≥ 2× space within groups; grouping reads instantly at 3:1. If you need a divider line or box, your spacing ratio failed first — fix spacing before adding ink. [E]
- Related controls within ~8° visual angle (~80–120px at desktop distance) group by proximity; a label must sit closer to its own field than to the neighboring field, minimum 2:1 ratio. [E]
- Use similarity (same hue, shape, or size) to bind items across distance when proximity is impossible — max one similarity channel per grouping role, or groupings contradict each other. [E]
- Common region (background card, band) overrides proximity — use it only when spacing alone cannot separate, because every enclosure adds one boundary the eye must parse. [E]
- Exploit closure: an interrupted grid or a card cut by the viewport edge implies continuation and invites scroll; fully-contained compositions above the fold read as "page complete" and suppress scrolling. [E]

### Attention and eye behavior

- Text-heavy pages are scanned in an F-pattern (two horizontal sweeps, then a left-edge vertical skim); image-led or centered layouts pull a Z. Place must-see content on the pattern for your layout type: first 2 lines, left edge, terminal corner. [E]
- Front-load meaning: the first 11 characters of a heading or link carry most of its scan value (users fixate ~2 words per line while skimming). "Pricing — Teams" beats "Learn more about our team pricing". [E]
- One primary focal point per view; make it win on ≥2 preattentive channels (e.g., size + saturation). Every additional competing salient element measurably dilutes fixation share on the primary. [E]
- Faces and high-contrast figures capture fixation involuntarily within ~200ms; a photographed gaze cues attention in its look direction. Point depicted gaze at the CTA, never off-canvas. [E]
- Motion in periphery preempts everything — reserve it for genuinely interruptive events. Autoplaying or looping decoration adjacent to reading content degrades comprehension; anything animating >3s or looping needs a pause control. [E]
- Banner blindness: users suppress regions that look like ads (right rail, top strip, boxed high-saturation graphics). Never style critical content in ad geometry or ad palette. [E]

### Cognitive load and memory

- ≤4 items to hold mentally at any step: comparison sets, wizard state, code segments. Chunk anything longer (phone, card, and reference numbers in groups of 3–4). [E]
- Persist cross-step context on screen (cart contents, selected plan, form progress) — recall requests are error generators. If a step needs data from a previous step, show it, don't test for it. [E]
- Menus and pickers: expose ≤7 top-level choices; beyond that, group into labeled categories (recognition over search) or provide typeahead. Hick's law — decision time grows with log2(N) of equally likely options. [E]
- Progressive disclosure: default view carries only what 80% of users need; the rest sits one labeled interaction away. Every always-visible rarity is a permanent tax on every visit. [E]
- Instructional text: one action per sentence, ≤14 words, imperative first word. Reading grade ≤8 for interface copy regardless of audience sophistication — expert users are cognitively busy, not slow. [E]
- Consistency is compression: identical actions look identical everywhere (position, icon, label), so users learn once and pattern-match after. Each visual synonym for the same action forces re-learning. [E]

### Emotion and trust

- Design the 50ms impression deliberately: viewport-level color harmony, visual balance, and moderate density are judged before any content is read. Test a blurred screenshot — if hierarchy and mood don't survive blur, the first impression is noise. [H]
- Mild positive affect broadens attention and creativity; anxiety narrows it to threat scanning. Error and payment flows: strip decoration, maximize clarity and reversibility. Exploratory flows: warmth and personality earn engagement. [E]
- Never fight limbic priors: red = stop/danger/error across most UI contexts — a red primary "Continue" button raises hesitation. Align semantic color with learned affect unless brand deliberately subverts it (then see [[CULTURAL_AND_GLOBAL_DESIGN]] for locale risk). [E]
- Place your best moment at the hardest step and end every flow on a competent note (confirmation with next action, not a dead end) — peak–end memory decides whether users return. [E]
- Micro-delays without feedback read as system doubt: acknowledge input within 100ms, show progress past 1s, explain past 10s (see [[PERFORMANCE_PERCEPTION]] for the full latency ladder). [E]

### Decision behavior

- Defaults decide: preselect the recommended safe option; opt-out rates stay low because System 1 accepts the path of least resistance. Never default users into self-harming choices (dark pattern; destroys trust measured in churn). [E]
- Order effects: first position in a list gets disproportionate choice share in visual scanning; last position wins in spoken or sequential presentation. Put the recommended plan first or spatially emphasized center, not buried mid-list. [E]
- Comparison sets of 3 with one clearly-dominated decoy shift choice toward the target (asymmetric dominance). Use to clarify honest trade-offs, not to bury the fair option. [E]
- Loss framing outweighs gain framing roughly 2:1 (prospect theory) — "Don't lose your drafts" outperforms "Keep your drafts" for protective actions. Cap loss framing at one instance per flow; stacked threat framing reads manipulative and triggers reactance. [E]
- Choice overload is real past ~10 undifferentiated options: engagement rises but conversion falls. Cut, categorize, or rank — never present a flat wall of equivalents. [E]
- Uncertainty is the top abandonment driver at commitment points: surface price, duration, and reversibility ("free for 30 days, cancel anytime, 2 steps") before the button, not behind it. [H]

## Decision guide

| Situation | Do |
|---|---|
| Users miss an important element | Give it a preattentive edge (size or saturation), move it onto the F/Z scan path, and demote one competing salient element |
| Interface feels cluttered but nothing is removable | Fix grouping first: 2–3× between-group spacing, one similarity channel per role, remove boxes/dividers made redundant |
| Users forget info across steps | Persist it on screen; never rely on recall for anything >0 steps old |
| Long option list, low completion | ≤7 top-level groups, typeahead, ranked or recommended default |
| State changes but users don't react | Change happened outside the spotlight — animate the transition or move feedback to the current fixation region |
| Choosing between two flows' polish budgets | Fund the peak (hardest moment) and the end; average polish is invisible to memory |
| Copy is accurate but people misread it | Front-load first 11 chars, one action per sentence, ≤14 words, grade ≤8 |
| A nudge feels effective but icky | If it exploits System 1 against the user's interest, it's a dark pattern — redesign; trust loss compounds |

## Cross-refs

- [[LAYOUT_MATHEMATICS]] — spacing scales and grids that implement Gestalt ratios numerically.
- [[INTERACTION_PSYCHOLOGY]] — behavior models, habit loops, and motivation built atop these perceptual constraints.
- [[EMOTIONAL_DESIGN]] — designing the affective layer the 50ms judgment and peak–end rules describe.
- [[PERFORMANCE_PERCEPTION]] — time perception, latency thresholds, and waiting-state psychology in depth.
- [[DATA_VISUALIZATION]] — preattentive encoding channels ranked for accurate data reading.
- [[ACCESSIBILITY_AND_INCLUSION]] — perceptual floors (contrast, motion sensitivity, cognitive load) as hard requirements.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — using peripheral motion capture deliberately instead of accidentally.
