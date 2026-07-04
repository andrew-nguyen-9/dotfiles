# lite.md — single-session strategy for small asks

For asks not worth the 4-session orchestrator (`orchestrator.md`): **one chat, one agent**, the same efficiency + correctness discipline at task scale. Most asks land here.

**Routed here from `wishlist.md`.** If mid-task it grows past one sequential pass, escalate: a handful of units needing a plan + parallel work → `medium.md` (commit WIP to a branch, continue in the SAME chat reading medium.md — your WIP branch becomes medium's feature branch, skip its step 1); many independent units / multi-day / context won't fit → `orchestrator.md` Session A (your findings become its wishlist input). Don't grind a bigger job through this path. **Repo has a stale `.orchestrator/` dir** (prior big-tier run) → its presence silently activates the orch enforcement hooks on THIS session (read cap, dispatch guard, return cap) — print the cleaning kickoff (`Read ~/.claude/cleaning/README.md and run it.`) and deal with it first.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena/LSP. Output styles off. **Think deep, output terse** (prose only — code/commits stay normal).

## Flow — scale each step to the ask; skip what's overkill

1. **Understand first.** Trace the real path with Serena `get_symbols_overview` / LSP broad→narrow (`documentSymbol` → `hover` → `definition` → `references`), not whole-file reads. Brownfield: read before you write. Bug = find the **root cause, not the symptom** — grep every caller of the function you're about to touch; fix once where they route through.
2. **Scope.** Ask only if genuinely ambiguous — one batched round of multiple-choice (AskUserQuestion); else state your assumption and proceed.
3. **Brainstorm** only if creative / multiple valid approaches (`superpowers:brainstorming`); skip for mechanical work.
4. **Think ∝ blast radius.** `ultrathink` the one load-bearing design decision; none on mechanical edits.
5. **Offload heavy search.** Dispatch a **read-only subagent (Explore)** for broad fan-out exploration so grep/file dumps stay out of your window — it returns conclusions, not dumps. Never fork. (The one orchestrator trick worth it at small scale.) Agent type: pick via the `~/.claude/agents-docs/README.md` tree — load only the one category file.
6. **Implement.** ponytail ladder (reuse > stdlib > native > one line); **diff edits, not rewrites**; TDD for non-trivial logic; mark deliberate shortcuts `// ponytail:`.
7. **Verify — non-negotiable.** DoD gate: build + test + lint green before claiming done (`verification-before-completion`: evidence, not assertion). Don't trust your own "should work" — run it. **Flaky/intermittent bug:** one green run proves nothing stochastic — the gate is N repeated runs (loop the test ~10×, or the CI rerun) all green. **No toolchain / docs-only / research ask:** the gate becomes the smallest runnable check that fails if you're wrong (assert-style script, links resolve, claims match code) + note it in the summary — never invent a fake green. **Research/recommendation ask:** factual claims cited + verified; the recommendation itself is judgment, not gate-able — say so, don't fake a green on it.
8. **Land.** One branch; trust-boundary diff (auth/input/secrets) → dispatch the matching security reviewer (`agents-docs/security/`) on it before landing. `commit -q`, no AI attribution; PR only if asked. Then print the cleaning kickoff for a fresh chat: `Read ~/.claude/cleaning/README.md and run it.`

## Efficiency reflexes (single-session subset of `efficiency.md`)

- **Dedicated tools first** — Grep/Glob/Read (+ Serena/LSP) for code search and reads (token-optimized, no shell); reserve bash `grep`/`jq`/`head` for filtering command *output*.
- **Load less** — partial reads (`offset`/`limit`) or symbolic nav over full files; hold paths/symbols, fetch on demand (JIT).
- **Parallel** — fire independent reads/searches/bash in one message; don't serialize.
- **Don't re-read** — the harness tracks file state after an edit; no verify-read.
- **Multi-step → todo list** (TaskCreate) so you don't lose the thread or redo steps.
- **git/gh hygiene** — exit codes over parsing prose; `git --stat`/`--name-only`, `commit -q`; `gh --json … --jq …`.
- **Caching is automatic in-session** — keep stable context early, volatile late; don't thrash unrelated files mid-task.

Need the full treatment of any reflex → `~/.claude/orchestrating/efficiency.md` (load only if you actually need it).
