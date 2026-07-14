# Cleaning

A pick-the-right-weight system for resetting a repo after an orchestrating cycle — or tidying any repo on demand. Same shape as `~/.codex/orchestrating/`: a router sizes the mess and runs the matching tier. Four ops everywhere: **consolidate docs, archive (= git history), delete junk, rename to convention** — plus a docs refresh at medium+.

## Start

Fresh Codex chat **in the target repo**:
`Read ~/.codex/cleaning/README.md and run it.`
(Orchestrating's land steps print this automatically after a cycle.)

---

**INSTRUCTIONS TO CODEX — do not edit this block:**

```
Use RTK automatically when available. Use installed navigation or compression skills only when they match; their absence is not a blocker.
Quick survey (git status, root tree, docs/ listing, .gitignore) — a scan, not an index. FIRST test: is this a template/config repo (content-is-machinery — templates, catalogs, hook scripts, dotfiles)? → apply Invariant 6 (flag drift only, never junk-table template files) before manifesting anything. Then ROUTE by mess size:

- LITE — post-orchestrating reset / obvious junk only, <~15 paths
    → Read ~/.codex/cleaning/lite.md and run it.
- MEDIUM — whole-repo tidy: doc sprawl, stale plans, naming drift, docs refresh, fits one session
    → Read ~/.codex/cleaning/medium.md and run it.
- DEEP — structural migration to structure.md: versioned-docs collapse (v1/v2/v3, archive/), template migration, big rename sweeps; parallel agents only when authorized and file ownership is disjoint
    → Read ~/.codex/cleaning/deep.md and run it.

State the chosen route + a one-line why. Borderline → lighter tier (cheap to escalate, expensive to over-build).
```

---

## The ladder

| Tier | File | For | Machinery |
|------|------|-----|-----------|
| **Lite** | `lite.md` | post-cycle reset, obvious junk | 1 pass, 1 manifest |
| **Medium** | `medium.md` | whole-repo tidy + docs refresh | census → manifest → refresh, sequential |
| **Deep** | `deep.md` | migration to `structure.md` standard | survey agent + 2–4 parallel cleaners |

## Invariants — every tier

1. **Approval gate.** All destructive/moving ops go into ONE manifest (`action | path | reason` table) → ONE explicit user approval → execute. Nothing unmanifested.
2. **Git history IS the archive.** Tree committed clean *before* the destructive pass; deleted content lives in git, not `archive/` folders (existing archive folders collapse in deep).
3. **Ref-check before delete/move.** Code: serena `find_referencing_symbols` / grep imports — zero refs required — **plus grep the bare filename repo-wide** (catches shell `source`/`.` lines, Makefile/CI/config.toml references that symbol tools can't see). Docs: grep for links to the old path.
4. **DoD after moves.** Build + test + lint green before the final commit — moves and renames break imports and links.
5. **Land.** `chore:` commits per op type, `-q`, no AI attribution + a compact chat summary (moved/merged/deleted/renamed/pruned counts, notable paths, flags).
5b. **`main` = the repo's default branch.** Every `main` in these docs (land gates, branch prune) substitutes the actual default (`git symbolic-ref --short refs/remotes/origin/HEAD`, or current branch on a fresh clone) if it isn't literally `main`.
6. **Template/config repos are exempt from structure.md** — dotfiles and any repo whose *content is itself the machinery* (templates, catalogs, hook scripts): never migrate them toward the docs/ template or junk-table their template files. Flag drift only; the four ops still apply to genuine junk. The dotfiles `codex/AGENTS.md` is the symlinked user-global instruction source, not a per-repo spec; never cap or restructure it during cleanup.
7. **Docs refresh** runs whenever medium/deep runs: verify README/AGENTS.md/core-doc claims against actual code and patch stale sections. Also verify the symlinked agent catalog against installed custom agents. If the repo has a `design/` North Star, run its validator and flag drift rather than silently rewriting product decisions.

## Files

- `README.md` — this file: entry + router
- `lite.md` / `medium.md` / `deep.md` — the three tiers
- `structure.md` — the canonical cross-repo convention (target tree, naming, gitignore baseline, junk table, tool recipes). Every tier cleans *toward* it.
