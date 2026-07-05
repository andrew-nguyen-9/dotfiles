# EMOTIONAL_DESIGN

## Purpose

Decides the emotional layer of an interface: which feeling each moment should produce, how to earn trust, reduce anxiety, express personality, and place delight. Load when setting tone, writing state/error copy, designing empty/waiting/failure states, or auditing why a functionally correct product feels cold or untrustworthy.

## Principles

- Emotion precedes cognition: users form an affective judgment of a screen in ~50ms (Lindgaard et al., 2006), before reading a word. First-paint aesthetics is an emotional decision, not decoration. [E]
- Aesthetic-usability effect: interfaces judged more attractive are perceived as easier to use and are forgiven more errors (Kurosu & Kashimura, 1995; Tractinsky et al., 2000). Visual care is functional slack — it buys tolerance for the failures you haven't fixed yet. [E]
- Norman's three levels — visceral (instant sensory reaction), behavioral (felt competence during use), reflective (the story users tell about themselves using it) — are designed with different tools: form/color/motion, feedback/control, identity/meaning. A product weak on one level cannot compensate with another. [E]
- Peak-end rule: remembered experience ≈ average of the emotional peak and the final moment, not the sum (Kahneman et al., 1993). Duration is largely neglected. Engineer one deliberate peak and a clean ending per journey; a mediocre middle is cheap. [E]
- Negativity bias: negative events weigh roughly 2–4× positive ones in memory and judgment (Baumeister et al., 2001). One hostile error message can erase ten delight moments — fix the worst moment before polishing the best. [E]
- Trust is asymmetric: built in small consistent increments, destroyed in single violations, and it transfers — sloppy typography lowers believed accuracy of the content itself (Fogg et al., 2003 credibility studies: visual design is the #1 cited credibility cue). [E]
- Arousal and valence are separable axes (circumplex model, Russell 1980). "Exciting" (high arousal, positive) and "calm" (low arousal, positive) are both good targets but opposite executions; pick per context — checkout wants calm, launch moment wants excitement. [E]
- Personality is consistency of choices, not mascots. Users attribute character to any system with consistent voice, timing, and motion (Nass & Reeves, media equation, 1996) — you have a personality whether designed or accidental; accidental reads as careless. [E]
- Delight obeys diminishing returns and habituation: a repeated surprise becomes furniture in 3–5 exposures, then noise. Delight belongs on rare paths (first-run, milestones, recovery), never on hot paths users hit 50×/day. [H]
- Anxiety is mostly uncertainty, not difficulty: unknown wait length, unclear reversibility, ambiguous system state. Reducing uncertainty (progress, previews, undo) cuts anxiety more than reducing steps. [H]
- Human connection ≠ pretending to be human. Warm, accountable, first-person-plural voice builds connection; fake empathy from a system ("I'm so sorry! 😢" from a bank) reads as manipulation and lowers trust. [H]

## Rules

### Emotional mapping

- Map every core journey before styling it: for each stage (entry → action → wait → result → exit) write the user's arriving emotional state and the target state, one word each on the arousal/valence axes. No stage may have target "neutral" — neutral is an unmade decision. [H]
- Match arousal at entry, then steer: an anxious user (error, payment, deadline) is met with low-arousal design — muted palette, fewer options, short sentences — before any upsell or celebration. Steering against arrival state (confetti on a failure recovery) reads as tone-deaf. [H]
- Place exactly one designed emotional peak per journey and invest in the last screen of the flow (peak-end rule). Success states get the same design hours as first screens; a flow may not end on a dead-end confirmation with no next action. [E]
- Emotional range budget: define ≤3 named tones for the product (e.g. calm / capable / celebratory) and assign every screen one of them. More than 3 tones in one product produces a mood-swinging interface. [H]

### Trust signals

- Consistency is the base signal: one term per concept, one component per job, identical spacing/radius/casing across screens. Each inconsistency is read (subconsciously) as either carelessness or deceit — both discount trust (Fogg: "amateurism" is a top credibility killer). [E]
- Latency honesty: acknowledge any action within 100ms; show determinate progress for waits >1s; never show a progress bar that lies (jumps to 90% then stalls). A caught lie in progress UI discounts all future system claims. [E]
- Show the price of the click before the click: destructive actions state scope ("Delete 14 files — cannot be undone"), payments state the exact charge and date, subscriptions state renewal terms at signup, not in the receipt. Surprise cost is the fastest trust destroyer. [H]
- Admit errors in first person and state the next step: "We lost your connection — your draft is saved" beats "An error occurred (code 500)". Blame the system, never the user; passive voice in error copy is banned. [H]
- Social proof must be specific and verifiable to work: "4,213 teams" with a link outperforms "trusted by thousands"; fabricated-looking round numbers and stock-photo testimonials backfire (specificity is a core credibility heuristic). [E]
- Dark patterns are trust arson: no pre-checked upsells, no guilt-trip decline copy ("No thanks, I hate saving money"), no hidden unsubscribe. Short-term conversion gains reverse as churn and reputation damage (FTC/EU enforcement + Mathur et al., 2019 dark-patterns corpus). [E]

### Anxiety reduction

- Reversibility beats confirmation: prefer undo (5–10s window) over "Are you sure?" dialogs for any action recoverable in <30s of work. Confirmation dialogs get click-through-habituated within days; undo keeps safety without friction. [E]
- Never present an unbounded wait: >1s gets a progress indicator, >10s gets a time estimate or step count, >60s gets "we'll notify you" plus permission to leave. Unknown duration is rated more stressful than known-longer duration. [E]
- Preview before commit: any input with a visible consequence (formatting, cropping, publishing, sending to N people) shows the result state before the irreversible step. "What will happen" uncertainty is the anxiety, not the action. [H]
- Empty states carry three parts: what this space is for, what it looks like when alive (illustration or example data), and the one action that starts it. A blank panel with only "No items" reads as either broken or your fault. [H]
- Cap simultaneous choices at the decision point: ≤5 primary options per screen for anxious contexts (payment, medical, error recovery); overflow goes behind "more". Choice overload measurably lowers action rates and satisfaction (Iyengar & Lepper, 2000). [E]
- Autosave everything a user types for >10s, and say so ("Saved" with timestamp). Fear of loss is a background anxiety on every long form; a visible save state removes it for one line of UI. [H]

### Personality systems

- Define personality as a 4-slider spec, each with a 1–5 position and a banned extreme: formal↔casual, serious↔playful, matter-of-fact↔warm, terse↔expressive. Every writer and every component (button copy, errors, emails) inherits the same positions. [H]
- Voice is fixed; tone flexes by context within ±1 slider step: playful may drop to neutral in an error state, but a formal product never cracks jokes at failure. Publish a 4-cell voice/tone matrix (success/failure × routine/high-stakes) with one example sentence per cell. [H]
- Personality must survive translation into non-verbal channels: motion curves (snappy vs. languid), sound (see [[SENSORY_DESIGN]]), color temperature, and illustration style all sit at the same slider positions as the copy. Mismatched channels (playful copy, sterile motion) read as two products. [H]
- Distinctiveness check: cover the logo — can a returning user still name the product from one screen? If every choice is defensible-generic, personality is zero; see [[ANTI_HOMOGENIZATION]] for escape moves. [H]

### Surprise and delight

- Delight placement whitelist: first-run completion, milestones (streaks, 100th item), recovery moments (after an error is fixed), seasonal easter eggs. Blacklist: hot paths, error states themselves, anything blocking, anything >2s of forced animation. [H]
- Variable > fixed reward for repeat encounters: a small pool (≥5 variants) of celebration copy/animation sampled randomly resists habituation far longer than one perfect animation (variable-ratio reinforcement, Skinner). Rotate before users can predict. [E]
- Every delight moment must be skippable and must cost 0 task time: user can act/dismiss immediately; animation runs alongside, never in front of, the next action. Delight that delays becomes irritation on second exposure. [H]
- Budget rule: ≤1 designed delight moment per session-typical journey; if analytics show a "delight" surface triggering >3×/session, demote or remove it. [H]

### Human connection

- Write for one person: "your dashboard", not "users' dashboards"; second person throughout product UI, first person ("my…") only for user-owned labels the user selects. Direct address measurably increases perceived relevance. [H]
- Show the humans behind the product at trust-critical seams: real names in support replies, changelog entries signed by people, a team page with actual faces. Reciprocal self-disclosure increases user trust and disclosure (Moon, 2000). [E]
- Machine honesty rule: automated messages identify as automated; bots don't use "I feel". Warmth comes from word choice and helpfulness, not simulated emotion — violating this reads as manipulation once discovered. [H]
- Celebrate the user's work, not the product: "You shipped 12 reports this month", never "Look what our AI did for you". Reflective-level pride attaches users; product self-congratulation repels. [H]

## Decision guide

| Situation | Do |
|---|---|
| Screen feels cold but works fine | Audit visceral layer: color temperature, motion, imagery vs. slider spec; then check voice for passive/system-centric copy |
| Users hesitate at a step | Treat as uncertainty, not difficulty: add preview, undo, or explicit cost/scope statement before adding help text |
| Where to spend polish hours | Worst moment first (negativity bias), then journey end, then the one peak — in that order |
| Error state design | Low arousal: mute palette, one next action, first-person-plural accountable copy, no mascots/jokes |
| Delight idea proposed | Check whitelist (rare path? skippable? 0 task-time cost? variant pool?) — any "no" kills it |
| Confirmation dialog vs. undo | Recoverable in <30s → undo with 5–10s window; truly irreversible → typed confirmation stating scope |
| Copy tone dispute | Locate context in the voice/tone matrix; tone may flex ±1 step from voice sliders, never further |
| Trust metric dropping | Sweep for: inconsistent terms/components, lying progress UI, hidden costs, dark-pattern flows — fix before adding testimonials |

## Cross-refs

- [[SENSORY_DESIGN]] — executing tone through sound, haptics, and texture channels.
- [[MICROINTERACTIONS]] — mechanics of the feedback moments this doc assigns emotions to.
- [[INTERACTION_PSYCHOLOGY]] — motivation, habit, and persuasion mechanics beneath these rules.
- [[HUMAN_PERCEPTION]] — attention and processing limits that cap arousal and choice budgets.
- [[PERFORMANCE_PERCEPTION]] — wait-state thresholds and perceived-speed techniques in depth.
- [[ANTI_HOMOGENIZATION]] — concrete moves when the personality check returns "generic".
- [[ONBOARDING_AND_LEARNING]] — first-run flows where visceral impressions and delight land first.
