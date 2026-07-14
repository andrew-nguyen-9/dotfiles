# INDEX

Router for `codex/design-guidelines/`. Exempt from per-doc validation (see `CONVENTIONS.md`); the doc table below is the single source cross-refs resolve against.

## Load order (JIT)

1. `INDEX.md` (this file) — always first, never skipped.
2. Only the docs the task tables route to, in listed order — never bulk-load the directory. Match a project shape first; fall back to domain rows for narrower questions.
3. `CONVENTIONS.md` — only when authoring or editing guideline docs themselves.

## Task → docs

### Project shapes

| Task | Load |
|---|---|
| dashboard build | [[DATA_VISUALIZATION]], [[LAYOUT_MATHEMATICS]], [[COLOR_SYSTEMS]] |
| new brand / visual identity | [[PHILOSOPHY]], [[COLOR_SYSTEMS]], [[TYPOGRAPHY_SYSTEMS]], [[ANTI_HOMOGENIZATION]] |
| web app (full build) | [[PHILOSOPHY]], [[VISUAL_DECISION_ENGINE]], [[PATTERN_LANGUAGE]], [[INFORMATION_ARCHITECTURE]] |
| mobile app | [[MULTI_DEVICE_ECOSYSTEMS]], [[PATTERN_LANGUAGE]], [[MICROINTERACTIONS]], [[ONBOARDING_AND_LEARNING]] |
| game UI / HUD | [[MOTION_AND_SPATIAL_BEHAVIOR]], [[DYNAMIC_SYSTEMS]], [[SENSORY_DESIGN]], [[EMOTIONAL_DESIGN]] |
| landing page | [[EMOTIONAL_DESIGN]], [[TYPOGRAPHY_SYSTEMS]], [[LAYOUT_MATHEMATICS]], [[ANTI_HOMOGENIZATION]] |
| form / flow design | [[INTERACTION_PSYCHOLOGY]], [[PATTERN_LANGUAGE]], [[MICROINTERACTIONS]] |
| a11y audit | [[ACCESSIBILITY_AND_INCLUSION]], [[CHECKLISTS]] |
| motion pass | [[MOTION_AND_SPATIAL_BEHAVIOR]], [[MICROINTERACTIONS]], [[DYNAMIC_SYSTEMS]] |
| perf-perception pass | [[PERFORMANCE_PERCEPTION]], [[MICROINTERACTIONS]] |
| pre-ship review | [[CHECKLISTS]], [[VISUAL_DECISION_ENGINE]] |

### Domain questions

| Task | Load |
|---|---|
| starting any visual/UI decision | [[PHILOSOPHY]], [[VISUAL_DECISION_ENGINE]] |
| choosing or systematizing color | [[COLOR_SYSTEMS]] |
| choosing/pairing typefaces | [[TYPOGRAPHY_SYSTEMS]], [[UNDISCOVERED_TYPE_LIBRARY]] |
| spacing, grids, composition | [[LAYOUT_MATHEMATICS]], [[MATHEMATICAL_DESIGN]] |
| reusable components/patterns | [[PATTERN_LANGUAGE]] |
| motion, transitions, spatial model | [[MOTION_AND_SPATIAL_BEHAVIOR]], [[DYNAMIC_SYSTEMS]] |
| small interactive moments | [[MICROINTERACTIONS]], [[INTERACTION_PSYCHOLOGY]] |
| perception, attention, cognition | [[HUMAN_PERCEPTION]] |
| emotional tone, delight, trust | [[EMOTIONAL_DESIGN]], [[SENSORY_DESIGN]] |
| accessibility, inclusion | [[ACCESSIBILITY_AND_INCLUSION]] |
| navigation, structure, findability | [[INFORMATION_ARCHITECTURE]] |
| first-run, education, mastery | [[ONBOARDING_AND_LEARNING]] |
| perceived speed, waiting states | [[PERFORMANCE_PERCEPTION]] |
| charts, dashboards, data density | [[DATA_VISUALIZATION]] |
| cross-device, responsive ecosystems | [[MULTI_DEVICE_ECOSYSTEMS]] |
| localization, cultural reach | [[CULTURAL_AND_GLOBAL_DESIGN]] |
| organic/natural systems inspiration | [[BIOMIMICRY]] |
| escaping generic/AI-looking output | [[ANTI_HOMOGENIZATION]] |
| generative, adaptive, AI-driven UI | [[GENERATIVE_AND_ADAPTIVE_UI]] |
| pre-ship review, audits | [[CHECKLISTS]] |

## Docs

| Doc | Status | Answers |
|---|---|---|
| PHILOSOPHY | live | Which value wins when design goals conflict? |
| COLOR_SYSTEMS | live | How is color specified, generated, adapted, judged? |
| TYPOGRAPHY_SYSTEMS | live | How are typefaces chosen, paired, scaled into a system? |
| UNDISCOVERED_TYPE_LIBRARY | live | Which distinctive free typeface fits this voice? |
| LAYOUT_MATHEMATICS | live | What numbers govern grids, spacing, proportion, density? |
| PATTERN_LANGUAGE | live | Which proven pattern applies before inventing a new one? |
| DYNAMIC_SYSTEMS | live | How is behavior-over-time specified as a system? |
| MOTION_AND_SPATIAL_BEHAVIOR | live | How long, with what easing, meaning what spatially? |
| MICROINTERACTIONS | live | What should this single action's feedback do? |
| HUMAN_PERCEPTION | live | What will users notice, group, remember, feel? |
| INTERACTION_PSYCHOLOGY | live | What motivates, rewards, or manipulates the user here? |
| EMOTIONAL_DESIGN | live | What should this moment make the user feel, and how? |
| ACCESSIBILITY_AND_INCLUSION | live | Who gets excluded, at which measurable threshold? |
| INFORMATION_ARCHITECTURE | live | Where does this live and how will users find it? |
| ONBOARDING_AND_LEARNING | live | How does the product teach itself to novices? |
| PERFORMANCE_PERCEPTION | live | How is waiting experienced, and how is latency masked? |
| DATA_VISUALIZATION | live | Which visual encoding answers this data question? |
| MULTI_DEVICE_ECOSYSTEMS | live | How does one design survive many devices and inputs? |
| CULTURAL_AND_GLOBAL_DESIGN | live | Does this survive translation, script, and culture shifts? |
| BIOMIMICRY | live | What biological structure solves this scaling problem? |
| MATHEMATICAL_DESIGN | live | What formal structure makes this decision defensible? |
| ANTI_HOMOGENIZATION | live | Does this look like every other generated product? |
| GENERATIVE_AND_ADAPTIVE_UI | live | When may the interface change itself, and how far? |
| SENSORY_DESIGN | live | When do sound, haptics, and ambient channels join in? |
| VISUAL_DECISION_ENGINE | live | Which decision tree routes this visual choice? |
| CHECKLISTS | live | Is this ready to ship — pass, fail, or waived? |
