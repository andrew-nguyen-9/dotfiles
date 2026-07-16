# Plugins — Codex-managed installation

Codex stores installed marketplaces and plugin enablement in `~/.codex/config.toml`. The desktop app and CLI may update that file, so it remains machine-local and is deliberately not symlinked into this repository.

Use the Codex plugin UI or CLI to install and enable plugins. Keep broadly useful core plugins enabled globally; enable large or stack-specific plugins only where they earn their standing context cost.

Orchestrated work follows [`orchestrating/plugin-policy.md`](orchestrating/plugin-policy.md): reuse installed Caveman/Ponytail, keep large wrappers parked, scope MCP tools per repository, inspect hook hashes on upgrade, and require paired evidence before expanding global context. Do not install duplicates or create an orchestration plugin while native docs, agents, hooks, Bash, and `jq` cover the workflow.

This repository manages the durable pieces that are safe to share across machines:

- global instructions (`AGENTS.md` and `RTK.md`)
- lifecycle hooks (`hooks.json` and `hooks/`)
- workflow and design documentation
- custom agent definitions (`agent-defs/*.toml`)
- the explicit-MCQ skill (`skills/mcq/`) without replacing the user's skill directory
- safe CLI defaults and the macOS turn-complete notifier, merged by `configure.sh`

Authentication, runtime state, generated marketplaces, bundled-runtime paths, caches, and app-managed plugin entries stay local under `~/.codex/`.

CLI/TUI notifications cover turn completion and approval requests. The external notifier receives only turn completion; desktop app notification settings and the one-time macOS grant remain user-controlled, and IDE/VS Code notification behavior is separate.
