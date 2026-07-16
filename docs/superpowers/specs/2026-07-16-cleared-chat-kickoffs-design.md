# Cleared-chat orchestration kickoffs

## Problem

Codex orchestration preserves state on disk, but its session boundaries do not consistently finish with a copy-ready prompt for a cleared chat. Session C requires an exact resume kickoff only for incomplete work; Sessions A, B, and D have no equivalent output contract.

## Design

Keep the behavior inline where each transition is defined:

- Session A ends with a copy-ready Session B prompt.
- Session B ends with a copy-ready Session C prompt after plan validation.
- Session C ends with a copy-ready Session D prompt when waves are green, or an exact resume prompt when work is incomplete.
- Session D ends with a cleanup prompt after landing/abandonment, or an exact resume prompt when parked/pending.

Each prompt names the current branch/state, only the files needed by the next session, the next action, and the next runnable gate. The prompt must be the final user-facing block so it can be copied without extracting it from surrounding prose.

No shared template or generator is needed. Four short inline contracts are easier to find, customize, and maintain than another abstraction.

## Error handling

- Missing required state leaves the current session active; do not emit a misleading next-session prompt.
- Failed Session B validation keeps the user in Session B.
- Failed Session C combined DoD emits a Session C resume prompt, not a Session D prompt.
- Session D selects cleanup versus resume from the recorded terminal state.

## Verification

Extend `codex/verify.sh` with one small loop that requires every orchestrator session document to contain the cleared-chat kickoff contract. Existing repository verification remains the full DoD.

Implementation follows red-green-refactor: add the verification assertion, observe failure, add the four inline contracts, then rerun `bash codex/verify.sh` and `git diff --check`.

## Scope

Only Codex orchestration session documents and their existing verifier change. Claude orchestration, runtime `.orchestrator/` state, cleanup behavior, and unrelated handoff formats stay unchanged.
