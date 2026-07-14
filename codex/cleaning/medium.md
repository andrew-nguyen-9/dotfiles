# Medium cleanup — whole-repo tidy

Use for doc sprawl, stale plans, loose scripts/tests, naming drift, and a repository-wide docs refresh that fits one task.

1. Run the lite preflight and preserve live orchestration state.
2. Census the root, docs, tests, scripts, gitignore, and stale plans using partial reads and `rg`.
3. Build one manifest covering delete, move, merge, and rename operations; include a keep-list for unrelated work.
4. Obtain one explicit user approval, then execute only approved rows. Ref-check before every move or delete.
5. Refresh README, AGENTS.md, and core docs against the actual code. Keep canonical DoD, Secrets, Branches, and Map lines intact.
6. Run the full DoD and search old paths for dangling references.
7. Land only authorized changes with a compact counts-and-flags summary and no AI attribution.

Escalate to `deep.md` for structural migration or large versioned-doc collapse.
