# build/ — write code

Executors. Default is **general-purpose + a good brief** — the brief, not the agent type, is the #1 success driver. Every build dispatch obeys orchestrator.md Invariant 4 (lean stack) + Standing constraints (DoD gate, ponytail ladder, isolated worktree, branch discipline).

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| unit-builder | role (orchestrator.md §C) | the standard C dispatch: one unit off brief + upstream `.done.md` paths (not: coupled clusters — collapse to one sequential agent) | all | adaptive | $$–$$$ | Invariant-2 JSON + `.done.md` | C |
| general-purpose | core | default executor for any bounded task | all | adaptive | $$ | as contract | all |
| cavecrew-builder | caveman | surgical 1–2 file edit: typo, single-fn rewrite, mechanical rename (not: 3+ files — hard-refuses; new features) | Read/Edit/Write/Grep/Glob | haiku-ok | $ | caveman diff receipt | lite, C |
| claude | core | FleetView catch-all default (not: anything a specialist row covers) | all | default | $$ | — | — |
| fork | core | side task needing YOUR full context, no re-brief possible (not: **orchestrator C — never**; inherits the fat window) | inherits | default | $$$ | — | lite |
| ce-ankane-readme-writer | compound-eng | Ankane-template README for Ruby gems (not: general docs) | all | haiku-ok | $ | README | any |
| cleaner | role (cleaning `deep.md` §4) | execute one **disjoint path partition** of an approved manifest (not: overlapping paths — sequential yourself) | all | default | $ | ≤2-line note | clean |

## Fallback

`cavecrew-builder` → `general-purpose` with "≤2 files, diff-edit only" in the brief.

## Dispatch snippet — unit-builder (C copies verbatim; keep the skeleton byte-identical across a wave — only the last line varies, so the prefix caches)

```
You are unit-builder for one unit. Obey .orchestrator/orchestrator.md §Efficiency + §Standing constraints:
caveman ultra + ponytail ultra + RTK + Serena, output styles off; isolated worktree;
branch <prefix>/<unit> off current integration; TDD non-trivial logic; no AI attribution.
DoD gate: <build>+<test>+<lint> green → write .orchestrator/<unit>.done.md (≤15 lines) → commit -q.
Return ONLY JSON: {"id":"","status":"done|blocked","branch":"","PR":null,"note":"≤2 lines"}.
Unit: read .orchestrator/briefs/<unit>.md; upstream notes: <paths|none>.
```

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
