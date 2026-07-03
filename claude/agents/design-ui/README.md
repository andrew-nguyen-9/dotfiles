# design-ui/ — pixels, UX, design fidelity

Visual verification and iteration. **Heaviest agents in the catalog** — vision + browser tooling; dispatch only when the unit is genuinely visual.

## Agents

| Agent | Source | Use when / (not:) | Tools | Effort | Cost | Returns | Tier |
|-------|--------|-------------------|-------|--------|------|---------|------|
| ce-design-implementation-reviewer | compound-eng | live UI vs Figma design — discrepancy feedback after HTML/CSS/React work | all (+vision) | default | $$$ | discrepancy report | C, D |
| ce-design-iterator | compound-eng | N screenshot→analyze→improve cycles when design isn't landing after 1–2 attempts (not: first attempt) | all (+vision) | default | $$$ | iterated UI | C |
| ce-figma-design-sync | compound-eng | detect + fix diffs between implementation and Figma spec, iteratively | all (+vision) | default | $$$ | synced UI | C |

## Fallback

`general-purpose` + Playwright/chrome-devtools MCP + the `frontend-design` / `ce-frontend-design` skill lens. QA-shaped visual work: gstack `qa` / `design-review` skills.

## Efficiency notes (the $$$ tamers — orchestrator.md §Efficiency §4)

- **Snapshot-default, vision per-task**: a11y snapshot (500–5k tok) over screenshots (10k–50k); screenshot only when judging *pixels*, not structure.
- `includeSnapshot:false` on non-interacting calls; `browser_evaluate` to extract fields, not the whole tree.
- **Capture-to-disk** for heavy flows; `--isolated` + headless for parallel correctness.
- Cap iteration loops: brief `ce-design-iterator` with a max-N cycles budget, else it's an unbounded $$$ loop.

## Lessons

<!-- dated one-liners appended by cycles; cleaning consolidates into rows -->
