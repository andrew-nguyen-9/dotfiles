# orchestrator.md

Multi-agent orchestrator run as **four chat sessions** (A→B→C→D). Each session does one job, writes its output to disk, and ends with a **copy-paste kickoff prompt** for the next. Context stays thin because detail lives in files, never in chat — the kickoff prompt + disk artifacts *are* the handoff.

This file is a **template** (lives in dotfiles at `~/.claude/orchestrating/orchestrator.md`, alongside `wishlist.md` — the fill-in bootstrap). Session A copies it into the target project with the [Swap per project](#swap-per-project) blanks filled. Everything downstream reads the **project copy**, never the template.

**When to use** — big asks only: many genuinely independent epics, shared scaffolding, multi-day, worth ~15× fan-out. Smaller → `lite.md` (one pass) or `medium.md` (plan + bounded fan-out). The `wishlist.md` router picks; this file assumes it chose orchestrator.

## How to run

Each session is a **separate, fresh chat** — open a new chat, paste that session's kickoff prompt, let it run, copy the kickoff it prints at the end, open the next new chat. Don't run two sessions in one window: the whole point is that a cold session carries no prior context, so the window stays thin. **Session A is first — it has no upstream kickoff; start it with the bootstrap prompt in §Session A.** Resuming mid-session (e.g. C after a budget stop) = new chat reading `handoff.md`, not the kickoff.

**Session read map (each session loads only its own file + shared spine sections):** A = this whole spine (it fills the blanks). B = `~/.claude/orchestrating/session-b.md` + spine §Tiers + §Invariants + §Thinking budget + §Swap. C = `~/.claude/orchestrating/session-c.md` + `~/.claude/orchestrating/efficiency.md` (skeleton) + `~/.claude/orchestrating/safeguards.md` §Loop safeguards (the 3-kill procedure it runs live) + the project copy's §Swap + §Model + §Invariants + §Thinking budget. D = `~/.claude/orchestrating/session-d.md` + `~/.claude/orchestrating/safeguards.md` + the project copy's §Swap + §Invariants + §Thinking budget (+ artifacts `depmap.md` + `progress.md` + `spec.md` + `*.done.md` — fix-unit scoping + C's substitution/gap notes). Shared spine sections live in `.orchestrator/orchestrator.md` (the project copy, blanks filled).

## Artifacts — one home for all state

All cross-session state lives in **`.orchestrator/`** at the project repo root. Every session reads/writes here; nothing of substance lives in chat. Add `.orchestrator/` to `.gitignore` unless you want the trail committed. **`.orchestrator/` is gitignored + unit branches are local → a big-tier run resumes only on the machine that started it.**

```
.orchestrator/
  state.md          # lifecycle: running|parked|abandoned|landed — A writes running; D transitions
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
| **D — Review & land** | Verify original ask is met, full code review, then commit/push/merge/prune. | merged trunk | — |

**Blockers gate C, not B.** B is pure thinking (no env needed). A lists everything the user must finish (secrets, accounts, infra, access, decisions) *before* C fans out.

**D treats C's work as claims, not gospel** — re-verifies against committed code (Safeguards).

## Model — terms used throughout

- **`main`** — throughout this system = the repo's DEFAULT branch. Repo uses `master`/`trunk`/etc → substitute it everywhere (D ff/push, cleaning gates, medium merges); A records the actual name at cycle start (`git symbolic-ref --short refs/remotes/origin/HEAD` — strip the `origin/` prefix; no remote → `git config init.defaultBranch`, else the current branch on a fresh clone).
- **Wave** — a batch of units with no unmet deps, dispatched together. Foundation wave first; feature waves after its `.done.md` lands.
- **Dispatch** — C launches a **fresh subagent** per unit; the type comes from the task's `agent` field in `prd.json` (picked by B from the **agents catalog** `~/.claude/agents-docs/` — category docs + role dispatch snippets, loaded JIT). **Never fork** — a fork inherits C's context, defeating the thin window.
- **Integration model (default = local-branch-merge, no PRs needed).** A long-lived `integration` branch starts at `main`. **Each unit branches `<prefix>/<unit>` off the *current* `integration`** — so upstream *code* (not just `.done.md` notes) is already present for dependents. As a wave's units pass DoD, the integration subagent merges them into `integration` in dep order and runs full regression *there* (C holds only pass/fail, never the build output); the **next wave branches off the updated `integration`**. D fast-forwards `main` to the final green `integration`. Set `PR` in returns to null. Assumes the run owns `main` (freeze other merges, or **merge `origin/main` INTO `integration` before the final ff — never rebase `integration` while unit branches exist, that orphans them**). *PR-based variant:* agents open a PR per unit, C's integration agent uses `gh` to assemble, D merges PRs — pick one model project-wide, don't mix.

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
2. **Return contract.** Every agent returns ONLY `id, status, branch, PR?, ≤2-line note` as JSON (`PR` null in local-merge model — see Integration model). The BUILT return-cap hook truncates any >4000-char return at the boundary (tail-preserving, so the trailing contract JSON survives); C's discipline covers the sub-4000 range — a verbose return already cost its tokens; **never re-quote it** — carry a 1-line summary forward, drop the rest. (Workflow-tool dispatches CAN enforce via `agent(schema:)`.)
3. **Cap every artifact.** Note ≤15 lines. Return ≤2 lines. Brief = one unit, **≤~150 lines / ~2k tok** (over → unit too big, split it). Uncapped = re-flood.
4. **Every session AND every subagent runs lean.** Sessions (A–D): activate `/caveman:caveman ultra` (compress all prose/returns/notes), `/ponytail:ponytail ultra` (laziest diff that works), **RTK** (shell → `rtk`), **Serena/LSP** (symbolic nav over whole-file reads; unavailable or no-fit → Grep/Glob/Read). **Subagents can't reliably invoke skills** — they get the same rules as plain text via the dispatch skeleton (`~/.claude/orchestrating/efficiency.md`): a behavioral contract, not a skill dependency. **Installed output-style plugins inject their style prompt regardless of enable flags** (verified: both flags `false`, both styles still inject) — the control is **UNINSTALL** (`claude plugin uninstall`), NOT settings flags; `explanatory`/`learning` multiply prose, so uninstall them (see PLUGINS.md). **Boundary:** caveman/ponytail govern *prose, returns, notes* — NOT code, commit messages, or PR bodies, which stay normal and complete (and carry no AI attribution).

---

# Session A — Intake

**Bootstrap (chat #1).** Easiest: fill `~/.claude/orchestrating/wishlist.md` and paste it (or type `Read ~/.claude/orchestrating/wishlist.md and run it`). Or paste this directly into a fresh chat in the repo:
```
Read ~/.claude/orchestrating/orchestrator.md and run Session A on the wishlist below.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
First confirm this wishlist is big enough to warrant the orchestrator (§When to use) — if not, switch to lite.md or medium.md per the wishlist.md ladder.
Wishlist:
<paste your wishlist here>
```

**Input:** the user's raw wishlist + this template.

0. **Set up** — `.orchestrator/` exists at the project root → **consult `state.md` FIRST** (its first line is authoritative over the artifact matrix; missing = legacy dir → skip to the matrix): `parked` → print the D-resume kickoff (session-d.md documents it) and stop; `abandoned`|`landed` → cleaning never ran → STOP + cleaning kickoff (`Read ~/.claude/cleaning/README.md and run it.`) and end; `running` → **possibly a live run in another window** — warn + ask the user first; only a confirmed-dead run falls through to the artifact matrix for the crash-resume point. **Artifact matrix** (heuristic crash-detection misroutes; presence of specific files is authoritative):
   - only the `orchestrator.md` copy and/or `state.md`, or empty → **fresh**: overwrite, proceed below.
   - `spec.md` only (no `blockers.md`) → **resume A** from its state: read the half-written `spec.md`, continue scoping, don't clean.
   - `spec.md` + `blockers.md`, but no `prd.json`/`briefs/` → **A finished**: print the A→B kickoff and end.
   - `prd.json` + `briefs/` + `depmap.md` ALL present, but no `*.done.md` → **B finished**: print the B→C kickoff (in session-b.md) and end.
   - PARTIAL-B (some of `prd.json`/`briefs/`/`depmap.md` present but not all) → **resume B** from its artifacts: fresh B chat reading `spec.md`; don't re-plan units whose briefs already exist.
   - any `*.done.md` → **STOP**: `state.md` says `running` AND user just confirmed the run dead (step-0 warn+ask) → print the C RESUME kickoff (session-c.md §Resume reconstructs without `handoff.md`); non-running/legacy → **prior-cycle STOP**: a cycle didn't clean; print the cleaning kickoff (`Read ~/.claude/cleaning/README.md and run it.`) and end — stale files silently poison a run.
   - User overrides the STOP ("just proceed") → `mv .orchestrator .orchestrator.stale-<YYYY-MM-DD>` (target exists — 2nd same-day override → append `-<HHMM>`; harvest later), THEN proceed fresh — stale same-named `*.done.md` otherwise make C silently skip new units.
   Fresh → create `.orchestrator/` at the repo ROOT (`git rev-parse --show-toplevel` — a session opened in a monorepo subdir else plants it off-root, hooks + later sessions miss it; **open every session at the repo root**); **append `.orchestrator/` to `.gitignore` when absent** (else untracked `.orchestrator/` noise pollutes every porcelain check all run); **`cp ~/.claude/orchestrating/orchestrator.md .orchestrator/orchestrator.md`** then delete the whole `# Session A — Intake` section from the PROJECT COPY (B/C/D never read it — ~1.7k dead tok/run; the dotfiles template stays untouched) + write `.orchestrator/state.md` = one line `state: running — <YYYY-MM-DD>` (D transitions it later), then fill blanks with targeted Edits (never re-type the template — ~8k output tokens wasted). All artifacts below land in `.orchestrator/`.
0.5 **Survey the repo** — **arriving from a medium-tier escalation? `plan.md` is the wishlist input — read it.** **Read the repo `CLAUDE.md` first**: any Swap-per-project blank already answered there (DoD, secrets location, prefix, stack) is a question A skips; A patches `CLAUDE.md` with newly-decided durable blanks at the end (cycle 2 then re-asks nothing) — **but repo `CLAUDE.md` is a symlink (`test -L`) → STOP and ask before patching** (dotfiles-managed; writing through the symlink corrupts the shared source). An answer already living in HUMAN PROSE (e.g. a `## Testing` section) → A skips the question but MUST still normalize it into the canonical `DoD:`/`Secrets:`/`Branches:` lines (pointer to the prose detail is fine) — GATE 1 greps the literal lines, not prose; else a correctly-configured repo hard-STOPs C. Repo has `AGENTS.md` but no `CLAUDE.md` → create a THIN `CLAUDE.md` holding only the canonical lines + a `See AGENTS.md` pointer; never duplicate its content (two sources drift). Also read `docs/03-roadmap.md` + **every `docs/decisions/` file dated since the previous cycle's land** (same-day medium+big cycles produce two — "latest" silently skips one) if present — prior-cycle blocked epics and `cost:`/`process:` footers feed this cycle's scope and budget; **plus `docs/02-architecture.md` §Map/§Ownership zones/§Gotchas + `docs/04-operations.md` §Ops notes** (A is the sole documented reader of harvested knowledge — grounds scope in what prior cycles learned). Brownfield (existing code)? Map it first (Serena `get_symbols_overview` / LSP, README, build files) so questions are grounded and B doesn't rebuild what exists. Empty repo (greenfield)? Skip the mapping, but **A owns git bootstrap**: `git init` (if needed) — then verify the created default branch is `main` (`init.defaultBranch` may differ); not → note the actual name (see §Model `main` line) — + create `CLAUDE.md` from `~/.claude/cleaning/structure.md` §CLAUDE.md with the INTENDED DoD commands (else GATE 1 STOPs C on the missing lines). **Order-critical: the root commit COMMITS `CLAUDE.md` on `main` (NOT an empty commit), THEN `git branch integration`** — else worktrees branched off `integration` carry no `CLAUDE.md` and builders improvise DoD silently. A's end-of-session `CLAUDE.md` patch also commits (stage only `CLAUDE.md`, never `-a`) — then re-sync `integration` (`git branch -f integration main` — safe, nothing has branched off it yet this cycle); an unsynced patch commit on `main` otherwise breaks D's final `--ff-only`. **Ensure `integration` exists (EVERY run, not just greenfield — brownfield + every medium→big escalation, else unit-builders' `checkout -b <u> integration` fails or reuses a stale one):** kickoff/wishlist names a brownfield START BRANCH (lite/medium escalation's feature branch) → seed/reset `integration` from THAT branch, not `main` (the escalation preserved half-done work there; a `main`-seeded `integration` makes wave 1 rebuild it; D's land gate still guards `main`). Otherwise: missing → `git branch integration main`; exists from a prior cycle fully merged into `main` → reset it to `main` (reset refused because a leftover worktree holds `integration` checked out — dead integration agent → `git worktree remove --force <that worktree>` first, then reset); unmerged → STOP and ask. Every unit branches off `integration`; nobody downstream creates it.
1. **Batched scoping.** AskUserQuestion serves **max 4 questions per call** — a "round" is several back-to-back calls (~3–5 calls = ~12–20 questions), then you digest answers before the next round. **300 = hard ceiling, not a target** — most projects finish well under. Rounds narrow: goals → scope → stack → constraints → DoD → release policy. **Stop the moment answers stop changing the spec** (don't pad to 300). An answer contradicting an earlier round's → surface the pair to the user next round; never silently pick one (a silent pick cascades 15×). Scoping reveals the ask is really lite/medium-sized → **DE-ESCALATE** (never de-escalate an ask that arrived via escalation — `plan.md` input — finish it big; avoids medium→big→medium ping-pong): `rm -rf .orchestrator` (created this session, nothing landed — an orphaned `state: running` else makes every later chat warn "possibly live run") + delete an `integration` branch created/reset this session (`git branch -d integration`, it sits at `main`; else a later medium dispatch missing `base:` silently branches off it), then print the medium/lite kickoff carrying the answers gathered so far.
2. **Write `spec.md`** — structured epics, each with acceptance criteria. Normalize the wishlist; don't carry a raw list forward. Soft cap ~1 page per epic — a bloated spec inflates B and every brief derived from it.
3. **Fill the project `orchestrator.md`** — in the copy from step 0, fill the [Swap per project](#swap-per-project) blanks (spec path, DoD, secrets location, tool choices).
4. **Write `blockers.md`** — a **markdown checkbox list** of everything the user must complete before C: secrets provisioned, accounts/access granted, infra up, external decisions made. Each line `- [ ] <blocker> — <how to verify done> — blocks: <unit|wave|all>[ — assumed: <what the spec assumes meanwhile>]`. Each box's "how to verify" must be a READ-ONLY/idempotent probe (C runs it blind, possibly repeatedly, pre-wave) whose **EXIT CODE 0 means done** — never judge by output text (hooks may rewrite output); a mutating verify → route to the user instead. A probe that would NAME a secrets file (`test -f .env` etc.) is blocked by the env-read-guard hook and perma-fails → write `verify: user-attested` instead; C trusts the tick for those. The user ticks each `- [x]` as they finish. C halts **only the waves whose deps are blocked** (an unchecked wave-3-only box must not idle wave 1), printing which. Before dispatching a wave a freshly-ticked box unblocks, C **runs that box's "how to verify" command** — a wrongly-ticked box costs a wasted dispatch. A ticked answer that contradicts its `assumed:` → the affected briefs are stale: re-run B for those briefs before their wave. User abandons scoping mid-round → write the spec with stated assumptions and route each open question to a `blockers.md` checkbox — user answers async, C gates on it. **`<release policy>` still unfilled → default `block-release` + a `blockers.md` box to confirm** (else the literal token surfaces only at the first ⛔ unit mid-run).

**A → B kickoff (copy-paste):**
```
Session B — Architecture. Read ~/.claude/orchestrating/session-b.md + .orchestrator/orchestrator.md ONLY §Tiers, §Invariants, §Thinking budget, §Swap (grep headings, offset/limit windows — never the whole copy; this project's filled values) + .orchestrator/spec.md + .orchestrator/blockers.md.
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Do Session B: brainstorm, plan, scaffold, write trackers + design docs, fan spec → .orchestrator/briefs/ + prd.json + depmap.md.
Read spec.md ONCE. Detail to disk only. End by printing the Session C kickoff prompt.
```

---

The three downstream session bodies + the efficiency/safeguards layer live in sibling files (each session loads only its own). Pointers:

- **Session B — Architecture** → `~/.claude/orchestrating/session-b.md`
- **Session C — Execution (the lean core)** → `~/.claude/orchestrating/session-c.md`
- **Session D — Review & land** → `~/.claude/orchestrating/session-d.md`
- **Efficiency layer (§1–4, dispatch skeleton) → `~/.claude/orchestrating/efficiency.md` · API-only §5 → `~/.claude/orchestrating/efficiency-api.md` · Safeguards → `~/.claude/orchestrating/safeguards.md`**

---

## Swap per project

Session A fills these placeholders in the project copy (search the literal `<...>` tokens). **Durable blanks live in the repo `CLAUDE.md`** (DoD commands, secrets location, prefix, stack — per `~/.claude/cleaning/structure.md` §CLAUDE.md); the project copy references them, never duplicates — cycle 2 skips those questions. Cycle-scoped blanks (spec path, integration model, unit granularity) stay here.

- **`<build>` / `<test>` / `<lint>`** — exact DoD commands + stack security checks. *Greenfield:* fill with the INTENDED commands from scoping's stack answers; the foundation unit's acceptance criteria include "make these commands real" — its `.done.md` is authoritative after wave 1.
- **`<secrets location>`** — where agents pull secrets. **`Secrets: none` is a valid filled value** when there are no secrets — never leave the literal `<secrets location>` token, it hard-STOPs C's GATE 1.
- **`<prefix>`** — branch namespace (`feat`, `epic`, project slug…).
- **`<release policy>`** — ship-without vs block-release for a ⛔ (failed) unit: default + per-unit exceptions. Decided in A but written HERE (C is banned from `spec.md`, so this is the only place C can read the ship-without rule for ⛔ units). Non-default per-unit exceptions → also record as a `depmap.md` column.
- **Spec file + unit granularity** (epic/feature/module/endpoint).
- **Dependency map edges** — the real work; wrong edge → stale build.
- **Integration model** (local-merge default vs PR-based) + **reference sources, tool choices.** `main` branch-protected (PRs required, direct push rejected) → pick the PR-based variant at A time; local-merge's D land step cannot push.
- **Conditional plugins** — stack plugins are `false` in global settings.json (each costs standing context in every session); A enables what the stack needs in the target repo's `.claude/settings.json` per `~/.claude/PLUGINS.md` stack packs (Language LSP §2, `security-guidance` at trust boundaries, etc.). **Enables take effect at next session start** — A's enables serve B onward, never A itself; don't debug a "missing" plugin mid-session. Core set (caveman/ponytail/serena/superpowers/ralph/hookify/review/commit + compound-engineering) is already global.
