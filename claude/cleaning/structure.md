# structure.md — cross-repo convention (canonical)

The single source of truth every cleaning tier cleans *toward*. Repos migrate incrementally — never big-bang a green repo to match this. Template/config repos (dotfiles): exempt — flag only (cleaning README Invariant 6).

## Tiers — don't scaffold what the repo hasn't earned

- **minimal** (default): `README.md` + `CLAUDE.md`. Cleaning never creates docs/ *preemptively* — but harvest may create a destination file when real content demands it (content-driven, see §Harvest table); README is the overview.
- **full**: the docs/ template below. Graduate when: a big-tier orchestrator cycle lands (harvest needs destinations) · big-tier greenfield at foundation-seed (first unit seeds docs/) · README outgrows ~100 lines · doc sprawl already exists and needs homes.

## Root whitelist

Repo root holds ONLY: `README.md`, `CLAUDE.md`, `AGENTS.md`, `LICENSE(.md)`, `CHANGELOG.md`, config/manifests (`package.json`, `pyproject.toml`, `tsconfig.json`, `next.config.*`, `wrangler.jsonc`, `.gitignore`, lockfiles, …), the `design/` North Star folder (canonical root home — never moved into `docs/`; sibling systems find it by a literal `design/INDEX.md` test), and top-level source dirs. Any other `.md` → `docs/`. Loose scripts → `scripts/`. Loose tests → the tests dir. **AI-tool instruction files read by path convention (`GEMINI.md`, `.cursorrules`, `.windsurfrules`, and the like) are root-only like `CLAUDE.md`/`AGENTS.md` — flag, never move: a ref-check finds no in-repo links to them (the tool reads them by fixed path), so a move breaks the tool silently** (the docs-side analog of the shell-`source` blind spot).

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

- Core files numbered kebab; add `05+` only if genuinely core. Small one-off notes (SPOTIFY.md, DNS-CAA.md style) merge into `04-operations.md`. `01-overview.md` is **optional** — README covers it until it outgrows elevator-pitch size; human-facing only, the pipeline never reads it (A step 0.5 reads 02/03/04/decisions only). `research/`, `design/`, `decisions/` created on first artifact, never empty.
- **One live version.** No `docs/v1|v2|v3`, no `docs/archive/` — superseded content lives in git history.
- `superpowers/`, `.orchestrator/`, tool scaffolding: never inside `docs/`.

## 02-architecture.md skeleton — stable, addressable headings

**The canonical agent map**: orchestrator briefs path-ref its *sections* (`02 §Map`, `02 §Ownership zones`, `02 §Gotchas`) instead of re-describing the stack — stable headings are what make path-refs cheap. Greenfield: the foundation unit seeds exactly these headings; harvest and docs-refresh keep them truthful.

```markdown
## Stack → CLAUDE.md  # pointer only, don't dup the one-line stack
## Map              # modules, entry points, data flow — the brief path-ref target
## Ownership zones  # zone lines lead with the glob: `<glob> — purpose — seam note`;
                    # lossless round-trip w/ depmap's files-owned col (B seeds from it,
                    # harvest copies back down)
## Test layout      # tests dir, run-one cmd, fixtures; monorepo: per-package DoD table
                    # here (briefs' `dod:` copies from it; CLAUDE.md DoD stays repo-level)
## Conventions      # patterns agents follow: error handling, API shape, naming
## Gotchas          # dated lines: `YYYY-MM-DD <path/symbol>: <trap>` — cap ~20,
                    # oldest-out; docs-refresh DROPS lines whose path/symbol is gone
```

## 04-operations.md skeleton

`## Deploy` · `## Env & secrets` (detail — the *pointer* stays in CLAUDE.md) · `## Ops notes` (DNS, DKIM, keys-where). Harvested blocker env/infra facts land under `## Ops notes`.

## CLAUDE.md — per-repo spec (≤20 lines HARD cap; auto-loads every session, each line is forever-cost)

The one file every session AND subagent gets free — the highest-leverage context slot. Durable orchestrator blanks live here (Session A reads first, patches after; filled blank = skipped scoping question). **This file is the single GATE 1 source**: orchestrator dispatch prompts say "DoD per repo CLAUDE.md" and never duplicate the commands; C's GATE 1 = grep THIS file for unfilled `<…>` tokens + presence of the DoD/Secrets/Branches lines (minimal template lacks Branches — Session A adds it at big-tier start). Cap enforcement: cleaning docs-refresh compresses past 20 lines. `Secrets: none` is a valid FILLED value — a secret-less repo writes it literally (leaving the `<…>` token unfilled hard-fails orchestrator GATE 1).

**Minimal** (minimal-tier repo, no docs/ — 5–6 lines):

```markdown
# <repo>

- Stack: <langs / frameworks — one line>
- Map: README.md#architecture (read before coding)
- DoD: build `<cmd>` · test `<cmd>` · lint `<cmd>` — all green before "done"
- Test-one: <single-file/case cmd>
- Secrets: <location> — never commit
```

**Full** (docs/ graduated) adds — and repoints Map:

```markdown
- Map: docs/02-architecture.md (supersedes the README pointer)
- Ops/env: docs/04-operations.md
- Branches: <prefix>/<unit>
- Must-not-touch: <paths / constraints, or "none">
```

## Harvest table — run BEFORE deleting `.orchestrator/` (cleaning lite step 3)

`.orchestrator/` is gitignored but still on disk — harvest reads it before the delete pass. Every row names its **consumer** — a harvest destination nothing reads is ritual, not memory. Destination file missing → create it minimal from the templates above (this graduation is content-driven, not the preemptive-creation §Tiers forbids — never skip the harvest because the file doesn't exist).

- **`<cycle>` slug** = `YYYY-MM-DD` (the land date); append a short spec-title slug (`YYYY-MM-DD-<slug>`) only when two cycles land the same day.
- **Graduation is half-done until the pointer moves.** Creating a docs/ destination (first harvest into `docs/02` or `docs/04`) does NOT repoint CLAUDE.md — patch the repo-root CLAUDE.md pointer lines too: `Map:` → `docs/02-architecture.md` **only when §Map actually has content** (a gotchas-only first harvest keeps the README `Map:` pointer — an empty §Map target is a regression), and add `Ops/env:` → `docs/04-operations.md` **only when `docs/04-operations.md` actually exists** (a dangling pointer trips next cycle's GATE 1 `test -f`), per §CLAUDE.md full template. A destination nothing points to is orphaned.

| Artifact | → Destination | Trigger | Consumer (next cycle) |
|---|---|---|---|
| `spec.md` blocked / ship-without epics | `docs/03-roadmap.md` bullets | any epic unmet at land | A step 0.5 reads roadmap into scoping |
| `*.done.md` `decided:` lines | `docs/decisions/YYYY-MM-DD-<cycle>.md` (ONE file per cycle) | any non-obvious decision | A step 0.5 reads every file since the last land |
| `*.done.md` `gotchas:` lines | `docs/02-architecture.md` §Gotchas (dated) | any gotcha | every brief that path-refs 02 |
| `depmap.md` unit seams that worked | `docs/02-architecture.md` §Ownership zones | seams changed | A step 0.5 (reads 02) |
| wave-1 cost actuals — the `cost:` line Session C appends to `progress.md` at wave-1 calibration (session-c.md §Pre-flight Calibrate) — + process lessons (3×-stuck units, re-dispatch causes) | copy into 2-line footer of the cycle's decisions file: `cost:` / `process:` | every cycle | A step 0.5 |
| `blockers.md` env/infra/secrets facts | `docs/04-operations.md` §Ops notes | new ops fact | A step 0.5 (reads 04) |
| `blockers.md` unticked boxes at land (pending USER actions) | `docs/03-roadmap.md` bullet (or `04` §Ops notes if env/infra) | any box unticked at land | A step 0.5 — else the pending post-launch action dies with `.orchestrator/` |
| briefs, depmap, progress, handoff, rest of spec | delete — git history | always | — |

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
.orchestrator.stale-*/
.serena/
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
| `.orchestrator.stale-<date>/` dirs (Session A "just proceed" overrides) | harvest per §Harvest table, then delete |
| scratch/debug: `tmp.*`, `test2.*`, `*-old.*`, `*-backup.*`, `*.bak`, one-off debug scripts | delete |
| `plan.md` / `NOTES.md` / `TODO.md` / session logs whose content shipped or died | delete (git keeps it) — but an escalation `plan.md` with todo/in-flight units is LIVE, keep it; uncommitted files are NOT in git history, so never delete — flag instead |
| `.serena/` (serena `activate_project` scaffolding in worktrees) | delete + gitignore |
| stray `handoff.md` / `progress.md` / `prd.json` outside `.orchestrator/` | delete after landed |
| `wishlist.md` at repo root after its route landed | delete (template lives in dotfiles) |
| `stale/<unit>` branches (medium-escalation renames) whose unit later shipped | verify shipped vs `decisions/`/roadmap → manifest for `git branch -d`; unshipped → list with age, don't touch (report-only when unsure, like branch-prune) |
| `FILE_INDEX.md` / `REPO_MAP.md` manual indexes | delete (drift by design; serena + README cover it) |
| `docs/vN/`, `docs/archive/` | collapse — latest live, rest to git history (deep tier) |
| `02 §Gotchas` lines w/ dead path/symbol refs | delete at docs-refresh (fixed or stale) |
| empty sibling repos / stray worktrees / built artifact next to its source (`x.skill` + `x/`) | **flag only**, user decides |

## Tool recipes

- **Survey:** `git status`, `git ls-files | head -50`, serena `list_dir` / `get_symbols_overview` — never whole-file reads.
- **Ref-check before code delete/move:** serena `find_referencing_symbols` (zero refs required) or grep imports, **plus grep the bare filename repo-wide** (shell `source`/`.`, Makefile/CI/settings.json refs are invisible to symbol tools). Docs: grep the old path/filename for links.
- **Untrack:** `git rm -r --cached -q <path>`. **Move/rename:** `git mv` (keeps history).
- **Branch prune:** `git branch --merged main | grep -vE '^[*+]? *main$'` → `git branch -d` each (never `-D`; anchored so `main-backup`/`feat/main-nav` aren't skipped as false "main" matches).
- **Docs-refresh ground truth:** serena `get_symbols_overview`, `package.json` scripts, `pyproject.toml`, build files — patch docs to match reality, not memory.
- **Dead code / unused deps (deep, report-only):** serena `find_referencing_symbols` per suspect export; `knip`/`depcheck` (JS), `deptry` (py) *only if already installed* — cleaning never adds tooling.
- **Stale check:** `git log -1 --format=%cs -- <path>` + `git log --oneline -3 -- <path>`.
