# Orchestrator

Use this tier for multi-wave work that needs crash-safe state or a later resume.

## Session A — intake

1. Read the wishlist or escalation `plan.md`, repository `AGENTS.md`, map, and git status.
2. Resolve only scope questions whose answers change architecture, ownership, or release policy.
3. Create `.orchestrator/` and write `state.md` with `state: running`.
4. Write `spec.md`: outcome, scope, constraints, acceptance criteria, DoD, release policy, and user-authorized external actions.
5. Establish a green base. Never hide unrelated dirty work.
6. Hand off to Session B: read `session-b.md`, `spec.md`, and the repository map.

## Invariants

- `.orchestrator/` is the source of truth across tasks and compaction.
- Each unit owns explicit files. Concurrent writers never overlap.
- Subagents share the workspace; the root agent alone changes branches or writes git history.
- Every unit has a runnable check. The combined DoD runs after every wave.
- Secrets stay out of context and out of git.
- External writes, pushes, PRs, releases, and destructive cleanup need the authority recorded in `spec.md`.
- Git artifacts contain no assistant attribution.
