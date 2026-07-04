# Session C — Execution (the lean core)

_Loaded by Session C (fresh or resuming). Assumes the spine's §Invariants + §Thinking budget + §Model + the project copy's §Swap (`.orchestrator/orchestrator.md`), plus `~/.claude/orchestrating/efficiency.md` (the dispatch skeleton)._

Keep this window near-empty: map + statuses only. Everything else is a path.

## Pre-flight — budget & limits

Two 2026 ceilings: **5-hour rolling window** (resets +300 min from first prompt) and the **weekly cap** (7-day, shared across all Claude use — the hard ceiling). Both are **account-global**: a second concurrent orchestrator run in another repo shares the same window — serialize big runs. The agent reads budget autonomously via **`ccusage blocks -j`** (Bash-runnable; **not installed → assume one wave per window, wave-pace conservatively, AND write `guard: INACTIVE — no ccusage` into `progress.md`** so resume sessions and the user see the guard is dark); `/usage` + `/stats` are the *user's* glance (user-typed slash commands the agent can't call). **Weekly cap has no guard hook** — pre-flight checks it once; near it (≥~95%) → don't start the wave (a mid-wave weekly freeze is the crash path below, not a clean handoff).

- Estimate total cost vs remaining window + weekly: **run total ≈ ~15× a plain-chat baseline** (Anthropic's multi-agent number — that 15× is vs *chat*, not vs single-agent); **per unit ≈ 3–4× its single-agent estimate**. Baseline: `count_tokens` only if an API key is present (CLI Max-plan sessions have none) — else `wc -c brief` ÷ 4. Won't fit → wave it; don't start a run you can't finish.
- **Calibrate from wave 1** — the multiplier is a prior; after the foundation wave, read the actual `ccusage` delta and re-budget waves 2..N from real burn, not the heuristic.
- **Wave-pace to one rolling window** (foundation → feature waves); `.done.md` between waves so a reset loses nothing. Weekly cap = spread big runs across days.
- **No surge pricing** — peak = global **529 overload**, not cost. Schedule big independent waves off-peak (ScheduleWakeup/cron); set `fallbackModel` (≤3), exp backoff 30s → failover, stop after ~3×529. Batch API for latency-tolerant units (eval/doc/non-interactive) = flat 50% off.
- **Usage guard — BUILT** (`~/.claude/hooks/orch-usage-guard.sh`, PreToolUse on dispatch, active only with `.orchestrator/` present): ≥98% of the 5h window → dispatch blocked with a handoff order. Limit = `$ORCH_TOKEN_LIMIT` (set it if you know your plan's block size) else max historical `ccusage` block. Belt-and-braces: C still checks `ccusage blocks -j` between waves — time-to-limit < whole-wave est → finish in-flight wave, don't start next.

**Handoff file — clean stop at ≥98%** (don't grind to a hard freeze): a wave is N parallel agents — **don't kill running agents**: dispatch nothing new, accept the returns of agents already running (their tokens are committed either way), `TaskStop` only a genuinely hung one; then **disposition EVERY in-flight unit** (landed → note it; stopped mid-work → record branch + committed?/rolled-back), write `handoff.md`, end session, schedule a wakeup for the reset. A fresh session resumes off the file (idempotent units make this safe). **Context pressure ≠ budget exhaustion:** if the *window* is filling (not the token budget), write `handoff.md` **proactively before auto-compaction** — a compacted in-window map can silently drop units; disk (`.done.md` + branches) is authoritative over anything the compaction kept.
```
# handoff.md  (resume checkpoint)
window resets: <time>     done: <units w/ .done.md>
in-flight:                # one line PER unit still open
  <unit>: <branch> — committed? / rolled-back
next wave: <units, dep order>     next-wave est: <tokens>
dep-map cursor: <stop point>     blockers: <unit: reason>     savings: <rtk gain>
```

**Resume kickoff (copy-paste into the fresh chat at reset):**
```
Session C — Execution, RESUMING. You are the orchestrator: map + statuses only.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Read ~/.claude/orchestrating/session-c.md + ~/.claude/orchestrating/efficiency.md (dispatch skeleton) + .orchestrator/orchestrator.md §Swap + .orchestrator/handoff.md + .orchestrator/depmap.md.
No handoff.md (crash / hard freeze)? Reconstruct: progress.md + ls .orchestrator/*.done.md + git branch --list <prefix>/* — a unit branch with no .done.md = in-flight at death → inspect its last commit, finish or reset it, then proceed as normal.
Divergence check first: git fetch && git log integration..origin/main --oneline — nonempty → merge origin/main INTO integration (never rebase while unit branches exist — rewrite orphans them); conflicts in that merge → STOP, list, ask the user.
Prior-wave merge check: git branch --merged integration must list every unit handoff `done:` claims merged — a claimed-done branch absent → disk/git wins, re-integrate it (dispatch the integration agent) before branching wave N.
Continue from the handoff's next wave. Don't re-run done units (idempotent — check .done.md first).
```

## Run

```
driver per progress.md header: ralph → ralph-loop:ralph-loop on prd.json;
  manual → dispatch tasks yourself in dep order
  → dispatch per task (dispatching-parallel-agents = independent;
     subagent-driven-development = the coupled chain)
Each dispatch carries: brief path + upstream .done.md paths. Nothing else.
```

- **Agent choice is B's** — dispatch each task's `agent` from `prd.json` verbatim. `unit-builder`, `integration-agent`, `blind-judge` are **real agent defs** (dotfiles `claude/agent-defs/` → `~/.claude/agents/`) with the terse contract baked in; other types come with their role snippet already pasted in the brief by B. Missing/unknown type → `general-purpose` + note it in `progress.md`. **C never opens the catalog.**
- **Dispatch mechanics** — subagents run in the background; C is re-invoked as each completes (no polling). Retry a stuck-but-alive agent via `SendMessage` (context intact — cheaper than a fresh re-brief); a **stopped/failed agent also resumes via `SendMessage`** — prefer that over fresh re-dispatch (keeps its investigation context). Agent truly dead (terminal API error, null return)? Its branch may exist half-built: `git branch -D <prefix>/<unit>` (this one -D is safe — nothing merged), then fresh dispatch, same brief; counts toward the 3-iteration kill. **Never edit a brief an in-flight agent holds, or the project orchestrator.md mid-wave** — changes take effect next wave; a dead/⛔ unit's brief MAY be amended for its one re-dispatch (nobody is reading it). **Between waves, reconcile:** diff each landing `.done.md`'s `decided:`/`gotchas:` against the next wave's briefs — a renamed symbol or changed decision makes a brief stale; patch it before dispatch. Precedence: upstream `.done.md` outranks the brief. *Agent-teams option (experimental):* shared task list + native deps ≈ depmap+progress+wave-driver built in; use if available, keep this file pipeline as the fallback and for resume.
- **`.done.md` schema gate** — when a unit's `.done.md` lands, grep it for the required headers (`shipped:`/`verified:`/`decided:`/`gotchas:`/`branch`); any missing → the unit is **not done**, `SendMessage` the builder once to complete it (a malformed note poisons every dependent — efficiency.md §Safeguards). Prose+grep, no hook.
- **Over-decomposition guard** — ~15× cost is worth it *only* for truly independent units. A coupled cluster (B needs A mid-task) is cheaper as **one sequential agent** than N coordinating ones. Fan out independent; collapse coupled. Units pending but none wave-eligible (no pending unit has all deps met) = a dep cycle B missed → **STOP + report it**, never silent-stall.
- **Right-size effort/model per unit** — `thinking:{type:adaptive}` + `output_config:{effort}` (not fixed `budget_tokens`); Haiku trivial → Sonnet default → Opus hard. Enforced by `$CLAUDE_EFFORT` hooks.

## Standing constraints (every agent)

- **DoD gate** — the repo `CLAUDE.md` DoD commands green before `.done.md` (`verification-before-completion`: evidence before done). Brief `dod:` field overrides (monorepo package, research/docs-only unit — gate = smallest runnable check that fails if the work is wrong; never a fake green).
- **ponytail ladder** — exists? stdlib? native? one line? Ship minimum. Mark shortcuts `// ponytail:`. **TDD** for non-trivial logic.
- **Branch/commit** — one branch per unit `<prefix>/<unit>` off the current `integration` (spine §Model); commit on DoD-green only; no AI attribution.
- **Isolation is a dispatch flag, not prose:** pass `isolation: "worktree"` on every write-agent dispatch (each gets its own checkout; git refuses the same branch in two worktrees — per-unit branches make this safe).
- **Secrets** — never commit; pull from `<secrets location>`; none in briefs/notes.

## Enforcement via hooks — BUILT (dotfiles `claude/hooks/`, wired in settings.json)

Real shell hooks, 0 model tokens. The three `orch-*` hooks activate **only in repos with a live `.orchestrator/` dir** (dormant everywhere else; cleaning deletes the dir → hooks go quiet). Built as plain settings.json hooks — hookify's markdown-rule format can't express these (no Read event, no output rewrite, no external commands).
- `orch-usage-guard.sh` — PreToolUse on dispatch (Task|Agent): ≥98% of the 5h window → blocks dispatch, orders handoff. Limit = `$ORCH_TOKEN_LIMIT` or max historical `ccusage` block.
- `orch-return-cap.sh` — PostToolUse on dispatch: subagent return >4000 chars → truncated at the boundary.
- `orch-read-cap.sh` — PreToolUse Read: file >600 lines without offset/limit → blocked, use symbolic nav.
- `env-read-guard.sh` — PreToolUse Read+Bash, **global**: `.env`/secrets reads blocked (`.env.example` allowed).
- RTK rewrite (PreToolUse Bash) — live, guarded against missing binary.
- *Dropped:* `$CLAUDE_EFFORT` gates — no such env var reaches hooks; effort control = model override per dispatch.

## Integration gate (before handoff)

Per-unit DoD is local: N green branches can sum to a red trunk. **Run it per wave, not once at the end** — as each wave's units pass DoD, **dispatch the integration subagent** (don't do it in C's window): it merges that wave into `integration` in dep order, runs the **full regression + integration/e2e suite + lint there** (not just per-unit). **Conflict authority:** the integration agent resolves mechanical merge conflicts itself (`think hard` licensed — spine §Thinking budget; aborts any failed merge so `integration` is never left half-merged); a conflict needing domain judgment → return `fail` + conflicting-file list, and C dispatches a **fresh unit-builder for the owning unit**: "merge `integration` into `<prefix>/<unit>`, resolve the conflicts in <files> using both units' `.done.md` **and both units' briefs** (paths — intent, not just outcomes), DoD green, commit" — then the integration agent re-merges. **Red trunk with `conflicts:null`** (integration agent found a post-merge regression, no merge conflict) → C names the **owner** = the unit whose change touches the failing test's subject, and re-dispatches that one unit-builder to fix (not the merger). (The original agent is gone; semantic conflicts belong to the unit owner's *brief*, not the merger.) **Wave 1 extra: the integration agent re-runs the foundation `.done.md`'s `verified:` commands** — a lying foundation claim caught here costs one wave; caught at D it costs the whole run. Returns pass/fail (+ conflict list on fail) only — C never sees build output. Green-alone but red-together = cross-unit break → fix before the next wave branches off `integration`. Final wave green = `integration` is what D fast-forwards `main` to.

**C → D kickoff (copy-paste):**
```
Session D — Review & land. Read ~/.claude/orchestrating/session-d.md + ~/.claude/orchestrating/efficiency.md §Safeguards, .orchestrator/spec.md, .orchestrator/depmap.md, .orchestrator/progress.md, and every .orchestrator/<unit>.done.md (treat as CLAIMS, not truth — verify load-bearing ones against committed code; depmap+progress scope any fix-unit and surface C's substitution/gap notes).
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Verify the original spec is fully met, run full code review across all changes, fix what's found. Then get explicit user go before merge/push/prune (irreversible); prune only merged <prefix>/<unit> branches.
```
