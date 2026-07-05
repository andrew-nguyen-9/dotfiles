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

blocks=$(ccusage blocks -j 2>/dev/null) || exit 0
active=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isActive == true)][0].totalTokens // 0')
derived=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isGap != true and .isActive != true) | .totalTokens] | max // 0')

# ORCH_TOKEN_LIMIT overrides the derived ceiling, but a non-numeric value
# (e.g. "garbage") must NOT silently disable the guard — warn once and fall
# back to the max-completed-block logic instead of a swallowed -gt error.
if [ -n "${ORCH_TOKEN_LIMIT:-}" ]; then
  case "$ORCH_TOKEN_LIMIT" in
    *[!0-9]* | "") echo "BUDGET GUARD: ORCH_TOKEN_LIMIT='$ORCH_TOKEN_LIMIT' is not a positive integer — ignoring it, using derived ceiling." >&2; limit="$derived" ;;
    *) limit="$ORCH_TOKEN_LIMIT" ;;
  esac
else
  limit="$derived"
fi

[ "$limit" -gt 0 ] 2>/dev/null || exit 0
pct=$(( active * 100 / limit ))

if [ "$pct" -ge 98 ]; then
  echo "BUDGET GUARD: 5h window at ${pct}% (${active}/${limit} tokens). Do NOT dispatch. Do NOT kill in-flight agents — accept their returns; dispatch nothing new. Disposition every in-flight unit, write .orchestrator/handoff.md, end the session; resume at window reset. (False positive from thin usage history / low derived ceiling? Override with ORCH_TOKEN_LIMIT=<tokens>.)" >&2
  exit 2
fi
exit 0
