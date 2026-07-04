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
if [ ! -d "$dir/.orchestrator" ]; then
  common=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null) || exit 0
  [ -n "$common" ] || exit 0
  case "$common" in /*) ;; *) common="$dir/$common" ;; esac
  [ -d "$(dirname "$common")/.orchestrator" ] || exit 0
fi

# ponytail: 4000-char ceiling, not 2 lines — leaves room for legit review findings
printf '%s' "$input" | jq -c '
  (.tool_response | if type == "string" then . else tojson end) as $out
  | if ($out | length) > 4000 then
      {hookSpecificOutput: {hookEventName: "PostToolUse",
        updatedToolOutput: (($out[0:4000]) + "\n[TRUNCATED by return-cap hook: return contract is <=2 lines — detail belongs in .done.md on disk]")}}
    else empty end'
exit 0
