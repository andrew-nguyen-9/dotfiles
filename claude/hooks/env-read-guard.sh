#!/usr/bin/env bash
# PreToolUse (Read + Bash) — blocks reading .env / .envrc secrets files. GLOBAL
# (no .orchestrator gate): secrets never belong in a model context window.
# Allows any *.env* / *.envrc* whose name carries example / template / sample.
# Fires on EVERY Read and Bash call — false positives on normal files are
# unacceptable, so matching is per-token and basename-anchored.
set -u
input=$(cat)

deny() {
  echo "SECRETS GUARD: $1 looks like a secrets file. Never load secrets into context — reference the var name; the runtime reads the value." >&2
  exit 2
}

# scan_secret <text>: succeeds (0) when the text contains a bare .env-ish token
# — .env, .env.<x>, .envrc, .envrc.<x> — that is NOT an example/template/sample.
# tr splits on every non-path char, so verbs, redirects (`< .env`), `=`, `:`,
# quotes and separators all break into their own tokens; the anchored regex then
# matches only a real basename component (so `development.environment`, `foo.env`
# and `.environment` never match).
scan_secret() {
  printf '%s' "$1" | tr -c 'A-Za-z0-9_./-' '\n' \
    | grep -E '(^|/)\.env(rc)?(\.[A-Za-z0-9_.-]+)?$' \
    | grep -qvE 'example|template|sample'
}

# jq missing OR JSON unparseable → coarse fallback over raw stdin. Never a plain
# allow: block when a real .env token is present, otherwise allow (normal reads
# carry no .env token so they pass). 2>/dev/null keeps jq parse errors quiet.
if ! command -v jq >/dev/null 2>&1 || ! printf '%s' "$input" | jq -e . >/dev/null 2>&1; then
  scan_secret "$input" && deny ".env reference"
  exit 0
fi

tool=$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null)

case "$tool" in
  Read)
    file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    base=$(basename "$file")
    case "$base" in
      .env|.env.*|.envrc|.envrc.*)
        case "$base" in
          *example*|*template*|*sample*) exit 0 ;;
          *) deny "$file" ;;
        esac
        ;;
    esac
    ;;
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
    scan_secret "$cmd" && deny ".env target in: $cmd"
    ;;
esac
exit 0
