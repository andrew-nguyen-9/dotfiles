# PATTERN_LANGUAGE

## Purpose

Decides which reusable interaction, navigation, attention, and information patterns to apply, how to compose them into coherent systems, and which anti-patterns to refuse. Load when designing or reviewing any recurring UI structure — flows, screens, components — before inventing a new one.

## Principles

- A pattern is a named, recurring solution to a recurring problem in a context: problem + forces + resolution + consequences (Alexander, *A Pattern Language*, 1977; Gamma et al. carried it to software). A pattern without a stated problem and mechanism is decoration, not a pattern. [E]
- Patterns work through recognition, not recall: users transfer expectations from thousands of prior exposures (Jakob's Law — users spend most of their time on other products). Matching the expected pattern moves interaction from slow deliberate processing to fast automatic processing; deviation is a cost you must repay with clear benefit. [E]
- Composition is grammar: patterns are words, screens are sentences. A screen mixing >3 novel patterns overloads working memory (~4 chunks; Cowan 2001) because nothing can be processed automatically. Budget novelty: one unfamiliar pattern per view, everything else convention. [E]
- Every pattern has a load profile — what it demands of attention, memory, and motor precision. Choose by matching the profile to the user's context (expert vs first-run, calm desk vs one-handed transit), not by aesthetic preference. [E]
- Forces conflict; patterns resolve trade-offs, not eliminate them. Progressive disclosure trades discoverability for simplicity; infinite scroll trades sense-of-place for continuity. Naming the traded-away quality is what lets you compensate for it elsewhere. [E]
- Anti-patterns persist because they optimize a local metric (clicks, sign-ups, session length) while damaging the global one (trust, retention). Any pattern whose success depends on user misunderstanding is an anti-pattern by definition. [E]
- A house pattern language — your product's specific dialect of the common patterns — is the cheapest durable differentiator: consistent internal grammar reads as craftsmanship even when every individual pattern is conventional. [H]

## Rules

### Interaction patterns

- Direct manipulation over form-and-submit when the object is visible and the action is spatial (drag to reorder, resize, crop): visible objects + immediate feedback + reversible actions shorten the gulf of execution (Shneiderman 1983; Hutchins/Hollan/Norman 1985). Keep feedback latency <100 ms or the illusion of manipulation breaks. [E]
- Undo over confirm for reversible actions: confirmation dialogs get automatized within ~5 exposures and stop preventing errors, while undo preserves flow and still recovers mistakes. Reserve confirmation for irreversible + destructive actions only, and make the dialog state the consequence, not "Are you sure?". Undo window: 5–10 s visible affordance. [E]
- Progressive disclosure: show the 20% of options that serve 80% of uses; place the rest exactly one interaction away behind a labeled expander ("Advanced", "More"). Never nest disclosure >2 levels — each level hides features from discovery, and level-3 features effectively don't exist. [E]
- Defaults do the work: users accept defaults 90%+ of the time in field studies (Jarrett; opt-out organ-donation natural experiments, Johnson & Goldstein 2003). Every default is a recommendation you are accountable for — set it to the safe, most-common choice, never the business-favorable one. [E]
- Input pattern selection: free text only when the answer space is unbounded. ≤5 mutually exclusive options → radio/segmented control (all visible); 6–15 → dropdown; >15 or user-known value → type-ahead search. Mechanism: recognition beats recall, but scanning cost grows linearly with visible options. [E]
- Forgiving formats: accept every unambiguous input variant (phone with/without dashes, dates in local order) and normalize in code. Rejecting parseable input shifts machine work onto the user — inverted effort economics. [E]
- Wizard (multi-step) only when steps have real dependencies or the task is rare + high-stakes; otherwise single scrollable form. Wizards hide progress context; if used, show step count and allow backward navigation without data loss. 3–7 steps; >7 means the task needs restructuring. [E]

### Navigation patterns

- Choose topology by collection shape: hub-and-spoke for ≤5 independent task areas (mobile tab bar); hierarchy/drill-down for containment trees; faceted search for large flat collections (>100 items with orthogonal attributes); sequential for processes. Mixing topologies within one level breaks the user's spatial model. [E]
- Persistent global navigation ≤7 top-level items, one always marked "you are here". Mechanism: navigation doubles as a map; without a current-location marker users rebuild position from memory each glance. [E]
- Breadcrumbs whenever hierarchy depth ≥3: they cost one line, cut back-button round-trips, and expose the schema. Path-style (ancestors), not history-style. [E]
- Search is a navigation pattern, not a feature: when users can name what they want, type-ahead search beats any browse tree (query formulation ~2–5 s vs multi-level scan). Provide both; instrument which wins per task and rebalance. [E]
- Hamburger/overflow menus halve engagement with their contents versus visible tabs (multiple A/B replications, e.g. NN/g mobile studies): out of sight is out of mind. Permissible only for genuinely secondary items; never bury a primary task behind one. [E]
- Infinite scroll only for ranked, non-exhaustive feeds where any stopping point is acceptable. It destroys position memory, footer access, and "I finished" closure — for goal-directed browsing use pagination or load-more (which preserves a place marker). [E]
- Deep-link every stable state: URL/route per screen and per meaningful filter combination. Navigation patterns that trap state in session memory break sharing, history, and recovery. [E]

### Attention patterns

- One focal point per view: establish a dominance hierarchy where the primary element carries ≥3× visual weight (size × contrast × isolation) of secondary elements. Two equal maxima force a serial scan-and-compare loop and read as indecision. See [[HUMAN_PERCEPTION]] for the salience mechanics. [E]
- F-pattern is a symptom, not a target: users F-scan when layout gives no hierarchy (Nielsen eye-tracking, 2006). Strong headings, front-loaded first words, and meaningful subheads convert F-scanning into layer-cake scanning — design for the latter. [E]
- Banner blindness generalizes: anything shaped like an ad (top/right placement, high saturation, animation, isolation from content flow) is unconsciously filtered — including your own promos and system notices. Put critical messages in the content flow, styled as content. [E]
- Motion is the strongest attention magnet (peripheral vision evolved for it) — budget one autonomous motion per view; simultaneous movers cancel each other and read as noise. Details in [[MOTION_AND_SPATIAL_BEHAVIOR]]. [E]
- Interruption patterns, escalating cost: inline hint < badge < toast < banner < modal. Match level to (relevance to current task × urgency). Modal is a last resort — it taxes task resumption (interrupted tasks take ~2× subjective effort to resume; Mark et al.). Never modal for information the user can't act on. [E]
- Attention is a commons: every element that claims salience devalues every other claim. Enforce a per-view salience budget — if a new element must "pop", something else must be demoted first. [H]

### Information patterns

- Master-detail when items share a type and users compare or triage (mail, files): list pane preserves context, detail pane serves depth. Collapse to stacked list→detail below ~720 px width. [E]
- Cards for heterogeneous, self-contained items competing for choice (products, articles); tables for homogeneous records compared attribute-by-attribute (columns enable vertical scanning); lists for single-attribute ranked runs. Choosing cards for comparison tasks forces users to rebuild the table in their head. [E]
- Empty states are the pattern's first impression: never a blank region — state what belongs here, why it's empty, and the one action that fills it. First-run empty ≠ zero-results empty ≠ cleared/done empty; design all three. [E]
- Skeleton screens and structural placeholders over spinners for content loads >300 ms: showing the layout early lets schema-building start before data arrives (perceived-wait mechanics in [[PERFORMANCE_PERCEPTION]]). [E]
- Inline validation at field-blur, not keystroke, not submit: keystroke validation punishes unfinished input; submit-time validation forces error archaeology. Error message = what's wrong + how to fix, adjacent to the field. [E]
- Progressive summary: at every aggregation level show enough to decide whether to drill down (count, status, delta) — a label alone forces a click to evaluate, a full dump defeats aggregation. [H]

### Composition and system rules

- Pattern consistency is internal first: the same problem gets the same pattern everywhere in the product (one date picker, one confirmation idiom, one empty-state voice). Each variant multiplies learning cost and signals carelessness. Maintain a pattern inventory; two solutions to one problem is a bug. [E]
- Compose by nesting, not blending: a card may contain a list; a wizard step may contain a form. Never hybridize two patterns' halves (e.g., infinite scroll with page numbers) — users can't predict behavior of a chimera. [H]
- When a needed pattern doesn't exist, derive it: name the problem, list the forces, adapt the nearest established pattern, and document the delta. Record it in the house pattern language so the derivation happens once. [H]
- Deviate from convention only where the product differentiates: spend novelty on the 1–2 interactions that embody your core value, keep the rest rigorously conventional so the novelty is legible against a calm background (see [[ANTI_HOMOGENIZATION]] for the identity side). [H]
- Every pattern instance must survive stress content: longest realistic string, zero items, 10× items, RTL, offline. A pattern that only works with demo data is not implemented. [E]

### Anti-patterns (refuse, and name them in review)

- Dark patterns — confirmshaming ("No thanks, I hate saving money"), roach motel (1-click in, support-call out), sneak-into-basket, forced continuity without pre-renewal notice, nagging re-prompts after explicit dismissal (Brignull's taxonomy; FTC actions 2022+). They convert by exploiting asymmetric effort and shame; short-term lift, measurable trust and chargeback damage, increasing legal exposure. [E]
- Mystery-meat navigation: unlabeled icons for anything beyond the ~5 near-universal glyphs (search, home, settings, close, back). Icon comprehension without labels is chance-level for abstract actions; pair icon + label or use text alone. [E]
- False affordances and dead signifiers: underlined non-links, card hover-lift with no action, disabled-looking enabled buttons. Each false signal raises the cost of trusting every true one. [E]
- Premature personalization: reordering navigation or hiding "unused" items based on behavior breaks spatial memory — the interface becomes unlearnable because it won't hold still. Personalize content slots, never the frame. [E]
- Carousel as a decision-avoidance dump: auto-advancing hero carousels get <2% interaction beyond slide 1; they exist to end stakeholder arguments, not to inform users. Pick one message or use a static grid. [E]
- Modal cascade: a modal spawning a modal (or a toast announcing a dialog) means the flow was never designed — flatten into a sequence or a dedicated screen. [H]
- Pattern-library cargo culting: adopting a kit's component because it exists, not because its problem occurred. Every unused affordance is noise charged against the salience budget. [H]

## Decision guide

| Situation | Do |
|---|---|
| Recurring design problem, no house pattern yet | Find the established pattern (problem + forces match, not looks); adapt; record the delta |
| Action is destructive | Reversible → undo affordance (5–10 s); irreversible → confirmation stating the consequence |
| Choosing option input | ≤5 options → radio/segmented; 6–15 → dropdown; >15 or known value → type-ahead |
| Choosing collection display | Compare attributes → table; choose among self-contained items → cards; ranked single-attribute → list |
| Choosing navigation topology | ≤5 task areas → hub/tabs; containment tree → drill-down + breadcrumbs at depth ≥3; large flat set → faceted search |
| Feed vs goal-directed browsing | Ranked non-exhaustive → infinite scroll; findable/finishable → pagination or load-more |
| Something must interrupt | Escalate inline → badge → toast → banner → modal; modal only for act-now + blocking |
| Two patterns solve the same problem in-product | Consolidate to one; log the removal in the pattern inventory |
| Tempted by a conversion trick | Test: does it work only if the user misunderstands? yes → anti-pattern, refuse |
| New view feels novel everywhere | Cap at one unfamiliar pattern; return the rest to convention |

## Cross-refs

- [[HUMAN_PERCEPTION]] — salience, scanning, and memory mechanics underlying the attention patterns.
- [[INTERACTION_PSYCHOLOGY]] — motivation, habit, and effort economics behind interaction pattern choice.
- [[MICROINTERACTIONS]] — feedback loops inside a single pattern instance (the moment-scale layer).
- [[INFORMATION_ARCHITECTURE]] — schema and labeling decisions that navigation patterns render visible.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — motion budgets and spatial continuity for transitions between patterns.
- [[PERFORMANCE_PERCEPTION]] — loading, waiting, and skeleton-state patterns in depth.
- [[ANTI_HOMOGENIZATION]] — where to spend the novelty budget without becoming generic.
- [[LAYOUT_MATHEMATICS]] — grids and spacing systems that pattern compositions sit on.
- [[CHECKLISTS]] — pre-ship sweep including anti-pattern and stress-content review.
