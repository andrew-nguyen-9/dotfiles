# explore/ — find, locate, research

Read-only fan-out: locate code, map structure, gather external grounding. Explorers return **conclusions/refs (paths, symbols, file:line), never dumps** — the whole point is keeping search bulk out of the dispatching window.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| Explore | core | broad fan-out search across many files/conventions; specify breadth ("medium"/"very thorough") (not: judging code quality — locates, doesn't review) | read-only | haiku-ok–default | $ | compact md conclusions | all |
| cavecrew-investigator | caveman | "where is X / what calls Y / map dir" — caveman-compressed, ~60% cheaper returns (not: fix suggestions — refuses) | Read/Grep/Glob/Bash | haiku-ok | $ | file:line table | lite, C |
| general-purpose | core | multi-step search where first-try match unlikely; search that must also act (not: single-fact lookups you can grep) | all | default | $$ | as briefed | all |
| code-explorer | feature-dev | trace execution paths, architecture layers, deps before building on a feature (not: quick locates) | read-only | default | $$ | analysis report | B, med |
| ce-repo-research-analyst | compound-eng | onboarding a codebase: structure, conventions, patterns | read-only | default | $$ | structured research | A, B |
| ce-learnings-researcher | compound-eng | check `docs/solutions/` institutional learnings before building (not: repos without docs/solutions) | read-only | haiku-ok | $ | applicable learnings | A, B |
| ce-git-history-analyzer | compound-eng | why does this code exist — blame/evolution archaeology | read-only | haiku-ok | $ | history findings | any |
| ce-issue-intelligence-analyst | compound-eng | GitHub issue themes, pain patterns, severity trends | +github | default | $$ | themes report | A |
| ce-best-practices-researcher | compound-eng | external standards / community conventions (not: in-repo questions) | +web, context7 | default | $$ | synthesis | B |
| ce-framework-docs-researcher | compound-eng | version-specific framework/library docs and constraints | +web, context7 | default | $$ | docs digest | B, C |
| ce-web-researcher | compound-eng | structured external grounding: prior art, competitors, market (not: code search) | +web | default | $$ | structured md | A, B |
| ce-slack-researcher | compound-eng | org decisions/context in Slack — **explicit user ask only** | slack | haiku-ok | $ | findings | A |
| ce-session-historian | compound-eng | prior-session synthesis — **via `/ce-sessions` pipeline only**, not direct dispatch | all | default | $$ | prose findings | A |
| survey-agent | role (cleaning `deep.md` §2) | full repo census vs `structure.md`: manifest candidates, dupes, drift (not: acting on findings) | Explore dispatch | default | $$ | manifest candidates + dupe report | clean |

## Fallback

`cavecrew-investigator` → `Explore` → `general-purpose`. Web research rows → run WebSearch/WebFetch yourself with pre-stripping.

## Efficiency notes

- Brief explorers to return **refs not bodies** (paths/symbols/queries); the dispatcher fetches JIT.
- Web-facing agents: pre-strip pages to markdown (~94% fewer tok) — efficiency.md §4.
- One Explore with "very thorough" usually beats 3 narrow dispatches — batch the questions.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
