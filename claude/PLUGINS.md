# Plugins — global core + per-project stack

`settings.json` stays the single source of **declaration** (every plugin + marketplace listed there, so any machine knows where to get them). **Enablement is two-tier:** the core set loads globally; stack plugins are `false` globally and enabled per project — every enabled plugin costs standing context (skills + agents + tool schemas) in EVERY session, ~10-15k tokens when all stack plugins load everywhere.

## Global core (always on — the orchestrating system's dependencies)

caveman · ponytail · serena · superpowers · hookify · code-review · commit-commands · context7

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
| TS/web | `typescript-lsp`, `playwright`; +`vercel` / `supabase` if deployed there; +`frontend-design` for UI work; `chrome-devtools-mcp` UNINSTALLED (playwright covers it) |
| Python | `pyright-lsp`; +`data-engineering` for pipelines (UNINSTALLED — reinstall when needed) |
| Trust-boundary work | `security-guidance` |
| Claude tooling (plugins/skills/SDK) | `plugin-dev`, `agent-sdk-dev`, `skill-creator` |
| Heavy GitHub API use | `github` (default: `gh` CLI, no plugin) |
| Compound-eng / PR-review / Ralph work | `compound-engineering`, `pr-review-toolkit`, `ralph-loop`, `ralph-skills` — enable in repos that lean on ce-* personas, the PR-review bundle, or the Ralph wave driver |
| One-off needs | `feature-dev`, `code-simplifier`, `claude-md-management`, `claude-code-setup` — enable for the session, disable after |

**Why these four are per-project, not core:** every enabled plugin's agent + skill descriptions load into EVERY session, including each subagent dispatch. These four are the heaviest (~6–9k tokens/dispatch) and are dispatch-time tools you reach for in specific repos, not every-session dependencies — so they earn their keep only where actually used. `ralph-loop`+`ralph-skills` are also the orchestrator big-tier wave driver (with `superpowers`): enable them in big-tier repos, or use `session-b.md`'s documented manual fallback (hand-written `prd.json` + `dispatching-parallel-agents`).

**Install vs enable — the leak:** skill descriptions inject per INSTALLED plugin, regardless of the `false` toggle (the toggle gates agents/MCP/commands only — NOT skills, and NOT output styles). Output-style plugins are the same trap: an installed output-style plugin injects its style prompt into EVERY session at SessionStart even with its enable flag `false` — verified for `explanatory`/`learning`. A disabled-but-installed skill or output-style pack costs its full surface every session — uninstall (`claude plugin uninstall <name>@<marketplace>`) is the only reclaim. Uninstalled 2026-07: `data-engineering` (~3.5k tok), `chrome-devtools-mcp` (~646), `explanatory-output-style` + `learning-output-style` (style prompts inject at SessionStart despite `false` flags). Gotcha: `claude plugin install` flips the settings.json key to `true` — reset stack plugins to `false` after any reinstall. Note: `data-engineering` + `chrome-devtools-mcp` are NOT in settings.json `enabledPlugins` (uninstalled, not just `false`) — reinstall by `name@marketplace` when needed.

Orchestrator Session A: when the stack is known, write the project `.claude/settings.json` enablement as part of setup (it's a durable blank, like CLAUDE.md).
