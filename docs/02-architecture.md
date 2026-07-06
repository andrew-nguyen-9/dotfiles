# Architecture notes

## Gotchas

- 2026-07-05 claude/install.sh: running it from a git worktree re-links ALL managed symlinks to the worktree path (live setup breaks when the worktree is deleted) — run only from the main checkout.
- 2026-07-05 claude/design-guidelines/PHILOSOPHY.md: siblings citing the hierarchy reference levels by number+name ("level 3, comprehension") so wording shifts don't break refs.
