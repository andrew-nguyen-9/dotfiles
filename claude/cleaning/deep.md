# deep.md — structural migration

Repo drifted far from `structure.md`: versioned docs (`docs/v1|v2|v3`, `docs/archive/`), template migration, big rename sweeps, leaked tool scaffolding. **Survey agent + one manifest + 2–4 parallel cleaners.** Routed here from `README.md`.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena. Output styles off. Obey `README.md` §Invariants.

## Flow

1. **Reset first.** `lite.md` steps 1–2 (preflight, gitignore).
2. **Survey agent.** Dispatch ONE read-only Explore agent: full census vs `structure.md` — docs mapping old→new, duplicate files across versions (diff, don't assume), junk hits, naming drift, loose files, stray flags. Returns manifest candidates + a dupe/overlap report — never file dumps into this chat.
3. **Manifest → ONE approval.** Full migration plan:
   - **docs template mapping** — every old path → its `NN-kebab` / folder target
   - **version collapse** — latest version survives as the live doc; older-only unique content merges in; the rest dies to git history. `docs/archive/`, `docs/vN/`, leaked `superpowers/`/scaffolding folders — gone.
   - **moves / renames / deletes** — as `medium.md` step 3
   - **report-only flags** (never auto-acted): dead code (serena `find_referencing_symbols` per suspect export), unused deps (`knip`/`depcheck` JS, `deptry` py — only if already installed; don't add tooling), stray sibling repos / empty worktrees, built-artifact-next-to-source dupes
4. **Execute — bounded fan-out.** Partition the approved manifest into **disjoint path sets** → 2–4 fresh agents in parallel (e.g. docs-migration / junk+renames / docs-refresh), each returns a **≤2-line note**, never a dump. Overlapping paths → do those sequentially yourself. Disjoint partition = no worktree machinery needed.
5. **Docs refresh.** As `medium.md` step 4 — all core docs + CLAUDE.md/AGENTS.md; merged/collapsed docs get one coherence pass.
6. **Verify.** Full DoD green + grep every old path (zero dangling links/imports) + `git status --porcelain` clean of strays.
7. **Land.** `chore:` commits per area, `-q` + caveman summary: counts + the report-only flags (dead code, deps, strays — user decides those separately).

**Never:** auto-delete flagged code, dependencies, or sibling repos — report only.
