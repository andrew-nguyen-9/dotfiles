#!/usr/bin/env bash
set -u

[ "$#" -ge 1 ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

event=$(jq -r '.type // empty' <<<"$1" 2>/dev/null) || exit 0
[ "$event" = agent-turn-complete ] || exit 0
message=$(jq -r '."last-assistant-message" // "Turn complete"' <<<"$1" 2>/dev/null) || exit 0

if [ "${CODEX_NOTIFY_DRY_RUN:-}" = 1 ]; then
  printf 'Codex\n%s\n' "$message"
  exit 0
fi

command -v osascript >/dev/null 2>&1 || exit 0
osascript - "Codex" "$message" >/dev/null 2>&1 <<'APPLESCRIPT' || true
on run argv
  display notification (item 2 of argv) with title (item 1 of argv)
end run
APPLESCRIPT
