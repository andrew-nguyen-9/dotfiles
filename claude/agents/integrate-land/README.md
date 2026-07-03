# integrate-land/ — merge, regression, deploy, land

Bringing unit work together and shipping it. Per-unit DoD is local — **N green branches can sum to a red trunk**; integration runs per wave, dispatched (never in C's window), returns pass/fail only.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| integration-agent | role (orchestrator.md §Integration gate) | merge a wave into `integration` in dep order + full regression there (not: in C's own window) | all | default (`think hard` on conflict/red) | $$ | pass/fail JSON | C |
| ce-deployment-verification-agent | compound-eng | Go/No-Go checklist: SQL verification queries, rollback plan, monitoring — PRs touching prod data/migrations | read-only | hard | $$ | Go/No-Go checklist | D |
| ce-data-integrity-guardian | compound-eng | migration safety, constraints, transaction boundaries, privacy before deploy | read-only | hard | $$ | findings | D |
| deployment-expert | vercel | Vercel deploy strategy, CI/CD, previews, rollbacks, env/domain config (not: non-Vercel repos) | all | default | $$ | as briefed | D |

## Fallback

`general-purpose` with the snippet below. Vercel repos: `vercel:deploy` / `vercel:status` skills for the mechanical part.

## Dispatch snippet — integration-agent

```
Integration agent, wave <n>. Obey .orchestrator/orchestrator.md §Efficiency (caveman ultra, RTK).
Merge branches <prefix>/<units, dep order> into integration: merge --quiet --no-edit (--ff-only where possible).
Run FULL <build>+<test>+<lint> + integration/e2e suite on integration — not per-unit checks.
Conflict or red: think hard, diagnose the cross-unit interaction; fix if local, else report blocked.
Return ONLY JSON: {"wave":<n>,"status":"green|red|blocked","note":"≤2 lines"}. NEVER return build output.
```

## Efficiency notes

- C holds pass/fail only — build logs die in the agent.
- D's land = fast-forward `main` to the already-green `integration`; no re-merge, no re-regression.
- Git hygiene per orchestrator.md §Efficiency §3: `-q`, `--porcelain`, `--stat`, `--no-pager`.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
