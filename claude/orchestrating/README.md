# Orchestrating

A pick-the-right-weight system for turning a wishlist into shipped work. You write the ask once; a router sizes it and runs the matching strategy. All three strategies share the same token-efficiency + correctness discipline — they differ only in machinery.

## Start

Fill `wishlist.md`, then in a **fresh Claude Code chat in your target repo**: paste it, or type
`Read ~/.claude/orchestrating/wishlist.md and run it`.
The router sizes the ask and routes — you don't pick.

## The ladder

Always safe to start lighter; escalate on discovery. Borderline → lighter tier (cheap to escalate, expensive to over-build).

| Tier | File | For | Machinery |
|------|------|-----|-----------|
| **Lite** | `lite.md` | one feature / bugfix / refactor, sequential | 1 chat, 1 agent |
| **Medium** | `medium.md` | a handful of units (~2–6), some deps, ~1 session | 1 chat, plan + bounded parallel agents |
| **Big** | `orchestrator.md` | many independent epics, shared scaffolding, multi-day | 4 chats, fan-out, disk artifacts, checkpoints |

## Files

- `wishlist.md` — entry point + router (the file you edit)
- `lite.md` / `medium.md` / `orchestrator.md` — the three strategies
- `.orchestrator/` — runtime state, **big tier only**, created in the *target repo* (spec, briefs, notes, handoff)

## Shared discipline (every tier)

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena/LSP, output styles off; **think ∝ blast radius**; **DoD gate** (build + test + lint green before "done"); diff edits over rewrites; dedicated search tools; no AI attribution.

## Install

`install.sh` symlinks this folder to `~/.claude/orchestrating/`. RTK needs its shell hook installed; caveman/ponytail activate when the chat invokes the skills — on a bare machine the pipeline still runs, minus those savings.
