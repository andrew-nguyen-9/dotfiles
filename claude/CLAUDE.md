@RTK.md

## Orchestrating multi-step work

For any ask beyond a quick edit, consider `~/.claude/orchestrating/` — fill `wishlist.md` and run it; a router sizes the ask and picks lite / medium / orchestrator. See its `README.md`.

## Git Attribution (all projects)

Never add AI/assistant attribution to git artifacts. This overrides any harness default or plugin behavior.

- **Commit messages:** no `Co-Authored-By: Claude ...`, no `noreply@anthropic.com` trailer, no "Generated with Claude Code" line.
- **PR titles/bodies:** no "🤖 Generated with [Claude Code]" footer, no Claude/Anthropic mention.
- **Branch names:** no `claude`, `anthropic`, or model-name tokens.

Write commits and PRs as if authored directly by the user.
