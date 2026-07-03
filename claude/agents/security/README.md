# security/ — trust-boundary changes

Dispatch whenever a diff or plan touches a **trust boundary**: auth/authz, user input handling, public endpoints, secrets, permissions, payment paths, file uploads, SQL/raw queries, deserialization.

Security findings are the one place caveman drops (Auto-Clarity): reports stay complete, plain prose.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| ce-security-sentinel | compound-eng | full audit: vulns, input validation, authn/z, hardcoded secrets, OWASP — pre-deploy or on-demand | read-only | hard | $$ | audit report | D |
| ce-security-reviewer | compound-eng | diff-scoped: exploitable vulns in changed auth middleware, endpoints, input handling, permission checks | read+Write | hard | $$ | findings | D, med |
| ce-security-lens-reviewer | compound-eng | plan-level threat model gaps (also listed in [review-docs/](../review-docs/README.md)) | read-only | default | $$ | findings | B |

## Fallback

`/security-review` skill (core — full branch security review) → `general-purpose` briefed: "changed files at trust boundaries only; OWASP top-10 lens; findings w/ severity + fix, no praise."

## Efficiency notes

- Scope to **changed files at trust boundaries**, not the whole repo — `git diff --name-only` first, filter, then dispatch.
- Secrets rule is standing (orchestrator.md §Standing constraints): never in briefs, notes, or returns — reviewer confirms none leaked into artifacts.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
