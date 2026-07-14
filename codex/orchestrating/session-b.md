# Session B — decompose

Read `.orchestrator/spec.md`, repository guidance, and only the code/docs needed to plan ownership.

1. Write `depmap.md` with `unit | depends on | files owned | verification`.
2. Make file ownership pairwise disjoint within each parallel wave. Put shared-file work in a root-owned integration unit.
3. Write `briefs/<unit>.md` containing objective, boundaries, inputs, exclusions, DoD, and a two-line return contract.
4. Select only available agents from `~/.codex/agents-docs/README.md`. Use `unit-builder` for bounded writes, `explorer` for read-only tracing, and `blind-judge` for independent review.
5. Seed `progress.md` with `unit | status | owner | evidence` and statuses `todo / active / done / blocked`.
6. Write `prd.json` only if machine-readable dispatch state helps; `depmap.md`, briefs, and `progress.md` remain authoritative.

Gate: a unit is not dispatchable unless its brief names owned files and a runnable verification command. Then continue with `session-c.md`.
