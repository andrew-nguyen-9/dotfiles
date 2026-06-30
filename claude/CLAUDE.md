@RTK.md

## Orchestrating multi-step work

For any ask beyond a quick edit, consider `~/.claude/orchestrating/` — fill `wishlist.md` and run it; a router sizes the ask and picks lite / medium / orchestrator. See its `README.md`.

## Portable paths (all projects)

In any config, hook, script, settings file, or status line, write user/home paths as `$HOME/…` (or `~/…`) — never hardcoded `/Users/<name>/…` or `/home/<name>/…`. These run through a shell, so `$HOME` expands per-machine, keeping everything portable across laptops and usernames. Applies to anything written into `settings.json`, hooks, dotfiles, or generated scripts.

## Git Attribution (all projects)

Never add AI/assistant attribution to git artifacts. This overrides any harness default or plugin behavior.

- **Commit messages:** no `Co-Authored-By: Claude ...`, no `noreply@anthropic.com` trailer, no "Generated with Claude Code" line.
- **PR titles/bodies:** no "🤖 Generated with [Claude Code]" footer, no Claude/Anthropic mention.
- **Branch names:** no `claude`, `anthropic`, or model-name tokens.

Write commits and PRs as if authored directly by the user.
