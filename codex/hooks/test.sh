#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$(cd "$ROOT/.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
contains() { grep -Fq "$2" "$1" || fail "$1 missing: $2"; }
not_contains() { ! grep -Fq "$2" "$1" || fail "$1 unexpectedly contains: $2"; }

synthetic() {
  local project="$tmp/project" input status output history i estimate quota
  mkdir -p "$project/.orchestrator"
  printf '%s\n' 'state: running' > "$project/.orchestrator/state.md"
  awk 'BEGIN { for (i=1; i<=601; i++) print i }' > "$project/large.txt"

  input=$(jq -cn --arg cwd "$project" '{cwd:$cwd,tool_name:"Bash",tool_input:{command:"sed -n 1p .env"}}')
  status=0
  printf '%s' "$input" | bash "$ROOT/hooks/env-read-guard.sh" >/dev/null 2>&1 || status=$?
  [ "$status" -eq 2 ] || fail "secrets guard did not block synthetic secret target"

  input=$(jq -cn --arg cwd "$project" --arg file "$project/large.txt" '{cwd:$cwd,tool_input:{file_path:$file}}')
  status=0
  printf '%s' "$input" | bash "$ROOT/hooks/orch-read-cap.sh" >/dev/null 2>&1 || status=$?
  [ "$status" -eq 2 ] || fail "read cap did not block 601-line whole read"
  input=$(jq -cn --arg cwd "$project" --arg file "$project/large.txt" '{cwd:$cwd,tool_input:{file_path:$file,limit:20}}')
  printf '%s' "$input" | bash "$ROOT/hooks/orch-read-cap.sh" >/dev/null || fail "read cap blocked bounded read"

  input=$(jq -cn --arg cwd "$project" --arg response "$(awk 'BEGIN { for (i=1; i<=4100; i++) printf "x" }')" '{cwd:$cwd,tool_response:$response}')
  printf '%s' "$input" | bash "$ROOT/hooks/orch-return-cap.sh" > "$tmp/return.json"
  contains "$tmp/return.json" 'systemMessage'
  not_contains "$tmp/return.json" 'updatedToolOutput'

  jq -e '.hooks.PreToolUse[] | select(.matcher == "^Bash$") | .hooks[] | select(.command | contains("rtk hook claude"))' "$ROOT/hooks.json" >/dev/null || fail "RTK Bash hook missing"

  history="$tmp/orchestrator"
  mkdir -p "$history"
  for i in 100 200 300 400; do
    jq -cn --argjson input "$i" '{type:"turn.completed",usage:{input_tokens:$input,cached_input_tokens:0,output_tokens:10,reasoning_output_tokens:2}}' > "$tmp/run.jsonl"
    jq -cn '{model:"gpt-5.6-terra",effort:"medium",category:"implementation",success:true}' > "$tmp/meta.json"
    ORCH_DIR="$history" bash "$ROOT/orchestrating/usage-budget.sh" record "$tmp/run.jsonl" "$tmp/meta.json" >/dev/null
  done
  estimate=$(ORCH_DIR="$history" bash "$ROOT/orchestrating/usage-budget.sh" estimate gpt-5.6-terra medium implementation)
  [ "$(jq -r '.source' <<<"$estimate")" = estimate ] || fail "estimate source mislabeled"
  [ "$(jq -r '.p75_tokens' <<<"$estimate")" -eq 310 ] || fail "p75 estimate is not 310"

  jq -cn '{windows:[{duration_minutes:10080,used_percent:90,reset_at:"2026-07-21T00:00:00Z"}]}' > "$tmp/quota.json"
  quota=$(ORCH_DIR="$history" bash "$ROOT/orchestrating/usage-budget.sh" quota "$tmp/quota.json")
  [ "$(jq -r '.source' <<<"$quota")" = reported ] || fail "quota source mislabeled"
  [ "$(jq -r '.action' <<<"$quota")" = checkpoint ] || fail "90 percent quota did not checkpoint"
  contains "$history/usage.jsonl" '"source":"measured"'
  echo "Codex hook synthetic tests: PASS"
}

runtime() {
  local real_rtk shim marker stream command_seen
  command -v codex >/dev/null 2>&1 || fail "codex missing"
  real_rtk=$(command -v rtk) || fail "rtk missing"
  marker="$tmp/rtk.marker"
  stream="$tmp/codex.jsonl"
  mkdir -p "$tmp/bin"
  shim="$tmp/bin/rtk"
  cat > "$shim" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$RTK_SMOKE_MARKER"
exec "$RTK_REAL" "$@"
EOF
  chmod +x "$shim"
  RTK_REAL="$real_rtk" RTK_SMOKE_MARKER="$marker" PATH="$tmp/bin:$PATH" \
    codex exec --ephemeral --json --sandbox read-only --dangerously-bypass-hook-trust \
    --model gpt-5.6-terra -c 'model_reasoning_effort="medium"' -C "$REPO" \
    'Run exactly one shell command: git status --short. Do not modify files or use network. Then reply done.' \
    > "$stream"
  contains "$marker" 'hook claude'
  command_seen=$(jq -sr '[.[] | select(.type == "item.completed" and .item.type == "command_execution")]|length' "$stream")
  [ "$command_seen" -ge 1 ] || fail "Codex did not run shell command"
  if ! "$real_rtk" gain >/dev/null 2>&1; then
    echo "RTK tracking unavailable; runtime invocation passed, savings remain unmeasured." >&2
  fi
  echo "RTK runtime smoke: PASS ($real_rtk invoked by Codex Bash hook)"
}

case "${1:-}" in
  "") synthetic ;;
  --runtime) runtime ;;
  *) fail "usage: $0 [--runtime]" ;;
esac
