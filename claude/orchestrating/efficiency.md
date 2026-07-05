# Efficiency layer

_Loaded by Session C (skeleton); A/B may skim. Assumes the spine's §Invariants. **Agents never read this file** — the dispatch skeleton below is pasted verbatim into each dispatch instead. Safeguards → safeguards.md (Session D). API-only layer (§5 + semantic/plan caching) → efficiency-api.md (SDK/API builds only)._

Accuracy bar: every tactic drops **transcript bulk, never meaning**. This section is for the SESSIONS (A–D). Agents never read this file — a by-path ref would make all 15 load the whole thing (~100k tok/run). Instead every dispatch opens with the **dispatch skeleton**, byte-identical across a wave (cached once, ~free for agents 2..N), then only `[brief path + upstream .done.md paths]` varies after it:

**Agent-def types (unit-builder / integration-agent / blind-judge) skip the skeleton** — their def IS the contract; their dispatch is two lines (see the catalog category file). The skeleton below is for **non-def types only** (general-purpose, plugin specialists):

```
You are <agent-type> for one unit. Terse contract: prose/notes caveman-compressed;
laziest diff that works (reuse > stdlib > native > one line); shell via rtk; Serena/LSP
symbolic nav over whole-file reads (unavailable → Grep/Read); JIT — hold paths/symbols,
fetch on demand; start broad, then narrow; parallel independent reads in one message.
DoD: repo CLAUDE.md commands green before done (brief dod: overrides). Branch
<prefix>/<unit> off the dispatch's base: line (default integration; explicitly:
checkout -b <prefix>/<unit> <base>); commit -q; no AI attribution. Secrets: location per CLAUDE.md, never committed.
Verify upstream .done.md claims (symbols exist) before building on them.
Write .orchestrator/<unit>.done.md (≤15 lines: shipped:/verified:/decided:/gotchas:/branch: — colon-anchored headers, non-empty bodies).
RETURN ONLY: {"id","status","branch","PR":null,"note":"≤2 lines"} — no dumps, no build output.
```

## §1 Context management (platform)

| Feature | Do | Save | Risk |
|---------|-----|------|------|
| Prompt caching | cache `[system][spec][brief]`, order stable→volatile (live status last/uncached); 5-min TTL, 1-hr for long fan-outs | ~90% on hits | none — byte-identical replay |
| Context editing | CC CLI now natively clears older tool outputs first, then summarizes, at the context limit; the API `clear_tool_uses_20250919` knob stays API/SDK-only | ~84% on 100-turn evals | low — **write `.done.md` before results age out** |
| Memory tool | `.done.md` + briefs = the store; state in files outside the window | +39% w/ editing | none — files are source of truth |
| Shared base-prompt cache | the dispatch skeleton above, byte-identical per wave; only `[brief path + upstream .done.md paths]` varies after it | one write serves the whole fan-out (~90% off the prefix for agents 2..N) | none — vary nothing before the breakpoint |

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
