# Session B — Architecture

_Loaded by Session B (fresh chat). Assumes you've already read the spine's §Invariants + §Thinking budget + §Tiers and the project copy's §Swap values (`.orchestrator/orchestrator.md`)._

All design lives here so C stays empty. Read `spec.md` ONCE → artifacts; never re-read it.

- **Plan & split** — `superpowers:writing-plans` → units (epic/feature/module/endpoint per project). `ralph-skills:prd` → `ralph` → `prd.json` (machine task list).
  - **Minimal schema C reads:** each task `{id, brief (path), deps [ids], effort, agent}`. Ralph's output is a superset — fine as long as those fields exist.
  - **`agent` (required)** — B picks each unit's type from the catalog: `~/.claude/agents-docs/README.md` task-verb tree → load **only** the matching category file. No specialist fits → `general-purpose` (a good brief beats a mis-fit specialist). **B verifies availability at pick time** (plugin rows: is the plugin enabled in THIS repo?) — an unknown type doesn't error at dispatch, the harness silently runs general-purpose, so B is the only real checkpoint. Plugin missing → the category's Fallback chain, and **bake the fallback's brief-amendment into the brief itself** (e.g. "≤2 files, diff-edit only") so C never needs the catalog. **Record every fallback/substitution in `progress.md`** — C dispatches verbatim and can't detect the harness's silent general-purpose swap; B is the only writer that knows (and D reads it).
  - **Requires** the `ralph-loop` + `ralph-skills` + `superpowers` plugins (C drives `ralph-loop` on `prd.json`). Check at the start of B — missing → **fallback**: hand-write `prd.json` to the schema above; C dispatches units itself in dep order with `dispatching-parallel-agents` (no ralph-loop). Same artifacts, manual driver. **Persist the choice** — B's chat dies with B: `progress.md` header line `driver: ralph|manual`; C runs whichever it says.
- **Briefs** — `briefs/<unit>.md`, standalone. *Standalone test:* an agent given only its brief can finish. Needs the spec → brief is incomplete; fix it. **Required skeleton — delegation failures come from missing fields, not length:** `objective / boundaries (files OWNED, exclusions) / tool guidance / return format [/ dod: <commands> when the unit's gate differs from CLAUDE.md — monorepo package, research/docs-only unit]`. **Agent-def types (unit-builder, integration-agent, blind-judge) get NO role snippet** — the contract is baked into the def; pasting it again duplicates ~300 tok/dispatch. Other types: the agent's ≤5-line role snippet pasted from the catalog (B pastes at write time; C never opens the catalog). Research/docs-only units: `dod:` = the smallest runnable check that fails if the work is wrong (assert script, links resolve, claims match code) — never a fake build-green. Repo/stack context = **path-ref to `docs/02-architecture.md`** (or the repo map), never re-described per brief. **Smallest high-signal set** — a fat brief is *less* accurate (irrelevant context worsens hallucination) and costlier. **High-fan-out briefs → ultrathink** (spine §Thinking budget); leaf briefs, normal effort. Effort field rubric: est. tool calls — ≤10 → haiku-ok, 10–15 → default, more or design-heavy → hard (or split the unit).
- **Dependency map** — the one genuinely project-specific artifact; write it to `depmap.md` (the table below), since C reads it cold. **Check acyclicity before writing `prd.json`** — a dependency cycle (A→B→A) has no valid wave order; collapse the cycle into ONE sequential unit (the over-decomposition rule — session-c.md §Run). Wrong edge → dependent runs blind. Unsure → **add the edge** (extra path is cheap; stale build is not). **`files-owned` column is mandatory** — two agents editing one file is the most reliable way to corrupt output; two units claiming the same path can't share a wave (B merges them into one unit, or C's pre-dispatch scan catches it: **before each wave C greps the wave's files-owned globs for overlap; overlap → defer the dep-later unit one wave**). Discovered mid-wave anyway → treat as an integration conflict: C names one unit the owner, the other's overlapping hunks re-do on top after merge. Fan out *reads* freely; fan out *writes* only with disjoint ownership.

  | Unit | Upstream `.done.md` to inject | files-owned |
  |------|------------------------------|-------------|
  | auth-mw | — | `src/middleware/*` |
  | user-api | `auth-mw.done.md` | `src/api/users*` |
  | billing | `auth-mw.done.md`, `user-api.done.md` | `src/billing/*` |

- **Tracker** — seed `progress.md`: header lines (`driver: ralph|manual`, `guard: active|INACTIVE — <why>`) + a `unit | status | branch` table (statuses ⏳→🔁→✅/⛔). C updates it as waves land; it's the at-a-glance state for resume + the Block-8 report — **and the crash-recovery source when no handoff.md exists**.
- **Foundation-first** — epics share scaffolding (schema, shared types, design system, auth, config). Make it **unit #1** (map: all → foundation), run as the first wave; its `.done.md` carries shared decisions. Genuinely independent units skip it — don't invent a foundation. **Brownfield: existing shared code already IS the foundation** — point briefs at it (paths/symbols), don't rebuild; only add a foundation unit for *new* shared scaffolding.
- **`.done.md` contract** — every C agent writes this on finish (≤15 lines, caveman-compressed, disk only, pass the **path** not the body):
  ```
  # <unit>.done.md  (≤15 lines)
  shipped: <what>     files: <paths>
  verified: <cmd/test that proves each shipped claim>
  decided: <non-obvious choices>
  gotchas: <traps for dependents>
  branch / PR
  ```
  A claim without a `verified:` line is exactly what D must re-check; dependents verify upstream symbols exist (Serena) before building on them.

**B → C kickoff (copy-paste):**
```
Session C — Execution. You are the orchestrator: hold ONLY the dependency map + short statuses.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Read ~/.claude/orchestrating/session-c.md + ~/.claude/orchestrating/efficiency.md (dispatch skeleton) + .orchestrator/orchestrator.md §Swap + .orchestrator/depmap.md. Work off depmap.md + prd.json + briefs only — do NOT open spec.md (detail is the agents' job).
GATE 1: the repo CLAUDE.md is the single DoD source — it must hold REAL values on its DoD / Secrets / Branches lines; any literal <...> token left in CLAUDE.md (or a missing line) → STOP, finish Session A's blank-fill before any dispatch. On a full-docs-tier repo also `test -f` the `Map:`/`Ops/env:` pointer targets — a dangling pointer → fix before dispatch. (The dispatch skeleton says "DoD per repo CLAUDE.md" — it never duplicates commands.)
GATE 2: read .orchestrator/blockers.md — unchecked boxes block ONLY the waves that depend on them (blocks: field); a wave with a blocked dep does not dispatch. All of wave 1 blocked → STOP and list.
Then pre-flight budget, run waves off prd.json. Inject brief path + upstream .done.md paths into each dispatch — nothing else. End by printing the Session D kickoff prompt.
```
