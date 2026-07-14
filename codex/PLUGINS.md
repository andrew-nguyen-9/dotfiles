# Plugins — Codex-managed installation

Codex stores installed marketplaces and plugin enablement in `~/.codex/config.toml`. The desktop app and CLI may update that file, so it remains machine-local and is deliberately not symlinked into this repository.

Use the Codex plugin UI or CLI to install and enable plugins. Keep broadly useful core plugins enabled globally; enable large or stack-specific plugins only where they earn their standing context cost.

This repository manages the durable pieces that are safe to share across machines:

- global instructions (`AGENTS.md` and `RTK.md`)
- lifecycle hooks (`hooks.json` and `hooks/`)
- workflow and design documentation
- custom agent definitions (`agent-defs/*.toml`)

Authentication, runtime state, generated marketplaces, bundled-runtime paths, caches, and app-managed plugin entries stay local under `~/.codex/`.
