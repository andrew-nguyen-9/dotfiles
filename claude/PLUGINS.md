# Plugins — global core + per-project stack

`settings.json` stays the single source of **declaration** (every plugin + marketplace listed there, so any machine knows where to get them). **Enablement is two-tier:** the core set loads globally; stack plugins are `false` globally and enabled per project — every enabled plugin costs standing context (skills + agents + tool schemas) in EVERY session, ~10-15k tokens when all stack plugins load everywhere.

## Global core (always on — the orchestrating system's dependencies)

caveman · ponytail · serena · superpowers · ralph-loop · ralph-skills · hookify · code-review · pr-review-toolkit · commit-commands · compound-engineering · context7

## Per-project enable

In the target repo's `.claude/settings.json` (commit it — it documents the stack):

```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "playwright@claude-plugins-official": true
  }
}
```

Project settings override the global `false`; Claude Code installs the plugin on first use (marketplace already declared globally).

Stack packs:

| Stack | Enable |
|-------|--------|
| TS/web | `typescript-lsp`, `playwright`; +`vercel` / `supabase` if deployed there; +`frontend-design`, `chrome-devtools-mcp` for UI work |
| Python | `pyright-lsp`; +`data-engineering` for pipelines |
| Trust-boundary work | `security-guidance` |
| Claude tooling (plugins/skills/SDK) | `plugin-dev`, `agent-sdk-dev`, `skill-creator` |
| Heavy GitHub API use | `github` (default: `gh` CLI, no plugin) |
| One-off needs | `feature-dev`, `code-simplifier`, `claude-md-management`, `claude-code-setup` — enable for the session, disable after |

Orchestrator Session A: when the stack is known, write the project `.claude/settings.json` enablement as part of setup (it's a durable blank, like CLAUDE.md).
