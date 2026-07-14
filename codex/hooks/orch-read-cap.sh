#!/usr/bin/env bash
# PreToolUse (Read|Grep) — big-read block: forces offset/limit or symbolic
# nav for files over 600 lines. Active ONLY with a live .orchestrator/ dir.
# Wired on the `^(Read|Grep)$` matcher; Grep calls carry no file_path so they hit
# the `[ -f "$file" ]` guard below and pass through (exit 0) — only Read is capped.
set -u
input=$(cat)

. "$(dirname "${BASH_SOURCE[0]}")/lib/orch-common.sh"
orch_dir=$(orch_find_dir "$input") || exit 0
orch_gate_open "$orch_dir" || exit 0

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
  echo "READ CAP: $file is $lines lines. Use symbolic navigation or offset/limit windowing; never whole-file reads at this size. No live orchestrator run? .orchestrator/ may be stale — run: Read ~/.codex/cleaning/README.md and run it." >&2
  exit 2
fi
exit 0
