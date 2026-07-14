# ANTI_HOMOGENIZATION

## Purpose

Detect and dismantle the convergent "AI default" aesthetic: same gradients, same grids, same type, same hero. Load when output could be any product in its category, before shipping any brand-facing surface, or when reviewing generated designs for identity.

## Principles

- Homogenization is statistical, not lazy: generators and design systems regress to the modal choice at every decision point, and N modal choices in a row reproduce the same design everyone ships. Escape requires deliberately off-modal picks, not more polish. [H]
- Brands are retrieved from memory by their unique sensory cues, not their category-typical ones (distinctive-assets research, Romaniuk & Sharp). A 100% category-typical design is unretrievable — correct, and invisible. [E]
- The Von Restorff isolation effect: the one element that violates the surrounding pattern is recalled disproportionately. Deviation only registers against an intact system — break a grid you visibly kept. [E]
- Novelty is a budget, not a virtue: processing fluency raises liking, so preference peaks at "most advanced yet acceptable" (Loewy's MAYA; Hekkert's unity-in-variety). Weird everything = noise; weird nothing = wallpaper. [E]
- Bounded irregularity signals human intent: handmade cues raise perceived effort, uniqueness, and value (the handmade effect, Fuchs et al. 2015; wabi-sabi tradition). Pixel-perfect uniformity reads as machine output. [E]
- Identity lives below content: users recognize products from silhouette, palette, and type voice before reading a word. If a blurred screenshot is interchangeable with competitors', copy is carrying identity that pixels should carry. [H]
- Trend adoption is identity leakage: every trend you copy at peak (glassmorphism, corporate-Memphis blobs, bento grids) timestamps the design and donates your surface to the category look. Adopt trends only translated through your own asset language. [H]

## Rules

### Detect — the AI-tell audit

- Score 1 point per tell present; ≥4/10 = homogenized. Fix the highest-visibility offenders first (hero > nav > cards > footer). [H]

| # | Tell |
|---|---|
| 1 | Purple/violet-to-blue gradient, usually on near-black |
| 2 | Glassmorphism (blur + transparency) on every card |
| 3 | Emoji as bullets or section markers |
| 4 | Default type: Inter / Poppins / Space Grotesk / system stack |
| 5 | 3-column feature grid: icon + bold line + two grey lines |
| 6 | Hero = centered H1 + subhead + 2 buttons + floating screenshot |
| 7 | One border-radius (8–16px) applied to literally everything |
| 8 | Interchangeable 24px/2px-stroke icon set |
| 9 | Identical full-width stacked bands, uniform vertical rhythm |
| 10 | Logo wall + testimonial carousel as trust section |

- Blur test: at ~20px Gaussian blur, place your screen beside 3 direct competitors'. If a teammate can't pick yours in 5 seconds, you have no visual identity — silhouette, palette, or type must change. [H]
- Swap test: put a competitor's logo on your page. If the page stays plausible, identity is decorative, not structural; move distinctiveness into layout and shape language, not just the mark. [H]
- Mode test: for hero layout, primary typeface, and brand hue, name the category's modal choice. If all three of yours match the mode, you are the statistical average by construction. [H]

### Break generic structure

- Deviate from the categorical default in exactly 1–2 zones per screen; everything else obeys the system. This is the MAYA budget: deviation needs a calm majority to register against. [E]
- Keep the grid, then break it visibly: one element crossing a column boundary, one overlap, or one off-axis rotation ≤3°. A broken rule reads as intent only when the rule is otherwise enforced. [E]
- Ban the reflex hero: if the centered stack (tell #6) survives, it must lose one modal component — off-center axis, typographic hero with no screenshot, or content-first opening. [H]
- Vary section anatomy: across any page, no more than 2 consecutive sections may share the same layout skeleton (columns, alignment, media position). Repetition of skeleton, not of style, is what reads as template. [H]

### Controlled asymmetry

- Prefer asymmetric balance to mirror symmetry: split primary compositions off-center (60/40 or ~62/38 golden section) and balance by visual weight — weight ≈ area × tonal contrast × saturation — not by geometry. Symmetry is the modal, lowest-information layout. [H]
- Cap irregularity so it stays legible as intent: rotation jitter ≤3°, positional jitter ≤8px or ≤0.5× base spacing unit, applied to ≤20% of elements. Below the cap it reads human; above it reads broken. [H]
- Never randomize per render: pick the "imperfect" offsets once and freeze them. Consistent irregularity is character; fresh randomness every build is noise and breaks recognition. [H]

### Preserve identity

- Choose 1–3 distinctive assets — a signature hue, a shape language, a type voice, a motion curve — and repeat them at 100% consistency across surfaces. Distinctiveness = uniqueness × frequency; a unique asset used once builds nothing (Romaniuk). [E]
- Escape the modal hue band: SaaS clusters at 210–270° (blue→violet). Pick a brand hue outside it, or if you must stay, differentiate structurally — unusual lightness architecture or a signature secondary always paired with it. Build the system in [[COLOR_SYSTEMS]]. [H]
- Never ship the default stack: select display type from outside the top-20 most-served fonts (see [[UNDISCOVERED_TYPE_LIBRARY]]); pair for contrast per [[TYPOGRAPHY_SYSTEMS]]. Type is the highest-leverage single swap — it touches every screen. [H]
- Define one shape language and enforce it: a radius scale of your own (e.g. 2/6/20px, or squared corners + one round signature element) instead of uniform 12px. Contour is a blur-test survivor. [H]
- Give motion a signature: replace default ease-in-out with one named custom curve or spring (stiffness/damping) used everywhere. Motion identity survives even total visual redesigns. [H]
- Write an anti-spec alongside the spec: 5–10 explicit "we never do X" bans (from the tell table + category clichés). Negative constraints steer generators and juniors harder than positive moodboards. [H]

### Humanize

- Add material: 2–5% opacity grain/noise over large flat or gradient fields kills banding and the sterile-vector look; texture is evidence of surface, and surfaces read as real. [H]
- Prefer specific human imagery over interchangeable 3D blobs and corporate-Memphis illustration — those styles are themselves tells #11 by now. If illustrating, commission or build a style with named constraints (palette, line weight, flaws to keep). [H]
- Let microcopy carry voice in low-stakes moments (empty states, loaders, 404s): one sentence of personality where cost-of-error is zero, plain language where stakes rise. Placement follows arousal — see [[EMOTIONAL_DESIGN]]. [H]
- Keep one visibly hand-touched element per product (hand-drawn arrow, annotation, signature, irregular divider) as a handmade-effect anchor; one is an accent, five is a theme park. [E]

## Decision guide

| Situation | Do |
|---|---|
| Design "looks AI-generated" | Run the tell audit; fix highest-visibility tells until score <4 |
| Score <4 but still forgettable | Blur test → fix whichever layer failed: silhouette, palette, or type |
| New product, no identity yet | Pick 1–3 distinctive assets + write the anti-spec before any screens |
| Rebrand tempts a trend | Translate the trend through your assets or skip it; never adopt raw |
| Everything feels stiff/sterile | Asymmetry rules + grain + one hand-touched anchor, within jitter caps |
| Deviation feels chaotic | You overspent MAYA: revert to system everywhere but 1–2 zones |
| Generated UI drifts off-identity | Encode assets + anti-spec as hard constraints — [[GENERATIVE_AND_ADAPTIVE_UI]] |
| Pre-ship check | Tell audit + blur test + swap test; log scores in [[CHECKLISTS]] |

## Cross-refs

- [[UNDISCOVERED_TYPE_LIBRARY]] — off-modal typefaces to replace tell #4.
- [[TYPOGRAPHY_SYSTEMS]] — pairing and hierarchy mechanics once type is chosen.
- [[COLOR_SYSTEMS]] — building a full palette around an off-modal brand hue.
- [[LAYOUT_MATHEMATICS]] — the grids and ratios you must master before breaking them.
- [[EMOTIONAL_DESIGN]] — where personality raises resonance vs. where it erodes trust.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — constraining generators to your identity.
- [[PHILOSOPHY]] — the stance layer: why memorable beats sterile at all.
- [[CHECKLISTS]] — pre-ship audit sequence embedding the tests above.
