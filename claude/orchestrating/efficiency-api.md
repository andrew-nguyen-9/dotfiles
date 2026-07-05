# Efficiency — API/SDK layer

_SDK/API builds only — never loaded by orchestrator sessions; JIT-load when building on the API._

## §1 rows (API/SDK-only, un-actionable in a CC session)

| Feature | Do | Save | Risk |
|---------|-----|------|------|
| Semantic caching | reuse answers for *similar* subtasks via embedding match | skips repeat calls | **low–med — verify before trusting on a critical path** |
| Plan caching | cache + adapt execution-plan templates across runs | plan stage = most compute, often repeated | low |

## §5 API-call construction — SDK/API builds ONLY (not settable from Claude Code sessions)

Output (output ≈ 5× input cost): **`max_tokens` tight** (ceiling not target); **`stop_sequences`** (4–6) halt after the return closes; **assistant prefill** (`{`) forces format + skips preamble (⊥ extended thinking — a thinking unit can't prefill; pick one); low temperature.

Caching: order `tools → system → messages`; `cache_control:{ephemeral}` on the **last static block** (≤4 breakpoints); **dynamic content (date/name/vars) → human turn or after a breakpoint** (one var busts the cache); reads 0.1× / writes 1.25×–2×, TTL refreshes on read. Cache tool defs; strip unneeded (§3) — keeps the prefix clean.
