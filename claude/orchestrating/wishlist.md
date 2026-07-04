# Wishlist + router

This is a **template** — don't fill it in place (it's your symlinked dotfiles). Either **copy it into your target repo** (`cp ~/.claude/orchestrating/wishlist.md ./wishlist.md`), fill it there, and tell a fresh chat `read ./wishlist.md and run it`; **or** paste the template into a fresh chat and fill the **WISHLIST** inline. Open the chat **in the target repo**.

The chat first **routes** your ask to the right weight — you don't choose:

- **Lite** — one feature / bugfix / refactor, sequential → `lite.md`. **Most asks.**
- **Medium** — a handful of units (~2–6), some deps, ~one session → `medium.md` (plan + bounded parallel agents).
- **Big** — many independent epics / shared scaffolding / multi-day → `orchestrator.md` (4-session pipeline).

---

**INSTRUCTIONS TO CLAUDE — do not edit this block:**

```
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Any plugin/skill missing → proceed without it, note it once.
CWD CHECK first: current repo must match the WISHLIST's target (Repo hint or content) — mismatch → STOP and ask, don't route.
Glance at the repo (structure / README / build files — a quick scan, not a deep index) and read the WISHLIST below. Then ROUTE by size:

- LITE — single feature / bugfix / refactor, one sequential pass (incl. research-only and docs-only asks — skip build-shaped steps)
    → Read ~/.claude/orchestrating/lite.md and run it.
- MEDIUM — a handful of units (~2-6) with some deps/structure, fits ~one session, benefits from a plan + maybe 2-4 parallel build agents
    → Read ~/.claude/orchestrating/medium.md and run it.
- BIG — many genuinely independent epics, shared scaffolding, multi-day, worth ~15× fan-out
    → Read ~/.claude/orchestrating/orchestrator.md and run Session A — Intake.

MEDIUM↔BIG gate: >6 independent units OR multi-day OR shared scaffolding → BIG; else MEDIUM (borderline stays MEDIUM).

State the chosen route + a one-line why before starting — the line MUST name the detected repo root + project identity as evidence (e.g. "LITE in ~/code/acme (acme-api, per package.json)"), so a wrong-repo run is visible even when the Repo hint says "current directory".
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
