#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code dotfiles..."

mkdir -p "$CLAUDE_DIR"

# Symlink config files + the orchestrating/ + cleaning/ folders
for file in settings.json CLAUDE.md RTK.md orchestrating cleaning; do
  target="$CLAUDE_DIR/$file"
  source="$DOTFILES_DIR/$file"
  if [ -L "$target" ]; then
    echo "  $file: symlink already exists, skipping"
  elif [ -e "$target" ]; then
    echo "  $file: backing up existing to $target.bak"
    mv "$target" "$target.bak"
    ln -s "$source" "$target"
    echo "  $file: symlinked"
  else
    ln -s "$source" "$target"
    echo "  $file: symlinked"
  fi
done

# Symlink the agents catalog to a NON-colliding name:
# ~/.claude/agents/ is Claude Code's live agent-definition dir; these are docs.
target="$CLAUDE_DIR/agents-docs"
source="$DOTFILES_DIR/agents"
if [ -L "$target" ]; then
  echo "  agents-docs: symlink already exists, skipping"
elif [ -e "$target" ]; then
  echo "  agents-docs: backing up existing to $target.bak"
  mv "$target" "$target.bak"
  ln -s "$source" "$target"
  echo "  agents-docs: symlinked"
else
  ln -s "$source" "$target"
  echo "  agents-docs: symlinked"
fi

# Install bun (required by gstack)
if ! command -v bun &>/dev/null; then
  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "bun: already installed ($(bun --version))"
fi

# Install rtk (Rust Token Killer) — drives the Bash hook in settings.json
# Source: https://github.com/rtk-ai/rtk
if ! command -v rtk &>/dev/null; then
  echo "Installing rtk..."
  if command -v brew &>/dev/null; then
    brew install rtk
  else
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  fi
else
  echo "rtk: already installed ($(rtk --version 2>/dev/null))"
fi

# Clone gstack skill
GSTACK_DIR="$CLAUDE_DIR/skills/gstack"
if [ -d "$GSTACK_DIR" ]; then
  echo "gstack: already installed, skipping"
else
  echo "Installing gstack skill..."
  mkdir -p "$CLAUDE_DIR/skills"
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$GSTACK_DIR"
  cd "$GSTACK_DIR" && ./setup
  echo "gstack: installed"
fi

# Plugins: settings.json (symlinked above) is the single source of truth.
# enabledPlugins declares every plugin; extraKnownMarketplaces declares the
# custom marketplaces (compound-engineering, ralph, caveman, ponytail).
# Claude Code reads both on startup and installs what's missing.
echo ""
echo "Plugins are declared in settings.json (enabledPlugins + extraKnownMarketplaces)."
echo "Claude Code installs them on first startup."
echo "If any plugin is missing later: /plugin install <name>@<marketplace> in Claude Code."
echo ""
echo "Done! Start Claude Code to finish plugin installation."
