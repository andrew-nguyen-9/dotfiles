# review-code/ — judge written code

Diff/branch/PR reviewers. **Review the branch diff only** (`git diff main...<branch>`), never the whole tree; findings confidence-gated; deterministic tests stay the DoD gate — reviewers supplement, never replace (efficiency.md §Safeguards).

**Machinery note:** `compound-engineering:ce-code-review` skill orchestrates the ce-* persona roster itself (tier selection + dedup); `/code-review` and `pr-review-toolkit:review-pr` likewise bundle. Prefer one bundle over hand-picking personas unless you need a single lens.

## Always-on personas (any nontrivial diff)

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| ce-correctness-reviewer | compound-eng | logic errors, edge cases, state bugs, intent-vs-impl | read+Write | default | $$ | findings | D, med |
| ce-maintainability-reviewer | compound-eng | complexity, coupling, naming, dead code, abstraction debt | read+Write | default | $$ | findings | D |
| ce-testing-reviewer | compound-eng | coverage gaps, weak assertions, brittle tests | read+Write | default | $$ | findings | D |
| ce-project-standards-reviewer | compound-eng | diff vs the repo's own CLAUDE.md/AGENTS.md rules | read+Write | haiku-ok | $ | findings | D |
| code-reviewer | feature-dev | confidence-gated general review, only high-priority issues | read-only | default | $$ | findings | med, D |
| cavecrew-reviewer | caveman | one-line-per-finding severity-tagged review, no praise — cheapest full pass | Read/Grep/Bash | haiku-ok | $ | `path:line: sev: problem. fix.` | lite, C |

## Conditional personas (dispatch only when trigger matches)

| Agent | Trigger | Cost |
|-------|---------|------|
| ce-security-reviewer | auth middleware, public endpoints, user input, permissions (see [security/](../security/README.md)) | $$ |
| ce-performance-reviewer | db queries, loop-heavy transforms, caching, I/O paths | $$ |
| ce-reliability-reviewer | error handling, retries, timeouts, background jobs | $$ |
| ce-api-contract-reviewer | API routes, request/response types, versioning, exported signatures | $$ |
| ce-data-migration-reviewer | migrations, schema dumps, backfills | $$ |
| ce-adversarial-reviewer | diff ≥50 lines OR auth/payments/data-mutation/external-API | $$ |
| ce-swift-ios-reviewer | Swift/SwiftUI/UIKit, entitlements, Core Data, .pbxproj | $$ |
| ce-julik-frontend-races-reviewer | async UI, Stimulus/Turbo lifecycles, DOM timing | $$ |
| ce-previous-comments-reviewer | PR has existing review threads | $ |
| ce-agent-native-reviewer | new UI features / agent tools — user-agent parity | $ |
| ce-code-simplicity-reviewer | final pass: YAGNI / simplification (ponytail in agent form) | $ |
| ce-pattern-recognition-specialist | consistency vs established codebase patterns | $ |
| ce-performance-oracle | deep perf: complexity, queries, memory, scalability | $$ |
| performance-optimizer (vercel) | Core Web Vitals, bundle size, edge/caching on Vercel | $$ |

## pr-review-toolkit set (PR-shaped work)

| Agent | Lens | Cost |
|-------|------|------|
| code-reviewer | CLAUDE.md/style adherence | $$ |
| code-simplifier | post-build simplification preserving behavior (also standalone `code-simplifier:code-simplifier`) | $$ |
| comment-analyzer | comment accuracy / rot | $ |
| pr-test-analyzer | test coverage quality on the PR | $$ |
| silent-failure-hunter | swallowed errors, bad fallbacks, empty catches | $$ |
| type-design-analyzer | type encapsulation / invariant expression | $$ |

## Roles

| Agent | Source | Use when | Returns | Tier |
|-------|--------|----------|---------|------|
| blind-judge | role (efficiency.md §Safeguards) | producer-blind verdict where judgment matters; criteria hidden from producer | verdict JSON | C, D |
| ce-pr-comment-resolver | compound-eng | evaluate + fix PR review threads (via `ce-resolve-pr-feedback` skill) | fix summaries + replies | D |

## Dispatch — blind-judge (real agent def; rubric + return schema baked in — NO snippet)

The def (`~/.claude/agents/blind-judge.md`) is canonical: 4-axis rubric (accuracy/completeness/spec-fit/quality), returns `{"unit","scores":{…},"unmet":[criteria],"note"}`. Dispatch carries ONLY the unit's acceptance criteria + branch/diff ref — never the producer's notes, reasoning, or `.done.md` (that's the blindness). Pass = no unmet criteria + no score ≤2; C/D applies that reading, the judge just scores.

## Fallback

ce-* personas missing → `pr-review-toolkit` set → `cavecrew-reviewer` → `general-purpose` briefed with the persona's lens line.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->

- 2026-07-05 blind-judge@medium: 34 dispatches (26 doc units + 3 infra + 2 panels), ~13k tok each, zero disagreements with deterministic gates; heterogeneous panel lenses (shell/adversarial) on the foundation unit surfaced 3 latent validator edge cases no single judge caught — panel-for-load-bearing earns its cost.
- 2026-07-05 parallel judge fan-out (8–10/batch) hit the 5h session cap mid-batch; judges are stateless one-shot dispatches, so relaunching after reset cost nothing — same prompts, no lost state.
