# medium.md — whole-repo tidy

Doc sprawl, stray files, naming drift, stale plans, docs refresh — **fits one session, sequential, one manifest.** Routed here from `README.md`. Turns out trivial → drop to `lite.md`; needs versioned-docs collapse or template migration → escalate to `deep.md`.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena. Output styles off. Obey `README.md` §Invariants.

## Flow

1. **Reset first.** Run `lite.md` steps 1–2 (preflight, gitignore) — the manifest below absorbs lite's step 3.
2. **Census.** Root `.md` census, `docs/` tree, loose `test_*`/scripts, naming drift vs `structure.md`. Stale-plan check: `git log -1 --format=%cs -- <path>` + did its content ship? Serena `list_dir` + partial reads — never whole-file dumps.
3. **Manifest → approve → execute.** Carry step-1's gate exclusions (parked/live-run keeps: `.orchestrator/`, unit branches) into the manifest as an explicit keep-list — they live only in lite's RESUME prose and get lost by the time the manifest executes. ONE table covering all four ops:
   - **delete** — junk table hits, stale plans / session logs / TODO-NOTES whose content shipped
   - **move** — root `.md` → `docs/` (root whitelist only), loose tests → tests dir, loose scripts → `scripts/` (`git mv`, ref-check first)
   - **merge** — overlapping docs → one canonical file; unique content preserved, duplicates die
   - **rename** — → `structure.md` §naming (`git mv`; docs only, never code files)
4. **Docs refresh.** README + CLAUDE.md/AGENTS.md + core docs: verify claims against code; harvested gotchas/decisions (lite step 3) fold into this pass — dedupe against what the docs already say (serena `get_symbols_overview`, package manifests, build/scripts). **Enforce the CLAUDE.md ≤20-line cap** (repo-root `CLAUDE.md` only — not nested/symlinked ones; nobody else does): over → compress, overflow detail moves to docs/ with a pointer line. Prune `02 §Gotchas` lines whose path/symbol no longer exists (dead-ref = fixed or stale). Prune `docs/03-roadmap.md` bullets whose epic shipped (verify vs code / `git log`) — nothing else ever removes them ("live plans only" has no other remover). Patch stale sections; big drift → flag in summary, don't rewrite the voice. Merged docs get one coherence pass. Agents catalog (`~/.claude/agents-docs/`): verify + consolidate per `README.md` §Invariants 7 — catalog edits dirty the dotfiles repo; commit them there (`chore:`), staging only the catalog paths (`git add` the agents-docs dir), never `-a` (dotfiles may hold unrelated WIP).
5. **Verify.** DoD: build + test + lint green. Grep old paths for dangling links/imports — zero hits.
6. **Land.** `chore:` commits per op type, `-q` + caveman summary: moved/merged/deleted/renamed counts + flags.
