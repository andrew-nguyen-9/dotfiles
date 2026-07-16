# Orchestrator

Use this tier for multi-wave work that needs crash-safe state or a later resume.

Start Caveman ultra and Ponytail ultra unless the user overrides them. Keep internal state structured; escalate clarity or correctness automatically when ultra output would be ambiguous or incomplete.

## Session A — intake

1. Read the wishlist or escalation `plan.md`, repository `AGENTS.md`, map, and git status.
2. Resolve only scope questions whose answers change architecture, ownership, or release policy.
3. Create `.orchestrator/` and write `state.md` with `state: running`, phase, branch, green base SHA, current attempt, failure signature, blockers, estimated/actual tokens, verification, and next action.
4. Write `spec.md`: outcome, scope, constraints, acceptance criteria, DoD, release policy, and user-authorized external actions.
5. Establish a green base. Never hide unrelated dirty work.
6. Hand off to Session B: read `session-b.md`, `spec.md`, and the repository map.

## Invariants

- `.orchestrator/` is the source of truth across tasks and compaction.
- Each unit owns explicit files. Concurrent writers never overlap.
- Subagents share the workspace; the root agent alone changes branches or writes git history.
- Every unit has a runnable check. The combined DoD runs after every wave.
- Stateful config migrations require representative existing-state fixtures and authoritative-consumer validation.
- Record reported quota windows separately from measured task tokens and estimates.
- Secrets stay out of context and out of git.
- External writes, pushes, PRs, releases, and destructive cleanup need the authority recorded in `spec.md`.
- Git artifacts contain no assistant attribution.

## Cleared-chat kickoff

After Session A and its green-base check succeed, finish the user-facing response with a copy-ready prompt as its final block. Substitute the recorded branch and state; include no stale run artifacts.

```text
Continue the active orchestration run on branch `<branch>` with state `<state>`.

Read:
- `$HOME/.codex/orchestrating/session-b.md`
- `.orchestrator/state.md`
- `.orchestrator/spec.md`
- repository guidance and map

Run Session B only. Write this run's dependency map, briefs, progress, and `prd.json`, then run:

bash $HOME/.codex/orchestrating/validate-plan.sh .orchestrator

When Session B is complete, finish with a copy-ready cleared-chat kickoff for Session C.
```

If intake or green-base verification failed, keep Session A active and emit a Session A resume prompt instead.
