# Codex Config Migration Safety Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prevent the Codex config merger and orchestration workflow from accepting malformed migrated TOML.

**Architecture:** Keep the existing line-preserving merger and teach it to replace complete multiline arrays. Exercise that regression with a real Codex parse, make installed verification invoke Codex as the authoritative parser, and carry the same migration invariant through Sessions A-D.

**Tech Stack:** Bash, Python 3.9 standard library, Codex CLI, Markdown.

## Global Constraints

- Preserve unrelated `$HOME/.codex/config.toml` values and byte stability.
- Add no TOML parser or dependency; Codex is the authoritative validator.
- Preserve the existing `codex/configure.sh` and `codex/configure.test.sh` fix at commit `66c910a`.
- Do not edit `codex/AGENTS.md` or `codex/RTK.md`.
- Do not commit unless the user requests it.

---

### Task 1: Multiline assignment regression

**Files:**
- Modify: `codex/configure.sh:33-79`
- Test: `codex/configure.test.sh:16-68`

**Interfaces:**
- Consumes: existing `lines`, `assignment(line, key)`, and root/table bounds.
- Produces: `value_end(start, limit) -> int` and `replace_assignment(key, start, end, value) -> bool`.

- [x] **Step 1: Verify the regression test fails against the committed implementation**

Extract committed `configure.sh` and `notify.sh` into a temporary directory, copy the current regression-bearing `configure.test.sh`, and run it:

```bash
tmp=$(mktemp -d)
git archive 0627d0d codex/configure.sh codex/notify.sh | tar -x -C "$tmp"
cp codex/configure.test.sh "$tmp/codex/configure.test.sh"
bash "$tmp/codex/configure.test.sh"
```

Expected: FAIL because `existing-notifier` remains after the first line of the multiline array is replaced.

- [x] **Step 2: Preserve the minimal implementation already present on the branch**

Keep `value_end()` limited to multiline arrays and use `replace_assignment()` for root defaults and `[tui].notifications`. Do not add a general TOML parser.

- [x] **Step 3: Verify the regression is green with the branch implementation**

Run:

```bash
bash codex/configure.test.sh
```

Expected: `Codex config synthetic tests: PASS (7 cases; second-run identity PASS)`.

### Task 2: Authoritative validation and Session A-D invariant

**Files:**
- Modify: `codex/verify.sh:41-52,81-88`
- Modify: `codex/orchestrating/orchestrator.md:16-25`
- Modify: `codex/orchestrating/session-b.md:5-12`
- Modify: `codex/orchestrating/session-c.md:18-23`
- Modify: `codex/orchestrating/session-d.md:3-11`

**Interfaces:**
- Consumes: `fail()` in `codex/verify.sh` and Codex CLI config loading.
- Produces: a repository check for the Session A-D invariant and an installed-config parse gate.

- [x] **Step 1: Add the failing documentation contract check**

Add this before agent-definition verification in `codex/verify.sh`:

```bash
migration_invariant='Stateful config migrations require representative existing-state fixtures and authoritative-consumer validation.'
for session in orchestrator.md session-b.md session-c.md session-d.md; do
  rg -Fq "$migration_invariant" "$ROOT/orchestrating/$session" || fail "$session missing stateful config migration invariant"
done
```

- [x] **Step 2: Run the repository verifier and confirm RED**

Run:

```bash
bash codex/verify.sh
```

Expected: FAIL with `orchestrator.md missing stateful config migration invariant`.

- [x] **Step 3: Add the approved invariant to Sessions A-D**

Add this exact sentence at the phase's planning, execution, or judgment gate in each document:

```markdown
Stateful config migrations require representative existing-state fixtures and authoritative-consumer validation.
```

- [x] **Step 4: Add the installed authoritative parse gate**

Immediately after confirming the installed config exists in `codex/verify.sh`, add:

```bash
codex mcp list --json >/dev/null 2>&1 || fail "installed config is not accepted by Codex"
```

- [x] **Step 5: Verify the focused and full checks**

Run:

```bash
bash codex/configure.test.sh
bash codex/verify.sh
bash codex/verify.sh --installed
git diff --check
```

Expected: both config tests and both verification modes report PASS; `git diff --check` emits no output.

- [x] **Step 6: Review only the scoped diff**

Run:

```bash
git diff -- codex/configure.sh codex/configure.test.sh codex/verify.sh codex/orchestrating/orchestrator.md codex/orchestrating/session-b.md codex/orchestrating/session-c.md codex/orchestrating/session-d.md docs/superpowers/specs/2026-07-16-codex-config-migration-safety-design.md docs/superpowers/plans/2026-07-16-codex-config-migration-safety.md
```

Expected: only the approved regression fix, authoritative parse gate, Session A-D invariant, and their design/plan docs.
