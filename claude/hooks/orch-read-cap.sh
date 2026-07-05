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
