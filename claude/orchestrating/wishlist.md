# Wishlist + router

Fill the **WISHLIST** and **PROJECT** sections below, then in a **fresh Claude Code chat opened in your target repo** either paste this whole file or type:
`Read ~/.claude/orchestrating/wishlist.md and run it.`

The chat first **routes** your ask to the right strategy — you don't choose:

- **Big** — multiple genuinely independent epics / shared scaffolding / multi-day → `orchestrator.md` (4-session multi-agent pipeline).
- **Small–medium** — feature, bugfix, refactor, coupled steps that fit ~one session → `lite.md` (single-session, same efficiency discipline). **Most asks land here.**

---

**INSTRUCTIONS TO CLAUDE — do not edit this block:**

```
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Glance at the repo (structure / README / build files — a quick scan, not a deep index) and read the WISHLIST below. Then ROUTE:

- BIG — multiple genuinely independent epics, shared scaffolding, multi-day, worth ~15× multi-agent fan-out
    → Read ~/.claude/orchestrating/orchestrator.md and run Session A — Intake.
- SMALL–MEDIUM — single feature / bugfix / refactor / coupled steps that fit ~one session
    → Read ~/.claude/orchestrating/lite.md and run it.

State the chosen route + a one-line why before starting.
Borderline → default to lite (cheap to escalate mid-task; expensive to over-build a small ask).
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
