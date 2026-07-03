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
| `hammerspoon/` | Hammerspoon Lua config (incl. OCR-paste) |
| `karabiner/` | Karabiner-Elements key remaps |
| `docs/requirements.md` | Full fresh-macOS setup checklist (apps, tools, backups) |

`install.sh` symlinks the `claude/` config into `~/.claude/`, installs `rtk` + `bun` + the gstack skill, and installs Claude Code plugins. Paths use `$HOME` throughout — portable across machines and usernames.
