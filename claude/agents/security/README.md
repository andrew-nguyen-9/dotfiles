# security/ — trust-boundary changes

Dispatch whenever a diff or plan touches a **trust boundary**: auth/authz, user input handling, public endpoints, secrets, permissions, payment paths, file uploads, SQL/raw queries, deserialization.

Security findings are the one place caveman drops (Auto-Clarity): reports stay complete, plain prose.

All ce-* rows are compound-eng = per-project enable (global-`false`): enable `compound-engineering` in the repo's `.claude/settings.json`, else use the Fallback chain.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| ce-security-sentinel | compound-eng | full audit: vulns, input validation, authn/z, hardcoded secrets, OWASP — pre-deploy or on-demand | read-only | hard | $$ | audit report | D |
| ce-security-reviewer | compound-eng | diff-scoped: exploitable vulns in changed auth middleware, endpoints, input handling, permission checks | read+Write | hard | $$ | findings | D, med |
| ce-security-lens-reviewer | compound-eng | plan-level threat model gaps (also listed in [review-docs/](../review-docs/README.md)) | read-only | default | $$ | findings | B |

## Fallback

`/security-review` **(skill, not a dispatchable agent type)** → `general-purpose` **(agent)** briefed: "changed files at trust boundaries only; OWASP top-10 lens; findings w/ severity + fix, no praise." For a prd.json `agent:` pick use the **first AGENT entry** (`general-purpose` here) — `/security-review` is a skill, in-session for lite/medium only, never a dispatch target.

## Efficiency notes

- Scope to **changed files at trust boundaries**, not the whole repo — `git diff --name-only` first, filter, then dispatch.
- Secrets rule is standing (session-c.md §Standing constraints): never in briefs, notes, or returns — reviewer confirms none leaked into artifacts.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
