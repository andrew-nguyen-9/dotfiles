# Codex dispatch compactness and RTK hook design

## Outcome

Accept the verified quality/safety rollout, fix RTK 0.42.4 compatibility for current and future dotfiles installations, and measure whether a compact per-agent dispatch brief reduces tokens without lowering quality or safety.

## RTK compatibility

The current `rtk hook claude` response contains `hookSpecificOutput.updatedInput` but omits the `permissionDecision: "allow"` required by Codex. This causes the PreToolUse hook failure before the rewritten Bash command can run.

Add one repository-owned compatibility script under `codex/hooks/`. It reads the hook event, invokes the installed RTK hook, and:

- adds `permissionDecision: "allow"` only when RTK returns `updatedInput` without a decision;
- preserves an existing decision and all other RTK fields;
- passes valid non-rewrite output through unchanged;
- exits successfully without output when RTK or `jq` is unavailable, disabling rewriting rather than returning invalid hook JSON.

Point `codex/hooks.json` at the compatibility script. `codex/install.sh` already links the complete hooks directory and `hooks.json`, so no new installer mechanism is needed. Keep paths portable through `$HOME` and repository-relative links.

Synthetic tests use an RTK stub and cover the reported invalid response, an already-valid response, passthrough, and missing dependency behavior. The trusted runtime smoke must still prove that Codex invokes the actual RTK binary before a supported Bash command.

## Compactness experiment

Measure the repeated dispatch cost, not durable documentation size. Reuse the existing benchmark harness and the 16 committed live fixtures.

Both arms use the same candidate commit, Terra-medium model, scenario, policy excerpt, output schema, safety constraints, and clean read-only worktree. The control uses the current verbose dispatch contract. The candidate uses a semantically equivalent compact two-line contract. Alternate order across all 16 pairs.

Record exact `codex exec --json` input, cached-input, output, reasoning-output, uncached input, wall time, tool calls, clarification turns, file changes, scores, and hard failures. Compare total tokens only among successful matched pairs.

The compact contract passes only when it has:

- no new hard failure;
- equal or better hard-pass rate and mean weighted score;
- lower aggregate total tokens across successful pairs.

If it passes, replace only the repeated dispatch wording and document the measured delta. If it fails, retain the quality rollout and record the compactness result without claiming savings. Do not compress durable workflow documentation, add a prompt-rewriting hook, change models, or add dependencies.

## Verification and delivery

Use one runnable self-test for the RTK compatibility logic and extend the existing benchmark self-test for prompt-arm selection. Run the trusted RTK runtime smoke, the 16-pair Terra experiment, `bash codex/verify.sh --installed`, and `bash codex/verify.sh`.

Commit green checkpoints. Do not push, open a PR, release, or deploy. Do not read or alter machine-local credential values.
