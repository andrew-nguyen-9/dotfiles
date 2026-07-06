# 2026-07-05 — design-system-creator

- North Star = JIT-routed folder in the target repo (`design/INDEX.md` router + capped role files), not one monolith — per-agent loads (dev: FOUNDATIONS+UI-KIT, writer: VOICE) are the token win; mirrors design-guidelines' INDEX model.
- Five routes, four build files: update+revamp share `modes.md` spine; `challenge.md` separate (adversarial, no build ask). Challenge state (wildcard rotation, trials) persists in DECISIONS tags — sessions are stateless.
- Gotcha: target `design/validate.sh` template must stay bash-3.2-safe (macOS default — no `declare -A`).
- Gotcha: interview round budgets vs question count — confirm-rounds count as one question (table in question text) or Extract can't close; P1 identity + P2.4 a11y are never defaulted.
- Scenario-tested (3 fresh-stranger sims: scratch/extract/challenge) — 45 findings fixed pre-land; rerun that pattern after any major edit.
