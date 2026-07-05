# Audit cycle — orchestrator-agents system (dotfiles claude/)

Run with: `Read ~/.claude/orchestrating/audit-cycle.md and run it` in a fresh chat in the dotfiles repo. ultrathink.

Plan/brainstorm ONLY with Fable (use forks — they inherit loaded context; never make them re-read).
Code EVERY fix with Opus builders. `/caveman:caveman ultra`; `/ponytail:ponytail ultra`; RTK + Serena active.

## Setup (main window, before fan-out)

- Read the orchestrator-audit memory (see MEMORY.md index): prior fixes + deferred user-decisions. Everything listed there is COVERED — scenarios must break new ground; never re-apply what the user deferred.
- Read all of `orchestrating/*`, `cleaning/*`, `agent-defs/*`, `hooks/*.sh` (~1k lines) + git diff since the last audit commit — recently-changed text gets the heaviest scenario coverage.

## Fan-out (parallel Fable forks, strict output contracts)

1. **5+ scenario forks × 7+ scenarios (35+ total)**, themed by subsystem — rotate themes across cycles. Per fork: walk each scenario through EXACT doc text; return table `# | scenario | outcome | CONFIRMED/PLAUSIBLE/NIT | file:line | 1-line fix | sev P0-P3`, ≤120 lines, detail paragraphs for P0/P1 only.
2. **Hooks fork**: LIVE-TEST every claim (synthetic JSON stdin in the scratchpad; never create `.orchestrator` in a real repo). No speculation — "live-tested" tag required.
3. **Context fork**: quantify every role's read set (chars/4), ranked savings, APPLY-NOW vs USER-DECISION.
4. **Structure fork**: `cleaning/structure.md` ↔ pipeline round-trips — every harvest artifact needs a named consumer; flag write-only ritual.
5. **Research fork**: WebSearch current subagent/orchestration practice; verify against fetched docs; skip prior-cycle findings; tag APPLY-NOW / USER-DECISION / EXPERIMENT.

Agent dies (session limit etc.) → re-run after reset or do its work inline with live tests. Coverage is never silently dropped.

## Synthesize (Fable, main window)

Dedupe, drop NITs, verify every P0/P1 against the actual text, build a fix manifest partitioned into DISJOINT file sets. Apply CONFIRMED + cheap PLAUSIBLE; structural/behavioral changes → user-decision list, not edits.

## Fix (Opus)

One builder per file set, parallel. Briefs carry exact line anchors + "match the file's terse style, minimal diffs, no commits". Then cross-verify in the main window: grep every cross-file contract the fixes touched (header formats, pointers, refs to new files) — builders drift on shared conventions; patch residue inline. Shell fixes: reuse `hooks/lib/orch-common.sh` functions first; extract a NEW shared function only when a pattern repeats ≥3× AND extraction shrinks total lines; never trivial wrappers.

## Land

`fix:`/`chore:` commits (no AI attribution), push main. Update the memory file: cycle record + open user-decisions with fresh evidence. Then run cleaning on this repo (template repo — Invariant 6, flag-only). Final report: P0/P1s fixed, token savings, open user-decisions.
