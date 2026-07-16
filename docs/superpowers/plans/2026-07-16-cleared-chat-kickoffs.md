# Cleared-Chat Kickoffs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every Codex orchestration session finish with a copy-ready prompt for the next cleared chat.

**Architecture:** Keep one explicit `## Cleared-chat kickoff` contract in each existing session document. Extend the existing Bash verifier with a marker check; do not add a template, generator, or dependency.

**Tech Stack:** Markdown, Bash, `rg`

## Global Constraints

- Modify only Codex orchestration session documents and `codex/verify.sh`.
- Do not edit `codex/AGENTS.md` or `codex/RTK.md`.
- Use `$HOME/...` or `~/...` in committed paths.
- Prompts must be the final user-facing block and must name branch/state, minimum inputs, next action, and runnable gate.
- Failed gates keep the current session active; never advance to a misleading next-session prompt.
- Do not modify Claude orchestration, runtime `.orchestrator/` state, or cleanup behavior.

---

### Task 1: Enforce and document cleared-chat kickoffs

**Files:**
- Modify: `codex/verify.sh`
- Modify: `codex/orchestrating/orchestrator.md`
- Modify: `codex/orchestrating/session-b.md`
- Modify: `codex/orchestrating/session-c.md`
- Modify: `codex/orchestrating/session-d.md`

**Interfaces:**
- Consumes: existing Session A-D state files, gates, and handoff rules.
- Produces: one `## Cleared-chat kickoff` section per session document; `codex/verify.sh` rejects missing sections.

- [ ] **Step 1: Write the failing verification assertion**

Add this block to `codex/verify.sh` after the existing orchestration-tier checks:

```bash
for session in orchestrator.md session-b.md session-c.md session-d.md; do
  rg -q '^## Cleared-chat kickoff$' "$ROOT/orchestrating/$session" || fail "$session missing cleared-chat kickoff"
done
```

- [ ] **Step 2: Run the verifier and confirm the expected failure**

Run:

```bash
bash codex/verify.sh
```

Expected: nonzero exit with `FAIL: orchestrator.md missing cleared-chat kickoff`.

- [ ] **Step 3: Add Session A kickoff contract**

Append to `codex/orchestrating/orchestrator.md`:

````markdown
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
````

- [ ] **Step 4: Add Session B kickoff contract**

Append to `codex/orchestrating/session-b.md`:

````markdown
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
````

- [ ] **Step 5: Add Session C kickoff contract**

Append to `codex/orchestrating/session-c.md`:

````markdown
## Cleared-chat kickoff

Finish every Session C response with one copy-ready prompt as its final block:

- Green waves and combined DoD: Session D kickoff naming the branch/state, `session-d.md`, acceptance criteria, `progress.md`, done notes, final diff, and full DoD command.
- Incomplete, blocked, pending, or failed DoD: Session C resume kickoff naming the branch/state, `handoff.md`, `progress.md`, next ready or blocked unit, and exact re-verification command.

Never emit a Session D kickoff before the combined DoD passes.
````

- [ ] **Step 6: Add Session D kickoff contract**

Append to `codex/orchestrating/session-d.md`:

````markdown
## Cleared-chat kickoff

Finish every Session D response with one copy-ready prompt as its final block:

- `landed` or `abandoned`: cleanup kickoff, `Read $HOME/.codex/cleaning/README.md and run it.`
- `parked` or `pending`: exact resume kickoff naming the branch/SHA, state, required authority or external change, handoff path, and re-verification command.

Do not emit cleanup while work remains resumable.
````

- [ ] **Step 7: Run focused and full verification**

Run:

```bash
bash codex/orchestrating/validate-plan.sh --self-test
bash codex/verify.sh
git diff --check
```

Expected:

```text
Orchestration plan self-test: PASS
Codex verification: PASS
```

`git diff --check` exits zero with no output.

- [ ] **Step 8: Commit the implementation**

```bash
git add codex/verify.sh codex/orchestrating/orchestrator.md codex/orchestrating/session-b.md codex/orchestrating/session-c.md codex/orchestrating/session-d.md
git commit -m "feat: add cleared-chat orchestration kickoffs"
```
