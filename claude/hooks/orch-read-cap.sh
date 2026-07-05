#!/usr/bin/env bash
# PreToolUse (Read|Grep) — big-read block: forces offset/limit or Serena symbolic
# nav for files over 600 lines. Active ONLY with a live .orchestrator/ dir.
# Wired on the `^(Read|Grep)$` matcher; Grep calls carry no file_path so they hit
# the `[ -f "$file" ]` guard below and pass through (exit 0) — only Read is capped.
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

# A real window requires a positive `limit` — that is what bounds the number of
# lines read. offset-without-limit does NOT bound the read (Read's default limit
# then pulls the whole file from the offset), so it must remain blockable.
# limit:0 is degenerate (no lines) and also must NOT bypass the cap.
has_window=$(printf '%s' "$input" | jq -r '(.tool_input.limit | type == "number" and . > 0)' 2>/dev/null)
[ "$has_window" = true ] && exit 0

file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -f "$file" ] || exit 0

lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
if [ "${lines:-0}" -gt 600 ]; then
  echo "READ CAP: $file is $lines lines. Read the section you need with Serena get_symbols_overview / find_symbol, or offset/limit windowing (the universal path — works without serena tools) — never whole-file reads at this size. No live orchestrator run? .orchestrator/ may be stale — run: Read ~/.claude/cleaning/README.md and run it." >&2
  exit 2
fi
exit 0
