# meta/ — tooling for Claude itself

Agents that build/validate/explain the Claude Code setup: plugins, skills, hooks, SDK apps, this catalog. Mostly lite-tier, on-demand.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| claude-code-guide | core | "can Claude / how do I" questions on Claude Code, Agent SDK, Claude API — continue an existing one via SendMessage before spawning new | Bash/Read/web | haiku-ok | $ | answer | any |
| agent-creator | plugin-dev | generate a new agent definition for a plugin | Write/Read | default | $ | agent .md | lite |
| plugin-validator | plugin-dev | validate plugin structure/manifest after create/modify | read+Bash | haiku-ok | $ | validation report | lite |
| skill-reviewer | plugin-dev | review a skill's quality/description/triggering after create/modify | read-only | haiku-ok | $ | review | lite |
| conversation-analyzer | hookify | mine the current transcript for behaviors worth preventing with hooks (`/hookify`) | Read/Grep | default | $ | hook candidates | lite |
| statusline-setup | core | configure status line | Read/Edit | haiku-ok | $ | config | lite |
| agent-sdk-verifier-ts / -py | agent-sdk-dev | verify an Agent SDK app follows SDK best practices post-build | all | default | $$ | verification report | D |

## Fallback

`general-purpose` + `plugin-dev:*` skills (skill-development, hook-development, plugin-structure) as reference.

## Efficiency notes

- Deterministic rules → hookify hooks, not prompt lines (0 model tokens; session-c.md §Enforcement via hooks) — `conversation-analyzer` finds candidates after a messy run.
- This catalog itself is meta: update via the contract in [../README.md](../README.md) §Update contract.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
