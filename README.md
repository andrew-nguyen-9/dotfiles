# dotfiles

Personal machine config. Clone, run the installer, done.

```sh
git clone https://github.com/andrew-nguyen-9/dotfiles.git
cd dotfiles/claude && ./install.sh
```

## Layout

| Path | What |
|------|------|
| `claude/` | Claude Code config: `settings.json`, `CLAUDE.md`, `RTK.md`, `install.sh` |
| `claude/orchestrating/` | Multi-agent orchestration system — wishlist router + lite/medium/big strategies (see its `README.md`) |
| `claude/cleaning/` | Post-cycle repo reset + docs refresh system (see its `README.md`) |
| `claude/agents/` | Agents catalog — cross-repo subagent docs, symlinked to `~/.claude/agents-docs/` (see its `README.md`) |
| `claude/agent-defs/` | Live agent definitions (unit-builder, integration-agent, blind-judge), symlinked into `~/.claude/agents/` |
| `claude/hooks/` | Enforcement hooks (budget guard, return cap, read cap, secrets guard), symlinked to `~/.claude/hooks/` |
| `claude/PLUGINS.md` | Plugin policy: core set global, stack plugins per-project |
| `hammerspoon/` | Hammerspoon Lua config (incl. OCR-paste) |
| `karabiner/` | Karabiner-Elements key remaps |
| `docs/requirements.md` | Full fresh-macOS setup checklist (apps, tools, backups) |

`install.sh` symlinks the `claude/` config into `~/.claude/` (including `claude/agents/` → `~/.claude/agents-docs/`, `claude/hooks/` → `~/.claude/hooks/`, `claude/agent-defs/*` → `~/.claude/agents/`) and installs `rtk` + `bun` + `ccusage` + the gstack skill. Plugins are declared in `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`): the core set is enabled globally; stack plugins are per-project — see `claude/PLUGINS.md`. Paths use `$HOME` throughout — portable across machines and usernames.
