#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$ROOT/.." && pwd)"
CHECK_INSTALLED=false
[ "${1:-}" = "--installed" ] && CHECK_INSTALLED=true

fail() { echo "FAIL: $*" >&2; exit 1; }

required=(
  AGENTS.md RTK.md PLUGINS.md hooks.json install.sh configure.sh configure.test.sh notify.sh
  orchestrating cleaning hooks design-guidelines design-system-creator
  agents agent-defs skills/mcq
)

for entry in "${required[@]}"; do
  [ -e "$ROOT/$entry" ] || fail "missing codex/$entry"
done

for script in "$ROOT/install.sh" "$ROOT/verify.sh" "$ROOT/configure.sh" "$ROOT/configure.test.sh" "$ROOT/notify.sh" "$ROOT"/hooks/*.sh "$ROOT"/hooks/lib/*.sh "$ROOT"/design-guidelines/validate.sh "$ROOT"/design-system-creator/validate.sh; do
  bash -n "$script" || fail "shell syntax: $script"
done

jq -e . "$ROOT/hooks.json" >/dev/null || fail "invalid hooks.json"
bash "$ROOT/hooks/test.sh"
bash "$ROOT/configure.test.sh"
rg -q '^permission_matrix\(\)' "$ROOT/hooks/test.sh" || fail "missing named permission matrix"
test -s "$ROOT/skills/mcq/SKILL.md" || fail "missing mcq skill"
rg -q 'request_user_input' "$ROOT/skills/mcq/SKILL.md" || fail "mcq skill missing structured input"
rg -q 'recommended.*first' "$ROOT/skills/mcq/SKILL.md" || fail "mcq skill missing recommended-first rule"

if rg -n '/Users/[[:alnum:]_.-]+/|/home/[[:alnum:]_.-]+/' "$ROOT" --glob '*.md' --glob '*.json' --glob '*.sh' --glob '*.toml' >/tmp/codex-portable-paths.$$; then
  cat /tmp/codex-portable-paths.$$
  rm -f /tmp/codex-portable-paths.$$
  fail "hardcoded home path found"
fi
rm -f /tmp/codex-portable-paths.$$

rg -q 'Never add AI or assistant attribution' "$ROOT/AGENTS.md" || fail "missing git attribution policy"
rg -q 'Write commits and PRs as if authored directly by the user' "$ROOT/AGENTS.md" || fail "missing user-authorship rule"
rg -q 'DoD: test `bash codex/verify.sh`' "$REPO_ROOT/AGENTS.md" || fail "root AGENTS.md does not use the Codex verification gate"
rg -q 'Must-not-touch: codex/AGENTS.md, codex/RTK.md' "$REPO_ROOT/AGENTS.md" || fail "root AGENTS.md does not point at the Codex global sources"

for tier in README.md lite.md medium.md orchestrator.md; do
  rg -qi 'Caveman ultra' "$ROOT/orchestrating/$tier" || fail "$tier missing Caveman ultra"
  rg -qi 'Ponytail ultra' "$ROOT/orchestrating/$tier" || fail "$tier missing Ponytail ultra"
done

for session in orchestrator.md session-b.md session-c.md session-d.md; do
  rg -q '^## Cleared-chat kickoff$' "$ROOT/orchestrating/$session" || fail "$session missing cleared-chat kickoff"
done

migration_invariant='Stateful config migrations require representative existing-state fixtures and authoritative-consumer validation.'
for session in orchestrator.md session-b.md session-c.md session-d.md; do
  rg -Fq "$migration_invariant" "$ROOT/orchestrating/$session" || fail "$session missing stateful config migration invariant"
done

for def in "$ROOT"/agent-defs/*.toml; do
  rg -q '^model = "gpt-5.6-terra"$' "$def" || fail "$(basename "$def") is not Terra"
  rg -q '^model_reasoning_effort = "medium"$' "$def" || fail "$(basename "$def") is not medium effort"
  rg -qi 'Caveman ultra' "$def" || fail "$(basename "$def") missing Caveman ultra"
  rg -qi 'Ponytail ultra' "$def" || fail "$(basename "$def") missing Ponytail ultra"
done
! rg -q 'gpt-5.6-sol' "$ROOT/agent-defs" || fail "Sol must not be a normal agent default"

git_ident="$(git -C "$REPO_ROOT" var GIT_AUTHOR_IDENT 2>/dev/null || true)"
if printf '%s' "$git_ident" | grep -qiE 'codex|chatgpt|openai|claude|anthropic|assistant'; then
  fail "git author identity contains an AI product, vendor, or assistant name"
fi

bash "$ROOT/design-guidelines/validate.sh"
bash "$ROOT/design-system-creator/validate.sh"

if $CHECK_INSTALLED; then
  expected=(AGENTS.md RTK.md PLUGINS.md hooks.json orchestrating cleaning hooks design-guidelines design-system-creator notify.sh)
  for entry in "${expected[@]}"; do
    [ -L "$HOME/.codex/$entry" ] || fail "$HOME/.codex/$entry is not a symlink"
    [ "$(readlink "$HOME/.codex/$entry")" = "$ROOT/$entry" ] || fail "$HOME/.codex/$entry points elsewhere"
  done

  [ ! -L "$HOME/.codex/skills" ] || fail "$HOME/.codex/skills must remain a real user directory"
  [ -L "$HOME/.codex/skills/mcq" ] || fail "$HOME/.codex/skills/mcq is not a symlink"
  [ "$(readlink "$HOME/.codex/skills/mcq")" = "$ROOT/skills/mcq" ] || fail "$HOME/.codex/skills/mcq points elsewhere"

  config="$HOME/.codex/config.toml"
  [ -f "$config" ] || fail "$config is missing"
  codex mcp list --json >/dev/null 2>&1 || fail "installed config is not accepted by Codex"
  grep -Fq 'sandbox_mode = "workspace-write"' "$config" || fail "installed config missing workspace-write default"
  grep -Fq 'approval_policy = "on-request"' "$config" || fail "installed config missing on-request default"
  grep -Fq 'approvals_reviewer = "auto_review"' "$config" || fail "installed config missing auto-review default"
  grep -Fq 'notifications = ["agent-turn-complete", "approval-requested"]' "$config" || fail "installed config missing TUI notifications"
  grep -Fq "notify = [\"$HOME/.codex/notify.sh\"]" "$config" || fail "installed config missing notifier"
  if grep -q '^\[mcp_servers\.serena\]' "$config"; then
    serena=$(codex mcp get serena --json 2>/dev/null | jq -c '{type:.transport.type,args:(.transport.args // [])}') || fail "installed Serena config is not accepted"
    if [ "$(jq -r '.type' <<<"$serena")" = stdio ]; then
      jq -e '.args as $a | ([ $a[] | select(. == "--enable-web-dashboard") ] | length) == 1 and any(range(0; $a | length); $a[.] == "--enable-web-dashboard" and $a[. + 1] == "false")' <<<"$serena" >/dev/null || fail "installed Serena enable-dashboard flag is not false"
      jq -e '.args as $a | ([ $a[] | select(. == "--open-web-dashboard") ] | length) == 1 and any(range(0; $a | length); $a[.] == "--open-web-dashboard" and $a[. + 1] == "false")' <<<"$serena" >/dev/null || fail "installed Serena open-dashboard flag is not false"
    fi
  fi
  before=$(shasum -a 256 "$config" | awk '{print $1}')
  bash "$ROOT/configure.sh" >/dev/null
  after=$(shasum -a 256 "$config" | awk '{print $1}')
  [ "$before" = "$after" ] || fail "installed config is not byte-stable"

  [ -L "$HOME/.codex/agents-docs" ] || fail "$HOME/.codex/agents-docs is not a symlink"
  [ "$(readlink "$HOME/.codex/agents-docs")" = "$ROOT/agents" ] || fail "$HOME/.codex/agents-docs points elsewhere"

  for def in "$ROOT"/agent-defs/*.toml; do
    name="$(basename "$def")"
    [ -L "$HOME/.codex/agents/$name" ] || fail "$HOME/.codex/agents/$name is not a symlink"
    [ "$(readlink "$HOME/.codex/agents/$name")" = "$def" ] || fail "$HOME/.codex/agents/$name points elsewhere"
  done
fi

echo "Codex verification: PASS"
