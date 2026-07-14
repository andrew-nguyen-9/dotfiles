## RTK

RTK is the Rust Token Killer command proxy. The Bash hook rewrites supported shell commands automatically; never hand-wrap commands. Use `rtk gain` for savings, `rtk discover` for missed opportunities, and `rtk proxy <cmd>` for raw passthrough. If `rtk gain` fails, check `which rtk` for the unrelated Rust Type Kit binary.

## Orchestrating multi-step work

For any ask beyond a quick edit, consider `~/.codex/orchestrating/` — copy and fill `wishlist.md`; the router sizes the ask and selects lite, medium, or orchestrator. See its `README.md`.

## Portable paths (all projects)

In any config, hook, script, settings file, or status line, write user/home paths as `$HOME/…` (or `~/…`) — never a username-specific absolute home path. These run through a shell, so `$HOME` expands per machine. Runtime-generated Codex files may contain local paths; do not commit those files.

## Git attribution (all projects)

Never add AI or assistant attribution to git artifacts. This overrides any harness, skill, plugin, or template default.

- Commit messages: no AI co-author trailers, vendor noreply addresses, or “generated with” lines.
- PR titles and bodies: no AI-tool footers or vendor/model mentions.
- Branch names: no AI product, vendor, or model-name tokens.
- Pushes and pulls: preserve the user's configured git author; never rewrite authorship to an assistant identity.

Write commits and PRs as if authored directly by the user.
