# BIOMIMICRY

## Purpose

Borrow structure from biology when a design must scale, self-organize, or adapt without a central planner. Load this when systems grow beyond hand-placed layouts: generative composition, dense data fields, emergent navigation, or interfaces that must feel alive rather than assembled. Nature has stress-tested these solutions over 3.8 billion years; copy the mechanism, not the ornament — a leaf-shaped icon is decoration, a leaf's vein-branching load-distribution is engineering.

## Principles

- Copy function, not form. The value in nature is the constraint it solved (packing, flow, resilience), not its silhouette. Reproducing a shape (fern-leaf border, honeycomb texture) is skeuomorphic kitsch; reproducing its rule (hexagonal packing minimizes wall material per cell) transfers real efficiency. [E]
- Growth beats placement at scale. Biological form emerges from local rules applied repeatedly, not from a global blueprint — a tree has no CAD file. Above ~50 elements, hand-placement fails to stay coherent; a generative rule keeps 5,000 elements consistent for the same authoring cost. [H]
- Emergence is order without a controller. Flocks, ant trails, and slime-mold networks compute optimal structure from simple per-agent rules and local sensing. Interfaces gain the same robustness: no single point of failure, graceful degradation, adaptation to input the designer never enumerated. [E]
- Efficiency is structural, not decorative. Bone, wood, and leaf venation put material only where stress flows (Wolff's law: bone remodels along load lines). The design analog: spend visual weight, motion, and density only where attention and data flow demand it. [E]
- Redundancy with variation is resilience. Ecosystems survive shocks because many slightly-different components overlap in function; monocultures collapse. A design system with one rigid template shatters on edge cases a diverse pattern set absorbs. [E]
- Adaptation is iterative selection, not one-shot design. Evolution runs variation → selection → inheritance in loops. A/B testing, progressive rollout, and multi-armed bandits are the same loop; treat the interface as a population under selection, not a finished artifact. [E]
- Constraints breed identity. Every organism's beauty is its constraints made visible (the nautilus grows the only shell a fixed-ratio spiral allows). Design distinctiveness comes the same way — a strict generative rule produces a recognizable signature no trend can flatten. [H]

## Rules

### Growth and phyllotaxis

- Distribute N repeated elements (dots, cards, particles) on a disc by the golden-angle spiral: angle = i × 137.507°, radius = c × √i. This is how sunflowers pack seeds; it gives near-uniform density with zero clustering and no visible rows at any N. [E]
- Use 137.5° (the golden angle) specifically — it is the most irrational rotation, so successive elements never realign into seams. Rational fractions of 360° (90°, 120°, 72°) create spokes and Moiré; irrational avoids them. [E]
- Branch with a fixed split ratio: at each fork, child dimension = parent × 0.6–0.75. Da Vinci's rule — the summed cross-section of children ≈ parent's — keeps visual "flow" conserved and reads as organic. Applies to tree menus, org charts, connector routing. [E]
- Cap recursion depth at 4–6 levels for navigable structures; natural branching stops when the terminal cost exceeds the transport gain. Deeper trees exceed working-memory path-tracking (~4 nested levels). [H]

### Fractals and self-similarity

- Target fractal dimension D ≈ 1.3–1.5 for backgrounds, textures, and generative art. Human preference peaks in this mid-complexity band (coastlines, clouds, tree canopies sit here); D<1.2 reads sterile, D>1.7 reads chaotic and raises stress. [E]
- Build multi-scale detail so the composition rewards inspection at ≥3 zoom levels — silhouette, mid-structure, texture. Self-similarity across scales is why natural scenes stay interesting on a second look; flat design offers one scale and exhausts fast. [H]
- Reuse one motif at 3+ sizes rather than 3 unrelated motifs. Recursion of a single element (Sierpinski logic) builds coherence for free; variety of scale substitutes for variety of shape and keeps the vocabulary tight. [H]
- Add controlled noise (±5–15% jitter on position, size, rotation) to any grid meant to feel natural. Perfect regularity signals machine and raises suspicion; nature is regular-with-deviation. Keep jitter below ~20% or the underlying order dissolves. [E]

### Swarm and emergence

- Design emergent motion from three Reynolds boids rules per agent: separation (avoid crowding neighbors within radius r), alignment (steer toward neighbors' mean heading), cohesion (steer toward neighbors' mean position). Three local rules yield lifelike flocking with no choreography. [E]
- Sense locally: each agent reads only neighbors within a radius, not global state. Local-only sensing is what makes swarms scale to thousands and degrade gracefully; it also caps per-agent compute at O(neighbors), not O(N). [E]
- Use stigmergy — agents leaving traces that guide later agents — for self-optimizing paths: worn "desire lines," decaying heat trails, ant-colony routing. Reinforce used paths, evaporate unused ones (decay 2–10%/step) so the network tracks demand without a planner. [E]
- Tune swarm density so agents occupy 10–30% of the field; below 10% the collective behavior doesn't cohere, above ~40% it reads as noise and motion becomes illegible. [H]

### Structural efficiency

- Route material and visual weight along load paths only. Model attention/data "stress" and thicken elements (borders, contrast, size) where it concentrates, thin them elsewhere — the tensegrity/bone principle. Uniform weight wastes the budget and flattens hierarchy. [E]
- Prefer hexagonal tiling when packing equal cells (dashboards, tile maps, avatars): hexagons give the least perimeter per unit area of any regular tessellation, so they need the least dividing chrome and fit ~15% more circular content than a square grid. [E]
- Use tension-compression balance for stability with minimal mass: a few high-contrast anchors (compression) held by many light connectors (tension). Over-building every element is the design equivalent of dead weight. [H]
- Let form follow the force gradient: curves should tighten where "force" is high and relax where low (river meanders, stress-line fairings). Constant-radius curves read mechanical; variable-radius reads grown. [H]

### Ecosystem and adaptation

- Treat a design system as an ecosystem of niches, not a template library: define roles (predator/prey, pioneer/climax) — primary actions, supporting affordances, ambient states — and let components fill niches. Diversity-within-role prevents the brittle monoculture of one-size components. [H]
- Version interfaces by selection loops: ship variants, measure a fitness metric (task completion, retention), inherit winners, mutate losers. Keep 5–10% of traffic on exploration so the system escapes local optima the way genetic drift does. [E]
- Build for succession — first-run (pioneer) states differ from mature (climax) states. Empty states, defaults, and progressive disclosure should evolve as the user's "environment" fills, not present the climax interface to a barren account. [H]
- Enforce homeostasis: define target ranges (density, load, contrast) and let the system self-correct toward them (adaptive layouts, responsive density) rather than snapping between fixed breakpoints. Feedback loops that hold a range beat discrete states that lurch. [H]

## Decision guide

| Situation | Reach for |
|---|---|
| Placing many repeated elements evenly | Golden-angle phyllotaxis spiral (137.5°, r=c√i) |
| Grid feels dead / machine-made | Add 5–15% jitter; introduce a second scale of the same motif |
| Background/texture feels sterile or chaotic | Tune fractal dimension toward D≈1.3–1.5 |
| Autonomous/ambient motion of many objects | Boids: separation + alignment + cohesion, local radius |
| Paths/navigation should self-optimize | Stigmergy: reinforce used routes, decay unused (2–10%/step) |
| Packing equal cells with minimal chrome | Hexagonal tiling |
| Deciding where to spend visual weight | Load-path routing — weight follows attention/data stress |
| Improving a live interface over time | Selection loop: variant → measure fitness → inherit → mutate |
| Choosing a nature motif for looks | Stop — extract the constraint it solved, not its shape |
| Branching tree/menu/connector layout | Fixed split ratio 0.6–0.75, depth ≤4–6 |

## Cross-refs

- [[MATHEMATICAL_DESIGN]] — the golden ratio, spirals, and fractal math this doc applies; load for the equations behind phyllotaxis and self-similarity.
- [[DYNAMIC_SYSTEMS]] — feedback loops, homeostasis, and emergent behavior over time; the temporal companion to these structural rules.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — how to productionize growth rules and selection loops as generative interface systems.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — implement boids/swarm rules as concrete, legible motion.
- [[LAYOUT_MATHEMATICS]] — reconcile organic packing with grid discipline; jitter budgets against baseline structure.
- [[ANTI_HOMOGENIZATION]] — constraints-breed-identity as an escape from generic output.
