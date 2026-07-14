# ONBOARDING_AND_LEARNING

## Purpose

Decides how a product teaches itself: first-run flows, guided discovery, empty states, skill progression from novice to expert, and adaptive learning systems. Load when designing anything a user meets before they are competent — or any mechanism that grows their competence.

## Principles

- Onboarding optimizes for the first felt success ("aha moment"), not feature coverage. Users form a keep-or-abandon judgment from early outcomes; activation-metric practice across SaaS/consumer shows retention correlates with reaching one core value event, not with tour completion. Every screen before that event is cost. [E]
- People learn by doing, not by reading about doing. Carroll's minimalist instruction studies (IBM, *The Nurnberg Funnel*) showed task-first learners outperform manual-first learners in both speed and retention — put real actions where tutorials would go. [E]
- Motivation for any first-run step follows Fogg's B=MAP: behavior fires when motivation, ability, and prompt coincide. Onboarding cannot much raise motivation, so it must raise ability (shrink the step) and time the prompt (ask when intent is visible). [E]
- Started-but-unfinished tasks create completion pressure (Zeigarnik effect), and perceived progress accelerates effort as the goal nears (goal-gradient: Kivetz et al. 2006, café reward-card completion sped up near the end); pre-stamped cards nearly doubled completion, 34% vs 19% (endowed progress: Nunes & Drèze 2006). Progress you *give* the user is fuel. [E]
- Teach inside the zone of proximal development: introduce a capability only when it is one step beyond what the user just did (Vygotsky's scaffolding). Concepts presented with no anchoring task are discarded — this is why up-front carousel tours test poorly on recall. [E]
- Fluency is a spatial skill: users learn *where* things are, not lists of features. Interfaces that silently rearrange themselves (fully adaptive menus) break spatial memory; Findlater & McGrenere found static and user-controlled layouts beat system-adaptive ones for speed and preference. Adapt content, keep geography stable. [E]
- Skill follows the power law of practice: time-per-task drops as a power function of repetitions. Expert efficiency features (shortcuts, batch actions) pay off only after basics are automatic — sequencing matters more than availability. [E]
- Retention of taught concepts decays exponentially (Ebbinghaus forgetting curve); reinforcement spaced over days beats massed repetition (spacing effect). One-shot onboarding cannot produce durable knowledge — plan re-exposure. [E]
- An empty state is the interface's first sentence, not an error condition. Users read absence as meaning ("nothing works here" vs "your first X goes here"); framing it as an invitation converts dead ends into starts. [H]

## Rules

### First-run

- Define one activation event (the measurable proxy for first value) before designing any first-run UI; instrument it; judge every onboarding change by time-to-value and activation rate, not completion of the flow itself. [E]
- Time-to-value budget: first felt success inside the first session — under 2 minutes for consumer products, under 15 minutes for tools requiring setup. Every mandatory pre-value step must justify itself against measured drop-off (each extra signup/setup screen typically sheds 10–20% of entrants). [H]
- Defer every input you can: ask for permissions, profile data, and configuration at the moment they unlock something visible, never as an up-front wall. Request OS-level permissions (notifications, location) only after a user action makes the benefit obvious — pre-prompt context roughly doubles grant rates. [E]
- If you use a tour, cap it at 3 steps, make every step skippable, and make each step point at a live element the user can act on immediately. Passive multi-screen carousels are banned: skip rates commonly exceed 50% and recall approaches zero. [H]
- Use an onboarding checklist of 3–5 concrete tasks with one item pre-completed ("account created ✓") — endowed progress (Nunes & Drèze) plus Zeigarnik tension measurably lifts completion versus an empty list. Show percent or fraction complete. [E]
- Let users reach the real interface with defaults intact even if they skip everything; onboarding is an accelerant, never a gate. Provide a way to re-enter it later (help menu: "restart setup"). [E]

### Guided discovery

- Teach just-in-time: one contextual hint, attached to the element it explains, triggered by the user entering the relevant context — never more than one hint on screen at once, and never re-show a dismissed hint more than once. [E]
- Scaffold, then fade: reveal advanced capability only after its prerequisite action has been performed (e.g., show "batch edit" after ≥3 single edits). Restricting early surface area — Carroll's "training wheels" interface — cut novice error time ~50% without slowing later learning. [E]
- Progressive disclosure budget: the default surface shows only what a first-week user needs; capabilities used by <20% of users start folded one level deeper. Mechanism: every visible-but-irrelevant control adds choice cost (Hick–Hyman: decision time grows with log of options). [E]
- Prefer recognition over recall in all guidance: label the thing where it lives instead of explaining it elsewhere; a hint that requires remembering a prior screen has already failed. [E]
- Make guidance dismissible in one interaction and never repeat-block the same workflow twice; forced repetition of known material reads as distrust and trains users to dismiss all guidance unread (habituation, same mechanism as banner blindness). [E]

### Empty states

- Every list, canvas, inbox, or dashboard ships a designed first-use empty state with exactly one primary action ("Create your first project"), ≤2 sentences of copy stating what will appear here and why it's valuable, and an optional example/template path. [E]
- Distinguish the three empty types and design each: first-use (invite + educate), user-cleared (celebrate or stay quiet — "inbox zero" is a reward state), and no-results (show the failed query, offer a corrected/broader search). Reusing one screen for all three misinforms two of them. [E]
- Offer demo data or a template when the product's value needs mass to be visible (dashboards, analytics, boards); label it clearly as sample and make it one-tap removable. Mechanism: concrete instances beat abstract descriptions for mental-model formation. [H]
- Never let an empty state be literally blank or a bare spinner-then-nothing; a zero-data screen with no action is a measured drop-off point and reads as breakage. [H]

### Skill progression and adaptive learning

- Design explicit novice → intermediate → expert paths for the top 3 workflows: novice path = defaults and recognition; expert path = shortcuts, command palette, batch operations. Both must produce the same result (Nielsen's "flexibility and efficiency of use" — accelerators invisible to novices). [E]
- Surface accelerators from observed behavior with a threshold, not a timer: after the same menu/command is used ≥3–5 times, show its keyboard shortcut once, inline, at the moment of use. Frequency-triggered, single-shot, contextual. [H]
- Space reinforcement of taught concepts at roughly expanding intervals (~1, 3, 7+ days) rather than repeating in-session; spacing-effect literature shows distributed exposure roughly doubles retention versus massed at equal total exposure. Applies to tips, digest emails, and re-engagement nudges. [E]
- Adapt what is *offered*, never silently move what is *learned*: recommendations, suggested next actions, and smart defaults may personalize; core navigation and control positions stay stable (or change only via user opt-in), preserving spatial memory. [E]
- Persist competence: never replay first-run onboarding after redesigns, device switches, or long absence. For returning users after major change, show a diff-style "what changed" (≤3 items), not a restart. [H]
- Track a proficiency signal per user (e.g., distinct features used, shortcut ratio, error/undo rate) and gate expert-mode suggestions on it; prompting novices toward expert density raises error rates instead of speed. [H]

## Decision guide

| Situation | Do |
|---|---|
| New product, designing first-run | Pick the activation event → shortest instrumented path to it → checklist (3–5 items, 1 pre-done) around it |
| Stakeholder wants a feature tour | Counter with ≤3-step interactive, skippable pointers on live UI; measure activation, not tour completion |
| Screen can be empty | Design all three empties (first-use / cleared / no-results); first-use gets one primary CTA + ≤2 sentences |
| Value invisible without data | Sample data or template, labeled, one-tap removable |
| Feature undiscovered (<20% usage) | Contextual just-in-time hint at moment of relevance; if still unused, question the feature before adding more prompting |
| Users stuck at basic proficiency | Frequency-triggered shortcut hints (≥3 uses), same-result expert path, spaced tips (1/3/7 days) |
| Redesign shipping | "What changed" diff (≤3 items) for existing users; full onboarding only for genuinely new accounts |
| Tempted to auto-rearrange UI by usage | Don't move learned geography; adapt suggestions/content instead, or offer opt-in layout change |

## Cross-refs

- [[INTERACTION_PSYCHOLOGY]] — deeper mechanics of motivation, habit loops, and cognitive load behind these rules.
- [[MICROINTERACTIONS]] — crafting the individual hints, confirmations, and progress moments onboarding is built from.
- [[EMOTIONAL_DESIGN]] — tone of first-run and empty-state copy; delight without gimmick.
- [[INFORMATION_ARCHITECTURE]] — structuring navigation so discovery needs less guidance in the first place.
- [[PERFORMANCE_PERCEPTION]] — first-run waiting states; perceived speed during setup and data import.
- [[GENERATIVE_AND_ADAPTIVE_UI]] — adaptive interfaces beyond learning aids; personalization system design.
