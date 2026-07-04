#!/usr/bin/env bash
# PreToolUse (Read) — big-read block: forces offset/limit or Serena symbolic nav
# for files over 600 lines. Active ONLY with a live .orchestrator/ dir.
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

# A real window means a positive limit or offset. limit:0 / offset:0 are
# degenerate (no lines / whole file) and must NOT bypass the cap.
has_window=$(printf '%s' "$input" | jq -r '[.tool_input.limit, .tool_input.offset] | map(select(type == "number" and . > 0)) | length > 0' 2>/dev/null)
[ "$has_window" = true ] && exit 0

file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -f "$file" ] || exit 0

lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
if [ "${lines:-0}" -gt 600 ]; then
  echo "READ CAP: $file is $lines lines. Read the section you need with Serena get_symbols_overview / find_symbol, or offset/limit windowing (the universal path — works without serena tools) — never whole-file reads at this size." >&2
  exit 2
fi
exit 0
