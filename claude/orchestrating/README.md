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
- `~/.claude/agents-docs/` — sibling system: the **agents catalog** (who to dispatch, by pipeline function). B picks each unit's `agent`; C uses its role snippets; D + cleaning keep it current. Load category files JIT, never the whole thing.
- `~/.claude/cleaning/` — sibling system: post-cycle repo reset + docs refresh (every tier's land step prints its kickoff)

## Shared discipline (every tier)

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena/LSP (unavailable → Grep/Read); **think ∝ blast radius**; **DoD gate** (build + test + lint green before "done"); diff edits over rewrites; dedicated search tools; no AI attribution. Output styles (`explanatory`/`learning`) are **user config a session can't switch** — dotfiles settings.json keeps both plugins `false`; don't re-enable.

## Fresh machine

Clone dotfiles → run `install.sh`: symlinks this folder, the agents catalog (`claude/agents/` → `~/.claude/agents-docs/` — NOT `~/.claude/agents/`, which is the live agent-defs dir), the enforcement hooks (`claude/hooks/` → `~/.claude/hooks/`), the real agent defs (`claude/agent-defs/*` → `~/.claude/agents/`) + `settings.json` (declares every plugin; core set enabled globally, stack plugins per-project — see `claude/PLUGINS.md`) and installs `jq` (**load-bearing: every hook exits silently without it**) + `rtk` + `ccusage`. `settings.json` hook/statusline paths use `$HOME`, so they survive any username. Should be turnkey across laptops.

One residual: `settings.json` is runtime-written, so a session *could* re-bake absolute `/Users/<name>/` paths over the `$HOME` ones — if hooks/statusline break later, re-check that.
