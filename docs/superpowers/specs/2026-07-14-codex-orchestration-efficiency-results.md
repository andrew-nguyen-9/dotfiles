# Codex orchestration efficiency results

## Scope

Candidate: `d0c2c41`; baseline: `3063f1a`. The run used the committed 80-scenario definition, a deterministic baseline/candidate simulation, and 48 isolated `codex exec --json` runs. Normal runs used `gpt-5.6-terra` at medium reasoning; the four sentinels were repeated on Terra and run once on `gpt-5.6-sol` at medium reasoning. External writes, destructive actions, git changes, and network use were disallowed. Runtime artifacts remain uncommitted under `.orchestrator/benchmark/`.

## Result

| evidence | baseline | candidate |
| --- | ---: | ---: |
| deterministic scenarios | 80 / 39.25 | 80 / 100 |
| Terra primary (hard pass / mean score) | 16 / 55.94 | 16 / 81.25 |
| Terra repeated sentinels (hard pass / mean score) | 4 / 61.25 | 4 / 75 |
| Sol sentinels (hard pass / mean score) | 4 / 50 | 4 / 87.5 |
| hard failures | 0 | 0 |

The candidate has no correctness or safety regression. The 16-case Terra subset is the required representative regression subset; all checks passed and no fixture changed files or git state.

## Measured live usage

`turn.completed` supplied the following exact totals. These are measured task usage, not account-quota estimates.

| run | input | cached input | uncached input | output | reasoning | wall | tools | clarifications | file changes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Terra baseline, 16 | 253,282 | 205,824 | 47,458 | 1,723 | 152 | 96s | 0 | 1 | 0 |
| Terra candidate, 16 | 257,147 | 185,088 | 72,059 | 2,094 | 497 | 114s | 0 | 0 | 0 |
| Terra baseline repeat, 4 | 63,455 | 52,224 | 11,231 | 607 | 127 | 25s | 0 | 1 | 0 |
| Terra candidate repeat, 4 | 63,837 | 52,224 | 11,613 | 625 | 128 | 22s | 0 | 0 | 0 |
| Sol baseline, 4 | 63,431 | 13,056 | 50,375 | 631 | 155 | 32s | 0 | 0 | 0 |
| Sol candidate, 4 | 64,021 | 0 | 64,021 | 665 | 197 | 79s | 0 | 0 | 0 |

Among successful Terra primary pairs, candidate input was 3,865 tokens higher (1.53%). The repeated Terra sentinels were also higher by 382 tokens (0.60%), and Sol by 590 tokens (0.93%). The candidate improved scored evidence, but this evaluation does **not** demonstrate token savings. Keep the efficiency claim pending; do not convert this result into a permanent savings rule.

## RTK and quota evidence

- `which rtk`: `/opt/homebrew/bin/rtk`; `rtk --version`: `0.42.4`.
- `rtk gain` could not open its tracking database in this environment, so no RTK savings are measured.
- `rtk discover` reported 55 supported opportunities and about 4.9k estimated savings. That is an estimate, not measured usage.
- Synthetic hook tests and the trusted runtime smoke both passed; the latter proved the Codex Bash hook invoked `/opt/homebrew/bin/rtk` before a supported command.
- No new interactive quota-window snapshot was exposed during the run. Usage-budget estimates remain separate from the measured JSONL values above.

## Final verification

Passed after the combined wave:

- `bash codex/orchestrating/validate-plan.sh --self-test`
- `bash codex/orchestrating/benchmark/run.sh --self-test`
- `bash codex/hooks/test.sh`
- `bash codex/hooks/test.sh --runtime`
- `bash codex/verify.sh --installed`
- `bash codex/verify.sh`

The compact Codex-native workflow, Terra default, Sol sentinel policy, Caveman ultra, Ponytail ultra, synthetic hook coverage, and RTK runtime proof are integrated. No plugin was added, no machine-local credential was read or changed, and no push, PR, release, or deployment occurred.
