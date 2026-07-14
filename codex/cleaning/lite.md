# Lite cleanup — post-cycle reset

Use for obvious junk or a safely completed orchestration cycle.

1. Read git status and `.orchestrator/state.md` when present. Preserve unrelated work.
2. If state is `running` or `parked`, do not remove orchestration state; offer resume or explicit abandonment.
3. Harvest durable `decided` and `gotchas` lines into repository docs before deleting spent state.
4. Build one `action | path | reason` manifest for deletes, moves, untracking, or branch pruning. Obtain one explicit user approval.
5. Ref-check every moved/deleted path. Use safe branch deletion only; report unmerged branches and live worktrees.
6. Execute approved rows, run the repository DoD, and commit only when authorized. Never add AI attribution.

Escalate to `medium.md` for documentation sprawl, renames, or a docs refresh.
