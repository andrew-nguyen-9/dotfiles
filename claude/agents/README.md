# Agents catalog — index + decision tree

The cross-repo catalog of **every dispatchable subagent** (plugin agents, built-ins, orchestrator roles), organized by **pipeline function**. Lives in dotfiles at `claude/agents/`, symlinked to **`~/.claude/agents-docs/`** (NOT `~/.claude/agents/` — that's Claude Code's live agent-definition dir; these are docs, not defs).

**JIT rule — never load the whole catalog.** Pick the category from the tree below, load **only that one file**. Category files are sized to be a cheap single read; this README is the only always-safe load.

## Pick by what the unit needs

- find / locate / research → [explore/](explore/README.md)
- architecture / decomposition / blueprints → [plan/](plan/README.md)
- write code (a unit) → [build/](build/README.md)
- judge written code / diffs / PRs → [review-code/](review-code/README.md)
- judge a plan / spec / brief document → [review-docs/](review-docs/README.md)
- trust-boundary changes (auth, input, secrets) → [security/](security/README.md)
- pixels / UX / design fidelity → [design-ui/](design-ui/README.md)
- merge / regression / deploy / land → [integrate-land/](integrate-land/README.md)
- tooling for Claude itself (plugins, skills, hooks, SDK) → [meta/](meta/README.md)

## Column legend (all category tables)

| Col | Values |
|-----|--------|
| Source | `core` (built-in, always available) · plugin name (`caveman`, `compound-eng`, `feature-dev`, `pr-toolkit`, `plugin-dev`, `vercel`, `agent-sdk-dev`, `hookify`) · `role` (dispatch pattern from orchestrator/cleaning docs, runs on general-purpose) |
| Effort | `haiku-ok` (trivial, cheapest model fine) · `default` · `hard` (opus + thinking) — maps to orchestrator adaptive-effort rule |
| Cost | `$` ≈5–20k tok · `$$` ≈20–60k · `$$$` ≈60k+ (vision / multi-tool / e2e) per dispatch |
| Tier | who typically dispatches: `lite` · `med` · `A/B/C/D` (orchestrator sessions) · `clean` |

**Availability:** `core` rows always work. Plugin rows need that plugin installed — all are declared in dotfiles `settings.json` (`enabledPlugins` + `extraKnownMarketplaces`), so a fresh machine gets them on first Claude Code startup after `install.sh`. Plugin still missing → the category's **Fallback** chain; `general-purpose` + a good brief is the universal floor.

## Dispatch machinery — HOW to fan out (not who)

| Mechanism | Use when |
|-----------|----------|
| Agent tool, parallel calls in one message | independent units, the default |
| `superpowers:dispatching-parallel-agents` | independent units, skill-guided |
| `superpowers:subagent-driven-development` | coupled chain — sequential agents in one session |
| `ralph-loop:ralph-loop` on `prd.json` | orchestrator Session C wave driver |
| Workflow tool | deterministic script fan-out (loops/conditionals) — user opt-in only |
| `deep-research` skill | multi-source fact-checked research harness |
| fork (`subagent_type: "fork"`) | side task needing YOUR full context — **never in orchestrator C** (inherits fat window) |

## Standing constraints — every dispatch, by reference

Every dispatched brief obeys `orchestrator.md` **Invariant 4** (caveman ultra + ponytail ultra + RTK + Serena/LSP, output styles off) and **§Efficiency layer** — reference by path, never paste. Returns obey **Invariant 2** (structured JSON, ≤2-line note; malformed rejected at boundary). Category rows carry only agent-*specific* tricks.

## Anti-patterns

- **Never fork from an orchestrator window** — defeats the thin context.
- **Over-decomposition** — coupled cluster (B needs A mid-task) = ONE sequential agent, not N coordinating.
- **Specialist worship** — general-purpose + a good brief beats a mis-fit specialist; dispatch specialists only when the row's "use when" actually matches.
- **Re-scanning done work** — a landed `.done.md` is the answer; don't re-explore what an agent already returned.
- **Verbose returns tolerated** — reject at boundary, summarize to one line, drop the rest.
- **Docs in `~/.claude/agents/`** — that dir makes files LIVE agent types; catalog docs go to `agents-docs` only.

## Update contract — the catalog is living

Written by orchestrating/cleaning cycles, not by hand:

1. **Session D (each big-tier cycle)** — after review, before cleaning kickoff:
   - used an agent type/role not in the catalog → add its row to the right category file
   - an agent surprised (wrong tier, bad returns, cost blowout, great fit) → one dated line under that category's `## Lessons`
   - diff catalog vs actually-available agent types → flag drift (renamed/removed plugins) in the D report
2. **Cleaning docs-refresh (medium/deep)** — verify rows against installed plugins, fold sprawled Lessons into table rows, prune dead agents. Catalog is global (symlinked), so any repo's cleaning run may touch it.
3. Lite/medium tiers: hit a catalog gap mid-run → one Lessons line, don't restructure.

Keep rows terse (one line each). A category file growing past ~100 lines = consolidate Lessons or split the table, not more prose.
