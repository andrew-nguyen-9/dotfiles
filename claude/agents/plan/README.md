# plan/ — architecture, decomposition, blueprints

Design-stage agents. They **inform** decisions; the dispatching session (usually B) **owns** them — decomposition/seams get `ultrathink` in the main session (highest blast radius, orchestrator.md §Thinking budget), planners feed it.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| Plan | core | step-by-step implementation strategy, tradeoffs, critical files (not: writing code) | read-only | hard | $$ | plan | lite, med, B |
| code-architect | feature-dev | full blueprint: files to create/modify, component design, data flow, build sequence (not: trivial features) | read-only | hard | $$ | blueprint | B |
| ce-architecture-strategist | compound-eng | pattern compliance / design integrity of a proposed change or refactor (not: greenfield ideation) | read-only | hard | $$ | findings | B, D |
| ce-spec-flow-analyzer | compound-eng | spec gap / user-flow / edge-case analysis before briefs are written (not: code review) | read-only | default | $ | gaps list | A, B |
| ai-architect | vercel | AI-app design on Vercel: AI SDK patterns, agents, MCP, providers (not: non-AI features) | all | default | $$ | design doc | B |

## Fallback

`Plan` → `general-purpose` with an explicit plan-shaped brief.

## Efficiency notes

- Feed planners the **spec path**, not the spec body — they read once, you hold the ref.
- Run `ce-spec-flow-analyzer` on `spec.md` **before** B fans briefs out — gaps found pre-brief cost one fix; found post-dispatch cost 15×.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
