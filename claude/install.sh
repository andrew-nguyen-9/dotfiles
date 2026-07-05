#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

warn() { echo "  WARNING: $*" >&2; }

echo "Setting up Claude Code dotfiles..."

mkdir -p "$CLAUDE_DIR"

# Symlink config files + the orchestrating/ + cleaning/ + hooks/ folders
for file in settings.json CLAUDE.md RTK.md orchestrating cleaning hooks; do
  target="$CLAUDE_DIR/$file"
  source="$DOTFILES_DIR/$file"
  if [ -L "$target" ] && [ -e "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      echo "  $file: symlink already exists, skipping"
    else
      echo "  $file: symlink points elsewhere, re-linking"
      rm -f "$target"
      ln -s "$source" "$target"
      echo "  $file: symlinked"
    fi
  elif [ -L "$target" ]; then
    echo "  $file: broken symlink, re-linking"
    rm -f "$target"
    ln -s "$source" "$target"
    echo "  $file: symlinked"
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
if [ -L "$target" ] && [ -e "$target" ]; then
  if [ "$(readlink "$target")" = "$source" ]; then
    echo "  agents-docs: symlink already exists, skipping"
  else
    echo "  agents-docs: symlink points elsewhere, re-linking"
    rm -f "$target"
    ln -s "$source" "$target"
    echo "  agents-docs: symlinked"
  fi
elif [ -L "$target" ]; then
  echo "  agents-docs: broken symlink, re-linking"
  rm -f "$target"
  ln -s "$source" "$target"
  echo "  agents-docs: symlinked"
elif [ -e "$target" ]; then
  echo "  agents-docs: backing up existing to $target.bak"
  mv "$target" "$target.bak"
  ln -s "$source" "$target"
  echo "  agents-docs: symlinked"
else
  ln -s "$source" "$target"
  echo "  agents-docs: symlinked"
fi

# Symlink real agent defs (unit-builder, integration-agent, blind-judge)
# into ~/.claude/agents/ — the LIVE agent-definition dir (file-level links;
# the dir itself may hold the user's other agents).
mkdir -p "$CLAUDE_DIR/agents"
for def in "$DOTFILES_DIR"/agent-defs/*.md; do
  [ -e "$def" ] || continue  # empty dir: glob stays literal — don't link '*.md'
  name="$(basename "$def")"
  target="$CLAUDE_DIR/agents/$name"
  if [ -L "$target" ] && [ -e "$target" ]; then
    if [ "$(readlink "$target")" = "$def" ]; then
      echo "  agents/$name: symlink already exists, skipping"
    else
      echo "  agents/$name: symlink points elsewhere, re-linking"
      rm -f "$target"
      ln -s "$def" "$target"
      echo "  agents/$name: symlinked"
    fi
  elif [ -L "$target" ]; then
    echo "  agents/$name: broken symlink, re-linking"
    rm -f "$target"
    ln -s "$def" "$target"
    echo "  agents/$name: symlinked"
  elif [ -e "$target" ]; then
    echo "  agents/$name: exists (not a symlink), backing up to $target.bak"
    mv "$target" "$target.bak"
    ln -s "$def" "$target"
    echo "  agents/$name: symlinked"
  else
    ln -s "$def" "$target"
    echo "  agents/$name: symlinked"
  fi
done

# Network installs below must not abort the whole script under `set -e`:
# each is wrapped so a failure warns and the next step still runs.

# Install bun (required by gstack)
if ! command -v bun &>/dev/null; then
  echo "Installing bun..."
  if curl -fsSL https://bun.sh/install | bash; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
  else
    warn "bun install failed — install manually (https://bun.sh), then re-run."
  fi
else
  echo "bun: already installed ($(bun --version))"
fi

# Install jq — EVERY enforcement hook gates on `command -v jq || exit 0`;
# without it the whole hook layer is silently dead (stock macOS ships none).
if ! command -v jq &>/dev/null; then
  echo "Installing jq..."
  if command -v brew &>/dev/null; then
    brew install jq || warn "jq install failed — install jq manually or ALL claude hooks are inert."
  else
    warn "no brew and no jq — install jq manually or ALL claude hooks are inert."
  fi
else
  echo "jq: already installed"
fi

# Install rtk (Rust Token Killer) — drives the Bash hook in settings.json
# Source: https://github.com/rtk-ai/rtk
if ! command -v rtk &>/dev/null; then
  echo "Installing rtk..."
  # Upstream token-killer installer — also the brew fallback when the name
  # collides with the "Rust Type Kit" formula.
  rtk_upstream() {
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh \
      || warn "rtk install failed — install manually (https://github.com/rtk-ai/rtk)."
  }
  if command -v brew &>/dev/null; then
    brew install rtk 2>/dev/null || true
    # `brew install rtk` may pull the unrelated "Rust Type Kit" — verify the
    # binary is the token-killer (its help/gain mentions token or proxy);
    # wrong or missing → fall back to the upstream installer.
    if rtk --help 2>&1 | grep -qiE 'token|proxy' || rtk gain 2>&1 | grep -qiE 'token|proxy'; then
      echo "rtk: installed via brew"
    else
      warn "brew rtk missing or wrong formula (name collides with Rust Type Kit) — using upstream installer."
      rtk_upstream
    fi
  else
    rtk_upstream
  fi
else
  echo "rtk: already installed ($(rtk --version 2>/dev/null))"
fi

# Install ccusage — orchestrator Session C reads budget via `ccusage blocks -j`
if ! command -v ccusage &>/dev/null; then
  echo "Installing ccusage..."
  if command -v bun &>/dev/null; then
    bun add -g ccusage || warn "ccusage install failed — run 'bun add -g ccusage' manually."
  else
    warn "bun unavailable — run 'bun add -g ccusage' manually once bun is installed."
  fi
else
  echo "ccusage: already installed"
fi

# Clone gstack skill
GSTACK_DIR="$CLAUDE_DIR/skills/gstack"
if [ -d "$GSTACK_DIR" ]; then
  echo "gstack: already installed, skipping"
else
  echo "Installing gstack skill..."
  mkdir -p "$CLAUDE_DIR/skills"
  if git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$GSTACK_DIR"; then
    (cd "$GSTACK_DIR" && ./setup) || warn "gstack setup failed — run '$GSTACK_DIR/setup' manually."
    echo "gstack: installed"
  else
    warn "gstack clone failed — clone https://github.com/garrytan/gstack.git to $GSTACK_DIR manually."
  fi
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
