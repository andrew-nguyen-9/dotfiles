#!/usr/bin/env bash
# PreToolUse (Read + Bash) — blocks reading .env secrets files. GLOBAL (no
# .orchestrator gate): secrets never belong in a model context window.
# Allows .env.example / .env.template / .env.sample.
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || exit 0

tool=$(printf '%s' "$input" | jq -r '.tool_name // empty')

deny() {
  echo "SECRETS GUARD: $1 looks like a secrets file. Never load secrets into context — reference the var name; the runtime reads the value." >&2
  exit 2
}

case "$tool" in
  Read)
    file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
    base=$(basename "$file")
    case "$base" in
      .env.example|.env.template|.env.sample) exit 0 ;;
      .env|.env.*) deny "$file" ;;
    esac
    ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
    if printf '%s' "$cmd" | grep -qE '(cat|less|more|head|tail|bat|strings|vi|vim|nano|open|grep|awk|sed|source|dd|od|xxd|base64)[^|;&]*[[:space:]/]\.env(\.[a-z]+)?([[:space:]|;&]|$)' \
       && ! printf '%s' "$cmd" | grep -qE '\.env\.(example|template|sample)'; then
      deny ".env target in: $cmd"
    fi
    ;;
esac
exit 0
