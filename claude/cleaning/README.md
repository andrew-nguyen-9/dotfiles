# Cleaning

A pick-the-right-weight system for resetting a repo after an orchestrating cycle — or tidying any repo on demand. Same shape as `~/.claude/orchestrating/`: a router sizes the mess and runs the matching tier. Four ops everywhere: **consolidate docs, archive (= git history), delete junk, rename to convention** — plus a docs refresh at medium+.

## Start

Fresh Claude Code chat **in the target repo**:
`Read ~/.claude/cleaning/README.md and run it.`
(Orchestrating's land steps print this automatically after a cycle.)

---

**INSTRUCTIONS TO CLAUDE — do not edit this block:**

```
Activate /caveman:caveman ultra + /ponytail:ponytail ultra + RTK + Serena. Output styles off.
Quick survey (rtk git status, root tree, docs/ listing, .gitignore) — a scan, not an index. FIRST test: is this a template/config repo (content-is-machinery — templates, catalogs, hook scripts, dotfiles)? → apply Invariant 6 (flag drift only, never junk-table template files) before manifesting anything. Then ROUTE by mess size:

- LITE — post-orchestrating reset / obvious junk only, <~15 paths
    → Read ~/.claude/cleaning/lite.md and run it.
- MEDIUM — whole-repo tidy: doc sprawl, stale plans, naming drift, docs refresh, fits one session
    → Read ~/.claude/cleaning/medium.md and run it.
- DEEP — structural migration to structure.md: versioned-docs collapse (v1/v2/v3, archive/), template migration, big rename sweeps, 2–4 parallel agents
    → Read ~/.claude/cleaning/deep.md and run it.

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

1. **Approval gate.** All destructive/moving ops go into ONE manifest (`action | path | reason` table) → ONE AskUserQuestion approval → execute. Nothing unmanifested.
2. **Git history IS the archive.** Tree committed clean *before* the destructive pass; deleted content lives in git, not `archive/` folders (existing archive folders collapse in deep).
3. **Ref-check before delete/move.** Code: serena `find_referencing_symbols` / grep imports — zero refs required. Docs: grep for links to the old path.
4. **DoD after moves.** Build + test + lint green before the final commit — moves and renames break imports and links.
5. **Land.** `chore:` commits per op type, `-q`, no AI attribution + caveman chat summary (moved/merged/deleted/renamed/pruned counts, notable paths, flags).
6. **Template/config repos are exempt from structure.md** — dotfiles and any repo whose *content is itself the machinery* (templates, catalogs, hook scripts): never migrate them toward the docs/ template, never junk-table their template files (a root `wishlist.md` here IS the template, not residue). Flag drift only; the four ops still apply to genuine junk (.DS_Store, build artifacts). **The docs-refresh (Invariant 7) is flag-only too** for CLAUDE.md/AGENTS.md/template content on these repos: never compress, restructure, or apply the repo CLAUDE.md ≤20-line cap. Specifically: dotfiles' `claude/CLAUDE.md` IS the symlinked user-global instructions file (`~/.claude/CLAUDE.md`) — not a per-repo spec; never cap it, never inline its `@RTK.md` include, never template it.
7. **Docs refresh** runs whenever medium/deep runs: verify README/CLAUDE.md/core-doc claims against actual code, patch stale sections. Also the global **agents catalog** (`~/.claude/agents-docs/` — symlinked, so any repo's run may touch it): verify rows vs installed plugins, fold sprawled `## Lessons` one-liners into table rows, prune dead agents.

## Files

- `README.md` — this file: entry + router
- `lite.md` / `medium.md` / `deep.md` — the three tiers
- `structure.md` — the canonical cross-repo convention (target tree, naming, gitignore baseline, junk table, tool recipes). Every tier cleans *toward* it.
