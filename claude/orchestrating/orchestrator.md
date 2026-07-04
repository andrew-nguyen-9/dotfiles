# orchestrator.md

Multi-agent orchestrator run as **four chat sessions** (A→B→C→D). Each session does one job, writes its output to disk, and ends with a **copy-paste kickoff prompt** for the next. Context stays thin because detail lives in files, never in chat — the kickoff prompt + disk artifacts *are* the handoff.

This file is a **template** (lives in dotfiles at `~/.claude/orchestrating/orchestrator.md`, alongside `wishlist.md` — the fill-in bootstrap). Session A copies it into the target project with the [Swap per project](#swap-per-project) blanks filled. Everything downstream reads the **project copy**, never the template.

**When to use** — big asks only: many genuinely independent epics, shared scaffolding, multi-day, worth ~15× fan-out. Smaller → `lite.md` (one pass) or `medium.md` (plan + bounded fan-out). The `wishlist.md` router picks; this file assumes it chose orchestrator.

## How to run

Each session is a **separate, fresh chat** — open a new chat, paste that session's kickoff prompt, let it run, copy the kickoff it prints at the end, open the next new chat. Don't run two sessions in one window: the whole point is that a cold session carries no prior context, so the window stays thin. **Session A is first — it has no upstream kickoff; start it with the bootstrap prompt in §Session A.** Resuming mid-session (e.g. C after a budget stop) = new chat reading `handoff.md`, not the kickoff.

## Artifacts — one home for all state

All cross-session state lives in **`.orchestrator/`** at the project repo root. Every session reads/writes here; nothing of substance lives in chat. Add `.orchestrator/` to `.gitignore` unless you want the trail committed.

```
.orchestrator/
  orchestrator.md   # the project copy of this template (A writes; B/C/D read)
  spec.md           # A writes; B reads once; C/D reference
  blockers.md       # A writes (checkbox list); C gates on it
  depmap.md         # B writes (dependency map); C reads
  prd.json          # B writes (machine task list); C runs
  briefs/<unit>.md  # B writes; C injects path into each dispatch
  progress.md       # B seeds unit→status table; C updates as waves land
  <unit>.done.md    # C agents write; dependents + D read
  handoff.md        # C writes on a budget stop; the resuming C chat reads
```

Paths below are relative to `.orchestrator/`. When a kickoff says "read `./spec.md`" it means `.orchestrator/spec.md`.

## The four sessions

| Session | Job | Writes to disk | Hands off |
|---------|-----|----------------|-----------|
| **A — Intake** | Scope the asks via batched multiple-choice rounds. Build the project `orchestrator.md` from this template. | `spec.md`, project `orchestrator.md`, `blockers.md` | kickoff → B |
| **B — Architect** | All brainstorming, planning, scaffolding, doc creation, trackers, architecture. | `briefs/`, `prd.json`, dependency map, trackers, design docs | kickoff → C |
| **C — Execute (lean)** | Dispatch subagents, integrate. Keep this window as empty as possible. **The core of this file.** | `<unit>.done.md`, unit branches, `integration` branch, `handoff.md` | kickoff → D |
| **D — Review & land** | Verify original ask is met, full code review, then commit/push/merge/prune. | review notes, merged trunk | — |

**Blockers gate C, not B.** B is pure thinking (no env needed). A lists everything the user must finish (secrets, accounts, infra, access, decisions) *before* C fans out.

**D treats C's work as claims, not gospel** — re-verifies against committed code (Safeguards).

## Model — terms used throughout

- **Wave** — a batch of units with no unmet deps, dispatched together. Foundation wave first; feature waves after its `.done.md` lands.
- **Dispatch** — C launches a **fresh subagent** per unit; the type comes from the task's `agent` field in `prd.json` (picked by B from the **agents catalog** `~/.claude/agents-docs/` — category docs + role dispatch snippets, loaded JIT). **Never fork** — a fork inherits C's context, defeating the thin window.
- **Integration model (default = local-branch-merge, no PRs needed).** A long-lived `integration` branch starts at `main`. **Each unit branches `<prefix>/<unit>` off the *current* `integration`** — so upstream *code* (not just `.done.md` notes) is already present for dependents. As a wave's units pass DoD, the integration subagent merges them into `integration` in dep order and runs full regression *there* (C holds only pass/fail, never the build output); the **next wave branches off the updated `integration`**. D fast-forwards `main` to the final green `integration`. Set `PR` in returns to null. Assumes the run owns `main` (freeze other merges, or rebase `integration` before the final ff). *PR-based variant:* agents open a PR per unit, C's integration agent uses `gh` to assemble, D merges PRs — pick one model project-wide, don't mix.

## Thinking budget — reason ∝ blast radius

The rule: spend thinking in proportion to **blast radius** = how many downstream units inherit the decision × how late/expensive the error surfaces. Max it where a *reasoning* error cascades and surfaces late; spend none where work is leaf-level or a test verifies it cheaply. Thinking helps reasoning failures (tradeoffs, subtle interactions, planning) — not knowledge gaps (retrieve) or mechanical slips (test). Orthogonal to caveman/ponytail (those cap *output*, this is *internal*): **think deep, output terse**; ponytail + ultrathink = reason hard for the *simplest correct* solution.

- **B architecture = `ultrathink`** — decomposition (unit seams), couple-vs-independent, dependency edges, foundation. Highest blast radius in the pipeline; errors invisible until integration, cascade at 15×.
- **Briefs scale with fan-out, not session** — `ultrathink` the foundation brief + any brief many units inherit (a bad brief = a wrong agent at 15×, the #1 driver of subagent failure); a leaf brief (no dependents) gets normal effort. Brief quality is the direct success-gate on every dispatched unit.
- **A = `think hard` on question selection + acceptance criteria** — the reasoning is "what don't I know yet?" and "how will D verify this?"; vague criteria → false "done." Synthesis itself is mechanical.
- **C main thread = none** (reflexive + thin). **Units = adaptive** (Run): none Haiku-trivial → high Opus-hard.
- **Integration = conditional** — clean ff-merge none; a conflict or red-trunk regression gets `think hard` to diagnose the cross-unit interaction.
- **D = high on the completeness gate** (last line vs shipping incomplete); review findings think per-difficulty, not blanket.

## Tiers — the whole mental model

| Tier | Holds | Rule |
|------|-------|------|
| Spec (1 file) | full detail | read once → generate artifacts; never re-read |
| Briefs + `<unit>.done.md` (disk) | per-unit detail + outcomes | agents only; never into main chat |
| Main chat (esp. C) | dependency map + short statuses | nothing else |

Skip a load-bearing tier → context leaks → the thin window collapses.

## Invariants — never break

1. **Role line (C).** "You are the orchestrator. Hold only the map + statuses. Never pull detail, file contents, build output, or note bodies into this chat."
2. **Return contract.** Every agent returns ONLY `id, status, branch, PR?, ≤2-line note` as JSON (`PR` null in local-merge model — see Integration model). No mechanical rejection exists (the Agent tool has no schema param) — the REAL contract is C's discipline: a verbose return already cost its tokens; **never re-quote it** — carry a 1-line summary forward, drop the rest. (Workflow-tool dispatches CAN enforce via `agent(schema:)`.)
3. **Cap every artifact.** Note ≤15 lines. Return ≤2 lines. Brief = one unit, **≤~150 lines / ~2k tok** (over → unit too big, split it). Uncapped = re-flood.
4. **Every session AND every subagent runs lean.** Sessions (A–D): activate `/caveman:caveman ultra` (compress all prose/returns/notes), `/ponytail:ponytail ultra` (laziest diff that works), **RTK** (shell → `rtk`), **Serena/LSP** (symbolic nav over whole-file reads; unavailable or no-fit → Grep/Glob/Read). **Subagents can't reliably invoke skills** — they get the same rules as plain text via the [dispatch skeleton](#efficiency-layer): a behavioral contract, not a skill dependency. **Output styles are user config** — no session or agent can switch them; keep `explanatory`/`learning` plugin flags `false` in settings.json (they multiply prose). **Boundary:** caveman/ponytail govern *prose, returns, notes* — NOT code, commit messages, or PR bodies, which stay normal and complete (and carry no AI attribution).

---

# Session A — Intake

**Bootstrap (chat #1).** Easiest: fill `~/.claude/orchestrating/wishlist.md` and paste it (or type `Read ~/.claude/orchestrating/wishlist.md and run it`). Or paste this directly into a fresh chat in the repo:
```
Read ~/.claude/orchestrating/orchestrator.md and run Session A on the wishlist below.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
First confirm this wishlist is big enough to warrant the orchestrator (§When to use) — if not, switch to ~/.claude/orchestrating/lite.md instead.
Wishlist:
<paste your wishlist here>
```

**Input:** the user's raw wishlist + this template.

0. **Set up** — `.orchestrator/` already exists at the project root → **STOP**: a prior cycle didn't clean; print the cleaning kickoff (`Read ~/.claude/cleaning/README.md and run it.`) and end — stale `.done.md`/`blockers.md` silently poison a new run. Clean → create `.orchestrator/`; **`cp ~/.claude/orchestrating/orchestrator.md .orchestrator/orchestrator.md`** then fill blanks with targeted Edits (never re-type the template — ~8k output tokens wasted). All artifacts below land in `.orchestrator/`.
0.5 **Survey the repo** — **read the repo `CLAUDE.md` first**: any Swap-per-project blank already answered there (DoD, secrets location, prefix, stack) is a question A skips; A patches `CLAUDE.md` with newly-decided durable blanks at the end (cycle 2 then re-asks nothing). Brownfield (existing code)? Map it first (Serena `get_symbols_overview` / LSP, README, build files) so questions are grounded and B doesn't rebuild what exists. Empty repo (greenfield)? Skip; the foundation unit establishes the toolchain.
1. **Batched scoping.** AskUserQuestion serves **max 4 questions per call** — a "round" is several back-to-back calls (~3–5 calls = ~12–20 questions), then you digest answers before the next round. **300 = hard ceiling, not a target** — most projects finish well under. Rounds narrow: goals → scope → stack → constraints → DoD → release policy. **Stop the moment answers stop changing the spec** (don't pad to 300).
2. **Write `spec.md`** — structured epics, each with acceptance criteria. Normalize the wishlist; don't carry a raw list forward.
3. **Fill the project `orchestrator.md`** — in the copy from step 0, fill the [Swap per project](#swap-per-project) blanks (spec path, DoD, secrets location, tool choices).
4. **Write `blockers.md`** — a **markdown checkbox list** of everything the user must complete before C: secrets provisioned, accounts/access granted, infra up, external decisions made. Each line `- [ ] <blocker> — <how to verify done> — blocks: <unit|wave|all>`. The user ticks each `- [x]` as they finish. C halts **only the waves whose deps are blocked** (an unchecked wave-3-only box must not idle wave 1), printing which. User abandons scoping mid-round → write the spec with stated assumptions and route each open question to a `blockers.md` checkbox — user answers async, C gates on it.

**A → B kickoff (copy-paste):**
```
Session B — Architecture. Read .orchestrator/orchestrator.md, .orchestrator/spec.md, .orchestrator/blockers.md.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Do Session B: brainstorm, plan, scaffold, write trackers + design docs, fan spec → .orchestrator/briefs/ + prd.json + depmap.md.
Read spec.md ONCE. Detail to disk only. End by printing the Session C kickoff prompt.
```

---

# Session B — Architecture

All design lives here so C stays empty. Read `spec.md` ONCE → artifacts; never re-read it.

- **Plan & split** — `superpowers:writing-plans` → units (epic/feature/module/endpoint per project). `ralph-skills:prd` → `ralph` → `prd.json` (machine task list).
  - **Minimal schema C reads:** each task `{id, brief (path), deps [ids], effort, agent}`. Ralph's output is a superset — fine as long as those fields exist.
  - **`agent` (required)** — B picks each unit's type from the catalog: `~/.claude/agents-docs/README.md` task-verb tree → load **only** the matching category file. No specialist fits → `general-purpose` (a good brief beats a mis-fit specialist). Missing plugin → the category's Fallback chain.
  - **Requires** the `ralph-loop` + `ralph-skills` + `superpowers` plugins (C drives `ralph-loop` on `prd.json`). Check at the start of B — missing → **fallback**: hand-write `prd.json` to the schema above; in C, dispatch units yourself in dep order with `dispatching-parallel-agents` (no ralph-loop). Same artifacts, manual driver.
- **Briefs** — `briefs/<unit>.md`, standalone. *Standalone test:* an agent given only its brief can finish. Needs the spec → brief is incomplete; fix it. **Required skeleton — delegation failures come from missing fields, not length:** `objective / boundaries (files OWNED, exclusions) / tool guidance / return format`, plus the agent's ≤5-line role snippet pasted from the catalog (B pastes at write time; C never opens the catalog). Repo/stack context = **path-ref to `docs/02-architecture.md`** (or the repo map), never re-described per brief. **Smallest high-signal set** — a fat brief is *less* accurate (irrelevant context worsens hallucination) and costlier. **High-fan-out briefs → ultrathink** (Thinking budget); leaf briefs, normal effort. Effort field rubric: est. tool calls — ≤10 → haiku-ok, 10–15 → default, more or design-heavy → hard (or split the unit).
- **Dependency map** — the one genuinely project-specific artifact; write it to `depmap.md` (the table below), since C reads it cold. Wrong edge → dependent runs blind. Unsure → **add the edge** (extra path is cheap; stale build is not). **`files-owned` column is mandatory** — two agents editing one file is the most reliable way to corrupt output; two units claiming the same path can't share a wave (C rejects, or B merges them into one unit). Fan out *reads* freely; fan out *writes* only with disjoint ownership.

  | Unit | Upstream `.done.md` to inject | files-owned |
  |------|------------------------------|-------------|
  | auth-mw | — | `src/middleware/*` |
  | user-api | `auth-mw.done.md` | `src/api/users*` |
  | billing | `auth-mw.done.md`, `user-api.done.md` | `src/billing/*` |

- **Tracker** — seed `progress.md`: a `unit | status | branch` table (statuses ⏳→🔁→✅/⛔). C updates it as waves land; it's the at-a-glance state for resume + the Block-8 report.
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
Read .orchestrator/orchestrator.md §"Session C" + .orchestrator/depmap.md. Work off depmap.md + prd.json + briefs only — do NOT open spec.md (detail is the agents' job).
GATE 1: the dispatch skeleton (§Efficiency) and the repo CLAUDE.md must hold REAL commands — any literal <build>/<test>/<lint>/<prefix>/<secrets location> token left → STOP, finish Session A's blank-fill before any dispatch.
GATE 2: read .orchestrator/blockers.md — unchecked boxes block ONLY the waves that depend on them (blocks: field); a wave with a blocked dep does not dispatch. All of wave 1 blocked → STOP and list.
Then pre-flight budget, run waves off prd.json. Inject brief path + upstream .done.md paths into each dispatch — nothing else. End by printing the Session D kickoff prompt.
```

---

# Session C — Execution (the lean core)

Keep this window near-empty: map + statuses only. Everything else is a path.

## Pre-flight — budget & limits

Two 2026 ceilings: **5-hour rolling window** (resets +300 min from first prompt) and the **weekly cap** (7-day, shared across all Claude use — the hard ceiling). The agent reads budget autonomously via **`ccusage blocks -j`** (Bash-runnable; **not installed → assume one wave per window, wave-pace conservatively**); `/usage` + `/stats` are the *user's* glance (user-typed slash commands the agent can't call).

- Estimate total cost vs remaining window + weekly: **run total ≈ ~15× a plain-chat baseline** (Anthropic's multi-agent number — that 15× is vs *chat*, not vs single-agent); **per unit ≈ 3–4× its single-agent estimate**. Baseline: `count_tokens` only if an API key is present (CLI Max-plan sessions have none) — else `wc -c brief` ÷ 4. Won't fit → wave it; don't start a run you can't finish.
- **Calibrate from wave 1** — the multiplier is a prior; after the foundation wave, read the actual `ccusage` delta and re-budget waves 2..N from real burn, not the heuristic.
- **Wave-pace to one rolling window** (foundation → feature waves); `.done.md` between waves so a reset loses nothing. Weekly cap = spread big runs across days.
- **No surge pricing** — peak = global **529 overload**, not cost. Schedule big independent waves off-peak (ScheduleWakeup/cron); set `fallbackModel` (≤3), exp backoff 30s → failover, stop after ~3×529. Batch API for latency-tolerant units (eval/doc/non-interactive) = flat 50% off.
- **Usage guard — BUILT** (`~/.claude/hooks/orch-usage-guard.sh`, PreToolUse on dispatch, active only with `.orchestrator/` present): ≥98% of the 5h window → dispatch blocked with a handoff order. Limit = `$ORCH_TOKEN_LIMIT` (set it if you know your plan's block size) else max historical `ccusage` block. Belt-and-braces: C still checks `ccusage blocks -j` between waves — time-to-limit < whole-wave est → finish in-flight wave, don't start next.

**Handoff file — clean stop at ≥98%** (don't grind to a hard freeze): a wave is N parallel agents — **disposition EVERY in-flight unit** (finish or roll back each), write `handoff.md`, end session, schedule a wakeup for the reset. A fresh session resumes off the file (idempotent units make this safe).
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
Read .orchestrator/orchestrator.md §"Session C" + .orchestrator/handoff.md + .orchestrator/depmap.md.
Divergence check first: git fetch && git log integration..origin/main --oneline — nonempty → rebase integration (or flag) BEFORE dispatching (the run assumes it owns main; days may have passed).
Continue from the handoff's next wave. Don't re-run done units (idempotent — check .done.md first).
```

## Run

```
ralph-loop:ralph-loop on prd.json
  → dispatch per task (dispatching-parallel-agents = independent;
     subagent-driven-development = the coupled chain)
Each dispatch carries: brief path + upstream .done.md paths. Nothing else.
```

- **Agent choice is B's** — dispatch each task's `agent` from `prd.json` verbatim. `unit-builder`, `integration-agent`, `blind-judge` are **real agent defs** (dotfiles `claude/agent-defs/` → `~/.claude/agents/`) with the terse contract baked in; other types come with their role snippet already pasted in the brief by B. Missing/unknown type → `general-purpose` + note it in `progress.md`. **C never opens the catalog.**
- **Dispatch mechanics** — subagents run in the background; C is re-invoked as each completes (no polling). Retry a stuck-but-alive agent via `SendMessage` (context intact — cheaper than a fresh re-brief). **Never edit briefs or the project orchestrator.md mid-wave** — changes take effect next wave (don't change the template under in-flight agents). *Agent-teams option (experimental):* shared task list + native deps ≈ depmap+progress+wave-driver built in; use if available, keep this file pipeline as the fallback and for resume.
- **Over-decomposition guard** — ~15× cost is worth it *only* for truly independent units. A coupled cluster (B needs A mid-task) is cheaper as **one sequential agent** than N coordinating ones. Fan out independent; collapse coupled.
- **Right-size effort/model per unit** — `thinking:{type:adaptive}` + `output_config:{effort}` (not fixed `budget_tokens`); Haiku trivial → Sonnet default → Opus hard. Enforced by `$CLAUDE_EFFORT` hooks.

## Standing constraints (every agent)

- **DoD gate** — `<build>`+`<test>`+`<lint>` green before `.done.md` (`verification-before-completion`: evidence before done).
- **ponytail ladder** — exists? stdlib? native? one line? Ship minimum. Mark shortcuts `// ponytail:`. **TDD** for non-trivial logic.
- **Branch/commit** — one branch per unit `<prefix>/<unit>` off the current `integration` (Model); commit on DoD-green only; no AI attribution.
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

Per-unit DoD is local: N green branches can sum to a red trunk. **Run it per wave, not once at the end** — as each wave's units pass DoD, **dispatch the integration subagent** (don't do it in C's window): it merges that wave into `integration` in dep order, runs the **full regression + integration/e2e suite + lint there** (not just per-unit). **Conflict authority:** the integration agent resolves mechanical merge conflicts itself (`think hard` licensed — Thinking budget); a conflict needing domain judgment → return `fail` + conflicting-file list, and C re-dispatches the *owning unit's* agent with the conflict hunks + both units' `.done.md` paths (semantic conflicts belong to the unit owner, not the merger). Returns pass/fail (+ conflict list on fail) only — C never sees build output. Green-alone but red-together = cross-unit break → fix before the next wave branches off `integration`. Final wave green = `integration` is what D fast-forwards `main` to.

**C → D kickoff (copy-paste):**
```
Session D — Review & land. Read .orchestrator/orchestrator.md §"Session D", .orchestrator/spec.md, and every .orchestrator/<unit>.done.md (treat as CLAIMS, not truth — verify load-bearing ones against committed code).
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Verify the original spec is fully met, run full code review across all changes, fix what's found. Then get explicit user go before merge/push/prune (irreversible); prune only merged <prefix>/<unit> branches.
```

---

# Session D — Review & land

C's notes are **claims, not gospel** — verify load-bearing ones against committed code.

1. **Completeness** — walk `spec.md` epics + acceptance criteria against the merged trunk. Anything unmet → list it; **fix = dispatch a unit-builder with a mini-brief and re-verify** (D never builds in its own window — reviewer stays reviewer); large gap → a new C-style wave; else flag.
2. **Full code review** — across all units (`code-review`/`pr-review-toolkit`): branch diff only, diff via `gh`/git not MCP, isolated subagents returning confidence-gated findings (small model for style, large for logic). **Judge = ONE producer-blind rubric-scored call per unit** (accuracy / completeness / spec-fit — single call matches human judgment best); escalate to a multi-lens panel only for load-bearing or contested units. Deterministic tests stay the gate for exact correctness.
3. **Land** — `main` fast-forwards to C's already-regression-green `integration` branch (no re-merge). Irreversible + outward-facing: **show the user the plan and get an explicit go first** (what merges, what pushes, what gets deleted). On go: `merge --ff-only integration` into `main` → `push -q`. **Prune only the merged `<prefix>/<unit>` + `integration` branches** (`git branch -d` — safe-delete refuses unmerged; never `-D` blanket, never touch branches outside this run). Blocked/unmerged units stay. One clean trunk.
4. **Report** (caveman-terse, one line/unit):
   ```
   blockers: <unit: reason>     branches→PRs: <unit → PR>     savings: rtk gain
   ```
   **Partial-release policy** (decided in A, per unit): blocked unit → *ship-without* (drop + log) or *block-release* (hold version).
5. **Catalog update** — the agents catalog (`~/.claude/agents-docs/`) is living; this cycle feeds it: agent type/role used that has no row → add its row to the right category file; an agent surprised (wrong tier, bad returns, cost blowout, unexpectedly great fit) → one dated line under that category's `## Lessons`; catalog vs actually-available agent types drifted (plugin renamed/removed) → flag in the report. Rows stay one line; restructuring is cleaning's job, not D's.
6. **Clean** — end by printing the cleaning kickoff for a fresh chat: `Read ~/.claude/cleaning/README.md and run it.` (harvests durable knowledge from `.orchestrator/` into docs/ — see cleaning's harvest table — THEN resets spent state, merged branches, junk; refreshes docs + the agents catalog). **Don't pre-delete `.orchestrator/` — cleaning consumes the `.done.md` files.**

---

# Efficiency layer

Accuracy bar: every tactic drops **transcript bulk, never meaning**. This section is for the SESSIONS (A–D). Agents never read this file — a by-path ref would make all 15 load the whole thing (~100k tok/run). Instead every dispatch opens with the **dispatch skeleton**, byte-identical across a wave (cached once, ~free for agents 2..N), then only `[brief path + upstream .done.md paths]` varies after it:

```
You are <agent-type> for one unit. Terse contract: prose/notes caveman-compressed;
laziest diff that works (reuse > stdlib > native > one line); shell via rtk; Serena/LSP
symbolic nav over whole-file reads (unavailable → Grep/Read); JIT — hold paths/symbols,
fetch on demand; start broad, then narrow; parallel independent reads in one message.
DoD: <build>+<test>+<lint> green before done. Branch <prefix>/<unit> off integration;
commit -q; no AI attribution. Secrets from <secrets location>, never committed.
Verify upstream .done.md claims (symbols exist) before building on them.
Write .orchestrator/<unit>.done.md (≤15 lines: shipped/verified/decided/gotchas/branch).
RETURN ONLY: {"id","status","branch","PR":null,"note":"≤2 lines"} — no dumps, no build output.
```

## §1 Context management (platform)

| Feature | Do | Save | Risk |
|---------|-----|------|------|
| Prompt caching | cache `[system][spec][brief]`, order stable→volatile (live status last/uncached); 5-min TTL, 1-hr for long fan-outs | ~90% on hits | none — byte-identical replay |
| Context editing | **API/SDK builds only** — CC sessions can't set `clear_tool_uses_20250919`; in-CLI equivalent = subagent isolation + files + auto-compaction | ~84% on 100-turn evals | low — **write `.done.md` before results age out** |
| Memory tool | `.done.md` + briefs = the store; state in files outside the window | +39% w/ editing | none — files are source of truth |
| Shared base-prompt cache | the dispatch skeleton above, byte-identical per wave; only `[brief path + upstream .done.md paths]` varies after it | one write serves the whole fan-out (~90% off the prefix for agents 2..N) | none — vary nothing before the breakpoint |
| Semantic caching | reuse answers for *similar* subtasks via embedding match | skips repeat calls | **low–med — verify before trusting on a critical path** |
| Plan caching | cache + adapt execution-plan templates across runs | plan stage = most compute, often repeated | low |

**Token-efficient tool use** — on by default in Claude 4 (~14% output, up to 70%). Keep **consistent across cacheable requests** (selective use breaks caching); incompatible with `disable_parallel_tool_use`.

## §2 Retrieval & nav (load less)

- **JIT** — hold refs (paths/symbols/queries), fetch on demand; preload only the brief.
- **Overview** — Serena `get_symbols_overview` over hand-written headers (live → can't drift).
- **LSP** (`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `rust-analyzer-lsp`, `jdtls-lsp`, `ruby-lsp`, `clangd-lsp`, `csharp-lsp`, `swift-lsp`, `php-lsp`, `kotlin-lsp`, `lua-lsp`):
  - **Broad→narrow**: `documentSymbol` → `hover` → `definition` → `references`. ~500 tok vs 2k+ grep, type-aware.
  - **`diagnostics` = fast check, NOT the DoD gate** — keep the real build/test as the gate.
  - **Active language only.** Heavy servers (`pyright`, `rust-analyzer`) RAM-hungry → raise ceiling or `/plugin disable` → grep. Index warm-up worth it for multi-lookup units, not one-shots.

## §3 Edit & output (emit less)

- **Diff edits** — exact-match `str_replace`, keep syntactic units whole; smaller + more reliable than rewrites.
- **Structured returns** — JSON-schema (Invariant 2); malformed rejected at boundary.
- **Selective tool loading** — each agent gets only its unit's tools (schemas cost tokens every turn).
- **Git** — `commit -q`, `push -q`, `merge --quiet --no-edit --ff-only`; `status --porcelain`, `diff --stat`/`--name-only`; `--no-pager log --oneline -N`.
- **GitHub** — `gh --json <fields> --jq <filter>`; `gh run view --log-failed`; `gh` over GitHub MCP; pre-aggregate to a file the agent reads.
- **Bash** — cap dumps (`head`/`wc -l`, `find -maxdepth`); filter at source (`grep`/`jq`); exit codes over prose; chain `a && b && c`; redirect noise (`2>/dev/null`).

## §4 Browser & research units (Playwright MCP)

- **Pre-strip ingested content** — strip web pages to clean markdown before context (~94% fewer tokens; 38k→2.8k median). Never stream a raw page through the window.
- **Snapshot-default, vision per-task** — a11y snapshot (500–5k tok) over screenshots (10k–50k); `includeSnapshot:false` on non-interacting calls; `browser_evaluate` to extract fields not the tree.
- **Capture-to-disk** for heavy flows (file-as-memory, ~4× less). **`--isolated` + headless** = correct parallel runs.
- **Security:** never expose `browser_evaluate` to untrusted prompts (arbitrary in-page JS).

## §5 API-call construction — SDK/API builds ONLY (not settable from Claude Code sessions)

Output (output ≈ 5× input cost): **`max_tokens` tight** (ceiling not target); **`stop_sequences`** (4–6) halt after the return closes; **assistant prefill** (`{`) forces format + skips preamble (⊥ extended thinking — a thinking unit can't prefill; pick one); low temperature.

Caching: order `tools → system → messages`; `cache_control:{ephemeral}` on the **last static block** (≤4 breakpoints); **dynamic content (date/name/vars) → human turn or after a breakpoint** (one var busts the cache); reads 0.1× / writes 1.25×–2×, TTL refreshes on read. Cache tool defs; strip unneeded (§3) — keeps the prefix clean.

---

# Safeguards

Every efficiency tactic replays, drops, or compresses content — so each can propagate a wrong premise. These keep the fast pipeline from confidently shipping wrong.

- **Notes are claims, not gospel** — a wrong `.done.md` poisons every dependent (errors compound, they don't cancel). Dependents (and Session D) **verify load-bearing claims against committed code** (Serena/LSP), not the note alone.
- **Producer-blind judge gate** — isolated reviewer (separate context, hidden criteria) scores output; supplements the DoD, never replaces deterministic checks. Deterministic for exact (tests/schema/tool-correctness), judge only for judgment.
- **Inter-agent schema gates** — every handoff validates against expected structure before a downstream agent consumes it. Malformed/poisoned data blocked at the boundary.
- **Loop safeguards (C)** — auto-retry, but **kill after 3 stuck iterations** — then: ⛔ in `progress.md`, ONE re-dispatch with the brief amended by the failure signature (a 3×-failed brief is usually the defect — blind re-dispatch = 4th identical failure); still stuck → `blockers.md` line for the user. Per-unit token/iteration **budget guardrail**; circuit breaker + **human escalation** when agents converge on *unverified* info (agreement ≠ correctness).
- **Idempotent units + checkpoints** — re-running must not double-apply; `.done.md` is the checkpoint → a failure re-executes **one unit from its checkpoint, not the whole fan-out**.
- **Small bounded units** — fewer hallucinations than one big prompt; balance against the over-decomposition guard.

## Swap per project

Session A fills these placeholders in the project copy (search the literal `<...>` tokens). **Durable blanks live in the repo `CLAUDE.md`** (DoD commands, secrets location, prefix, stack — per `~/.claude/cleaning/structure.md` §CLAUDE.md); the project copy references them, never duplicates — cycle 2 skips those questions. Cycle-scoped blanks (spec path, integration model, unit granularity) stay here.

- **`<build>` / `<test>` / `<lint>`** — exact DoD commands + stack security checks. *Greenfield:* fill with the INTENDED commands from scoping's stack answers; the foundation unit's acceptance criteria include "make these commands real" — its `.done.md` is authoritative after wave 1.
- **`<secrets location>`** — where agents pull secrets.
- **`<prefix>`** — branch namespace (`feat`, `epic`, project slug…).
- **Spec file + unit granularity** (epic/feature/module/endpoint).
- **Dependency map edges** — the real work; wrong edge → stale build.
- **Integration model** (local-merge default vs PR-based) + **reference sources, tool choices.**
- **Conditional plugins** — stack plugins are `false` in global settings.json (each costs standing context in every session); A enables what the stack needs in the target repo's `.claude/settings.json` per `~/.claude/PLUGINS.md` stack packs (Language LSP §2, `security-guidance` at trust boundaries, etc.). Core set (caveman/ponytail/serena/superpowers/ralph/hookify/review/commit + compound-engineering) is already global.
