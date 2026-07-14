# Codex orchestration

This is the Codex-native counterpart to the Claude workflow. It keeps the same three sizes and disk-backed handoff model while using Codex tools and Codex's shared-workspace agent behavior.

## Route

1. Copy `wishlist.md` into the target repository and fill it there.
2. Run the routing block in that copy.
3. Follow exactly one path:
   - `lite.md` — one focused outcome, usually handled by the root agent.
   - `medium.md` — several units that fit one task; delegate only independent work.
   - `orchestrator.md` — multi-wave work requiring durable state and handoff.

Every tier starts with Caveman ultra and Ponytail ultra. A user can override either mode; clarity, correctness, security, and irreversible-action warnings automatically use fuller language or implementation when needed.

## Resume matrix

| recorded state | action |
|---|---|
| fresh | Read `AGENTS.md` and the map, route the wishlist, establish a green base. |
| running | Reconcile branch/SHA, `progress.md`, done notes, and active agents; continue the next ready unit. |
| partial | Preserve useful work, record failed attempt/signature, re-verify the combined tree, then split or absorb the unit. |
| parked | Confirm the old scope still applies, restore `state: running`, and re-run the recorded check. |
| pending | Wait for the recorded user authority, quota reset, or external state; do not widen scope. |
| abandoned | Do not resume implementation; retain the handoff until authorized cleanup. |
| landed | Verify the recorded landing SHA; start a new wishlist for new work. |

## Codex invariants

- Subagents share the workspace. Parallel writers must own pairwise-disjoint files; only the root agent performs branch switches, commits, merges, pushes, and PR creation.
- Use `spawn_agent` only when the user or an applicable instruction explicitly authorizes delegation.
- Use `send_message` to steer a running agent, `followup_task` to resume an idle agent, and `interrupt_agent` only for a genuinely stuck agent.
- Keep durable state under `.orchestrator/` for big runs. Disk wins over remembered state after interruption or compaction.
- Committed instructions use `$HOME` or `~/`; runtime-generated state may contain local paths but stays uncommitted.
- Run the repository DoD before declaring completion. A green unit is not proof that the combined tree is green.
- Never add AI attribution to git artifacts. Pushes, pulls, commits, branches, and PRs retain the user's identity.

## Installed layout

`codex/install.sh` links this folder to `~/.codex/orchestrating/`, the catalog to `~/.codex/agents-docs/`, custom TOML agents to `~/.codex/agents/`, and the hook layer to `~/.codex/hooks/` plus `~/.codex/hooks.json`.
