# CULTURAL_AND_GLOBAL_DESIGN

## Purpose

Decides how a design survives translation, script change, reading-direction flip, and cultural reinterpretation. Load when a product ships to more than one locale, when choosing symbols/colors/imagery for mixed audiences, or when auditing why an interface underperforms in a specific market.

## Principles

- Culture sets the prior, not the pixel: users decode color, gesture, and imagery through learned associations before conscious reading. A red badge is "sale" in China and "error" in Germany because association is trained, not innate — design against the audience's priors, not your own. [E]
- Localization is design-time, not ship-time: text expansion, script metrics, and direction flips break layouts structurally. Retrofitting RTL onto a hardcoded-LTR layout costs an order of magnitude more than building direction-agnostic from the start, because directionality touches every ordered element. [E]
- Translation ≠ localization ≠ culturalization: translation swaps words; localization adapts formats (dates, currency, units, name order); culturalization adapts meaning (imagery, humor, examples, color, hierarchy). Each layer failing produces a distinct error class — budget all three. [E]
- Reading direction is attention direction: scan patterns (F-pattern, Z-pattern) mirror in RTL scripts because habitual reading order trains saccade habits. Visual hierarchy built on "top-left first" silently inverts for ~600M RTL readers. [E]
- Hofstede-style dimensions predict interface preference weakly but usefully: high uncertainty-avoidance cultures respond to explicit navigation, guidance, and status visibility; high power-distance cultures tolerate authority cues and denser official layouts. Treat as hypothesis generator for testing, never as ship-blind rule. [H]
- High-context cultures (much of East Asia) accept — and often expect — denser, image-rich, multi-signal pages; low-context cultures (Germanic, Nordic) favor sparse explicit hierarchy. Density preference is a cultural variable, not a universal taste; a "clean" redesign can read as empty or untrustworthy. [E]
- Symbols are the highest-variance channel: hand gestures (OK sign, thumbs-up), animals (owl: wisdom vs bad omen), body parts, and religious geometry flip valence entirely between cultures, while abstract geometric icons travel safely. Prefer the boring abstract mark over the clever culture-bound one. [E]
- Universality is earned by subtraction: the designs that travel are those that lean on near-universal mechanisms — contrast, proximity, motion onset, facial expression of basic emotions — and push culture-bound meaning into swappable content layers. [H]
- A single global design with locale-swapped content beats N divergent designs for maintainability, but only if the base layout tolerates the extremes (longest translation, tallest script, RTL) — design for the worst case, decorate for the average. [E]

## Rules

### Text and expansion

- Reserve expansion room by source-string length: <10 chars → plan +100–200%; 11–20 → +80–100%; 21–30 → +60–80%; 31–50 → +40–60%; 51–70 → +30–40%; >70 → +30%. German and Finnish routinely hit these bounds; truncation is a layout bug, not a translation bug. [E]
- Never hardcode text in images; never concatenate translated fragments into sentences (grammar order varies — "You have {n} items" must be one translatable string with placeholder, pluralization handled per locale: Arabic has 6 plural forms, Japanese 1). [E]
- Line-height minimums rise with script complexity: Latin 1.4×; CJK 1.5–1.7× (dense glyphs need air); Thai, Devanagari, Arabic 1.6–1.8× (stacked diacritics and ascenders clip at Latin metrics). Test with real strings, not lorem ipsum. [E]
- CJK has no italic and bolding small glyphs fills counters: emphasize via weight change ≥2 steps, color, or surrounding space — not slant. Minimum comfortable body size: ~12px Latin ≈ 14px CJK ≈ 15px Thai/Arabic at equal reading distance. [E]
- Avoid ALL-CAPS as a styling channel: many scripts (CJK, Arabic, Devanagari) have no case, so the emphasis vanishes in translation; German capitalizes all nouns, so caps carry different signal. Use weight/size/space instead. [E]

### Direction (RTL/LTR/vertical)

- Mirror layout, navigation order, progress indicators, back arrows, and carousels in RTL; do NOT mirror: clocks, media-player controls (play/rewind are device conventions), phone numbers, code, music notation, physical-world icons (car steering), and checkmarks. [E]
- Numbers stay LTR inside RTL text (Arabic uses left-to-right digit order); plan for bidirectional runs — an Arabic sentence containing a Latin brand name and a number has 3 direction changes. Use logical properties (start/end), never left/right, in any layout spec. [E]
- Test RTL with real content, not flipped English: Arabic average word is shorter but letter-connected (no mid-word truncation), Hebrew lacks vowel marks in UI text. Pseudo-localization catches ~80% of direction bugs pre-translation. [H]
- Vertical scripts (traditional Mongolian; optional vertical CJK for editorial contexts) rotate the entire reading model; support only when the market demands it — modern CJK UI is horizontal by default. [E]

### Color across cultures

- Never encode critical meaning in hue alone across locales: red = danger/error (West, near-universal in UI convention) but prosperity/celebration (China), purity contexts vary for white (Western weddings vs East Asian mourning). UI-convention colors (red error, green success) now travel better than cultural colors because software itself trained the association — but pair every color signal with an icon or label. [E]
- Financial color codes flip: rising markets are green in the West, RED in China/Japan/Korea stock displays. Data-viz palettes for finance must be locale-parameterized, not global constants. [E]
- Audit brand palettes per target market against: mourning colors (white — East Asia; black — West; purple — some of Latin America/Thailand contexts), political/religious flag colors (green in Islamic contexts is positive but politically loaded in others), and gender-coding drift (pink's coding is Western-recent, not global). One audit table per market, before launch. [E]
- Saturation preference is a weak cultural signal (higher tolerance for saturated multi-hue palettes in South/Southeast Asia and Latin America; muted palettes read as premium in Nordic/Japanese minimalism traditions) — treat as starting hypothesis for market testing. [H]

### Symbols, imagery, gestures

- Ban culture-bound gesture icons from global surfaces: thumbs-up (offensive in parts of Middle East/West Africa), OK ring (offensive in Brazil/Turkey), pointing index finger (rude in many Asian cultures). Replace with abstract marks: check, plus, star, arrow. [E]
- Vet animal, body, and religious imagery per market: pigs/dogs (Islamic contexts), cows (Hindu contexts), owls (bad omen in parts of India/Middle East), left-hand imagery (unclean connotation in Islamic/Hindu contexts), crosses/crescents/hexagrams as decorative geometry. A 30-minute vet per market beats a recall. [E]
- Faces localize hard: photography with identifiable people should either match the market's demographics or be replaced with illustration/abstraction; mismatched stock faces measurably reduce trust and identification. Basic-emotion facial expressions (joy, anger, fear, sadness) read cross-culturally; posed social gestures do not. [E]
- Mailbox, piggy-bank, school-bus, and US-shaped metaphor icons fail internationally (objects don't exist or look different). Icon test: would the physical referent be recognized on 4 continents? No → use text label or abstract symbol. [H]
- Emoji render differently per platform and carry divergent meanings per culture (folded hands = thanks/prayer/high-five); never use emoji as sole carriers of critical meaning. [E]

### Formats and mechanics

- Localize as data, not strings: dates (DD/MM vs MM/DD vs YYYY年M月D日 — ISO 8601 for logs, locale format for display), decimal separators (1,5 vs 1.5), currency position and spacing, measurement units, calendar systems (Hijri, Buddhist-era +543), and week start (Sun/Mon/Sat all exist). Use the platform locale library; hand-rolled formats are latent bugs. [E]
- Name fields: single "full name" field beats first/last split (order flips in CJK/Hungarian; mononyms exist; no "middle name" in most cultures). Never validate names against Latin-alphabet regexes. [E]
- Address forms: country selector FIRST, then render country-specific fields (postal-code position, province concepts, and line order all vary); phone inputs accept country code and variable length. [E]
- Sort order is locale-dependent (Swedish ö after z; German ö with o; CJK by stroke/pinyin/radical): use locale-aware collation, never byte-order sort, for any user-facing list. [E]

## Decision guide

| Situation | Do |
|---|---|
| Entering first non-native market | Run 3-layer audit: translation (strings/plurals), localization (formats/inputs), culturalization (color/symbol/imagery tables per market) |
| Layout breaks in German/Finnish | Apply the expansion table above; if a control can't absorb +100% on short labels, redesign the control, don't abbreviate the German |
| Adding RTL support | Convert to logical start/end properties, mirror per the mirror/don't-mirror list, pseudo-localize, then test with native Arabic/Hebrew strings |
| Choosing a status color | Pair hue with icon + label; check the finance-flip rule if the value is money/market data |
| Icon proposal uses object/gesture metaphor | 4-continent recognition test; fail → abstract mark or text label |
| Two markets want opposite density | Keep one layout skeleton, parameterize density (spacing scale, items-per-view, imagery count) per locale rather than forking the design |
| "Just translate it" pressure from stakeholders | Show the error classes: string concatenation, name/address validation, color/symbol valence — each is a shipped bug translation cannot fix |
| Unsure if a cultural claim is real | Treat as [H]: test in-market with 5+ native users before betting the layout on it |

## Cross-refs

- [[COLOR_SYSTEMS]] — build the palette mechanics there; this doc governs per-market meaning and the finance flip.
- [[TYPOGRAPHY_SYSTEMS]] — type scale and pairing craft; this doc adds script metrics, line-height floors, and no-italic constraints.
- [[ACCESSIBILITY_AND_INCLUSION]] — inclusion overlaps culture (language access, cognitive load); load together for any global audit.
- [[INFORMATION_ARCHITECTURE]] — navigation order and labeling schemes that must survive direction flips and translation.
- [[EMOTIONAL_DESIGN]] — emotional tone calibration once cultural priors from this doc are known.
- [[DATA_VISUALIZATION]] — chart color and reading-order decisions inherit the finance-flip and RTL rules from here.
