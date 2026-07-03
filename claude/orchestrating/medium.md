# medium.md — planned execution with bounded fan-out

Between `lite.md` (one sequential pass) and `orchestrator.md` (4 chats, multi-day): for an ask with **a handful of units (~2–6), some structure, fits ~one session** — worth a written plan and maybe a few parallel build agents, but NOT the orchestrator's session-splitting / disk-artifact / checkpoint overhead.

**Routed here from `wishlist.md`.** Turns out trivial / single unit → drop to `lite.md`. Turns out many independent units, multi-day, or context won't fit one window → escalate to `orchestrator.md` Session A (your plan becomes its spec input).

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena/LSP. Output styles off. **Think deep, output terse.**

## Flow

1. **Understand.** Trace the real paths (Serena/LSP, not whole-file reads). Brownfield: read before you write. Bug → root cause across all callers, not the symptom.
2. **Plan.** Write a short plan — units + order + deps + the one load-bearing design call. **`ultrathink` that design call** (blast radius); none on mechanical work. Keep the plan in-chat (or a single `plan.md`) — no `prd.json` / `depmap` / per-unit briefs.
3. **Dispatch.** Genuinely independent units → **fresh build subagents in parallel** (2–4; never fork), each returns a **≤2-line structured note** (never a build dump). Coupled units → do them sequentially yourself. Agent types via the `~/.claude/agents-docs/README.md` tree (load only the needed category file). Main chat holds only the small plan + statuses.
4. **Integrate.** One feature branch; bring the unit work together, resolve conflicts, run the **full build + test + lint on the combined result** (not just per-unit). `think hard` only if a cross-unit break appears.
5. **Verify + land.** DoD green (`verification-before-completion`: evidence, not assertion). `commit -q`, no AI attribution; PR only if asked. Then print the cleaning kickoff for a fresh chat: `Read ~/.claude/cleaning/README.md and run it.`

## Efficiency

Same reflexes as `lite.md` §Efficiency (dedicated tools, load less, parallel, don't re-read, todo for multi-step, git/gh hygiene). The one extra rule, because you're fanning out: **subagent returns ≤2 lines, structured — never let a build/grep dump into the main chat.** Ensure subagents work in isolated worktrees to avoid checkout conflicts.

## Why it's its own tier

Holds a *small plan in-chat* — lite holds none; the orchestrator pushes everything to disk so its window stays empty. One branch + one integration pass (orchestrator: rolling integration across waves). One chat (orchestrator: A/B/C/D separate). At 2–6 units the coordination fits one head; past that, the scale-management machinery starts paying for itself — escalate.
