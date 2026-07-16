# Wishlist router

## Wishlist

1. Run Serena headless so its dashboard never opens browser tabs; keep the MCP server tied to the client session lifecycle.
2. Make safe Codex Auto behavior the portable default: workspace-scoped writes proceed automatically, eligible escalations use automatic review, and only serious blockers reach the user.
3. Resolve the `permissionsallowed`/permission-decision prehook compatibility issues and exercise a table-driven matrix of up to 100 edge scenarios.
4. When a user explicitly asks for an MCQ, use Codex's structured question UI with the recommended option first, selectable choices, notes, and free-text fallback wherever the active surface exposes it.
5. Improve paused-question notifications across Codex app, CLI, VS Code, and other Codex clients using each surface's supported native mechanism plus a portable macOS fallback where supported.
6. Keep every supported default and installer change in this repository so another device can clone, install, and reproduce the setup.

## Routing

Multi-wave work with durable handoff is required: run `$HOME/.codex/orchestrating/orchestrator.md` Session A.
