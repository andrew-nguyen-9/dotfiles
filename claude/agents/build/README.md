# build/ — write code

Executors. Default is **general-purpose + a good brief** — the brief, not the agent type, is the #1 success driver. Every build dispatch obeys orchestrator.md Invariant 4 (lean stack) + Standing constraints (DoD gate, ponytail ladder, isolated worktree, branch discipline).

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| unit-builder | agent-def (`~/.claude/agents/`) | the standard C dispatch: one unit off brief + upstream `.done.md` paths (not: coupled clusters — collapse to one sequential agent) | def allowlist (core + serena) | adaptive | $$–$$$ | def JSON + `.done.md` (def is canonical) | C |
| general-purpose | core | default executor for any bounded task | all | adaptive | $$ | as contract | all |
| cavecrew-builder | caveman | surgical 1–2 file edit: typo, single-fn rewrite, mechanical rename (not: 3+ files — hard-refuses; new features) | Read/Edit/Write/Grep/Glob | haiku-ok | $ | caveman diff receipt | lite, C |
| claude | core | FleetView catch-all default (not: anything a specialist row covers) | all | default | $$ | — | — |
| fork | core | side task needing YOUR full context, no re-brief possible (not: **orchestrator C — never**; inherits the fat window) | inherits | default | $$$ | — | lite |
| ce-ankane-readme-writer | compound-eng | Ankane-template README for Ruby gems (not: general docs) | all | haiku-ok | $ | README | any |
| cleaner | role (cleaning `deep.md` §4) | execute one **disjoint path partition** of an approved manifest (not: overlapping paths — sequential yourself) | all | default | $ | ≤2-line note | clean |

## Fallback

`cavecrew-builder` → `general-purpose` with "≤2 files, diff-edit only" in the brief.

## Dispatch — unit-builder (real agent def; contract + return schema baked in — NO snippet, NO role paste)

The def (`~/.claude/agents/unit-builder.md`) is the single canonical contract. Dispatch prompt = two lines, byte-identical prefix across a wave (only the last line varies → prefix caches):

```
Build your unit per your agent definition. DoD commands + branch prefix: repo CLAUDE.md (brief overrides via dod:).
Unit: read .orchestrator/briefs/<unit>.md; upstream notes: <paths|none>.
```

Non-def executors (`general-purpose`, etc.): B pastes the dispatch skeleton from orchestrator.md §Efficiency into the dispatch at write time — **inline rules only, never a §-path ref** (an agent told to "obey orchestrator.md §X" loads the whole 36K template; the Efficiency layer bans exactly that).

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
