# Codex Orchestration Efficiency Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship and validate a compact Codex-native orchestration workflow with an 80-scenario benchmark, safe hook proof, adaptive token budgeting, and evidence-backed model/plugin policy.

**Architecture:** Keep durable policy and summaries under `codex/orchestrating/`; keep run artifacts under ignored `.orchestrator/`. Use Bash, `jq`, `git`, and `codex`; no new dependency. Deterministic simulations gate all 80 scenarios; isolated live runs measure 16 representative fixtures.

**Tech Stack:** Markdown, Bash 3.2-compatible shell, `jq`, `git`, Codex CLI JSONL.

## Global Constraints

- Success and verification outrank token savings; no baseline success regression.
- Normal live runs use `gpt-5.6-terra` with medium reasoning. Sol is sentinel-only or evidence-backed escalation.
- Caveman ultra and Ponytail ultra start every orchestration tier; explicit override and clarity/correctness escalation remain allowed.
- Reported quota, measured task tokens, and future estimates remain separate.
- Runtime artifacts stay under `.orchestrator/`; committed paths use `$HOME` or `~/`, never a username-specific home.
- Run `bash codex/verify.sh` after every combined wave. Commit every green checkpoint. Do not push, open a PR, release, or deploy.
- Never read or expose credential values. Do not change machine-local Codex config.

---

### Task 1: Benchmark definitions and baseline harness

**Files:**
- Create: `codex/orchestrating/benchmark/scenarios.json`
- Create: `codex/orchestrating/benchmark/run.sh`
- Create: `codex/orchestrating/benchmark/result.schema.json`
- Create: `codex/orchestrating/benchmark/README.md`

**Interfaces:**
- Consumes: baseline SHA, candidate SHA, scenario IDs, `codex exec --json` JSONL.
- Produces: `.orchestrator/benchmark/{baseline,candidate,summary}.json`, exact token and hard-failure fields.

- [ ] **Step 1: Add 80 unique scenarios**

Create JSON objects with `id`, `category`, `kind`, `prompt`, `expected`, `hard_failures`, `live`, and `sentinel`. Enforce counts `28/16/20/8/4/4`, exactly 16 live fixtures, exactly 4 sentinels.

- [ ] **Step 2: Add failing validation command**

Run: `bash codex/orchestrating/benchmark/run.sh validate`

Expected before harness exists: command fails.

- [ ] **Step 3: Implement minimal harness**

Support `validate`, `simulate <ref> <label>`, `live <ref> <label>`, and `summarize`. Use `jq -e` for schema/count checks. Use detached worktrees under `.orchestrator/benchmark/worktrees`, alternate baseline/candidate order, mock external/destructive operations, and write ephemeral transcripts only for failing cases.

- [ ] **Step 4: Verify and checkpoint**

Run: `bash codex/orchestrating/benchmark/run.sh validate`

Run: `bash codex/orchestrating/benchmark/run.sh simulate 3063f1a baseline`

Run: `bash codex/verify.sh`

Expected: 80 valid scenarios, 80 baseline results, repository PASS.

Commit: `feat: add orchestration benchmark baseline`

### Task 2: State recovery and dispatch contract

**Files:**
- Create: `codex/orchestrating/validate-plan.sh`
- Modify: `codex/orchestrating/README.md`
- Modify: `codex/orchestrating/lite.md`
- Modify: `codex/orchestrating/medium.md`
- Modify: `codex/orchestrating/orchestrator.md`
- Modify: `codex/orchestrating/session-b.md`
- Modify: `codex/orchestrating/session-c.md`
- Modify: `codex/orchestrating/session-d.md`
- Modify: `codex/orchestrating/safeguards.md`
- Modify: `codex/orchestrating/efficiency.md`

**Interfaces:**
- Consumes: `.orchestrator/prd.json`, `depmap.md`, briefs, progress, done records.
- Produces: dispatch gate rejecting cycles, empty ownership, overlaps, missing checks/upstream symbols, and no-ready state.

- [ ] **Step 1: Write validator self-test first**

Add `bash codex/orchestrating/validate-plan.sh --self-test`; fixtures cover valid plan plus cycle, empty ownership, overlap, missing check, missing upstream symbol, and no-ready failures.

- [ ] **Step 2: Confirm red state**

Run: `bash codex/orchestrating/validate-plan.sh --self-test`

Expected before implementation: nonzero.

- [ ] **Step 3: Implement validator and compact docs**

Use `jq` plus Bash arrays only. Add resume matrix for fresh/running/partial/parked/pending/abandoned/landed. Require explicit owned files, runnable check, note path, upstream symbols, profile-capability fallback, producer-blind judge input, one combined DoD per wave, and recorded base/attempt/failure/token fields.

- [ ] **Step 4: Verify and checkpoint**

Run: `bash codex/orchestrating/validate-plan.sh --self-test`

Run: `bash codex/verify.sh`

Expected: self-test PASS; repository PASS.

Commit: `feat: harden orchestration recovery gates`

### Task 3: Hook proof and usage budgeting

**Files:**
- Create: `codex/hooks/test.sh`
- Create: `codex/orchestrating/usage-budget.sh`
- Modify: `codex/hooks/orch-return-cap.sh`
- Modify: `codex/hooks.json`
- Modify: `codex/verify.sh`
- Modify: `codex/orchestrating/session-c.md`
- Modify: `codex/orchestrating/session-d.md`

**Interfaces:**
- Consumes: Codex hook event JSON, `codex exec --json` usage records, optional user-recorded `/usage` window snapshots.
- Produces: hook synthetic PASS, trusted runtime RTK marker, measured p75 estimates, quota-aware wave action.

- [ ] **Step 1: Add failing synthetic tests**

Test secret guard, read cap, return-cap warning schema, RTK configured hook, exact usage parsing, p75 estimate, and 90%-used stop rule.

- [ ] **Step 2: Replace unsupported output rewrite**

Return `systemMessage` from `PostToolUse`; never emit `updatedToolOutput`. Keep two-line behavior contract in dispatch briefs.

- [ ] **Step 3: Add smallest budget tool**

Commands: `record <jsonl> <meta-json>`, `estimate <model> <effort> <category>`, `quota <snapshot-json>`. Store observations in `.orchestrator/usage.jsonl`; calculate successful historical p75 without converting tokens to quota percentage.

- [ ] **Step 4: Prove RTK runtime invocation**

Run a trusted ephemeral `codex exec` with a temporary marker-producing RTK shim first, then one actual supported command through the installed hook. Record configuration/proof separately from `rtk gain`; if tracking DB remains unavailable, state that no savings are measured.

- [ ] **Step 5: Verify and checkpoint**

Run: `bash codex/hooks/test.sh`

Run: `bash codex/verify.sh`

Expected: synthetic hooks, runtime RTK proof, budgeting checks, repository PASS.

Commit: `feat: verify hooks and adaptive budgets`

### Task 4: Agent and model policy

**Files:**
- Modify: `codex/agent-defs/unit-builder.toml`
- Modify: `codex/agent-defs/integration-agent.toml`
- Modify: `codex/agent-defs/blind-judge.toml`
- Modify: `codex/orchestrating/efficiency.md`
- Modify: `codex/orchestrating/medium.md`

**Interfaces:**
- Consumes: current surface profile-selection capability and benchmark evidence.
- Produces: Terra-medium default, Sol sentinel/escalation rule, ultra-mode contracts, prompt fallback when profile selection is absent.

- [ ] **Step 1: Add policy assertions to verification**

Check all orchestration tiers name Caveman ultra and Ponytail ultra, normal agents use Terra medium, and Sol appears only in benchmark/escalation text.

- [ ] **Step 2: Update minimal agent contracts**

Pin normal roles to `gpt-5.6-terra` and medium reasoning. Include two-line structured return, owned-files boundary, runnable check, note path, upstream-symbol gate, and automatic clarity/correctness escalation.

- [ ] **Step 3: Verify and checkpoint**

Run: `bash codex/verify.sh`

Expected: repository PASS.

Commit: `feat: set efficient orchestration agent policy`

### Task 5: Plugin scope and evidence record

**Files:**
- Create: `codex/orchestrating/plugin-policy.md`
- Modify: `codex/PLUGINS.md`

**Interfaces:**
- Consumes: installed plugin inventory from Session A and benchmark evidence.
- Produces: decisions covering provenance, permissions, hooks, maintenance, context cost, native overlap, revisions, and verification.

- [ ] **Step 1: Record decisions, no duplicate installs**

Keep installed Caveman/Ponytail. Keep parked gstack wrappers parked. Scope Serena/Context7 per repository. Benchmark Superpowers/Hookify/review/commit helpers before global retention. Reject `caveman-shrink` and a new orchestration plugin absent measured need.

- [ ] **Step 2: Record Claude decision**

Change no Claude file unless paired results show a missed opportunity with equal success and lower tokens. Document installed-but-disabled plugin context findings without exposing machine-local config or credentials.

- [ ] **Step 3: Verify and checkpoint**

Run: `bash codex/verify.sh`

Expected: repository PASS.

Commit: `docs: record orchestration plugin policy`

### Task 6: Candidate evaluation and final gate

**Files:**
- Create: `codex/orchestrating/benchmark/summary.json`
- Create: `docs/superpowers/specs/2026-07-14-codex-orchestration-efficiency-results.md`
- Modify: `codex/orchestrating/benchmark/README.md`
- Modify: `.orchestrator/progress.md`
- Modify: `.orchestrator/state.md`
- Modify: `.orchestrator/handoff.md`

**Interfaces:**
- Consumes: baseline/candidate simulations, 48 planned live runs, checks, plugin/hook evidence.
- Produces: weighted comparison, hard-failure gate, measured-versus-estimated report, maintenance guidance, final resumable state.

- [ ] **Step 1: Run deterministic candidate**

Run: `bash codex/orchestrating/benchmark/run.sh simulate HEAD candidate`

Expected: 80 candidate results, no new hard failure, no hard-pass regression.

- [ ] **Step 2: Run live matrix**

Run all 16 paired baseline/candidate fixtures on Terra medium; repeat four sentinel pairs once on Terra; run four sentinel pairs on Sol medium. Add trials only for discordant sentinels. Stop new dispatches, preserve results, and checkpoint if any reported quota window reaches 90% used.

- [ ] **Step 3: Summarize evidence**

Run: `bash codex/orchestrating/benchmark/run.sh summarize`

Report exact input, cached-input, output, reasoning-output, uncached input, cache-hit ratio, wall time, tool calls, clarification turns, file changes, model/effort/version, checks, hard failures, uncertainty, and weighted scores. Compare tokens only for successful pairs.

- [ ] **Step 4: Run regression and final review**

Run representative 16-scenario regression subset, `bash codex/hooks/test.sh`, `bash codex/orchestrating/validate-plan.sh --self-test`, and `bash codex/verify.sh` from clean combined tree. Review final diff against acceptance criteria; deterministic failures override narrative review.

- [ ] **Step 5: Commit final green checkpoint**

Commit: `docs: report orchestration efficiency results`

Do not push, open a PR, release, or deploy.
