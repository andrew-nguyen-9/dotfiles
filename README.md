# dotfiles

Personal machine config. Clone, run the installer, done.

```sh
git clone https://github.com/andrew-nguyen-9/dotfiles.git
cd dotfiles
./claude/install.sh
./codex/install.sh
```

## Layout

| Path | What |
|------|------|
| `claude/` | Claude Code config: `settings.json`, `CLAUDE.md`, `RTK.md`, `install.sh` |
| `codex/` | Codex config: `AGENTS.md`, hooks, custom agents, workflow docs, `install.sh`, `verify.sh` |
| `claude/orchestrating/` | Multi-agent orchestration system — wishlist router + lite/medium/big strategies (see its `README.md`) |
| `codex/orchestrating/` | Codex-native mirror of the orchestration system, symlinked to `~/.codex/orchestrating/` |
| `codex/cleaning/` | Codex-native post-cycle reset and docs-refresh system |
| `codex/design-system-creator/` | Codex-native design North Star workflow |
| `codex/design-guidelines/` | Portable validated design corpus used by Codex workflows |
| `codex/agents/` | Codex agent catalog, symlinked to `~/.codex/agents-docs/` |
| `codex/agent-defs/` | Live Codex custom-agent TOML definitions, linked into `~/.codex/agents/` |
| `codex/hooks/` | Portable lifecycle hook scripts paired with `codex/hooks.json` |
| `claude/cleaning/` | Post-cycle repo reset + docs refresh system (see its `README.md`) |
| `claude/design-system-creator/` | Builds a repo's design North Star — `design/` folder: tokens, UI kit, voice, patterns (see its `README.md`) |
| `claude/design-guidelines/` | Generic design corpus — validated guideline docs, JIT-routed via its `INDEX.md` |
| `claude/agents/` | Agents catalog — cross-repo subagent docs, symlinked to `~/.claude/agents-docs/` (see its `README.md`) |
| `claude/agent-defs/` | Live agent definitions (unit-builder, integration-agent, blind-judge), symlinked into `~/.claude/agents/` |
| `claude/hooks/` | Enforcement hooks (budget guard, return cap, read cap, secrets guard), symlinked to `~/.claude/hooks/` |
| `claude/PLUGINS.md` | Plugin policy: core set global, stack plugins per-project |
| `hammerspoon/` | Hammerspoon Lua config (incl. OCR-paste) |
| `karabiner/` | Karabiner-Elements key remaps |
| `docs/requirements.md` | Full fresh-macOS setup checklist (apps, tools, backups) |

`install.sh` symlinks the `claude/` config into `~/.claude/` (including `claude/agents/` → `~/.claude/agents-docs/`, `claude/hooks/` → `~/.claude/hooks/`, `claude/agent-defs/*` → `~/.claude/agents/`) and installs `jq` + `rtk` + `bun` + `ccusage` + the gstack skill. Plugins are declared in `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`): the core set is enabled globally; stack plugins are per-project — see `claude/PLUGINS.md`. Paths use `$HOME` throughout — portable across machines and usernames.

`codex/install.sh` follows the same layout: it symlinks global instructions, hooks, orchestration/cleaning/design folders, the agent catalog, Codex-native TOML agent definitions, the notifier, and only the managed `mcq` skill into `~/.codex/`. It merges safe CLI defaults into machine-local `config.toml` while preserving unrelated settings, authentication, MCP values, plugin state, caches, and bundled-runtime paths. Existing managed paths are backed up once to `.bak` before linking. Verify the repository with `bash codex/verify.sh`; after installation, use `bash codex/verify.sh --installed`.

Codex CLI/TUI alerts use native `agent-turn-complete` and `approval-requested` notifications; the macOS notifier is a turn-complete fallback because external `notify` currently receives only that event. The desktop app has separate notification controls and a one-time macOS permission prompt. IDE/VS Code surfaces do not inherit TUI alert behavior, so no cross-surface notification parity is claimed.

**`claude/settings.json` carries git skip-worktree** (Claude Code runtime-writes it; keeps the tree quiet). To commit a deliberate settings change: `git update-index --no-skip-worktree claude/settings.json` → commit → `git update-index --skip-worktree claude/settings.json`.

**Skills note:** gstack's 56 per-skill wrappers live parked in `~/.claude/skills-parked/` (each is one `SKILL.md` symlink into the `~/.claude/skills/gstack/` clone) — auto-loading all of them costs ~15–25k tokens of skill descriptions in every session. Restore any one with `mv ~/.claude/skills-parked/<name> ~/.claude/skills/`; restore all with gstack's `./setup`.
