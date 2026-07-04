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

`install.sh` symlinks the `claude/` config into `~/.claude/` (including `claude/agents/` → `~/.claude/agents-docs/`, `claude/hooks/` → `~/.claude/hooks/`, `claude/agent-defs/*` → `~/.claude/agents/`) and installs `jq` + `rtk` + `bun` + `ccusage` + the gstack skill. Plugins are declared in `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`): the core set is enabled globally; stack plugins are per-project — see `claude/PLUGINS.md`. Paths use `$HOME` throughout — portable across machines and usernames.

**`claude/settings.json` carries git skip-worktree** (Claude Code runtime-writes it; keeps the tree quiet). To commit a deliberate settings change: `git update-index --no-skip-worktree claude/settings.json` → commit → `git update-index --skip-worktree claude/settings.json`.

**Skills note:** gstack's 56 per-skill wrappers live parked in `~/.claude/skills-parked/` (each is one `SKILL.md` symlink into the `~/.claude/skills/gstack/` clone) — auto-loading all of them costs ~15–25k tokens of skill descriptions in every session. Restore any one with `mv ~/.claude/skills-parked/<name> ~/.claude/skills/`; restore all with gstack's `./setup`.
