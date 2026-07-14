#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="$HOME/.codex"

warn() { echo "  WARNING: $*" >&2; }

# link_into <source> <target> <label>: idempotently point target at source.
# Existing files/directories are preserved once as .bak before linking.
link_into() {
  local source="$1" target="$2" label="$3"

  if [ -L "$target" ] && [ -e "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      echo "  $label: symlink already exists, skipping"
      return 0
    fi
    echo "  $label: symlink points elsewhere, re-linking"
    rm -f "$target"
  elif [ -L "$target" ]; then
    echo "  $label: broken symlink, re-linking"
    rm -f "$target"
  elif [ -e "$target" ]; then
    if [ -e "$target.bak" ] || [ -L "$target.bak" ]; then
      warn "$label: $target.bak already exists; leaving $target unchanged"
      return 1
    fi
    echo "  $label: backing up existing to $target.bak"
    mv "$target" "$target.bak"
  fi

  ln -s "$source" "$target"
  echo "  $label: symlinked"
}

echo "Setting up Codex dotfiles..."
mkdir -p "$CODEX_DIR"

for entry in AGENTS.md RTK.md PLUGINS.md hooks.json orchestrating cleaning hooks design-guidelines design-system-creator; do
  link_into "$DOTFILES_DIR/$entry" "$CODEX_DIR/$entry" "$entry"
done

# Documentation catalog: keep separate from Codex's live custom-agent folder.
link_into "$DOTFILES_DIR/agents" "$CODEX_DIR/agents-docs" "agents-docs"

# Codex discovers standalone custom agent TOML files in ~/.codex/agents/.
mkdir -p "$CODEX_DIR/agents"
for def in "$DOTFILES_DIR"/agent-defs/*.toml; do
  [ -e "$def" ] || continue
  name="$(basename "$def")"
  link_into "$def" "$CODEX_DIR/agents/$name" "agents/$name"
done

if ! command -v jq >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "Installing jq..."
    brew install jq || warn "jq install failed — hooks use a conservative fallback without it."
  else
    warn "jq is missing and Homebrew is unavailable — install jq for full hook parsing."
  fi
else
  echo "jq: already installed"
fi

if ! command -v rtk >/dev/null 2>&1; then
  warn "rtk is missing — install Rust Token Killer from https://github.com/rtk-ai/rtk to enable command rewriting."
else
  echo "rtk: already installed ($(rtk --version 2>/dev/null || true))"
fi

echo ""
echo "Codex runtime config.toml and plugin state were preserved."
echo "Review and trust the linked hooks with /hooks after restarting Codex."
echo "Run '$DOTFILES_DIR/verify.sh --installed' to verify the installation."
