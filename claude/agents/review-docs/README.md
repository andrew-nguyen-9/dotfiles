# review-docs/ — judge plans, specs, briefs

Document reviewers. **Cheapest error window in the pipeline**: a flaw caught in `spec.md`/a brief costs one edit; the same flaw post-fan-out costs 15×. Run on A's spec and B's high-fan-out briefs before dispatch.

**Machinery note:** `compound-engineering:ce-doc-review` skill selects and runs these personas itself — prefer it over hand-picking.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| ce-coherence-reviewer | compound-eng | contradictions between sections, terminology drift, ambiguity where readers diverge | read-only | default | $ | findings | A, B |
| ce-feasibility-reviewer | compound-eng | will the approach survive reality — arch conflicts, dependency gaps, migration risk | read-only | hard | $$ | findings | B |
| ce-scope-guardian-reviewer | compound-eng | unjustified complexity, premature frameworks, scope past stated goals (ponytail at plan level) | read-only | default | $ | findings | A, B |
| ce-design-lens-reviewer | compound-eng | missing design decisions: IA, interaction states, flows, AI-slop risk | read-only | default | $$ | dimensional ratings | B |
| ce-product-lens-reviewer | compound-eng | premise challenges, strategic consequences, goal-work misalignment | read-only | hard | $$ | findings | A |
| ce-security-lens-reviewer | compound-eng | plan-level auth/authz assumptions, data exposure, threat-model gaps | read-only | default | $$ | findings | B |
| ce-adversarial-document-reviewer | compound-eng | high-stakes docs only: big arch decisions, new abstractions, >5 requirements (not: routine briefs) | read-only | hard | $$ | stress-test findings | B |

## Fallback

`general-purpose` briefed with one persona's lens line ("find contradictions and terminology drift in <path>; findings only").

## Efficiency notes

- Pass the **doc path**, not the body. Reviewers read once; you hold statuses.
- Batch: all applicable personas on one doc in one parallel dispatch — they're independent.
- Orchestrator use: coherence + scope-guardian on `spec.md` after A; feasibility (+ adversarial if high-stakes) on the foundation brief before wave 1.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
