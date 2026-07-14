# Medium workflow

1. Start Caveman ultra and Ponytail ultra unless overridden; correctness escalation beats compression.
2. Read `AGENTS.md`, the repository map, git status, and the relevant implementation surface.
3. Write a plan with units, dependencies, owned files, and verification. Overlapping file ownership means sequential work.
4. Create one work branch from the current green base when a branch is needed. The root agent owns all git operations.
5. If delegation is authorized, spawn at most the useful number of agents:
   - parallel writers receive pairwise-disjoint file globs;
   - shared files, branch changes, and integration stay with the root agent;
   - each return is at most two concise lines with verification evidence.
6. Steer a running agent with `send_message`; resume an idle one with `followup_task`. After repeated failure, absorb the unit locally or split it.
7. Reconcile unit outputs, inspect the combined diff, and run the full DoD.
8. Land only the green result. Push or open a PR only with authorization, and never add AI attribution.

If the units no longer fit one task, write `plan.md` with `done / in-progress / todo`, dependencies, owned files, current branch, and last green SHA; then run `orchestrator.md` Session A using that file as input.
