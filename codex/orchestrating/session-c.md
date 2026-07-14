# Session C — execute waves

Read `depmap.md`, `progress.md`, the ready briefs, and `safeguards.md`. Do not reload the full spec when the briefs are complete.

## Pre-flight

- Confirm `.orchestrator/state.md` says `running`.
- Confirm the current tree matches the recorded green base.
- Re-check that the ready wave has no file overlap.
- Confirm delegation is authorized by the user or applicable instructions.

## Wave loop

1. Mark ready units `active` in `progress.md`.
2. Spawn only independent units. The root agent retains git, shared files, and integration.
3. As results arrive, verify the claimed files and checks. A return is evidence to inspect, not proof by itself.
4. Write or validate `.orchestrator/<unit>.done.md` with non-empty `shipped`, `verified`, `decided`, and `gotchas` lines.
5. Run the combined repository DoD before unlocking dependents.
6. Update `progress.md` and reconcile downstream briefs against upstream decisions.

## Recovery

- Running but drifting: use `send_message` with one precise correction.
- Idle or stopped with useful context: use `followup_task` once.
- Genuinely hung: use `interrupt_agent`, record the failure signature, then split or absorb the unit.
- After three equivalent failures, stop retrying. Mark the unit blocked and write `handoff.md` with the required user decision or external state change.

## Handoff

Before ending an incomplete task, write `handoff.md` with current branch/SHA, done units, active-agent dispositions, blocked units, next ready wave, commands to re-verify, and the exact resume kickoff. Leave `state.md` as `running` when continuation is expected.

When all waves and the combined DoD are green, continue with `session-d.md`.
