# lite.md — single-session strategy for small asks

For asks not worth the 4-session orchestrator (`orchestrator.md`): **one chat, one agent**, the same efficiency + correctness discipline at task scale. Most asks land here.

**Routed here from `wishlist.md`.** If mid-task it turns out big (many genuinely independent units, multi-day, shared-scaffolding conflicts), stop, save what you have, and switch to `orchestrator.md` Session A — don't grind a big job through this path.

## Activate

`/caveman:caveman ultra` + `/ponytail:ponytail ultra` + RTK + Serena/LSP. Output styles off. **Think deep, output terse** (prose only — code/commits stay normal).

## Flow — scale each step to the ask; skip what's overkill

1. **Understand first.** Trace the real path with Serena `get_symbols_overview` / LSP broad→narrow (`documentSymbol` → `hover` → `definition` → `references`), not whole-file reads. Brownfield: read before you write. Bug = find the **root cause, not the symptom** — grep every caller of the function you're about to touch; fix once where they route through.
2. **Scope.** Ask only if genuinely ambiguous — one batched round of multiple-choice (AskUserQuestion); else state your assumption and proceed.
3. **Brainstorm** only if creative / multiple valid approaches (`superpowers:brainstorming`); skip for mechanical work.
4. **Think ∝ blast radius.** `ultrathink` the one load-bearing design decision; none on mechanical edits.
5. **Offload heavy search.** Dispatch a **read-only subagent (Explore)** for broad fan-out exploration so grep/file dumps stay out of your window — it returns conclusions, not dumps. Never fork. (The one orchestrator trick worth it at small scale.)
6. **Implement.** ponytail ladder (reuse > stdlib > native > one line); **diff edits, not rewrites**; TDD for non-trivial logic; mark deliberate shortcuts `// ponytail:`.
7. **Verify — non-negotiable.** DoD gate: build + test + lint green before claiming done (`verification-before-completion`: evidence, not assertion). Don't trust your own "should work" — run it.
8. **Land.** One branch; `commit -q`, no AI attribution; PR only if asked.

## Efficiency reflexes (single-session subset of `orchestrator.md` §Efficiency)

- **Dedicated tools first** — Grep/Glob/Read (+ Serena/LSP) for code search and reads (token-optimized, no shell); reserve bash `grep`/`jq`/`head` for filtering command *output*.
- **Load less** — partial reads (`offset`/`limit`) or symbolic nav over full files; hold paths/symbols, fetch on demand (JIT).
- **Parallel** — fire independent reads/searches/bash in one message; don't serialize.
- **Don't re-read** — the harness tracks file state after an edit; no verify-read.
- **Multi-step → todo list** (TaskCreate) so you don't lose the thread or redo steps.
- **git/gh hygiene** — exit codes over parsing prose; `git --stat`/`--name-only`, `commit -q`; `gh --json … --jq …`.
- **Caching is automatic in-session** — keep stable context early, volatile late; don't thrash unrelated files mid-task.

Need the full treatment of any reflex → `orchestrator.md` §Efficiency layer (load only if you actually need it).
