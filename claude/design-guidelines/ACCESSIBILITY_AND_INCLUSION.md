# ACCESSIBILITY_AND_INCLUSION

## Purpose

Decides visual, cognitive, and motor accessibility thresholds, screen-reader and reduced-motion behavior, and inclusive design method. Load before any interactive or content-bearing surface ships, and whenever a design decision trades aesthetics against operability.

## Principles

- Accessibility is a distribution problem, not an edge case: ~16% of people live with significant disability (WHO 2023), and situational impairment (sunlight glare, one-handed phone use, noisy rooms, concussion, aging eyes) puts every user in the disabled population intermittently. Design for the ability spectrum, not a "disabled persona". [E]
- Constraints sharpen identity rather than flatten it: the curb-cut effect (captions, autocomplete, dark mode all began as accommodations) shows accessible choices routinely become mainstream advantages. Treat each constraint as a forcing function for clearer hierarchy, not a tax on style. [E]
- Perceivable, operable, understandable, robust (POUR, from WCAG) is a complete decision lens: every failure is a user who cannot sense, act on, comprehend, or technically reach the interface. Diagnose failures by which letter broke — the fix category follows directly. [E]
- One sense is never load-bearing: any signal carried only by color, only by sound, or only by hover is invisible to a predictable slice of users (8% of men have color-vision deficiency; deafness, motor limits). Redundant encoding — shape + color, text + icon, visual + haptic — is the default, not the fallback. [E]
- Cognitive load is an accessibility axis: working memory holds roughly 4 chunks (Cowan 2001), and stress, ADHD, dyslexia, or age shrink the effective budget. Interfaces that demand memorization, parse-heavy prose, or time pressure exclude as concretely as low contrast does. [E]
- The assistive-technology experience is a parallel product surface: a screen-reader user navigates by headings, landmarks, and accessible names — a semantic outline, not the pixel layout. If the semantic layer is unstructured, the product is unstructured for them, regardless of visual polish. [E]
- Motion is physiological, not just aesthetic: parallax, zoom, and large-field movement trigger vestibular disorders (nausea, vertigo, migraine) in a meaningful minority. Honoring a reduced-motion preference is a safety behavior, like a food allergy label. [E]
- Inclusion outperforms retrofit economically: fixing an accessibility fault post-release costs multiples of designing it out (defect-cost escalation is one of software engineering's most replicated findings), and remediation typically produces the bolted-on, incoherent UI that accessible-first design avoids. [E]
- "Solve for one, extend to many" (inclusive design's core move) generates originality: designing a flow for a blind or one-handed user first strips decorative dependency and yields interaction models competitors ignore. [H]

## Rules

### Visual

- Text contrast: ≥4.5:1 against its background; ≥3:1 allowed for large text (≥24px regular or ≥18.7px bold). Non-text essentials (icons, input borders, focus rings, chart strokes) ≥3:1. Contrast is how low-vision and aging eyes (contrast sensitivity halves by ~65) resolve edges at all. [E]
- Never encode meaning in hue alone: pair color with shape, position, text, or pattern (error = red + icon + message; chart series = color + marker shape or direct label). Deuteranopia collapses red/green; grayscale-print and sunlight collapse everything. [E]
- Body text ≥16px equivalent; line length 45–75 characters; line height ≥1.4× font size. Layout must survive 200% text zoom and 320px-wide reflow without loss or 2-D scrolling — zoom is the most-used low-vision aid. [E]
- Do not disable pinch-zoom or text resize; overriding user font-size settings breaks the primary self-accommodation channel for low vision. [E]
- Dark-mode and brand palettes re-verify contrast independently — inverting a passing light palette usually fails, because perceived contrast is not symmetric around mid-gray. [E]

### Motor and input

- Touch targets ≥44×44px (pointer ≥24×24px) with ≥8px between adjacent targets. Fitts's law: acquisition time grows as targets shrink; tremor, arthritis, and bus-ride jitter raise the floor. [E]
- Everything operable by keyboard alone: reachable with Tab/arrows, activated with Enter/Space, escapable with Esc — no hover-only or drag-only functions without a click/keyboard equivalent. Keyboard is the common protocol behind switch devices, sip-and-puff, and voice control. [E]
- Focus is always visible: ≥3:1 contrast indicator, ≥2px outline (or equivalent area), never `outline: none` without a stronger replacement. Focus order follows visual reading order; a keyboard user's focus ring is their cursor. [E]
- No timing walls: user-controllable, extendable (≥10×), or removable time limits; no double-tap/long-press-only gestures; no path-dependent gestures (multi-point swipes) without single-pointer alternatives. [E]
- Place primary actions in the thumb-reachable bottom half on handhelds; one-handed use is the situational-motor default, not the exception. [H]

### Screen readers and semantics

- Every control exposes an accessible name matching its visible label; every meaningful image gets alt text describing function ("Search" not "magnifying glass icon"); decorative images are explicitly hidden from the accessibility tree. [E]
- Heading levels form a strict outline (one H1, no skipped levels): screen-reader users navigate by heading jumps first (consistently the top strategy in WebAIM screen-reader surveys). Landmarks/regions label the page's macro-zones. [E]
- Dynamic changes announce themselves: async results, validation errors, and toasts route through a live/announcement channel; errors are named in text next to the field, not just a red border. Silent state change is invisible change. [E]
- Use native/platform controls before custom ones; a custom control must reproduce the native role, states, and full keyboard grammar or it is a regression wearing better CSS. [E]
- Reading order in the semantic tree matches visual order; never let z-index or grid placement tell a different story than the DOM/element order. [E]

### Motion and vestibular

- Respect the OS reduced-motion preference: replace parallax, zoom, auto-playing background video, and large translations with opacity/color cuts ≤100ms. Reduced ≠ removed — keep micro-feedback (≤100ms, small extent) that carries state. [E]
- No content flashing >3 times/second (photosensitive-seizure threshold); auto-moving content lasting >5s gets a pause/stop control. [E]
- Cap decorative motion by default: transitions ≥500ms or moving >½ the viewport need functional justification, not taste. See [[MOTION_AND_SPATIAL_BEHAVIOR]] for the motion grammar this constrains. [H]

### Cognitive and language

- One primary action per screen/step; chunk flows so each step demands ≤4 simultaneous items of recall (working-memory limit); show, don't ask users to remember, prior inputs. [E]
- Write body copy at lower-secondary reading level (Flesch ≥60 or local equivalent); front-load the point; expand or avoid unexplained jargon, idioms, and abbreviations. Plain language raises comprehension for every reader, not only cognitive-disability users. [E]
- Errors state what happened, why, and the fix in one message; destructive and legal/financial actions are reversible or confirmed. Recovery design substitutes for the flawless attention no user has. [E]
- Support recognition over recall everywhere: persistent navigation labels (icon + text), visible state, no mystery-meat icons — icon-only comprehension is poor and unguessable across cultures. [E]

### Inclusive method

- Test with assistive tech each release: keyboard-only pass + one screen-reader pass minimum; automated checkers catch only ~30–40% of WCAG failures, so they gate but never certify. [E]
- Include users with disabilities in research panels (target ≥1 in 5 sessions across vision/motor/cognitive); proxy empathy (blindfolds, simulators) misestimates real adapted expertise. [E]
- Run the exclusion audit at concept stage: for each interaction ask "who cannot see / hear / touch / parse this?" and design the redundant channel before high-fidelity work locks the layout. [H]
- Represent the ability spectrum in imagery and copy without tokenism; default to people-first or identity-first language per community preference (e.g., "blind users" is fine; "the disabled" is not). [H]

## Decision guide

| Situation | Do |
|---|---|
| Meaning carried by color/sound/hover only | Add a second channel: shape, text, icon, haptic, or persistent visible state |
| Brand palette fails 4.5:1 on text | Keep hue, shift lightness until it passes; reserve failing tints for non-text decoration |
| Custom component vs native control | Native unless the custom version reproduces role, states, and keyboard grammar — then still test with a screen reader |
| Animation feels essential to identity | Keep it for default users; design the reduced-motion variant as a first-class cut, not an off switch |
| Flow demands memory of earlier steps | Surface prior inputs inline; chunk to ≤4 recall items per step |
| Time or budget forces triage | Fix in POUR order: blockers to perception, then operation, then comprehension, then robustness |
| Automated audit passes | Still run keyboard-only + screen-reader passes; automation finds under half of real failures |
| Unsure if impairment is "rare enough" to skip | Add situational equivalents (glare, one hand, noise) to the count — then decide |

## Cross-refs

- [[COLOR_SYSTEMS]] — building palettes where contrast thresholds hold across the whole scale.
- [[TYPOGRAPHY_SYSTEMS]] — sizing, line length, and hierarchy mechanics behind the readability rules here.
- [[MOTION_AND_SPATIAL_BEHAVIOR]] — the full motion grammar these vestibular limits constrain.
- [[HUMAN_PERCEPTION]] — perceptual mechanisms (contrast sensitivity, attention) underlying the visual thresholds.
- [[INTERACTION_PSYCHOLOGY]] — Fitts's law and cognitive-load models applied beyond accessibility.
- [[CHECKLISTS]] — pre-ship audit sequences that operationalize this doc.
