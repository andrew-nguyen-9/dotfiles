# Session B — decompose

Read `.orchestrator/spec.md`, repository guidance, and only the code/docs needed to plan ownership.

1. Write `depmap.md` with `unit | depends on | files owned | verification`; reject dependency cycles.
2. Make file ownership pairwise disjoint within each parallel wave. Reject empty ownership and new-file overlap; put shared-file work in a root-owned integration unit.
3. Write `briefs/<unit>.md` containing objective, exact owned files, boundaries, inputs, exclusions, runnable verification, note path, named upstream symbols, and a two-line return contract.
4. Select only available agents from `~/.codex/agents-docs/README.md`. Use `unit-builder` for bounded writes, `explorer` for read-only tracing, and `blind-judge` for independent review.
5. Seed `progress.md` with `unit | status | owner | evidence` and statuses `todo / active / done / blocked`; record green base, attempts, failure signatures, blockers, estimated/actual tokens, and verification.
6. Write `prd.json` as the machine-checkable mirror of `depmap.md`, briefs, and `progress.md`; those human-readable files remain authoritative.

Gate: run `bash $HOME/.codex/orchestrating/validate-plan.sh .orchestrator`. A unit is not dispatchable unless the plan is acyclic, a ready unit exists, ownership is non-empty and disjoint, its brief names a runnable verification and note path, and upstream symbols exist. Then continue with `session-c.md`.

## Cleared-chat kickoff

After plan validation passes, finish the user-facing response with a copy-ready prompt as its final block. Substitute the recorded branch and state.

```text
Continue the active orchestration run on branch `<branch>` with state `<state>`.

Read:
- `$HOME/.codex/orchestrating/session-c.md`
- `.orchestrator/state.md`
- `.orchestrator/depmap.md`
- `.orchestrator/progress.md`
- ready briefs named by the dependency map
- `$HOME/.codex/orchestrating/safeguards.md`

Run Session C. Re-run the plan gate before dispatch or inline execution:

bash $HOME/.codex/orchestrating/validate-plan.sh .orchestrator

When execution is complete or pauses, finish with the appropriate copy-ready cleared-chat kickoff required by Session C.
```

If validation fails, keep Session B active and emit a Session B resume prompt instead.
