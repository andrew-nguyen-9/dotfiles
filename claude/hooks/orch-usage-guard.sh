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

command -v ccusage >/dev/null 2>&1 || exit 0

. "$(dirname "${BASH_SOURCE[0]}")/lib/orch-common.sh"
orch_dir=$(orch_find_dir "$input") || exit 0
orch_gate_open "$orch_dir" || exit 0

blocks=$(ccusage blocks -j 2>/dev/null) || exit 0
active=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isActive == true)][0].totalTokens // 0')
derived=$(printf '%s' "$blocks" | jq '[.blocks[] | select(.isGap != true and .isActive != true) | .totalTokens] | max // 0')

# ORCH_TOKEN_LIMIT overrides the derived ceiling, but a non-numeric value
# (e.g. "garbage") OR a zero (0, 00, …) must NOT silently disable the guard —
# warn once and fall back to the max-completed-block logic. Zero would otherwise
# pass the digit check then die at `-gt 0` → guard silently inactive.
# A leading-zero value (0100, 0108) is a base-10 count, but bare `$(( ))` reads
# it as OCTAL — 0100→64 (guard trips 6.4% low) and 0108→invalid-octal arith
# error + `set -u` exit (guard dies). Force base-10 with 10#; the previous arm
# already filtered non-digits, so 10# here only ever sees pure digit strings.
if [ -n "${ORCH_TOKEN_LIMIT:-}" ]; then
  case "$ORCH_TOKEN_LIMIT" in
    *[!0-9]* | "") echo "BUDGET GUARD: ORCH_TOKEN_LIMIT='$ORCH_TOKEN_LIMIT' is not a positive integer — ignoring it, using derived ceiling." >&2; limit="$derived" ;;
    *[!0]*) limit=$((10#$ORCH_TOKEN_LIMIT)) ;;
    *) echo "BUDGET GUARD: ORCH_TOKEN_LIMIT='$ORCH_TOKEN_LIMIT' is not a positive integer — ignoring it, using derived ceiling." >&2; limit="$derived" ;;
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
