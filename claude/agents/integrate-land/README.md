# integrate-land/ — merge, regression, deploy, land

Bringing unit work together and shipping it. Per-unit DoD is local — **N green branches can sum to a red trunk**; integration runs per wave, dispatched (never in C's window), returns pass/fail only.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| integration-agent | agent-def (`~/.claude/agents/`) | merge a wave into `integration` in dep order + full regression there (not: in C's own window) | def allowlist | default (`think hard` on conflict/red) | $$ | def JSON `pass\|fail` + conflicts (def is canonical) | C |
| ce-deployment-verification-agent | compound-eng | Go/No-Go checklist: SQL verification queries, rollback plan, monitoring — PRs touching prod data/migrations | read-only | hard | $$ | Go/No-Go checklist | D |
| ce-data-integrity-guardian | compound-eng | migration safety, constraints, transaction boundaries, privacy before deploy | read-only | hard | $$ | findings | D |
| deployment-expert | vercel | Vercel deploy strategy, CI/CD, previews, rollbacks, env/domain config (not: non-Vercel repos) | all | default | $$ | as briefed | D |

## Fallback

`general-purpose` + paste the integration-agent def body (`~/.claude/agents/integration-agent.md`) as the dispatch prompt — the def is the single canonical contract (flow, conflict authority, `{"wave","status":"pass|fail","conflicts",note}` schema). Vercel repos: `vercel:deploy` / `vercel:status` skills for the mechanical part.

## Dispatch — integration-agent (real agent def; NO snippet)

```
Integrate wave <n> per your agent definition. Branches in dep order: <prefix>/<a>, <prefix>/<b>, …
DoD commands: repo CLAUDE.md. Wave 1: also audit foundation .done.md verified: cmds.
```

## Efficiency notes

- C holds pass/fail only — build logs die in the agent.
- D's land = fast-forward `main` to the already-green `integration`; no re-merge, no re-regression.
- Git hygiene per orchestrator.md §Efficiency §3: `-q`, `--porcelain`, `--stat`, `--no-pager`.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
