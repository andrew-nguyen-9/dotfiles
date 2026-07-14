# INFORMATION_ARCHITECTURE

## Purpose

Decides how content is structured, labeled, navigated, searched, and progressively revealed so users can predict where things live before they look. Load when designing navigation, taxonomies, search, site/app structure, or any "where does this go / how will they find it" question.

## Principles

- Users navigate by information scent: at each step they pick the link whose label smells most like their goal (information foraging, Pirolli & Card, Xerox PARC). Weak scent — vague labels, branded nouns, overlapping categories — causes backtracking and abandonment, not slower success. Every intermediate page must strengthen scent, not just exist. [E]
- Structure must match the user's mental model, not the org chart or database schema (Norman, mental models). Users can only predict locations inside a structure they can simulate in their heads; internal-facing taxonomies force recall of YOUR model instead of recognition of theirs. [E]
- Recognition beats recall: choosing a labeled option is reliably easier than generating a query or path from memory (Nielsen's usability heuristics; recognition/recall literature). Browse structures serve recognition, search serves recall — offer both, because user preference splits by task and expertise, not demographics. [E]
- Depth costs more than breadth: broader, shallower hierarchies outperform narrow-deep ones in time and error rate (Larson & Czerwinski 1998, web depth/breadth study) because each extra level adds a decision under uncertainty and a chance to mis-scent. [E]
- Number of clicks is not the cost — confidence per click is. Users tolerate many steps if each feels obviously right; the "3-click rule" fails empirically (Porter/UIE: satisfaction and success uncorrelated with click count up to ~12 clicks). Optimize scent, not depth alone. [E]
- Choice time grows with the log of options among well-organized alternatives (Hick–Hyman law), so grouping 40 items into 5 labeled clusters of 8 is faster than one flat list of 40 — categorization converts a linear scan into two log-time decisions. [E]
- Wayfinding needs landmarks, paths, and districts (Lynch, *The Image of the City*, transferred to interfaces): stable visual anchors (logo→home, persistent nav), a visible trail (breadcrumbs, back), and visually distinct regions. Users build a survey map of your product only when these are consistent across sessions. [H]
- Progressive disclosure works because working memory holds ~4 chunks (Cowan 2001): defer secondary options and detail until requested, and the primary path stays inside capacity. Hiding is safe only when the reveal control itself has strong scent. [E]
- Findability is a property of the content-label-structure triad, not of the search engine: search cannot rescue content whose vocabulary doesn't match user vocabulary — most queries are the user's words, not yours. [E]

## Rules

### Structure and hierarchy

- Prefer breadth: 2–3 levels for products under ~1,000 findable items; go deeper only when card-sort data shows users themselves chunk that way. Never exceed 4 levels without a search-dominant fallback. [E]
- Cap top-level navigation at 5–9 labeled categories; beyond 9, introduce a second organizing dimension (audience, task, facet) instead of a tenth sibling. [H]
- Categories must be mutually exclusive at the same level or explicitly poly-hierarchical (item listed in both places). If >20% of items plausibly fit 2+ siblings, the scheme is ambiguous — re-sort or add facets. [H]
- Use exact organization schemes (alphabetical, chronological, geographical) only when users know the item's name/date/place in advance; otherwise use ambiguous schemes (topic, task, audience) — exact schemes have zero scent for exploratory tasks. [E]
- Validate structure with open card sorting (20–30 participants for stable clusters, Tullis & Wood 2004) before build, and tree testing after: target ≥70% first-attempt success on top tasks; first click predicts task outcome (~87% success when first click is right vs ~46% when wrong, Bailey/first-click studies). [E]

### Navigation systems

- Ship all four navigation layers and keep them visually distinct: global (persistent, whole-product), local (within section), contextual (inline, related-X), utility (account/settings/help). Collapsing them into one bar destroys the district signal. [H]
- Labels: front-load the information-carrying word, 1–3 words, user vocabulary (mine search logs and support tickets), no invented brand nouns for core paths. Test: a new user must predict what's behind the label with ≥80% accuracy (label comprehension test). [E]
- Show location: current section highlighted in nav + breadcrumbs on any hierarchy ≥3 levels. Breadcrumbs are path-back and scent-forward simultaneously and cost one line. [E]
- Logo links home; back must never destroy work or dead-end. Violating either breaks the two cheapest landmarks users rely on. [E]
- Hidden navigation (hamburger and kin) halves discoverability and lowers nav usage vs visible/partially visible nav (NN/g mobile nav studies); hide only under real space constraints, never on desktop for primary paths. [E]

### Search

- Once findable items exceed ~200 or hierarchy exceeds 3 levels, search is mandatory, not supplementary — a visible input (not icon-only) on every screen where finding is a plausible task. [H]
- Handle the query users actually type: tolerate typos/plurals/synonyms (map user vocabulary to your taxonomy), and design for short queries — most are 1–3 words. [E]
- Zero-results pages must advance the task: show spelling suggestion, relaxed-match results, and category links — never a bare "no results". A dead end converts a recall failure into an exit. [E]
- Results must show enough metadata to disambiguate before clicking (title + type + 1-line context minimum); result pages are scent surfaces, judged in ~1 fixation per row. [H]
- Faceted filtering over forced pre-categorization for large ambiguous inventories: users narrow by the dimensions they hold (price, date, type) in any order, matching how memory retrieves attributes, not paths. [E]

### Progressive disclosure and discovery

- Two-tier rule: primary tier shows only what most users need for the core task (target: ≤4 choices in view per decision point); secondary tier is one interaction away behind a control whose label names what it reveals ("Advanced filters", never "More"). [E]
- Disclose in place: reveal detail where the trigger sits (expand/inline panel) rather than teleporting context away; spatial continuity preserves the user's partial mental map. [H]
- Never hide the only path to a frequent action: measure — any action used by >30% of sessions belongs in the primary tier regardless of visual-cleanliness pressure. [H]
- Support discovery of the unrequested: contextual "related/next" links at content ends and empty states that teach structure. Dead-end pages waste the moment of highest curiosity. [H]
- Instrument findability: track search-to-browse ratio, zero-result rate (<5% target), and pogo-sticking (rapid result-back-result). Rising search share on tasks with browse paths signals scent decay. [H]

## Decision guide

| Situation | Do |
|---|---|
| New product/section structure | Open card sort (15+ users) → draft 2–3 level tree → tree test top tasks to ≥70% first-try success |
| Users know item names (docs, contacts, files) | Exact scheme (alphabetical/chronological) + prominent search |
| Users explore without target vocabulary | Topic/task scheme with tested labels; search secondary |
| Large inventory, items fit many categories | Faceted navigation; facets from card-sort dimensions |
| Nav bar pressure to add a 10th item | Re-cluster into ≤9 or split by audience/task dimension |
| Screen feels crowded | Two-tier disclosure: keep top-task actions visible, label the reveal with what it hides |
| High zero-result rate | Mine failed queries → add synonyms to taxonomy → fix labels, then tune the engine |
| Users search for things with visible browse paths | Scent failure: rewrite labels with user vocabulary, re-test first click |
| Deep hierarchy already shipped | Add breadcrumbs + cross-links + search before attempting a re-architecture |

## Cross-refs

- [[HUMAN_PERCEPTION]] — attention, scanning, and chunking mechanics underlying scent and Hick's law.
- [[INTERACTION_PSYCHOLOGY]] — decision costs, defaults, and effort heuristics at each click.
- [[ONBOARDING_AND_LEARNING]] — teaching structure to first-run users and building mastery of it.
- [[ACCESSIBILITY_AND_INCLUSION]] — landmark roles, skip links, and screen-reader navigation of the same structures.
- [[PATTERN_LANGUAGE]] — concrete nav/search/breadcrumb component patterns implementing these rules.
- [[MULTI_DEVICE_ECOSYSTEMS]] — keeping one mental model when navigation reflows across form factors.
