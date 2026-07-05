# COLOR_SYSTEMS

## Purpose

Decides how color is specified, generated, adapted, and judged: perceptual color spaces, mathematical palette construction, contrast systems, emotional and environmental effects, harmony vs deliberate tension. Load when choosing, systematizing, or debugging color anywhere in a product.

## Principles

- Work in a perceptually uniform space (OKLCH/OKLab), not HSL/HSB. In OKLCH, equal lightness (L) steps look equal and hue stays stable while L or chroma (C) changes; HSL "lightness" is a lie — HSL yellow at L 50% has ~3× the luminance of HSL blue at L 50%, so HSL-derived ramps produce uneven, muddy scales. [E]
- Color is judged relative, never absolute: simultaneous contrast (Chevreul; Albers) shifts a swatch's perceived hue, lightness, and chroma toward the opposite of its surround. A color approved in isolation is unapproved — evaluate only in final context at final size. [E]
- Perceived brightness ≠ measured luminance: the Helmholtz–Kohlrausch effect makes high-chroma colors look brighter than their luminance predicts, which is why saturated accents can pass a contrast formula yet still glare, or look fine yet fail. Formulas gate; eyes confirm. [E]
- Small areas need more chroma, large areas less (area effect): a hue chosen from a 1 cm swatch will overwhelm as a full-bleed background. Choose backgrounds at scale, accents at scale. [E]
- Saturation drives arousal and lightness drives valence more strongly than hue drives either (Valdez & Mehrabian, 1994): a muted dusty red reads calmer than a neon teal. Tune energy with C and L before reaching for a different hue. [E]
- Hue–emotion mappings are dominated by culture and context, not biology — white is bridal in the West, funerary in parts of East Asia; "blue = trust" in fintech is convention, not psychology. Treat hue semantics as a localizable variable. [E]
- Perfect harmony reads sterile and forgettable; controlled discord is memorable. One deliberately off-harmony, high-chroma color at small area (≤5%) creates tension that anchors attention — the mechanism is violation-of-expectation, the same one that makes dissonance work in music. [H]
- Hue alone is invisible to ~8% of men and ~0.5% of women (red–green color vision deficiency): meaning encoded only in hue is meaning withheld. Redundant channels (lightness, shape, text) are structural, not add-ons. [E]
- A palette is a system with generative rules (L ramp, C arc, hue angles), not a list of hex codes. Rules regenerate under new requirements (dark mode, new brand hue, P3 gamut); lists rot. [H]

## Rules

### Specification and tokens

- Author all palette definitions in OKLCH (`oklch(L C H)`), gamut-map to sRGB for output; treat hex as a compile target, never a source of truth. Display-P3 covers ~25% more colors than sRGB — define chroma at the P3 ceiling only with an sRGB fallback token. [E]
- Three token layers: primitive (`blue-600`) → semantic (`surface`, `text-primary`, `accent`, `danger`) → component (`button-bg`). Components reference semantic only. Why: themes (dark, brand, high-contrast) swap one layer instead of touching every component. [E]
- Brand-color reproduction tolerance: ΔE2000 ≤ 2 across surfaces (JND ≈ 2.3); ΔE2000 > 5 reads as a different color to non-experts. [E]

### Palette generation (mathematical)

- Tone ramp: 10–12 steps per hue, OKLCH L from ≈0.98 down to ≈0.15 in equal ΔL steps (≈0.07–0.08 per step). Equal ΔL in OKLCH is equal perceived spacing — this is the property HSL ramps lack. [E]
- Chroma arc: C peaks mid-ramp (≈ L 0.5–0.65) and tapers toward both ends (near-white and near-black can't hold chroma without gamut clipping). Linear-constant C across a ramp is a common generator bug that clips and posterizes the extremes. [E]
- Hue harmonies as OKLCH hue-angle relations: complementary 180°, split-complementary ±150°, triadic 120°, analogous ±30°, tetradic 90°. For tension, detune the complement to 160–170° — near-miss angles register as deliberate energy, exact angles as static balance. [H]
- Rotate hue slightly along the ramp (±10–20° from light to dark: warm the light end, cool the dark end) for chromatic neutrals and shadows; flat-hue ramps read as generator output — grayed, lifeless. Painters' shadow practice, adopted by modern tone-scale tools. [H]
- Area distribution: ≈60% dominant (low C, extreme L), ≈30% secondary, ≤10% accent (highest C). Signal works by scarcity — an accent covering 30% of the screen is a background. [H]
- Cap simultaneous hues at 3 (+neutrals) in UI chrome; categorical data palettes may need more — hand that problem to [[DATA_VISUALIZATION]]. [H]

### Contrast systems

- WCAG 2.x floors: 4.5:1 body text; 3:1 for large text (≥24px, or ≥18.66px bold) and for UI component boundaries/focus indicators. These are legal-baseline gates, not quality targets. [E]
- Prefer APCA (WCAG 3 candidate) for design decisions: Lc ≥ 90 preferred body, Lc ≥ 75 minimum body, Lc ≥ 60 large/bold, Lc ≥ 45 non-text UI. APCA is polarity-aware (dark-on-light ≠ light-on-dark), which WCAG 2.x ratio math ignores — it misgrades dark-mode pairs in both directions. Ship compliance on WCAG 2.x, design on APCA. [E]
- Never encode state (error/success/warning/info) by hue alone: pair every hue shift with ΔL ≥ 0.2 (OKLCH) or an icon/label. Red–green pairs at equal lightness are the canonical CVD failure. [E]
- Test every palette under deuteranopia + protanopia simulation and in grayscale; if the grayscale render loses a distinction users need, the palette fails regardless of contrast ratios. [E]

### Adaptive, dark mode, environment

- Dark mode is a re-mapping, not an inversion: base surface ≈ OKLCH L 0.16–0.22 (never pure black — pure black + pure white maximizes halation), text ≈ L 0.85–0.92 (not pure white; halation blurs bright text for astigmatic users, ~30–40% of population), and cut accent chroma 10–30% (dark surrounds amplify perceived saturation — adaptation shifts). [E]
- Elevation in dark mode = lighter surface (each level +0.02–0.04 L), not drop shadows; shadows are invisible against dark grounds, so the lightness channel must carry depth. [E]
- Expect environment to move perception: bright ambient light crushes shadow detail and washes low-C distinctions (raise contrast, drop reliance on subtle tints for outdoor/mobile contexts); warm ambient light and night-shift filters shift white point via chromatic adaptation, so blue-vs-gray distinctions drift. Distinctions that must survive need ΔL, not just Δhue. [E]
- OLED specifics: true black (L 0) costs pixel-off power savings but causes black smear on scroll; near-black L 0.16 avoids smear. Choose per product motion profile. [E]
- Adaptive color (theme by time, ambient sensor, or content): change L and C, keep semantic hue anchors fixed — users track meaning by hue; a danger-red that turns orange at night breaks the learned mapping. See [[GENERATIVE_AND_ADAPTIVE_UI]] for the runtime machinery. [H]

### Identity and anti-cliché

- Derive the palette from one owned signature hue (exact OKLCH triple, not "blue") plus generated structure around it; default-framework palettes and purple-on-dark-gradient schemes are recognizable as template output and forfeit distinctiveness — see [[ANTI_HOMOGENIZATION]]. [H]
- Allow one controlled imperfection: a slightly detuned harmony angle, an off-ramp accent, or a chromatic gray that leans a few degrees warm. Uniform mathematical perfection is the tell of generated design. [H]

## Decision guide

| Situation | Do |
|---|---|
| Building a palette from a brand hue | Fix signature hue in OKLCH → generate 10–12-step ΔL ramp with chroma arc → pick harmony angles → verify APCA + CVD sim |
| Ramp looks muddy or uneven | You generated in HSL/HSB — regenerate in OKLCH with equal ΔL steps |
| Converting to dark mode | Re-map: surface L 0.16–0.22, text L ≤ 0.92, chroma −10–30%, elevation via +L; never invert, never pure black/white pairing |
| Accent passes contrast but glares | Helmholtz–Kohlrausch: drop C, adjust L to hold the APCA score, re-check by eye in context |
| Two states distinguishable to you, reports say otherwise | Run deuteranopia/protanopia sim + grayscale; add ΔL ≥ 0.2 or icon/shape channel |
| Palette feels harmonious but dead | Add one off-harmony high-C discord color at ≤5% area, or detune the complement 10–20° |
| Color meaning must ship across locales | Treat hue semantics as localizable; verify against [[CULTURAL_AND_GLOBAL_DESIGN]] before hard-coding |
| Choosing colors for charts/dashboards | This doc gives the space and ramps; categorical/sequential/diverging scheme design lives in [[DATA_VISUALIZATION]] |
| Contrast gate for release | WCAG 2.x floors (4.5:1 / 3:1) for compliance + APCA Lc targets for quality; both, not either |

## Cross-refs

- [[HUMAN_PERCEPTION]] — deeper mechanics of vision, adaptation, and attention that this doc's effects (simultaneous contrast, H-K) sit on.
- [[ACCESSIBILITY_AND_INCLUSION]] — full inclusive-design scope beyond CVD and contrast floors.
- [[EMOTIONAL_DESIGN]] — how color-driven arousal/valence integrates with the rest of the emotional system.
- [[DATA_VISUALIZATION]] — categorical, sequential, and diverging palettes for encoding data.
- [[ANTI_HOMOGENIZATION]] — escaping template palettes; identity strategy this doc's signature-hue rule serves.
- [[CULTURAL_AND_GLOBAL_DESIGN]] — localizing hue semantics.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — runtime adaptation machinery for context-sensitive color.
- [[MATHEMATICAL_DESIGN]] — the broader ratio/progression toolkit behind ramp and harmony math.
