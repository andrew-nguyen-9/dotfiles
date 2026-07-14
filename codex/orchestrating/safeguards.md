# Safeguards

- Parallel writes require pairwise-disjoint owned files. Any overlap becomes sequential root work.
- The root agent alone performs branch switches, commits, merges, pushes, PRs, and releases.
- Preserve unrelated dirty work; stage only owned paths.
- A claim is complete only with runnable evidence. Run the combined DoD after every wave.
- Never load or repeat secret values. Refer to variable names and let the runtime read values.
- Retry order: steer running agent → resume idle agent once → split or absorb. Stop after three equivalent failures.
- Disk state wins after interruption. Reconcile `progress.md`, git status, and `.done.md` files before dispatching again.
- Destructive cleanup, external writes, and expanded scope require explicit authority.
- Never add assistant attribution to git artifacts.
