# TYPOGRAPHY_SYSTEMS

## Purpose

Decides typeface selection, pairing, scale construction, hierarchy, line metrics, responsive behavior, and type accessibility. Load when choosing fonts, building a type scale, or diagnosing "the text feels wrong." Pair with [[UNDISCOVERED_TYPE_LIBRARY]] for concrete typeface picks.

## Principles

- Type is read twice: pre-attentively as texture/shape (~50ms, gestalt impression sets tone before a word is parsed) and consciously as language. Design the texture first — squint-test a page: hierarchy must survive blur. [E]
- Typefaces carry measurable personality: readers attribute traits (serious/playful, cheap/premium) consistently across studies (Shaikh & Chaparro font-personality work). A geometric sans reads engineered; a high-contrast serif reads authoritative/editorial; rounded terminals read approachable. Mismatch between voice and content measurably lowers trust. [E]
- Reading is saccadic, not linear: eyes jump 7–9 characters per saccade, fixate 200–250ms, regress ~10–15% of the time. Anything that increases regressions — long lines, tight leading, low contrast — taxes comprehension before the reader notices. [E]
- Skilled readers recognize word shapes (bouma) and parallel letter features, not letters serially — so ALL-CAPS body text (uniform rectangles) slows reading ~10–20%; reserve caps for ≤3-word labels with tracking. [E]
- Hierarchy is differentiation budget: each additional signal (size, weight, color, case, space) spends attention. Two signals per level distinguish cleanly; four+ signals or seven+ levels collapse into noise. Size alone is the weakest single cue; weight + size is the strongest cheap pair. [H]
- Fluency effect: easier-to-read text is judged more true, more likable, and its author more intelligent (Oppenheimer, processing-fluency research). Legibility is persuasion, not polish. [E]
- Disfluency has one legitimate use: mild difficulty (e.g., slightly harder display face for a 3-word headline) increases recall of that fragment — never apply to body text. [H]
- A type system is a constraint system: fixed scale steps, 2 families max, 3–4 weights total. Constraint is what makes pages feel "designed" — unlimited choice is how AI-generic output happens; see [[ANTI_HOMOGENIZATION]]. [H]
- Vertical rhythm works because Gestalt proximity/regularity: consistent baseline spacing lets space itself signal grouping, so you need fewer rules and boxes. Irregular spacing forces borders to do grouping's job. [E]

## Rules

### Selection and pairing

- Max 2 typefaces per product (1 is fine); if 2, pair by contrast of role, not flavor: differ in ≥2 axes (serif/sans, width, contrast) but share x-height within ~5% and similar apparent size — near-identical faces read as a mistake, not a choice. [H]
- Body faces need: x-height 0.48–0.55 of em, open apertures (c/e/a distinguishable at 10px), disambiguated Il1 O0, ≥4 weights available, real italics. Display faces are exempt from all but the last. [H]
- Check the full glyph coverage of your actual content language(s) BEFORE committing — fallback-font substitution mid-word is the most visible cheap-product tell. See [[CULTURAL_AND_GLOBAL_DESIGN]] for script-specific metrics (CJK needs ~1.7–2.0 leading; Arabic needs taller ascender room). [E]
- System font stacks are a legitimate identity choice (native feel, 0 bytes) — but then identity must come from scale, spacing, and color instead; you've spent your type-personality budget on neutrality. [H]

### Scale construction

- Build sizes from a modular scale: size(n) = base × ratio^n. Ratios by context — 1.125–1.2 (dense UI, dashboards), 1.25–1.333 (marketing, editorial), ≥1.414 (posters/hero-driven). Larger ratio = fewer usable steps before absurdity. [E]
- Base = body size: 16px minimum web body, 15–17pt native mobile; never build the scale down from the headline. [E]
- Snap computed sizes to whole px (or 0.5px) and cap the scale at 6–8 steps; a scale with 12 steps is a random-number generator with extra steps. [H]
- Weight pairs with size inversely: as size grows, drop weight and tighten tracking (display ≥32px: tracking −1% to −3%, weight 400–600); as size shrinks, add weight and tracking (labels ≤12px: tracking +2% to +8%, caps +5% to +12%). Optical compensation — big glyphs look tighter and bolder than they are. [E]
- Font-size ≠ optical size: at equal px, faces differ up to ~15% in apparent size (x-height driven). When swapping families, re-tune the base, don't trust the number. [E]

### Line metrics (the 3 levers)

- Line length: 45–75 characters per line, 66 ideal (Bringhurst; consistent with regression-rate studies). Under 40 forces excessive return sweeps; over 90 causes doubling (re-reading the same line). Set max-width in ch units: `max-width: 65ch`. [E]
- Leading (line-height): body 1.4–1.6; scale it inversely with size — headlines 1.1–1.2, small captions 1.5–1.7. Longer lines need more leading (+0.1 per ~15 chars over 66) so the return sweep can find the next line. [E]
- Paragraph spacing: either indent OR space-between (0.5–1.0em), never both; both is double-signaling the same boundary. [E]
- Justify only with hyphenation enabled and lines ≥60ch; otherwise rivers of whitespace fragment the texture. Default to left-aligned ragged-right; center-align only ≤3 lines. [E]

### Hierarchy

- 3–5 hierarchy levels max per view (e.g., page title / section / body / caption). Each level differs from its neighbor by ≥1 clear scale step or a weight jump of ≥200 — a 2px size difference is noise, not hierarchy. [H]
- Encode each level as a named token (display/title/body/label + size/weight/leading/tracking), never ad-hoc values; drift in one-off sizes is how systems rot. [H]
- Space groups tighter than it separates: heading-to-its-text gap ≤ 0.5× the gap above the heading (proximity law) — a heading floating equidistant belongs to nothing. [E]
- Emphasis within body: italic or weight-600 for ≤5 consecutive words; color-only emphasis fails colorblind users and low-contrast modes — pair color with weight. [E]

### Density and rhythm

- Pick a base unit (4 or 8px) and make line-heights multiples of it; vertical gaps between blocks come from the same unit. Rhythm breaks are allowed only as deliberate section boundaries. [H]
- Density modes are leading + size changes, not new fonts: comfortable (body 16/1.5), compact (14/1.4), dense data (13/1.35 with tabular figures). Ship them as token sets — see [[DATA_VISUALIZATION]] for table-specific numerals. [H]
- Use tabular (fixed-width) figures for any column of numbers, timers, or live-updating counts; proportional figures make aligned digits jitter. [E]

### Accessibility constraints (non-negotiable floor)

- Contrast: 4.5:1 minimum for body text, 3:1 for large text (≥24px regular / ≥18.7px bold) — WCAG 2.x AA. Decorative display text is not exempt if it carries content. [E]
- Text must survive 200% zoom without loss of content or function, and body text must respect user font-size settings — px-locked type on native platforms breaks Dynamic Type/font-scale users (double-digit % of mobile users enable larger text). Use rem/sp, not px, for anything readable. [E]
- Never convey hierarchy or state by color alone; pair with weight, size, or an icon. [E]
- Minimum interactive-text hit area 44×44pt regardless of the text's visual size. [E]
- Light text on dark backgrounds: bump body weight one step or +0.5% tracking — light-on-dark halation makes strokes appear thinner; also cut pure white to ~#EAEAEA on true black to reduce glare. [H]
- Dyslexia-friendly defaults help everyone: generous leading (≥1.5), left-aligned, no justified text, no italic for long passages, 60–70ch lines. "Dyslexia fonts" show no replicated advantage — spacing does. [E]

### Responsive and variable

- Fluid type: `clamp(min, calc(base + vw-slope), max)` for display sizes; body stays near-constant (16→18px across the whole viewport range) while display compresses hard (e.g., 56→32px). Headlines scale ~2–3× more steeply than body. [H]
- Recompute line-height at breakpoints: mobile's shorter lines want tighter leading (1.4) than desktop's longer lines (1.5–1.6) — one fixed ratio across breakpoints is always wrong at one end. [E]
- Variable fonts: one file replacing 4+ static weights usually wins on bytes and enables optical-size (opsz) and grade (GRAD) axes — grade changes stroke weight without reflow, ideal for dark-mode compensation and hover states. Animate weight/width axes only for ≤1s micro-moments; continuous animation of text is noise. [E]
- Subset fonts to used scripts; `font-display: swap` with a fallback metrically matched via size-adjust/ascent-override keeps CLS ~0 during load. [E]

### Cross-platform

- Translate, don't copy, sizes: web 16px body ≈ iOS 17pt ≈ Android 16sp ≈ TV 24px-at-3m ≈ print 10–11pt. Define the system in roles (body/title/label), map roles to platform units. [H]
- Respect platform rendering: identical fonts render lighter on macOS (thicker AA) than Windows (ClearType); test weights on both — 300-weight body that's fine on a Mac is broken on Windows. [E]
- Games/canvas UIs: SDF or pre-rasterized text still obeys the same metrics; re-verify contrast against the busiest possible background frame, not a mockup. [H]

## Decision guide

| Situation | Do |
|---|---|
| Starting a new product | Pick body face by legibility rules above → base 16px → ratio by density (1.2 UI / 1.25+ editorial) → 6-step scale → tokens |
| Text "feels wrong," cause unknown | Check in order: line length (45–75ch?) → leading (1.4–1.6?) → contrast (4.5:1?) → hierarchy signal count (≤2 per level?) |
| Need a second typeface | Prove one family + weights can't do it; if pairing, contrast ≥2 axes, match x-height ±5% |
| Dashboard / dense data | Ratio 1.125–1.2, body 13–14px, leading 1.35–1.4, tabular figures, weight-based hierarchy |
| Marketing / editorial page | Ratio 1.25–1.414, fluid clamp() display, 66ch body, generous 1.5–1.6 leading |
| Dark mode ships | Raise body weight one step or use GRAD axis; drop pure white to ~#EAEAEA; re-verify 4.5:1 |
| Headline looks loose/flabby | Tracking −1% to −3%, leading 1.1–1.2, weight down one step at ≥32px |
| Multilingual launch | Verify glyph coverage per script; re-tune leading per script; see [[CULTURAL_AND_GLOBAL_DESIGN]] |
| Users complain text too small | Confirm rem/sp units, 200% zoom survives, body ≥16px; never answer with a zoom-blocking meta tag |
| Choosing the actual typeface | [[UNDISCOVERED_TYPE_LIBRARY]] for picks beyond the top-40 defaults |

## Cross-refs

- [[UNDISCOVERED_TYPE_LIBRARY]] — concrete distinctive typeface choices once this doc's selection criteria are set.
- [[LAYOUT_MATHEMATICS]] — the spacing/grid system your baseline rhythm must lock into.
- [[MATHEMATICAL_DESIGN]] — ratio families (golden, musical intervals) behind modular scales.
- [[ACCESSIBILITY_AND_INCLUSION]] — full a11y scope beyond the type-specific floor here.
- [[HUMAN_PERCEPTION]] — deeper mechanics of saccades, fixation, and pre-attentive processing.
- [[ANTI_HOMOGENIZATION]] — escaping default-font sameness without breaking legibility rules.
- [[DATA_VISUALIZATION]] — numeral styles and micro-type in charts and tables.
- [[CULTURAL_AND_GLOBAL_DESIGN]] — script-specific metrics and multilingual type systems.
- [[MULTI_DEVICE_ECOSYSTEMS]] — carrying one type system across device classes.
