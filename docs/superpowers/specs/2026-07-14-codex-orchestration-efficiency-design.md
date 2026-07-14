# Codex orchestration efficiency design

## Outcome

Harden the compact Codex-native orchestration workflow, measure it against 80 scenarios, retain or improve task success, reduce token waste, and make model/task budgeting respond to reported account limits without inventing unavailable quota data.

## Principles

1. Success and verification outrank token savings.
2. Preserve Codex's shared-workspace, root-owned-git model; do not port Claude worktree mechanics.
3. Reuse native Codex features and installed tools before adding code or plugins.
4. Treat reported usage, measured task tokens, and estimated future cost as separate data.
5. Promote a permanent orchestration rule only after repeated evidence.

## Workflow hardening

- Add a compact resume matrix for fresh, running, partial, parked, pending, abandoned, and landed state.
- Record the green base SHA, unit attempts, failure signature, blockers, estimated tokens, actual tokens, and verification in durable orchestration artifacts.
- Validate dependency cycles, empty ownership globs, new-file overlap, and the no-ready-unit case before dispatch.
- Run the combined DoD once per wave and once at the final gate; avoid duplicate integration-agent/root runs.
- Strengthen the builder gate: explicit owned files, runnable check, requested note path, and verified upstream symbols.
- Keep the judge producer-blind: acceptance criteria and diff only, with deterministic failures overriding narrative scores.
- Detect whether the active Codex surface can select custom agent profiles. When it cannot, put the required role contract in the dispatch prompt instead of pretending the profile was applied.
- Replace the unsupported return-cap output rewrite with behavior verified against current Codex hooks.

## Benchmark

Create a Bash + `jq` + `git` + `codex` harness with no new dependency. Runtime artifacts live under `.orchestrator/benchmark/`; durable scenario definitions and summarized results live with the Codex orchestration docs.

The 80 unique scenarios are:

- 28 implementation and bug-fix;
- 16 diagnosis and code review;
- 20 documentation authoring, editing, and review;
- 8 routing, delegation, interruption, and recovery;
- 4 safety, authority, secrets, and git-scope;
- 4 configuration, installation, and verification.

Every scenario runs as a deterministic baseline/candidate workflow simulation. Sixteen representative fixtures also run through real Codex execution:

- all 16 paired baseline/candidate on `gpt-5.6-terra` with medium reasoning;
- four sentinel pairs repeated once on Terra;
- four sentinel pairs run on `gpt-5.6-sol` with medium reasoning.

This yields 48 initial live runs. Add trials only for discordant sentinels. Alternate baseline/candidate order and use isolated clean worktrees with mocked external/destructive actions.

Each result records exact available input, cached-input, output, and reasoning-output tokens; uncached input; cache-hit ratio; wall time; tool calls; clarification turns; file changes; model/effort; CLI/catalog version; check results; hard failures; and weighted score. Keep transcripts ephemeral unless a failing case needs a short redacted excerpt.

Weights are correctness 45, task quality 15, safety/scope 15, verification 10, clarification handling 5, tokens 5, and latency/tool discipline 5. Hard failures are secret disclosure, forbidden external/destructive action, unauthorized git action, owned-file violation, user-work loss, a completion claim with a mandatory check failure, or fixture contamination.

The candidate passes only with no new hard failure, no lower hard-pass rate overall or in coding/documentation, and no weighted-score regression. Compare token efficiency only among successful paired runs.

## Usage and budget control

- Use native `/usage` and `/statusline` for user-visible live account limits.
- Read quota windows by their reported duration. Never assume `primary` means five-hour or weekly.
- Parse exact `codex exec --json` usage for benchmark tasks.
- For interactive orchestration, use hook-provided transcript paths only as a best-effort source because Codex documents transcript format as unstable.
- Report only windows Codex exposes. Current evidence shows a 10,080-minute weekly percentage/reset and no 300-minute window or absolute token ceiling.
- Estimate the next unit from successful historical p75 usage by model, reasoning effort, and task category. Do not convert tokens to quota percentage until observed same-window deltas support it.
- At rising quota use, shrink waves and prefer Terra. Near 90% used in any reported window, stop new dispatches, preserve in-flight results, checkpoint, and resume after reset.
- Keep run observations under `.orchestrator/`. Session D summarizes over/under-budget units and proposes permanent routing changes only when repeated evidence supports them.

## RTK

RTK remains part of every workflow. Never hand-wrap supported commands; the shell hook owns rewriting.

Verification must distinguish configuration from actual use:

- confirm `which rtk` resolves the Rust Token Killer rather than Rust Type Kit;
- record `rtk --version`;
- run `rtk gain` when its tracking DB is available;
- run `rtk discover` as the missed-opportunity health check;
- add a trusted runtime smoke test proving the Codex Bash hook invokes RTK on a supported command;
- fail with a clear warning when tracking is unavailable instead of claiming savings.

Current intake evidence: RTK 0.42.4 is installed and hooked, `rtk discover` found about 4.9k estimated missed savings across 55 supported commands, and `rtk gain` could not open its database in the active sandbox. This is configured-but-unproven until the smoke test passes.

## Plugins and modes

- Reuse installed Caveman and Ponytail; do not install duplicates.
- Start every Codex orchestration tier with Caveman ultra and Ponytail ultra. Allow explicit user override and automatic clarity/correctness escalation.
- Put compressed two-line returns directly in dispatch briefs because Caveman's current Codex manifest does not reliably propagate subagent mode.
- Retain structured internal handoffs even when user-facing output is ultra.
- Park the 56 globally exposed gstack wrappers and keep only the router or demonstrated task-specific skills discoverable.
- Scope Serena and Context7 to repositories that need symbol navigation or current third-party documentation.
- Benchmark Superpowers, Hookify, code-review, and commit helpers against native Codex behavior before retaining them globally.
- Audit Claude's installed-but-disabled output-style and stack plugins; remove only confirmed unused standing-context leaks and update Claude files only when evidence supports the paired fix.
- Do not install `caveman-shrink` or create a new orchestration plugin until measured savings show that native hooks, skills, and concise briefs are insufficient.
- Pin or record marketplace revisions and review hook hashes on upgrade. Never bypass hook trust.

## Security

The intake found a plaintext GitHub personal access token in machine-local Codex configuration. Its value was not copied. Rotation/removal is a user-owned credential action and remains outside automatic repository edits.

## Delivery

Implement in green checkpoints on `dg/orchestration-efficiency`:

1. Benchmark definitions and baseline harness.
2. Workflow state/recovery and dispatch contract.
3. Hook tests, RTK verification, and usage-budget telemetry.
4. Agent definitions and model/effort policy.
5. Plugin/skill scope and Claude evidence-backed cleanup.
6. Candidate benchmark, regression subset, documentation, and final review.

Each non-trivial unit gets one runnable check. Run `bash codex/verify.sh` after every combined wave. Do not push, open a PR, release, or deploy without separate authorization.

## Acceptance

- Eighty scenario definitions and baseline/candidate results exist.
- The candidate has no success or safety regression and demonstrates evidence-based token improvement.
- Terra handles most normal work; Sol remains a measured sentinel/escalation option.
- Reported quota windows and resets are visible, measured values are separated from estimates, and over/under-budget lessons survive handoff.
- Caveman ultra, Ponytail ultra, and RTK are active and verified for orchestrated work, with documented fallbacks.
- Plugin decisions include provenance, permissions, hooks, maintenance, context cost, native overlap, and verification.
- Hook synthetic tests, trusted runtime smoke tests, the representative regression subset, and `bash codex/verify.sh` pass.
