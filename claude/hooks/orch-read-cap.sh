#!/usr/bin/env bash
# PreToolUse (Read) — big-read block: forces offset/limit or Serena symbolic nav
# for files over 600 lines. Active ONLY with a live .orchestrator/ dir.
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0

dir=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
[ -n "$dir" ] || dir="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -d "$dir/.orchestrator" ] || exit 0

has_window=$(printf '%s' "$input" | jq -r '(.tool_input.limit // .tool_input.offset // empty)')
[ -n "$has_window" ] && exit 0

file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -f "$file" ] || exit 0

lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
if [ "${lines:-0}" -gt 600 ]; then
  echo "READ CAP: $file is $lines lines. Use offset/limit for the section you need, or Serena get_symbols_overview / find_symbol — never whole-file reads at this size." >&2
  exit 2
fi
exit 0
