#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$ROOT/.." && pwd)"
CHECK_INSTALLED=false
[ "${1:-}" = "--installed" ] && CHECK_INSTALLED=true

fail() { echo "FAIL: $*" >&2; exit 1; }

required=(
  AGENTS.md RTK.md PLUGINS.md hooks.json install.sh
  orchestrating cleaning hooks design-guidelines design-system-creator
  agents agent-defs
)

for entry in "${required[@]}"; do
  [ -e "$ROOT/$entry" ] || fail "missing codex/$entry"
done

for script in "$ROOT/install.sh" "$ROOT/verify.sh" "$ROOT"/hooks/*.sh "$ROOT"/hooks/lib/*.sh "$ROOT"/design-guidelines/validate.sh "$ROOT"/design-system-creator/validate.sh; do
  bash -n "$script" || fail "shell syntax: $script"
done

jq -e . "$ROOT/hooks.json" >/dev/null || fail "invalid hooks.json"
bash "$ROOT/hooks/test.sh"

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
  expected=(AGENTS.md RTK.md PLUGINS.md hooks.json orchestrating cleaning hooks design-guidelines design-system-creator)
  for entry in "${expected[@]}"; do
    [ -L "$HOME/.codex/$entry" ] || fail "$HOME/.codex/$entry is not a symlink"
    [ "$(readlink "$HOME/.codex/$entry")" = "$ROOT/$entry" ] || fail "$HOME/.codex/$entry points elsewhere"
  done

  [ -L "$HOME/.codex/agents-docs" ] || fail "$HOME/.codex/agents-docs is not a symlink"
  [ "$(readlink "$HOME/.codex/agents-docs")" = "$ROOT/agents" ] || fail "$HOME/.codex/agents-docs points elsewhere"

  for def in "$ROOT"/agent-defs/*.toml; do
    name="$(basename "$def")"
    [ -L "$HOME/.codex/agents/$name" ] || fail "$HOME/.codex/agents/$name is not a symlink"
    [ "$(readlink "$HOME/.codex/agents/$name")" = "$def" ] || fail "$HOME/.codex/agents/$name points elsewhere"
  done
fi

echo "Codex verification: PASS"
