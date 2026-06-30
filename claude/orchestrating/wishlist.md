# Wishlist + router

Fill the **WISHLIST** and **PROJECT** sections below, then in a **fresh Claude Code chat opened in your target repo** either paste this whole file or type:
`Read ~/.claude/orchestrating/wishlist.md and run it.`

The chat first **routes** your ask to the right weight — you don't choose:

- **Lite** — one feature / bugfix / refactor, sequential → `lite.md`. **Most asks.**
- **Medium** — a handful of units (~2–6), some deps, ~one session → `medium.md` (plan + bounded parallel agents).
- **Big** — many independent epics / shared scaffolding / multi-day → `orchestrator.md` (4-session pipeline).

---

**INSTRUCTIONS TO CLAUDE — do not edit this block:**

```
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Glance at the repo (structure / README / build files — a quick scan, not a deep index) and read the WISHLIST below. Then ROUTE by size:

- LITE — single feature / bugfix / refactor, one sequential pass
    → Read ~/.claude/orchestrating/lite.md and run it.
- MEDIUM — a handful of units (~2-6) with some deps/structure, fits ~one session, benefits from a plan + maybe 2-4 parallel build agents
    → Read ~/.claude/orchestrating/medium.md and run it.
- BIG — many genuinely independent epics, shared scaffolding, multi-day, worth ~15× fan-out
    → Read ~/.claude/orchestrating/orchestrator.md and run Session A — Intake.

State the chosen route + a one-line why before starting.
Borderline → pick the lighter tier (cheap to escalate mid-task; expensive to over-build).
```

---

## WISHLIST

<!-- Write everything you want built/fixed/changed. Be as messy or detailed as you like —
     the chosen strategy will normalize it and ask clarifying questions where needed. -->



## PROJECT (optional hints — fill what you know, leave the rest)

- **Repo:** <path, or "current directory">
- **Stack:** <languages / frameworks, or "infer from repo">
- **Greenfield or brownfield:** <empty repo / existing codebase>
- **DoD commands:** <build / test / lint, or "infer">
- **Hard constraints:** <deadlines, must-not-touch areas, compliance, secrets location>
- **Branch prefix / release policy:** <orchestrator route only — e.g. feat; ship-without vs block-release>
