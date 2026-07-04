# structure.md — cross-repo convention (canonical)

The single source of truth every cleaning tier cleans *toward*. Repos migrate incrementally — never big-bang a green repo to match this.

## Root whitelist

Repo root holds ONLY: `README.md`, `CLAUDE.md`, `AGENTS.md`, `LICENSE(.md)`, `CHANGELOG.md`, config/manifests (`package.json`, `pyproject.toml`, `tsconfig.json`, `next.config.*`, `wrangler.jsonc`, `.gitignore`, lockfiles, …), and top-level source dirs. Any other `.md` → `docs/`. Loose scripts → `scripts/`. Loose tests → the tests dir.

## docs/ template

```
docs/
  01-overview.md      # what + why
  02-architecture.md  # stack, data flow, key modules
  03-roadmap.md       # live plans only — shipped/dead plans die to git
  04-operations.md    # deploy, workflow, env, one-off ops notes (DNS, DKIM, API keys-where)
  decisions/          # ADRs: YYYY-MM-DD-topic.md
  research/           # brainstorms, spikes, analysis
  design/             # design system, UX
```

- Core files numbered kebab; add `05+` only if genuinely core. Small one-off notes (SPOTIFY.md, DNS-CAA.md style) merge into `04-operations.md`.
- **One live version.** No `docs/v1|v2|v3`, no `docs/archive/` — superseded content lives in git history.
- `superpowers/`, `.orchestrator/`, tool scaffolding: never inside `docs/`.
- **`02-architecture.md` is the canonical agent map** — orchestrator briefs path-ref it instead of re-describing the stack; keep it truthful (docs-refresh invariant). Greenfield orchestrator runs: the foundation unit seeds its skeleton.

## CLAUDE.md — per-repo spec (≤20 lines HARD cap; auto-loads every session, each line is forever-cost)

The one file every session AND subagent gets free — the highest-leverage context slot. Durable orchestrator blanks live here (Session A reads first, patches after; filled blank = skipped scoping question).

```markdown
# <repo>

- Stack: <langs / frameworks — one line>
- Map: docs/02-architecture.md (read before coding)
- Ops/env: docs/04-operations.md
- DoD: build `<cmd>` · test `<cmd>` · lint `<cmd>` — all green before "done"
- Secrets: <location> — never commit
- Branches: <prefix>/<unit>; no AI attribution in git artifacts
- Must-not-touch: <paths / constraints, or "none">
```

## Harvest table — run BEFORE deleting `.orchestrator/` (cleaning lite step 3)

| Artifact | → Destination | Trigger |
|---|---|---|
| `spec.md` blocked / ship-without epics | `docs/03-roadmap.md` bullets | any epic unmet at land |
| `*.done.md` `decided:` lines | `docs/decisions/YYYY-MM-DD-<cycle>.md` (ONE file per cycle) | any non-obvious decision |
| `*.done.md` `gotchas:` lines | `docs/02-architecture.md` §Gotchas | any gotcha |
| `blockers.md` env/infra/secrets facts | `docs/04-operations.md` | new ops fact |
| briefs, depmap, progress, handoff, rest of spec | delete — git history | always |

## Naming

- Docs: `NN-kebab.md` for the core sequence, plain `kebab.md` inside folders; folders kebab, unnumbered. Numbers stay sparse — don't renumber the world to insert one file.
- UPPER exceptions (tooling expects them): `README.md`, `CLAUDE.md`, `AGENTS.md`, `LICENSE`, `CHANGELOG.md`.
- `decisions/`: `YYYY-MM-DD-topic.md`.
- **Code files: never renamed by cleaning** (imports break). Note the repo's dominant convention; flag drift only.

## Placement

- Python tests → `tests/` (not `scripts/`, not `pipeline/`). JS/TS tests → the repo's existing majority (`__tests__/` or colocated `*.test.ts`).
- One-off runnable scripts → `scripts/`; one-off *debug* scripts die.
- Built artifacts never committed (see baseline below).

## gitignore baseline (paste block)

```
.DS_Store
*.log
*.tsbuildinfo
.orchestrator/
.next/
dist/
coverage/
.coverage*
.pytest_cache/
.ruff_cache/
.benchmarks/
.lighthouseci/
node_modules/
.venv/
__pycache__/
```

Better, once per machine: `git config --global core.excludesFile ~/.gitignore_global` with `.DS_Store` + `*.log` there — fixes all repos at the source.

## Junk table — manifest candidates on sight

| Pattern | Action |
|---------|--------|
| `.DS_Store`, `*.tsbuildinfo`, committed build/coverage dirs | delete + gitignore |
| `.orchestrator/` after the cycle landed | delete + gitignore |
| scratch/debug: `tmp.*`, `test2.*`, `*-old.*`, `*-backup.*`, `*.bak`, one-off debug scripts | delete |
| `plan.md` / `NOTES.md` / `TODO.md` / session logs whose content shipped or died | delete (git keeps it) |
| stray `handoff.md` / `progress.md` / `prd.json` outside `.orchestrator/` | delete after landed |
| `wishlist.md` at repo root after its route landed | delete (template lives in dotfiles) |
| `FILE_INDEX.md` / `REPO_MAP.md` manual indexes | delete (drift by design; serena + README cover it) |
| `docs/vN/`, `docs/archive/` | collapse — latest live, rest to git history (deep tier) |
| empty sibling repos / stray worktrees / built artifact next to its source (`x.skill` + `x/`) | **flag only**, user decides |

## Tool recipes

- **Survey:** `rtk git status`, `git ls-files | head -50`, serena `list_dir` / `get_symbols_overview` — never whole-file reads.
- **Ref-check before code delete/move:** serena `find_referencing_symbols` (zero refs required) or grep imports. Docs: grep the old path/filename for links.
- **Untrack:** `git rm -r --cached -q <path>`. **Move/rename:** `git mv` (keeps history).
- **Branch prune:** `git branch --merged main | grep -v ' main'` → `git branch -d` each (never `-D`).
- **Docs-refresh ground truth:** serena `get_symbols_overview`, `package.json` scripts, `pyproject.toml`, build files — patch docs to match reality, not memory.
- **Dead code / unused deps (deep, report-only):** serena `find_referencing_symbols` per suspect export; `knip`/`depcheck` (JS), `deptry` (py) *only if already installed* — cleaning never adds tooling.
- **Stale check:** `git log -1 --format=%cs -- <path>` + `git log --oneline -3 -- <path>`.
