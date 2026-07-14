# LAYOUT_MATHEMATICS

## Purpose

Decides grid construction, spacing scales, proportion systems, hierarchy sizing, density targets, and balance checks — the numbers under every composition. Load when placing anything on a canvas: page layout, component spacing, dashboard packing, level/HUD framing.

## Principles

- Layout reads before content does: the eye extracts global structure in ~100ms (gist perception) and judges coherence from alignment and spacing alone. A mathematically consistent layout is perceived as trustworthy before a single word is read. [E]
- Ratios beat pixels: relationships between sizes are what the eye compares (Weber's law — perception of difference is proportional, not absolute). Define layout as ratios and derive pixels; never hand-pick sizes one by one. [E]
- One scale, everywhere: spacing, type, and component sizes drawn from a single modular scale produce coherence because repeated intervals become a learned visual rhythm, like meter in music. Mixing scales reads as noise even when each value looks fine alone. [H]
- The golden ratio is one tool, not a law: φ ≈ 1.618 has weak empirical support as universally preferred (Fechner's results failed replication), but it remains a serviceable ratio among several. Choose the ratio that fits content contrast needs; don't retrofit φ mysticism. [E]
- Fractal self-similarity lowers cognitive load: structures whose parts echo the whole (card mirrors page mirrors section) let users reuse one parsing strategy at every zoom level. Natural scenes average fractal dimension D ≈ 1.3–1.5, the range people rate most comfortable. [E]
- Whitespace is a signal, not absence: proximity is the strongest Gestalt grouping force, so the gap ratio between within-group and between-group spacing IS the information architecture. Compress whitespace and you delete structure, not just air. [E]
- Symmetry is cheap order; asymmetry is directed attention: symmetric layouts feel stable but static; asymmetric balance (unequal masses at compensating distances) creates motion and hierarchy. Default to asymmetric balance for anything with a primary action. [H]
- Grids exist to be broken deliberately: a violation of an established grid attracts fixation precisely because the grid built an expectation. One violation per view is emphasis; three is chaos. See [[ANTI_HOMOGENIZATION]] for making the break distinctive. [H]

## Rules

### Grids

- Columns: 12 for desktop ≥1024px (divisible by 2, 3, 4, 6), 8 for tablet 600–1023px, 4 for mobile <600px. Use fewer, wider columns only when content is a single reading stream. [E]
- Gutters: fix at one spacing-scale step (16 or 24px desktop, 16px mobile); never scale gutters proportionally with viewport — proportional gutters balloon on wide screens and starve grouping contrast. [H]
- Max text-column measure: 45–75 characters (~66 optimal). Beyond 75ch, return sweeps fail and reading speed drops; multi-column or capped containers are mandatory on wide viewports. [E]
- Baseline grid: 4px base unit; line-heights and vertical spacing in multiples of 4 (8 for coarse rhythm). All component heights land on the grid so adjacent columns' text baselines align within 2px. [E]
- Breaking the grid: max 1 intentional violation per viewport-height of content; the violating element must overhang by ≥1 full column or ≥2 spacing steps — half-hearted breaks read as bugs, not emphasis. [H]

### Modular scales

- Build every size ramp as `size(n) = base × ratio^n`. Pick base = body size (16px default) and one ratio per product. [E]
- Ratio selection by contrast need: 1.125–1.2 (dense UI, dashboards, ≥6 usable steps), 1.25–1.333 (marketing/editorial, strong hierarchy in 4–5 steps), 1.414–1.618 (posters/heroes, 3 steps max before sizes explode). [H]
- Spacing scale: a 4px-base ramp with ~1.33–1.5× alternating steps — 4, 8, 12, 16, 24, 32, 48, 64, 96. Cap the palette at ≤10 values; if a design "needs" an in-between value, the grouping logic is wrong, not the scale. [H]
- Adjacent hierarchy levels must differ by ≥15% in size OR by a second channel (weight ≥200 units, color ΔL ≥20); differences under Weber threshold (~10%) read as sloppy sameness, not hierarchy. [E]

### Proportion systems — φ and alternatives

- Usable ratios and when: 1:1 (stability, thumbnails), 5:4 / 4:3 (calm media), √2 ≈ 1.414 (halving-invariant panels — ISO 216 paper survives folding), 3:2 (photography default), φ ≈ 1.618 (sidebar:content ≈ 38:62%), 16:9 (video, heroes). [E]
- Rule of thirds as cheap asymmetry: placing focal elements at 1/3–2/3 intersections outperforms centering for directing gaze in composition practice; use it when φ subdivision is overkill. [H]
- Containment rule: nested containers keep the same ratio family (a √2 card inside a √2 panel), so subdivision reproduces the parent proportion — this is what makes a system feel "designed" rather than assembled. [H]

### Fractal structure

- Repeat one part-whole schema ≥3 nesting levels deep: page → section → card share the same slot order (header, body, meta) and the same padding ratio (outer:inner ≈ 1.5–2:1 per level). Users learn the schema once. [H]
- Scale spacing down with nesting: each level inward uses the next spacing step down (e.g. 32 → 24 → 16 → 8). Constant padding at every depth destroys depth perception. [H]
- Target moderate visual complexity: aim for the D ≈ 1.3–1.5 zone by mixing 2–3 element sizes per view rather than uniform tiles (D→1, dull) or unbounded variety (D→2, noisy). [E]

### Hierarchy math

- Weight budget: compute each element's salience ≈ area × contrast-vs-surround; the primary action should hold roughly 2× the salience of any secondary element. If two elements tie, the layout has no hierarchy — demote one. [H]
- Fitts's law governs placement: time to acquire a target ∝ log2(distance/size + 1). Primary actions get ≥44×44px touch / ≥32px pointer targets, placed near the interaction locus or at infinite-width screen edges. [E]
- Scanning follows F/Z patterns in text-heavy layouts: top-left quadrant gets the most fixations (LTR locales); put identity top-left, primary action along the terminal scan line, never bottom-left dead zone. Mirror for RTL — see [[CULTURAL_AND_GLOBAL_DESIGN]]. [E]
- Depth levels: ≤3 elevation/z-layers per view (base, raised, overlay). Each added layer multiplies attention splits; more than 3 and shadows stop encoding order. [H]

### Density equations

- Information density = meaningful data points / viewport area. Dashboards target high density with small multiples (see [[DATA_VISUALIZATION]]); marketing pages target low density: 1 idea per viewport-height. [H]
- Whitespace ratio: 30–50% of a content region as empty space for reading interfaces; <20% reads as cramped (comprehension drops), >60% reads as empty unless deliberate luxury positioning. [H]
- Grouping gap ratio: between-group spacing ≥2× within-group spacing (e.g. 24px between cards, ≤12px inside). Below 1.5× the Gestalt proximity signal collapses and borders/boxes must compensate — prefer fixing the ratio over adding chrome. [E]
- Element budget: ≤7 top-level regions per view (choice-scan cost rises with option count, Hick's law); each region internally holds ≤5 peer items before it needs its own subdivision. [E]

### Rhythm and spatial balance

- Vertical rhythm: successive block spacings follow the scale, and equal semantic gaps are pixel-identical everywhere (all section gaps 64, all card gaps 24). One inconsistent gap breaks the learned meter. [H]
- Balance check: treat each element as mass m = area × visual weight (dark/saturated ≈ 1.5×, text ≈ 1×, whitespace 0) and compute the moment about the layout's vertical axis: Σ(m × distance-left) vs Σ(m × distance-right) within ±20% = balanced; beyond that, the page feels like it tips. [H]
- Asymmetric balance recipe: one large light mass close to center ↔ one small dark mass far from center (m₁d₁ ≈ m₂d₂, the lever law). Use it to keep a dominant hero from flattening everything else. [H]
- Optical > geometric centering: circles, triangles, and icons must be nudged 2–4% toward their visual center of mass (triangles up, play-icons right) because the eye centers on mass, not bounding box. Trust the eye over the inspector. [E]

## Decision guide

| Situation | Do |
|---|---|
| New product, no system yet | 4px base, 12/8/4 grid, spacing ramp 4–96, one type ratio by contrast need — in that order |
| Dashboard feels cluttered | Check grouping gap ratio ≥2×, cut to ≤7 regions, then raise density via small multiples — not smaller text |
| Marketing page feels generic | Keep the scale, add one grid break per viewport + asymmetric balance; see [[ANTI_HOMOGENIZATION]] |
| Two elements compete for attention | Compute salience (area × contrast); enforce 2× dominance or demote one |
| Choosing panel proportions | Need halving-invariance → √2; sidebar/content → 38:62; media → 3:2 or 16:9; else rule of thirds |
| Sizes look arbitrary | Rebuild from `base × ratio^n`; delete any value not on the ramp |
| Wide viewport, long text | Cap measure at 66ch (45–75 hard bounds) before touching font size |
| Layout "feels off", cause unclear | Run the balance moment check, then baseline-grid audit (4px multiples), then gap-consistency sweep |

## Cross-refs

- [[MATHEMATICAL_DESIGN]] — the general math toolkit (curves, harmonics, parametrics) behind these layout-specific applications.
- [[TYPOGRAPHY_SYSTEMS]] — type scales, leading, and measure interact with the baseline grid and modular scale defined here.
- [[HUMAN_PERCEPTION]] — Gestalt, gist, and attention mechanisms these rules exploit.
- [[DATA_VISUALIZATION]] — density and small-multiple math for chart-heavy surfaces.
- [[MULTI_DEVICE_ECOSYSTEMS]] — breakpoint strategy for carrying these grids across devices.
- [[ANTI_HOMOGENIZATION]] — when and how to break the systems above without producing noise.
- [[CULTURAL_AND_GLOBAL_DESIGN]] — RTL mirroring and locale-dependent scanning patterns.
