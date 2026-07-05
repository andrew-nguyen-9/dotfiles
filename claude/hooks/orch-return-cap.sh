#!/usr/bin/env bash
# PostToolUse (Task|Agent) — return-contract cap.
# A subagent return over 4000 chars violates the <=2-line contract; truncate it
# before it floods the orchestrator window. Active ONLY with a live .orchestrator/.
# updatedToolOutput replaces the tool result (supported per hooks docs) — live.
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0

dir=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -n "$dir" ] || dir="${CLAUDE_PROJECT_DIR:-$PWD}"
# .orchestrator lives in the MAIN worktree; a subagent's cwd may be a linked
# git-worktree that lacks it — fall back to the common dir's parent. git
# absent/failing → fail-open (exit 0), unchanged from before.
orch_dir="$dir/.orchestrator"
if [ ! -d "$orch_dir" ]; then
  common=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null) || exit 0
  [ -n "$common" ] || exit 0
  case "$common" in /*) ;; *) common="$dir/$common" ;; esac
  orch_dir="$(dirname "$common")/.orchestrator"
  [ -d "$orch_dir" ] || exit 0
fi

# Lifecycle gate: dormant unless state.md is absent (legacy dir) or says running.
# Tolerant match: LC_ALL=C tr strips a leading UTF-8 BOM, then -iE accepts case
# and missing-space variants (state:running, State: running) — a stray byte or
# casing must not silently disarm the guard mid-run.
# jq-less/fail-open: a missing/unreadable state.md keeps the hook active as before.
if [ -f "$orch_dir/state.md" ] && ! head -n1 "$orch_dir/state.md" | LC_ALL=C tr -d '\357\273\277' | grep -qiE '^[[:space:]]*state:[[:space:]]*running'; then
  exit 0
fi

# ponytail: 4000-char ceiling, not 2 lines — leaves room for legit review findings.
# Tail-preserving: keep first ~3200 + marker + last ~800 chars so the trailing
# {"id","status",...} contract JSON agents append LAST survives truncation.
printf '%s' "$input" | jq -c '
  (.tool_response | if type == "string" then . else tojson end) as $out
  | ($out | length) as $len
  | if $len > 4000 then
      {hookSpecificOutput: {hookEventName: "PostToolUse",
        updatedToolOutput: (
          ($out[0:3200])
          + "\n…[truncated by return-cap hook: " + (($len - 4000) | tostring) + " chars dropped — return contract is <=2 lines; detail belongs in .done.md on disk]…\n"
          + ($out[($len - 800):$len]))}}
    else empty end'
exit 0
