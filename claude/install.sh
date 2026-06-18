#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code dotfiles..."

mkdir -p "$CLAUDE_DIR"

# Symlink config files
for file in settings.json CLAUDE.md RTK.md; do
  target="$CLAUDE_DIR/$file"
  source="$DOTFILES_DIR/$file"
  if [ -L "$target" ]; then
    echo "  $file: symlink already exists, skipping"
  elif [ -f "$target" ]; then
    echo "  $file: backing up existing file to $target.bak"
    mv "$target" "$target.bak"
    ln -s "$source" "$target"
    echo "  $file: symlinked"
  else
    ln -s "$source" "$target"
    echo "  $file: symlinked"
  fi
done

# Install bun (required by gstack)
if ! command -v bun &>/dev/null; then
  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "bun: already installed ($(bun --version))"
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

# Install plugins via npx claude-plugins
echo ""
echo "Installing plugins..."
echo "  (Run these in Claude Code if npx approach fails)"
echo ""

PLUGINS=(
  "typescript-lsp@claude-plugins-official"
  "playwright@claude-plugins-official"
  "code-review@claude-plugins-official"
  "security-guidance@claude-plugins-official"
  "pr-review-toolkit@claude-plugins-official"
  "commit-commands@claude-plugins-official"
  "code-simplifier@claude-plugins-official"
  "context7@claude-plugins-official"
  "claude-md-management@claude-plugins-official"
  "explanatory-output-style@claude-plugins-official"
  "learning-output-style@claude-plugins-official"
  "frontend-design@claude-plugins-official"
  "claude-code-setup@claude-plugins-official"
  "feature-dev@claude-plugins-official"
)

for plugin in "${PLUGINS[@]}"; do
  npx claude-plugins install "$plugin" && echo "  $plugin: installed" || echo "  $plugin: FAILED (install manually with /plugin install $plugin)"
done

# Custom marketplace plugins (need marketplace add first)
echo ""
echo "Custom marketplace plugins require manual setup in Claude Code:"
echo "  /plugin marketplace add EveryInc/compound-engineering-plugin"
echo "  /plugin install compound-engineering@compound-engineering-plugin"
echo "  /plugin marketplace add snarktank/ralph"
echo "  /plugin install ralph-skills@ralph-marketplace"
echo ""
echo "Done! Run /reload-plugins in Claude Code to apply."
