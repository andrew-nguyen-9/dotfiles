# Efficiency layer

_Loaded by Sessions C (skeleton) and D (§Safeguards); A/B may skim. Assumes the spine's §Invariants. **Agents never read this file** — the dispatch skeleton below is pasted verbatim into each dispatch instead._

Accuracy bar: every tactic drops **transcript bulk, never meaning**. This section is for the SESSIONS (A–D). Agents never read this file — a by-path ref would make all 15 load the whole thing (~100k tok/run). Instead every dispatch opens with the **dispatch skeleton**, byte-identical across a wave (cached once, ~free for agents 2..N), then only `[brief path + upstream .done.md paths]` varies after it:

**Agent-def types (unit-builder / integration-agent / blind-judge) skip the skeleton** — their def IS the contract; their dispatch is two lines (see the catalog category file). The skeleton below is for **non-def types only** (general-purpose, plugin specialists):

```
You are <agent-type> for one unit. Terse contract: prose/notes caveman-compressed;
laziest diff that works (reuse > stdlib > native > one line); shell via rtk; Serena/LSP
symbolic nav over whole-file reads (unavailable → Grep/Read); JIT — hold paths/symbols,
fetch on demand; start broad, then narrow; parallel independent reads in one message.
DoD: repo CLAUDE.md commands green before done (brief dod: overrides). Branch
<prefix>/<unit> off integration (explicitly: checkout -b <prefix>/<unit> integration);
commit -q; no AI attribution. Secrets: location per CLAUDE.md, never committed.
Verify upstream .done.md claims (symbols exist) before building on them.
Write .orchestrator/<unit>.done.md (≤15 lines: shipped/verified/decided/gotchas/branch).
RETURN ONLY: {"id","status","branch","PR":null,"note":"≤2 lines"} — no dumps, no build output.
```

## §1 Context management (platform)

| Feature | Do | Save | Risk |
|---------|-----|------|------|
| Prompt caching | cache `[system][spec][brief]`, order stable→volatile (live status last/uncached); 5-min TTL, 1-hr for long fan-outs | ~90% on hits | none — byte-identical replay |
| Context editing | **API/SDK builds only** — CC sessions can't set `clear_tool_uses_20250919`; in-CLI equivalent = subagent isolation + files + auto-compaction | ~84% on 100-turn evals | low — **write `.done.md` before results age out** |
| Memory tool | `.done.md` + briefs = the store; state in files outside the window | +39% w/ editing | none — files are source of truth |
| Shared base-prompt cache | the dispatch skeleton above, byte-identical per wave; only `[brief path + upstream .done.md paths]` varies after it | one write serves the whole fan-out (~90% off the prefix for agents 2..N) | none — vary nothing before the breakpoint |
| Semantic caching | reuse answers for *similar* subtasks via embedding match | skips repeat calls | **low–med — verify before trusting on a critical path** |
| Plan caching | cache + adapt execution-plan templates across runs | plan stage = most compute, often repeated | low |

**Token-efficient tool use** — on by default in Claude 4 (~14% output, up to 70%). Keep **consistent across cacheable requests** (selective use breaks caching); incompatible with `disable_parallel_tool_use`.

## §2 Retrieval & nav (load less)

- **JIT** — hold refs (paths/symbols/queries), fetch on demand; preload only the brief.
- **Overview** — Serena `get_symbols_overview` over hand-written headers (live → can't drift).
- **LSP** (`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `rust-analyzer-lsp`, `jdtls-lsp`, `ruby-lsp`, `clangd-lsp`, `csharp-lsp`, `swift-lsp`, `php-lsp`, `kotlin-lsp`, `lua-lsp`):
  - **Broad→narrow**: `documentSymbol` → `hover` → `definition` → `references`. ~500 tok vs 2k+ grep, type-aware.
  - **`diagnostics` = fast check, NOT the DoD gate** — keep the real build/test as the gate.
  - **Active language only.** Heavy servers (`pyright`, `rust-analyzer`) RAM-hungry → raise ceiling or `/plugin disable` → grep. Index warm-up worth it for multi-lookup units, not one-shots.

## §3 Edit & output (emit less)

- **Diff edits** — exact-match `str_replace`, keep syntactic units whole; smaller + more reliable than rewrites.
- **Structured returns** — JSON-schema (spine Invariant 2); malformed rejected at boundary.
- **Selective tool loading** — each agent gets only its unit's tools (schemas cost tokens every turn).
- **Git** — `commit -q`, `push -q`, `merge --quiet --no-edit --ff-only`; `status --porcelain`, `diff --stat`/`--name-only`; `--no-pager log --oneline -N`.
- **GitHub** — `gh --json <fields> --jq <filter>`; `gh run view --log-failed`; `gh` over GitHub MCP; pre-aggregate to a file the agent reads.
- **Bash** — cap dumps (`head`/`wc -l`, `find -maxdepth`); filter at source (`grep`/`jq`); exit codes over prose; chain `a && b && c`; redirect noise (`2>/dev/null`).

## §4 Browser & research units (Playwright MCP)

- **Pre-strip ingested content** — strip web pages to clean markdown before context (~94% fewer tokens; 38k→2.8k median). Never stream a raw page through the window.
- **Snapshot-default, vision per-task** — a11y snapshot (500–5k tok) over screenshots (10k–50k); `includeSnapshot:false` on non-interacting calls; `browser_evaluate` to extract fields not the tree.
- **Capture-to-disk** for heavy flows (file-as-memory, ~4× less). **`--isolated` + headless** = correct parallel runs.
- **Security:** never expose `browser_evaluate` to untrusted prompts (arbitrary in-page JS).

## §5 API-call construction — SDK/API builds ONLY (not settable from Claude Code sessions)

Output (output ≈ 5× input cost): **`max_tokens` tight** (ceiling not target); **`stop_sequences`** (4–6) halt after the return closes; **assistant prefill** (`{`) forces format + skips preamble (⊥ extended thinking — a thinking unit can't prefill; pick one); low temperature.

Caching: order `tools → system → messages`; `cache_control:{ephemeral}` on the **last static block** (≤4 breakpoints); **dynamic content (date/name/vars) → human turn or after a breakpoint** (one var busts the cache); reads 0.1× / writes 1.25×–2×, TTL refreshes on read. Cache tool defs; strip unneeded (§3) — keeps the prefix clean.

---

# Safeguards

Every efficiency tactic replays, drops, or compresses content — so each can propagate a wrong premise. These keep the fast pipeline from confidently shipping wrong.

- **Notes are claims, not gospel** — a wrong `.done.md` poisons every dependent (errors compound, they don't cancel). Dependents (and Session D) **verify load-bearing claims against committed code** (Serena/LSP), not the note alone.
- **Producer-blind judge gate** — isolated reviewer (separate context, hidden criteria) scores output; supplements the DoD, never replaces deterministic checks. Deterministic for exact (tests/schema/tool-correctness), judge only for judgment.
- **Inter-agent schema gates** — every handoff validates against expected structure before a downstream agent consumes it. Malformed/poisoned data blocked at the boundary (C's `.done.md` header grep in session-c.md §Run is the concrete enforcement — missing field → re-ask the builder).
- **Loop safeguards (C)** — auto-retry order: (1) `SendMessage` the same agent (context intact, cheapest), (2) **kill after 3 stuck iterations** → ⛔ in `progress.md`, ONE fresh re-dispatch with the brief amended by the failure signature (a 3×-failed brief is usually the defect — blind re-dispatch = 4th identical failure; amending a dead unit's brief is allowed, see session-c.md Dispatch mechanics); (3) still stuck: a **code-defect** ⛔ unit goes to `progress.md` + `handoff.md` — NOT `blockers.md` (that's USER-actionable items only: secrets, access, decisions); a ⛔ unit **blocks its downstream-dependent waves** → defer or drop them per the ship-without policy. Per-unit token/iteration **budget guardrail**; circuit breaker + **human escalation** when agents converge on *unverified* info (agreement ≠ correctness).
- **Idempotent units + checkpoints** — re-running must not double-apply; `.done.md` is the checkpoint → a failure re-executes **one unit from its checkpoint, not the whole fan-out**.
- **Small bounded units** — fewer hallucinations than one big prompt; balance against the over-decomposition guard.
