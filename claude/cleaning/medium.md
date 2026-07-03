# medium.md — whole-repo tidy

Doc sprawl, stray files, naming drift, stale plans, docs refresh — **fits one session, sequential, one manifest.** Routed here from `README.md`. Turns out trivial → drop to `lite.md`; needs versioned-docs collapse or template migration → escalate to `deep.md`.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena. Output styles off. Obey `README.md` §Invariants.

## Flow

1. **Reset first.** Run `lite.md` steps 1–2 (preflight, gitignore) — the manifest below absorbs lite's step 3.
2. **Census.** Root `.md` census, `docs/` tree, loose `test_*`/scripts, naming drift vs `structure.md`. Stale-plan check: `git log -1 --format=%cs -- <path>` + did its content ship? Serena `list_dir` + partial reads — never whole-file dumps.
3. **Manifest → approve → execute.** ONE table covering all four ops:
   - **delete** — junk table hits, stale plans / session logs / TODO-NOTES whose content shipped
   - **move** — root `.md` → `docs/` (root whitelist only), loose tests → tests dir, loose scripts → `scripts/` (`git mv`, ref-check first)
   - **merge** — overlapping docs → one canonical file; unique content preserved, duplicates die
   - **rename** — → `structure.md` §naming (`git mv`; docs only, never code files)
4. **Docs refresh.** README + CLAUDE.md/AGENTS.md + core docs: verify claims against code (serena `get_symbols_overview`, package manifests, build/scripts). Patch stale sections; big drift → flag in summary, don't rewrite the voice. Merged docs get one coherence pass.
5. **Verify.** DoD: build + test + lint green. Grep old paths for dangling links/imports — zero hits.
6. **Land.** `chore:` commits per op type, `-q` + caveman summary: moved/merged/deleted/renamed counts + flags.
