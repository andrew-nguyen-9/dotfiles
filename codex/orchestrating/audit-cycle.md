# Audit cycle — Codex orchestration

Run in the dotfiles repository after meaningful orchestration changes.

1. Compare the router, lite, medium, Sessions A–D, safeguards, hooks, installer, and agent definitions for path or contract drift.
2. Confirm every referenced file exists and every home path uses `$HOME` or `~`.
3. Confirm the docs reflect shared-workspace subagents and root-owned git operations.
4. Run `bash codex/verify.sh`.
5. Report findings before editing unrelated workflow behavior.
