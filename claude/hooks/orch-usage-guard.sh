#!/usr/bin/env bash
# PreToolUse (Task|Agent) — orchestrator budget guard.
# Blocks new subagent dispatch at >=98% of the 5h-window token limit so Session C
# writes handoff.md and stops cleanly instead of grinding into a hard freeze.
# Active ONLY in repos with a live .orchestrator/ dir. 0 model tokens.
# Limit source: $ORCH_TOKEN_LIMIT, else the max totalTokens of any past ccusage block.
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0
command -v ccusage >/dev/null 2>&1 || exit 0

dir=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -n "$dir" ] || dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.orchestrator" ] || exit 0

blocks=$(ccusage blocks -j 2>/dev/null) || exit 0
active=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isActive == true)][0].totalTokens // 0')
limit="${ORCH_TOKEN_LIMIT:-$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isGap != true) | .totalTokens] | max // 0')}"

[ "$limit" -gt 0 ] 2>/dev/null || exit 0
pct=$(( active * 100 / limit ))

if [ "$pct" -ge 98 ]; then
  echo "BUDGET GUARD: 5h window at ${pct}% (${active}/${limit} tokens). Do NOT dispatch. Disposition every in-flight unit, write .orchestrator/handoff.md, end the session; resume at window reset." >&2
  exit 2
fi
exit 0
