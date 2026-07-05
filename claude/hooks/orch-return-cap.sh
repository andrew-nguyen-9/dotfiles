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
# git-worktree, a submodule root, or a linked-worktree project root that lacks
# it. Resolve via the common dir: (1) its parent (plain worktree), else
# (2) core.worktree from the common config (submodule / linked-worktree root),
# else (3) the first `worktree list` entry that has one. git absent/failing or
# nothing found → fail-open (exit 0), unchanged from before.
orch_dir="$dir/.orchestrator"
if [ ! -d "$orch_dir" ]; then
  common=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null) || exit 0
  [ -n "$common" ] || exit 0
  case "$common" in /*) ;; *) common="$dir/$common" ;; esac
  orch_dir=""
  if [ -d "$(dirname "$common")/.orchestrator" ]; then
    orch_dir="$(dirname "$common")/.orchestrator"
  else
    wt=$(git config -f "$common/config" core.worktree 2>/dev/null)
    case "$wt" in /*) ;; ?*) wt="$common/$wt" ;; esac
    if [ -n "$wt" ] && [ -d "$wt/.orchestrator" ]; then
      orch_dir="$wt/.orchestrator"
    else
      for wt in $(git -C "$dir" worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2}'); do
        [ -d "$wt/.orchestrator" ] && { orch_dir="$wt/.orchestrator"; break; }
      done
    fi
  fi
  [ -d "$orch_dir" ] || exit 0
fi

# Lifecycle gate: dormant ONLY on an explicit non-running state.md; armed otherwise.
# Signal = first NON-blank line after BOM strip; an empty/blank/0-byte file stays
# ARMED (same as a missing file), so a truncated/racing write can't silently disarm.
# Tolerant match: -iE accepts case and missing-space variants (state:running,
# State: running). jq-less/fail-open: missing/unreadable state.md keeps it active.
if [ -f "$orch_dir/state.md" ]; then
  first=$(LC_ALL=C tr -d '\357\273\277' < "$orch_dir/state.md" | awk 'NF{print;exit}')
  [ -n "$first" ] && ! printf '%s' "$first" | grep -qiE '^[[:space:]]*state:[[:space:]]*running' && exit 0
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
