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
