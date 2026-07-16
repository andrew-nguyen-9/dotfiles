#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
contains() { grep -Fq "$2" "$1" || fail "$1 missing: $2"; }
not_contains() { ! grep -Fq "$2" "$1" || fail "$1 unexpectedly contains: $2"; }

apply_config() {
  HOME="$1" CODEX_HOME="$1/.codex" bash "$ROOT/configure.sh"
}

synthetic() {
  local home="$tmp/home" config before after output
  mkdir -p "$home/.codex"
  config="$home/.codex/config.toml"
  cat > "$config" <<'EOF'
model_reasoning_effort = "medium"

[features]
multi_agent = true

[mcp_servers.context7]
command = "context7"
args = ["--safe-test-value"]

[tui]
animations = false
notifications = false

[mcp_servers.serena]
command = "uvx"
args = [
  "--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server",
  "--enable-web-dashboard", "true", "--open-web-dashboard", "true",
  "--project", "keep-me",
]
env = { SAFE_TEST_VALUE = "preserved" }
EOF

  apply_config "$home"
  contains "$config" 'sandbox_mode = "workspace-write"'
  contains "$config" 'approval_policy = "on-request"'
  contains "$config" 'approvals_reviewer = "auto_review"'
  contains "$config" 'notifications = ["agent-turn-complete", "approval-requested"]'
  contains "$config" '"--enable-web-dashboard", "false", "--open-web-dashboard", "false"'
  contains "$config" '"--project", "keep-me"'
  contains "$config" 'SAFE_TEST_VALUE = "preserved"'
  contains "$config" "notify = [\"$home/.codex/notify.sh\"]"
  [ "$(grep -o -- '--enable-web-dashboard' "$config" | wc -l | tr -d ' ')" -eq 1 ] || fail "Serena enable flag duplicated"
  [ "$(grep -o -- '--open-web-dashboard' "$config" | wc -l | tr -d ' ')" -eq 1 ] || fail "Serena open flag duplicated"

  before=$(shasum -a 256 "$config" | awk '{print $1}')
  apply_config "$home"
  after=$(shasum -a 256 "$config" | awk '{print $1}')
  [ "$before" = "$after" ] || fail "second config merge changed bytes"

  HOME="$home" CODEX_HOME="$home/.codex" codex mcp get serena --json > "$tmp/serena.json"
  [ "$(jq -r '.transport.command' "$tmp/serena.json")" = uvx ] || fail "Codex rejected Serena config"
  [ "$(jq -r '.transport.args | map(select(. == "--enable-web-dashboard")) | length' "$tmp/serena.json")" -eq 1 ] || fail "Codex did not parse Serena flags"

  home="$tmp/no-serena"
  mkdir -p "$home/.codex"
  printf '%s\n' 'model = "gpt-5.6"' > "$home/.codex/config.toml"
  apply_config "$home"
  not_contains "$home/.codex/config.toml" 'mcp_servers.serena'

  output=$(CODEX_NOTIFY_DRY_RUN=1 bash "$ROOT/notify.sh" '{"type":"agent-turn-complete","last-assistant-message":"Ready","cwd":"/tmp/project"}')
  [ "$output" = $'Codex\nReady' ] || fail "notifier dry run did not parse turn completion"
  output=$(CODEX_NOTIFY_DRY_RUN=1 bash "$ROOT/notify.sh" '{"type":"approval-requested"}')
  [ -z "$output" ] || fail "external notifier handled unsupported event"
  output=$(CODEX_NOTIFY_DRY_RUN=1 bash "$ROOT/notify.sh" 'not-json')
  [ -z "$output" ] || fail "external notifier emitted on malformed input"

  echo "Codex config synthetic tests: PASS (7 cases; second-run identity PASS)"
}

runtime() {
  local home="$tmp/runtime-home" config command
  command -v codex >/dev/null 2>&1 || fail "codex missing"
  command -v uvx >/dev/null 2>&1 || { echo "Serena runtime smoke: SKIP (uvx missing)"; return; }
  mkdir -p "$home/.codex"
  config="$home/.codex/config.toml"
  cat > "$config" <<'EOF'
[mcp_servers.serena]
command = "uvx"
args = ["--offline", "--from", "git+https://github.com/oraios/serena", "serena", "start-mcp-server"]
EOF
  apply_config "$home"
  HOME="$home" CODEX_HOME="$home/.codex" codex mcp get serena --json > "$tmp/runtime-serena.json"
  command=$(jq -r '[.transport.command] + .transport.args | @sh' "$tmp/runtime-serena.json")
  python3 - "$tmp/runtime-serena.json" "$tmp/serena.stderr" <<'PY'
import json, subprocess, sys
config = json.load(open(sys.argv[1]))["transport"]
with open(sys.argv[2], "wb") as err:
    proc = subprocess.run([config["command"], *config["args"]], input=b"", stdout=subprocess.DEVNULL, stderr=err, timeout=30)
if proc.returncode not in (0, 1):
    sys.stderr.write(open(sys.argv[2], errors="replace").read())
    raise SystemExit(proc.returncode)
PY
  not_contains "$tmp/serena.stderr" 'dashboard is enabled'
  not_contains "$tmp/serena.stderr" 'web browser'
  echo "Serena runtime smoke: PASS (Codex accepted config; headless stdio exited on EOF: $command)"
}

case "${1:-}" in
  "") synthetic ;;
  --runtime) runtime ;;
  *) fail "usage: $0 [--runtime]" ;;
esac
