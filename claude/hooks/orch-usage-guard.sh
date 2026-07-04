#!/usr/bin/env bash
# PreToolUse (Task|Agent) — orchestrator budget guard.
# Blocks new subagent dispatch at >=98% of the 5h-window token limit so Session C
# writes handoff.md and stops cleanly instead of grinding into a hard freeze.
# Active ONLY in repos with a live .orchestrator/ dir. 0 model tokens.
# Limit source: $ORCH_TOKEN_LIMIT, else the max totalTokens of any COMPLETED
# ccusage block (active excluded — else the heaviest-ever run becomes its own
# limit and self-blocks at "100%"). No history and no env var → guard inactive.
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0
command -v ccusage >/dev/null 2>&1 || exit 0

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

blocks=$(ccusage blocks -j 2>/dev/null) || exit 0
active=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isActive == true)][0].totalTokens // 0')
limit="${ORCH_TOKEN_LIMIT:-$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isGap != true and .isActive != true) | .totalTokens] | max // 0')}"

[ "$limit" -gt 0 ] 2>/dev/null || exit 0
pct=$(( active * 100 / limit ))

if [ "$pct" -ge 98 ]; then
  echo "BUDGET GUARD: 5h window at ${pct}% (${active}/${limit} tokens). Do NOT dispatch. Disposition every in-flight unit, write .orchestrator/handoff.md, end the session; resume at window reset. (False positive from thin usage history / low derived ceiling? Override with ORCH_TOKEN_LIMIT=<tokens>.)" >&2
  exit 2
fi
exit 0
