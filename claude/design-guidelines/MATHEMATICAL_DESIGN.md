# MATHEMATICAL_DESIGN

## Purpose

Mathematical structures behind interfaces that feel coherent instead of arbitrary: graphs and networks, symmetry operations, harmonic ratios, entropy budgets, statistical distributions, and generative rule systems. Load when a design decision needs a defensible structure, not taste. For grid/spacing arithmetic specifically, go to [[LAYOUT_MATHEMATICS]].

## Principles

- Math earns its place only when it maps to perception: the eye detects ratio, rhythm, and deviation, not equations. A system built on a ratio users cannot perceive (differences under ~5% in length, ~20% in area) is numerology, not design. [E]
- Graph structure predicts navigability. Users build a mental map of an interface as a network of screens; maps form fastest when the graph is shallow (small diameter) and locally clustered — the same small-world properties that make social networks searchable (Milgram; Watts–Strogatz). [E]
- Symmetry is compression. Mirror-symmetric arrangements are detected pre-attentively (<100ms, especially about a vertical axis) and remembered better because they carry less information to encode; asymmetry spends that saved attention, so it must buy something — hierarchy, direction, or emphasis. [E]
- Harmonic relationships work because they create detectable self-similarity: when sizes are drawn from one geometric series, any two elements relate by a small power of the base ratio, so the composition rhymes with itself. Which ratio (1.2, 1.333, 1.618) matters far less than committing to exactly one. [E]
- Entropy is the cost side of interest. Shannon entropy of a layout (variety of sizes, colors, alignments) raises both engagement and processing effort; Berlyne's arousal work found preference peaks at moderate complexity and collapses at either extreme. Order alone is sterile, disorder alone is noise. [E]
- Natural-feeling variation is statistically structured, not uniform-random. Natural scenes follow 1/f spatial-frequency distributions and log-normal size distributions; uniform randomness reads as static, 1/f-structured randomness reads as organic. [E]
- A generative system is a hypothesis about which decisions are mechanical. Encode the mechanical ones (scale steps, tint ramps, spacing) as rules; leave the judgment ones (voice, emphasis, exception) to humans — automating judgment yields averaged, homogenized output ([[ANTI_HOMOGENIZATION]]). [H]
- Power laws govern usage: a minority of features/routes captures the large majority of traffic in most real systems. Design the head with bespoke care; design the long tail with generated, rule-based treatment. [E]

## Rules

### Graphs and networks

- Model the product as a directed graph (screens = nodes, actions = edges) before styling anything. Keep graph diameter ≤4 for core tasks: any key screen reachable in ≤4 clicks from entry, else restructure the graph — do not paper over depth with shortcuts. [H]
- Cap out-degree per screen at 7±2 primary edges (distinct navigational choices); beyond that, chunk edges into labeled groups so the perceived out-degree drops back under the cap (working-memory limit, Miller/Cowan). [E]
- Rank screens by betweenness centrality (how many task paths cross them); the top node after entry is your hub — give it the largest information scent and fastest load. If centrality is flat, the IA lacks a spine ([[INFORMATION_ARCHITECTURE]]). [H]
- Eliminate orphan nodes (in-degree 0 aside from deep links) and dead ends (out-degree 0 without an explicit terminal state like "order complete"). Every non-terminal screen carries ≥1 forward edge. [E]
- For rendered network diagrams: force-directed layout for ≤100 nodes; above that switch encoding (adjacency matrix, edge bundling, aggregation) — hairballs past ~100 nodes have near-zero read accuracy ([[DATA_VISUALIZATION]]). [E]

### Symmetry and asymmetry

- Choose symmetry class per element, deliberately: reflection (mirror) for identity and stability marks, translation (repetition) for rhythmic lists and grids, rotation for loaders and radial menus, scale (self-similarity) for hierarchy. Name the class in the spec so it survives handoff. [H]
- Default to vertical-axis reflection for stable containers (dialogs, empty states, logos): vertical mirror symmetry is detected fastest of all symmetry axes and signals intentional order. [E]
- Break symmetry at exactly the point of emphasis, and only there. One asymmetric element in a symmetric field is fixated first (Feature Integration/singleton pop-out); two or more competing breaks cancel the effect. Budget: 1 deliberate symmetry break per view. [E]
- Asymmetric balance must still balance: visual weight ≈ area × tonal contrast × distance from the composition's axis. Offset a large light mass with a small dark one placed farther out; verify by blurring the mock (8–12px Gaussian) — the blur image should not tip to one side. [H]
- Use scale symmetry across zoom levels: card, list item, and detail view of the same entity keep identical internal proportions so recognition transfers between levels. [H]

### Harmonic relationships

- Derive every size dimension (type, spacing, radii, icon sizes) from one modular scale: size(n) = base × ratio^n. Pick the ratio by information density — 1.2 (minor third) for dense dashboards, 1.25–1.333 for products, 1.5–1.618 for editorial/marketing. One ratio per product. [E]
- Steps must clear the perceptual floor: adjacent scale steps ≥15% apart, else they read as sloppy sameness rather than two intentional sizes. (This is why ratios below ~1.15 fail.) [E]
- Treat φ (1.618) as one usable ratio, not magic: empirical tests (Boselie; McManus) show no reliable preference for golden rectangles over nearby ratios. Never justify a decision "because golden ratio" — justify it by consistency with the chosen series. [E]
- Rhythm = spatial frequency. Repeat one dominant interval (card pitch, row height) ≥3 times before varying it; variation before the third repeat reads as error, after it reads as syncopation. [H]
- Related quantities take small-integer ratios: line-height:font-size near 3:2 for body text, column:gutter between 3:1 and 6:1, icon:cap-height 1:1. Small-integer ratios are recoverable by eye; 17:11 is not. [H]

### Entropy, statistics, and controlled randomness

- Set an entropy budget per view and spend it where meaning lives: unique values in use for font sizes ≤4, type families ≤2, hues ≤3 (+1 accent), alignment axes ≤2. Each extra distinct value adds visual information the reader must discount. [H]
- Aim for the mid-complexity peak: strip a view to minimal entropy, then reintroduce variation ONLY on elements whose difference encodes meaning (state, priority, category). Variation without semantics is noise by definition. [E]
- When you need organic variation (avatar fallbacks, decorative fields, galleries), draw offsets from 1/f or Perlin noise, not uniform random: match natural-image statistics (power ∝ 1/f²-ish spectra) and it reads as alive, not glitchy. [E]
- Jitter discipline: random displacement ≤10% of the element's own dimension keeps perceived alignment (grid still wins); >20% destroys grid membership. Between 10–20% is ambiguous — avoid. [H]
- Design for the real distribution of content, not the mean: text lengths and item counts are long-tailed. Spec every component at p5, p50, p95, and p99 content lengths; a card that only works at the mean breaks for roughly half of real data. [E]
- Anscombe rule for any data-driven design decision: never act on summary statistics alone — plot the distribution first (identical means/variance can hide wildly different shapes). [E]

### Generative systems

- Express the design system as parameters + rules, not artifacts: tokens are functions (scale(n), tint(hue, step), space(n)), and every generated value must be reproducible from (seed, rule, inputs). If a value can't be regenerated, it's a hand-tweak — document it as an explicit exception. [H]
- Constrain generative output to a validity envelope with hard checks: contrast ≥4.5:1, tap targets ≥44px, line length 45–75ch ([[ACCESSIBILITY_AND_INCLUSION]]). Generators explore inside the envelope; the envelope itself is never generated. [E]
- Seed-stability rule: same seed + same inputs = same output, forever. Randomness without a persisted seed makes bugs unreproducible and identity unstable across sessions. [E]
- L-system/recursion depth for decorative growth patterns: 3–5 iterations. Fewer reads as primitive geometry; more exceeds screen resolution and rendering budgets ([[BIOMIMICRY]] for the source patterns, [[GENERATIVE_AND_ADAPTIVE_UI]] for runtime adaptation). [H]
- Interpolate system states (light↔dark themes, compact↔comfortable density) through the parameter space, not per-property tweaks: change the ramp's curve or the scale's base, and let all values re-derive. Per-property overrides fork the system and rot ([[DYNAMIC_SYSTEMS]]). [H]

## Decision guide

| Situation | Do |
|---|---|
| IA feels tangled | Draw the screen graph; check diameter ≤4, out-degree ≤7±2, kill orphans/dead-ends |
| View feels static/sterile | Add 1 symmetry break at the emphasis point; or reintroduce 1/f variation on non-semantic decoration |
| View feels chaotic | Count distinct sizes/hues/alignments against the entropy budget; merge values until within it |
| Sizes feel arbitrary | Rebuild from one modular scale; ratio by density (1.2 dense → 1.618 editorial); steps ≥15% apart |
| "Should this be golden ratio?" | No special status — pick the series that fits density and stay consistent |
| Randomness looks glitchy | Swap uniform random for Perlin/1/f; cap jitter at 10% of element size; persist the seed |
| Component breaks on real data | Re-spec at p5/p50/p95/p99 content lengths, not the mean |
| Tempted to auto-generate a judgment call | Don't — generate mechanical values only; log judgment exceptions explicitly |

## Cross-refs

- [[LAYOUT_MATHEMATICS]] — applied grids, spacing units, and page-level composition arithmetic.
- [[INFORMATION_ARCHITECTURE]] — turning the screen-graph diagnosis into navigation structure.
- [[DATA_VISUALIZATION]] — encoding rules for rendering networks and distributions.
- [[DYNAMIC_SYSTEMS]] — parameterized systems evolving over time and state.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — runtime generation and adaptation built on these rules.
- [[BIOMIMICRY]] — natural sources of the statistical and growth patterns used here.
- [[ANTI_HOMOGENIZATION]] — why generated judgment produces averaged, generic output.
- [[ACCESSIBILITY_AND_INCLUSION]] — the hard validity envelope generative output must respect.
