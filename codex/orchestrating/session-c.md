# Session C — execute waves

Read `depmap.md`, `progress.md`, the ready briefs, and `safeguards.md`. Do not reload the full spec when the briefs are complete.

## Pre-flight

- Confirm `.orchestrator/state.md` says `running`.
- Confirm the current tree matches the recorded green base.
- Use native `/usage` and `/statusline` for account limits. Record only exposed windows with their reported `duration_minutes`, percentage, and reset; never assume a `primary` label means five-hour or weekly.
- Run `usage-budget.sh quota <snapshot.json>`. At 75% used, shrink to one-unit waves and prefer Terra. At 90%, start no new dispatch, preserve in-flight results, checkpoint, and leave `state: pending` until reset.
- Estimate a ready unit with successful historical p75 for the same model, effort, and category. Do not convert tokens to quota percentage without observed same-window deltas.
- Run `bash $HOME/.codex/orchestrating/validate-plan.sh .orchestrator`; stop instead of spinning on a no-ready state.
- Re-check that the ready wave has no file overlap, including new-file overlap.
- Confirm delegation is authorized by the user or applicable instructions.

## Wave loop

1. Mark ready units `active` in `progress.md`.
2. Spawn only independent units. The root agent retains git, shared files, and integration. If the active surface cannot select a custom profile, paste the role contract from `efficiency.md` into the dispatch prompt.
3. As results arrive, verify the claimed files and checks. A return is evidence to inspect, not proof by itself.
4. Record exact `codex exec --json` usage with `usage-budget.sh record`; interactive transcript paths are best-effort because their format is unstable. Write or validate `.orchestrator/<unit>.done.md` with non-empty `shipped`, `verified`, `decided`, and `gotchas` lines.
5. Run the combined repository DoD once per wave before unlocking dependents. Do not duplicate integration verification between the integration agent and root.
6. Update `progress.md` and reconcile downstream briefs against upstream decisions.

## Recovery

- Running but drifting: use `send_message` with one precise correction.
- Idle or stopped with useful context: use `followup_task` once.
- Genuinely hung: use `interrupt_agent`, record the attempt and failure signature, then split or absorb the unit.
- After three equivalent failures, stop retrying. Mark the unit blocked and write `handoff.md` with the required user decision or external state change.

## Handoff

Before ending an incomplete task, write `handoff.md` with current branch/SHA, done units, active-agent dispositions, blocked units, next ready wave, commands to re-verify, and the exact resume kickoff. Leave `state.md` as `running` when continuation is expected.

When all waves and the combined DoD are green, continue with `session-d.md`.

## Cleared-chat kickoff

Finish every Session C response with one copy-ready prompt as its final block:

- Green waves and combined DoD: Session D kickoff naming the branch/state, `session-d.md`, acceptance criteria, `progress.md`, done notes, final diff, and full DoD command.
- Incomplete, blocked, pending, or failed DoD: Session C resume kickoff naming the branch/state, `handoff.md`, `progress.md`, next ready or blocked unit, and exact re-verification command.

Never emit a Session D kickoff before the combined DoD passes.
