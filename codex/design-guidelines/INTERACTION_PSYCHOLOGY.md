# INTERACTION_PSYCHOLOGY

## Purpose

Decides how an interface motivates, rewards, builds trust, and applies friction: reward scheduling, curiosity mechanics, engagement loops, and behavioral patterns. Load when designing anything a user returns to, commits to, or could be manipulated by.

## Principles

- Behavior fires only when Motivation, Ability, and a Prompt converge (Fogg B=MAP). When a desired action isn't happening, raise ability (make it easier) before raising motivation — ability changes are cheaper, more durable, and don't fatigue. [E]
- Variable-ratio rewards produce the highest response rates and the strongest resistance to extinction of any reinforcement schedule (Ferster & Skinner 1957). This is the engine of slot machines and infinite feeds alike — potency creates an ethical obligation, not an excuse. [E]
- Losses weigh roughly 2× gains (loss-aversion coefficient λ ≈ 2.25, Tversky & Kahneman 1992). Framing the same state as "protect what you have" outpulls "gain something new" — and equally amplifies harm when used to trap. [E]
- Curiosity is an information gap: it peaks when a person knows enough to know what they're missing (Loewenstein 1994). Zero context produces indifference; full disclosure kills the itch. Reveal partially, never fully, never nothing. [E]
- Motivation rises with proximity to a goal (goal-gradient effect, Hull 1932): effort accelerates as the end nears, and perceived head starts work as well as real ones (endowed progress, Nunes & Drèze 2006: 34% vs 19% completion for identical remaining effort). [E]
- Interrupted or incomplete tasks may be remembered better than completed ones (Zeigarnik effect; replications are inconsistent) — visible unfinished state can itself act as a return prompt. [H]
- Memory of an experience is dominated by its most intense moment and its ending (peak-end rule, Kahneman et al. 1993), not its average or duration. Engineer one peak and the exit; the middle is forgiven. [E]
- Trust is the product of three perceptions — competence (it works), reliability (it works every time), and benevolence (it works for me, not on me). One visible act against the user's interest resets all three; trust accrues linearly and collapses exponentially. [H]
- Small acts of investment (customizing, saving, contributing) increase commitment via consistency bias and the endowment effect — people value what they've shaped and stay consistent with what they've done (Cialdini). Investment is the strongest retention lever that isn't a trap. [E]
- Friction is a tool, not a defect: added friction filters low-intent actions and prevents errors; removed friction accelerates high-intent ones. Friction that serves only the business, not the user, is sludge (Thaler 2018) and reads as bad faith once noticed. [E]
- Extrinsic rewards can crowd out intrinsic motivation for already-enjoyable tasks (overjustification effect, Deci et al. 1999 meta-analysis). Point-scoring an activity people loved for its own sake can permanently cheapen it. [E]

## Rules

### Reward systems

- Schedule rewards on variable ratio only for genuinely variable content (feeds, discovery, loot); use fixed, predictable rewards for utility actions (saving, completing, paying). Randomizing a utility reward reads as broken, not exciting. [E]
- Every reward answers a real action within 400 ms (Doherty threshold) — acknowledgment first, payout can lag. Unacknowledged actions extinguish the behavior faster than absent rewards. [E]
- Cap celebration intensity to achievement rarity: routine action → ≤300 ms micro-feedback; weekly milestone → one animated moment; rare achievement (top ~5% of sessions) → full-screen. Inflated praise for trivial acts devalues the currency (habituation). [H]
- Never attach variable rewards to money-like stakes or to children's interfaces; disclose odds wherever randomized value is purchasable (loot-box rule, now law in several jurisdictions). [E]
- Do not gamify intrinsically satisfying actions. Add points/badges only where motivation is genuinely absent, and expect behavior to drop if you later remove them (overjustification). [E]

### Curiosity and engagement loops

- Build loops with all four stages — trigger → action → variable reward → investment (Eyal) — and audit them with one test: does the user, reflecting later, endorse the time spent? An unendorsed loop is a trap; redesign or remove it. [H]
- Open information gaps honestly: previews, partial reveals, and progressive disclosure must deliver the implied payoff. Curiosity bait with a mismatched payoff (clickbait pattern) buys one click and costs the trust term permanently. [E]
- Show progress toward goals with an endowed head start where honest history exists (e.g., "2 of 8 steps done from your signup data"); never fabricate progress — fabrication discovered converts goal-gradient pull into reactance. [E]
- Use visible incomplete states (drafts, partial profiles, unfinished streaks) as return prompts (Zeigarnik); pair every streak with a repair mechanic (1 freeze/skip per interval) so a single miss doesn't convert loss aversion into abandonment. [H]
- Place the emotional peak at the moment of user achievement, not app self-congratulation, and end every session flow on a completed note — peak-end governs what the return decision remembers. [E]

### Trust

- Keep latency, wording, and layout consistent across sessions; reliability perception is set by worst-case, not average — one 10 s hang outweighs a hundred fast loads. Cross-check budgets in [[PERFORMANCE_PERCEPTION]]. [H]
- State what happens before it happens for any consequential action (cost, publish, delete, share); surprise outcomes are the single fastest benevolence-killer. [H]
- Ask for permissions, personal data, and commitment only at the moment of evident need, after the product has demonstrated value — reciprocity precedes disclosure. Never at first launch. [E]
- Admit errors in plain language with a next step; interfaces that acknowledge fault are rated more, not less, trustworthy (service-recovery paradox). [E]

### Friction design

- Match friction to consequence: irreversible/destructive → typed confirmation or 2-step; reversible → act immediately + undo (5–10 s window). Undo beats confirm: confirmation dialogs habituate within days, undo never does. [E]
- Add deliberate friction (one interstitial pause, ~1 s) before actions users regret at scale — rage-posts, huge sends, big purchases; a single "are you sure you read this?" prompt reduced unread article shares measurably (Twitter 2020, ~40% more opens before RT). [E]
- Remove every friction step that serves only the operator: cancellation, unsubscribe, and data export must cost ≤ the effort of the corresponding signup (symmetric-effort rule; codified in FTC click-to-cancel). Asymmetry is sludge and is increasingly illegal. [E]
- Defaults are decisions: whatever ships pre-selected, most users keep (defaults shift outcomes by tens of percentage points — organ-donation consent >85% opt-out vs <30% opt-in, Johnson & Goldstein 2003). Default to the option a fully informed user would pick, never the one that pays best. [E]

### Behavioral patterns — bans

- Banned outright: confirmshaming ("No thanks, I hate saving money"), roach-motel flows (easy in, hidden exit), forced continuity without pre-renewal notice, fake urgency/scarcity (countdowns that reset, invented stock levels), disguised ads, nagging re-prompts after explicit refusal. Each converts a known bias into a trap and is documented to raise churn and regulatory exposure once recognized. [E]
- Re-prompt a declined request at most once, after a state change that plausibly changes the answer — never on a timer. [H]
- Every persuasive mechanic must pass the reflective-endorsement test (would the user approve of it if fully explained?) and the front-page test (would you publish the mechanic's description?). Fail either → cut. [H]

## Decision guide

| Situation | Do |
|---|---|
| Desired action not happening | Fogg audit in order: prompt present? → ability high enough? → only then add motivation/reward |
| Choosing a reward schedule | Content genuinely variable → variable ratio; utility action → fixed + instant (<400 ms ack) |
| Users start but don't finish | Goal-gradient: show progress, grant honest endowed head start, surface the incomplete state |
| Users finish but don't return | Check loop: external/owned trigger? investment step? peak+end placed on user achievement? |
| High regret or error rate on an action | Add matched friction: undo for reversible, typed confirm + pause for irreversible |
| Business asks for a growth mechanic | Run reflective-endorsement + front-page tests; check bans list; symmetric-effort on any exit path |
| Trust metrics dropping | Audit worst-case consistency, surprise outcomes, and permission timing before adding reassurance copy |

## Cross-refs

- [[MICROINTERACTIONS]] — feedback timing and micro-reward execution at the component level.
- [[EMOTIONAL_DESIGN]] — tone, delight, and the affective layer these mechanics operate through.
- [[ONBOARDING_AND_LEARNING]] — first-run motivation, mastery curves, and when to introduce loops.
- [[PERFORMANCE_PERCEPTION]] — latency thresholds that gate reward acknowledgment and reliability perception.
- [[HUMAN_PERCEPTION]] — attention and cognition limits underlying prompts and curiosity gaps.
