# Wishlist router

## Wishlist

- Outcome: Audit and improve Codex orchestration, validate it with 80 scenarios, integrate evidence-backed Claude/plugin/token-efficiency improvements, and add adaptive token-limit budgeting.
- In scope:
  - Evaluate orchestration, agent definitions, token efficiency, and success.
  - Benchmark the current baseline against candidates with 80 repository-derived and synthetic scenarios, emphasizing coding and documentation.
  - Compare installed Claude and Codex orchestration/plugins; prefer native Codex equivalents and change Claude only for evidence-backed missed opportunities.
  - Install matching token-efficiency plugins after provenance, permission, hook, and maintenance review.
  - Track Codex five-hour and weekly token limits in real time where the available telemetry permits it; estimate task budgets, compare estimates with actuals, and retain compact lessons for later routing.
  - Enable Caveman ultra and Ponytail ultra for orchestrated workflows, with explicit user override and correctness escalation; keep internal handoffs structured.
  - Integrate validated changes across lite, medium, and orchestrator tiers.
- Out of scope:
  - Unrelated dotfiles cleanup.
  - Live destructive or external writes during benchmark scenarios.
  - Claude changes without measured token-efficiency and success evidence.
  - Pushes, PRs, releases, or deployment without separate authorization.
- Constraints:
  - Success first, then token efficiency; no baseline success regression.
  - Use the best behavior case-by-case rather than mirroring Claude mechanically.
  - Preserve interfaces unless evidence supports a migration.
  - Test multiple Codex models, with Terra expected to be the default and Sol secondary.
  - Keep raw results compact; retain definitions, expectations, scores, and summarized evidence rather than bulky transcripts.
  - Preserve unrelated work and portable `$HOME` paths.
- Verification / DoD:
  - Establish and preserve a green `bash codex/verify.sh` baseline.
  - Run the 80-scenario hybrid baseline/candidate evaluation with representative repeats and a weighted rubric with hard failure conditions.
  - Re-run a representative regression subset plus `bash codex/verify.sh` after integration.
  - Document measured tokens, success, clarification turns, latency, tool calls, uncertainty, plugin review, and maintenance guidance.
- Release policy: Commit each green checkpoint; do not push, open a PR, release, or deploy without separate authorization.
- Branch prefix: `dg/`
- Delegation allowed: yes, only for independent work with pairwise-disjoint file ownership.

## Routing

Multi-wave work with durable handoff is required: run `~/.codex/orchestrating/orchestrator.md` Session A.
