# Deep cleanup — structural migration

Use when the repository has drifted far from `structure.md`.

1. Run the lite preflight and preserve live orchestration state.
2. If delegation is authorized, use one read-only `explorer` to census old-to-new doc mappings, duplicates, junk, and naming drift.
3. Build one complete migration manifest. Older unique content merges into the live document; redundant versions remain recoverable through git history.
4. Obtain one explicit user approval.
5. Execute sequentially unless parallel writers have pairwise-disjoint paths. Subagents share the workspace; the root agent owns all git operations.
6. Refresh docs after moves settle, then run the full DoD and search every old path for dangling references.
7. Report dead code, unused dependencies, sibling repositories, and live worktrees—never delete them without separate authorization.
8. Land only authorized changes with no AI attribution.
