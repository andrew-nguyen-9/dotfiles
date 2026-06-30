# orchestrator.md

Multi-agent orchestrator. Fan out spec → standalone briefs → parallel agents → compressed notes. Main chat holds only the dependency map + short statuses.

## Quick-start

```
0. Normalize the wants/fixes list → a spec first (brainstorming/spec skill):
   structured epics, each with acceptance criteria. Don't fan out a raw wishlist.
0.5 Block 0.6 — /usage + /stats; estimate units×~15× vs remaining window + weekly; wave it if it won't fit.
1. Block 1  — activate Block-0 tools + context-management (§1). Read spec ONCE.
2. Block 2  — superpowers:writing-plans → ralph-skills:prd → ralph → prd.json + briefs/.
3. Block 4  — build dependency map. STOP: eyeball it (cross-epic edges). Approve.
4. Block 4b — run foundation wave first (shared scaffolding) → its .done.md seeds the rest.
5. Block 7  — ralph-loop:ralph-loop on prd.json → feature agents run, write <unit>.done.md.
6. Block 7b — integration gate: merge in dep order + full regression on the trunk.
7. Block 8  — report (rtk gain) + partial-release policy for any blocked unit.
```

## Tiers — the whole mental model

| Tier | Holds | Rule |
|------|-------|------|
| Spec (1 file) | full detail | read once → generate artifacts; never re-read |
| Briefs + `<unit>.done.md` (disk) | per-unit detail + outcomes | agents only; never into main chat |
| Main chat | dependency map + short statuses | nothing else |

Skip a load-bearing part → context leaks → thin window collapses.

## Block 0 — Tools

Optional (pattern holds without them); they cut tokens, don't carry it.

| Tool | Role |
|------|------|
| **superpowers** | skeleton: `dispatching-parallel-agents`, `subagent-driven-development`, `writing/executing-plans`, `test-driven-development`, `verification-before-completion` |
| **caveman ultra** (`/caveman:caveman ultra`) | mandatory compression on all thin-window traffic (returns, statuses, `.done.md`) |
| **ponytail ultra** (`/ponytail:ponytail ultra`) | laziest-that-works diffs → smaller carry-forward |
| **RTK** | shell token proxy (`git status`→`rtk git status`); `rtk gain` = savings metric |
| **Serena** | symbolic nav (`find_symbol`, `get_symbols_overview`) over whole-file reads |
| **Language LSP** (per stack) | type-aware symbol nav — see Efficiency layer |

## Invariants — never break

1. **Role line.** "You are the orchestrator. Hold only the map + statuses. Never pull detail, file contents, build output, or note bodies into this chat."
2. **Return contract.** Every agent returns ONLY `id, status, branch, PR, ≤2-line note`, as a **JSON schema** (rejects malformed at the boundary — a rejected return is also a paid retry). Backstop: verbose return → summarize to one line, drop the rest.
3. **Cap every artifact.** Note ≤15 lines. Return ≤2 lines. Brief = one unit. Uncapped = re-flood.

---

# Pipeline

## Block 0.6 — Budget & limits (pre-flight)

Two ceilings (2026): **5-hour rolling window** (starts on first prompt, resets +300 min) and the **weekly cap** (7-day reset, shared across *all* Claude use — the hard ceiling). `/usage` (remaining + reset time) and `/stats` are free, read-only — check liberally.

- **Pre-flight** — `/usage` + `/stats` before fan-out; estimate `units × ~15×` vs remaining window + weekly. Won't fit → wave it; don't start a run you can't finish.
- **Wave-pace to the 5-hour window** — size each wave to one rolling window (foundation → feature waves); `.done.md` between waves so a reset loses nothing.
- **Weekly cap = scheduling ceiling** — a full version may span multiple weekly buckets; spread waves across days.
- **Guardrail vs remaining budget** — set Block 7's per-unit cap against remaining window, not infinity. Match model to unit difficulty (Haiku trivial, Opus hard — Block 7). The **≥98% trip = hand off, not downshift** (below).

**Congestion & pacing** — no surge pricing (a token costs the same any hour); peak = global **529 overload**, not price:

- **Off-peak heavy waves** — schedule big/independent waves overnight/weekends (ScheduleWakeup/cron). Dodges 529 storms (peak = US weekday hours + post-release spikes) and spreads weekly burn. Off-peak ≠ cheaper, just more reliable (fewer retries).
- **529 resilience** — set `fallbackModel` (up to 3 backups); exp backoff 30s → failover; cap retries (stop after ~3×529 — retry storms make it worse). Ties to the loop safeguard.
- **Batch API for latency-tolerant units** — eval runs, doc processing, non-interactive work → flat **50% off**, runs off-peak by design.
- **Tracker = pacing signal** — `ccusage --once --output json` (exit `10` near-limit / `11` limit-hit) or Claude-Code-Usage-Monitor (burn-rate, time-to-limit) as a **PreToolUse hook** (Block 6b, 0 model tokens): **≥98% (exit 10) → handoff + clean end + scheduled resume** (below); limit-hit (11) → already frozen, resume at reset; time-to-limit < wave estimate → finish the in-flight unit then hand off, don't start the next.

### Handoff file — clean stop at ≥98%

Don't grind to a hard freeze mid-unit. At the trip: finish or roll back the in-flight unit, write `handoff.md`, end the session, schedule a wakeup for the reset (ScheduleWakeup / send_later / cron). Next window: a fresh session reads `handoff.md` and resumes (idempotent units make this safe — Safeguards).

```
# handoff.md  (orchestrator resume checkpoint)
window resets:  <time>
done:           <units with .done.md>
in-flight:      <unit + branch + committed? or rolled-back>
next wave:      <units, dep order>
next-wave est:  <count_tokens estimate>   # resume skips re-estimating
dep-map cursor: <where we stopped>
blockers:       <unit: reason>
savings:        <rtk gain>                 # cached, carry into the final report
```

Resume reads these → Block 0.6 pre-flight runs off the cached `next-wave est` + reset time instead of recomputing; `savings` accumulates across windows into the Block 8 report.

## Block 1 — Setup-once

```
Activate Block-0 tools. Enable context-management layer (Efficiency §1).
Read spec ONCE → briefs + dependency map. Never re-read spec.
```

## Block 2 — Fan-out

```
superpowers:writing-plans → split spec into units.
ralph-skills:prd → ralph → prd.json   (machine task list)
Write briefs/<unit>.md — standalone (agent reads its brief, nothing else from spec).
```

Standalone test: agent given only `briefs/<unit>.md` can finish. Needs the spec → brief is incomplete; fix the brief. Granularity per project: epic / feature / module / endpoint.

**Brief = smallest high-signal set** (right altitude). Not a kitchen sink: irrelevant context *worsens* hallucinations — a fat brief is less accurate *and* costlier. Goldilocks between over-spec (brittle) and under-spec (vague).

## Block 3 — Outcome note

Each agent writes `<unit>.done.md` on finish — ≤15 lines, caveman-compressed. Crash-resume checkpoint.

```
# <unit>.done.md  (≤15 lines)
shipped: <what>
files:   <paths>
decided: <non-obvious choices>
gotchas: <traps for dependents>
branch / PR
```

Tier 2 — disk only. Never read a body into main chat; pass the **path**.

## Block 4 — Dependency map

Only genuinely project-specific thinking. Wrong → dependent runs blind.

| Unit | Upstream `.done.md` to inject |
|------|------------------------------|
| auth-mw | — |
| user-api | `auth-mw.done.md` |
| billing | `auth-mw.done.md`, `user-api.done.md` |

Fallback: note missing → agent proceeds + logs, rediscovers from committed repo (Serena/LSP). Never blocks.

## Block 4b — Foundation-first

Across a version, epics share scaffolding (schema, shared types, design system, auth, config). If each epic agent builds its own → conflicts no per-unit DoD catches.

- Scan units for shared scaffolding → make it **unit #1**: everything depends on it (map: all → foundation).
- Run it as the **first wave**; its `.done.md` carries the shared decisions feature units read before they fan out.
- Genuinely independent units → skip; don't invent a foundation that isn't there.

## Block 5 — Carry-forward

Inject **paths only**, **to dependents only**, **never bodies**. Independent units get nothing.

## Block 6 — Standing constraints

Every agent obeys (token tactics → Efficiency layer):

- **DoD gate** — `<build>`+`<test>`+`<lint>` green before `.done.md`. superpowers `verification-before-completion`: evidence before done.
- **ponytail ladder** — exists already? stdlib? native? one line? Ship minimum. Mark shortcuts `// ponytail:`.
- **TDD** for non-trivial logic.
- **Branch/commit** — one branch per unit `<prefix>/<unit>`; commit on DoD-green only; no AI attribution.
- **Secrets** — never commit; pull from `<secrets location>`; none in briefs/notes.
- **Output styles off** — no `learning`/`explanatory` in agents (prose multiplier); caveman+ponytail instead.

## Block 6b — Enforcement via hooks (0 model tokens)

A hook is shell, not an LLM turn — fires every time, free. Move **deterministic** constraints out of the prompt into hookify; keep judgment in the prompt.

- **Return-contract cap** — PostToolUse rejects/trims verbose returns (invariant 2 backstop as code).
- **Output truncation** — PostToolUse `hookSpecificOutput.updatedToolOutput` trims verbose tool output pre-context.
- **Effort gates** (`$CLAUDE_EFFORT`) — PreToolUse blocks expensive Bash at low effort; PostToolUse truncates harder.
- **RTK rewrite + blocks** — PreToolUse rewrites shell to `rtk`, blocks reads of files >N lines (force symbolic nav) and `.env`/secrets.

## Block 7 — Loop driver

```
ralph-loop:ralph-loop on prd.json
  → dispatch per task (dispatching-parallel-agents = independent;
     subagent-driven-development = the chain).
```

Each dispatch carries: brief path + upstream `.done.md` paths. Nothing else.

- **Over-decomposition guard** — multi-agent costs ~15× chat tokens; worth it *only* for truly independent units. A coupled cluster (B needs A mid-task) is cheaper as **one sequential agent** than N coordinating ones. Fan out independent units; collapse coupled clusters to one.
- **Right-size effort per unit** — `thinking:{type:adaptive}` + `output_config:{effort}` (not fixed `budget_tokens`): low effort for trivial units, high only for hard ones. Enforced by the `$CLAUDE_EFFORT` hooks (Block 6b).

## Block 7b — Integration gate

Per-unit DoD is local: N green branches can sum to a red trunk. This is the **release DoD** — run after units go green, before the report.

- Merge in dependency order (foundation → dependents).
- Run the **full regression + integration/e2e suite on the merged trunk**, not just per-unit tests. Lint the trunk.
- Green-alone but red-together = cross-unit break → fix before reporting.

## Block 8 — End report

```
blockers: <unit: reason>
branches: <unit → branch>
PRs:      <unit → PR>
savings:  rtk gain
```

caveman-terse, one line per unit. **Partial-release policy** (decide up front per unit/epic): blocked unit → *ship-without* (drop from release, log) or *block-release* (hold the version). Optional Tier-3 status glyphs (status lines + report only, never in IDs/paths/`prd.json`/note bodies — a mis-decode = wrong build): ✅ done · 🚧 blocked · ⛔ failed · 🔁 in progress · ⏭ skipped. Glyph needs a second's thought → delete it, the word was cheaper.

---

# Efficiency layer

Accuracy bar: every tactic drops **transcript bulk, never meaning**. Agent-facing — inject into briefs by reference.

## §1 Context management (platform)

| Feature | Do | Save | Risk |
|---------|-----|------|------|
| Prompt caching | cache `[system][spec][brief]`, order stable→volatile (live status last/uncached); 5-min TTL, 1-hr for long fan-outs | ~90% on hits | none — byte-identical replay |
| Context editing | `clear_tool_uses_20250919`, keep N recent (beta `context-management-2025-06-27`) | ~84% long runs | low — placeholder left; **write `.done.md` before results age out** |
| Memory tool | `.done.md` + briefs = the store; state in files outside window | +39% w/ editing | none — files are source of truth |
| Shared base-prompt cache | every subagent shares one cached prefix | one cache write serves all agents | none |
| Semantic caching | reuse answers for *similar* (not identical) subtasks via embedding match → skip the LLM call | avoids repeat calls | **low–med — similar ≠ identical; verify before trusting on a critical path** |
| Plan caching | cache + adapt execution-plan templates across similar runs | Plan stage = most compute, often repeated; strong for a recurring orchestrator | low |

**Token-efficient tool use** — on by default in Claude 4 (~14% output tokens, up to 70%). Keep it **consistent across cacheable requests** (selective use breaks prompt caching); incompatible with `disable_parallel_tool_use`.

## §2 Retrieval & nav (load less)

- **JIT (A)** — hold refs (paths/symbols/queries), fetch on demand; preload only the brief. Hybrid ok (preload the few always-needed bits).
- **Overview** — Serena `get_symbols_overview` over hand-written file-header TLDRs (live-generated → can't drift; stale header = confidently-wrong signal).
- **LSP** (`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `rust-analyzer-lsp`, `jdtls-lsp`, `ruby-lsp`, `clangd-lsp`, `csharp-lsp`, `swift-lsp`, `php-lsp`, `kotlin-lsp`, `lua-lsp`):
  - **Broad→narrow**: `documentSymbol` → `hover` → `definition` → `references`. ~500 tok vs 2k+ grep, ~900× faster, type-aware (tells the function `process` from the variable from the comment).
  - **`diagnostics` = fast check, NOT the DoD gate** — pulls type/lint errors without running the build, but isn't a full build+test. Keep the real build/test as the gate; replacing it trades accuracy for tokens.
  - **Active language only.** Heavy servers (`pyright`, `rust-analyzer`) are RAM-hungry → on huge repos raise the ceiling (`PYRIGHT_MEMORY_LIMIT=4096`) or `/plugin disable` → grep. Warm-up index cost: worth it for multi-lookup units, not one-shots.
- **Optional `llms.txt`** — auto-generated index for the *docs/spec* tier only (generated, not hand-curated; no per-file TLDR comments in code).

## §3 Edit & output (emit less)

- **Diff edits (B)** — exact-match `str_replace` (old_str/new_str), keep syntactic units whole; more reliable *and* smaller than full rewrites.
- **Structured returns (C)** — JSON-schema return (invariant 2); malformed rejected at boundary.
- **Selective tool loading (D)** — each agent gets only its unit's tools (schemas cost tokens every turn).
- **Git** — `commit -q`, `push -q`, `merge --quiet --no-edit --ff-only`; `status --porcelain`/`--short`, `diff --stat`/`--name-only`; `--no-pager log --oneline -N`; one commit per unit.
- **GitHub** — `gh --json <fields> --jq <filter>`; `gh run view --log-failed`; `gh` CLI over GitHub MCP for data fetch; pre-aggregate to a workspace file the agent reads.
- **Bash** — cap dumps (`head`/`tail`/`wc -l`, `find -maxdepth`, `ls -1`); filter at source (`grep`/`jq`); exit codes over parsing prose; chain `a && b && c`; redirect noise (`2>/dev/null`, `--no-progress`).

## §4 Browser & research units (Playwright MCP)

- **Pre-strip ingested content** — research units that read web pages strip to clean markdown *before* it hits context (~94% fewer input tokens; median page 38k→2.8k). Same family as capture-to-disk: never stream a raw page through the window.
- **Snapshot-default, vision per-task** — a11y snapshot (500–5k tok) over screenshots/vision (10k–50k); stable refs also more reliable. Vision only for canvas/charts/custom UI.
- **`includeSnapshot: false`** on non-interacting calls; snapshot only to read or click.
- **`browser_evaluate`** to extract specific fields, not the whole tree.
- **Capture-to-disk** for heavy flows via Playwright CLI (file-as-memory, ~4× less than streaming).
- **`--isolated` + headless** — fresh state per agent (correct parallel runs), faster.
- **Security:** never expose `browser_evaluate`/testing to untrusted prompts (arbitrary in-page JS).
- **No `--max-snapshot-tokens` default** — truncation can drop the element you need; cap generously, full-snapshot before interacting.

## §5 API-call construction

Output side (output ≈ 5× input cost — cap it):
- **`max_tokens` tight** per call — ceiling not target; bounds worst-case output.
- **`stop_sequences`** (4–6) — halt right after the return closes; kills runaway tails.
- **Assistant prefill** — prefill the turn (e.g. `{`) to force format + skip preamble.
- Concise instruction + low temperature → shorter, focused output.

Caching mechanics (input):
- **Order `tools → system → messages`**; `cache_control:{type:ephemeral}` on the **last static block**; ≤4 breakpoints, ends of static content only.
- **Dynamic content (date/name/session vars) → human turn or after a breakpoint**, never in the static system prefix — one var busts the cache (0.1× read becomes 1× write every call).
- Reads 0.1× input, writes 1.25× (5-min) / 2× (1-hr); TTL refreshes on read → steady traffic keeps the prefix hot.
- Cache tool defs (`cache_control` on last tool); deferred/tool-search tools append inline and preserve caching.

Tool overhead + estimation:
- Tool defs serialize **every call → hundreds of tokens each**; strip unneeded (method D) — also keeps the cache prefix clean.
- **`count_tokens`** (free, no inference, separate rate limits) for Block 0.6 pre-flight — cost a brief before dispatch.
- **Tokenizer +30%** — the new tokenizer (Fable 5 / post-Opus-4.7) counts ~30% more for the same content; recount on the *actual* model or budget math is wrong.

---

# Safeguards

Every efficiency tactic replays, drops, or compresses content — so each can propagate a wrong premise. These are the counterweight that keeps the fast pipeline from confidently shipping wrong.

- **Notes are claims, not gospel** — a wrong `.done.md` poisons every dependent (hallucination → treated as verified fact → cascade; errors compound, they don't cancel). Dependents **verify load-bearing upstream claims against committed code** (Serena/LSP), not the note alone. Notes carry only verified facts.
- **Producer-blind judge gate** — an isolated reviewer (separate context, scoring criteria the producer never sees) evaluates unit output; for code, LLM-judge ≈ human quality. Supplements the DoD; never replaces deterministic checks.
- **Deterministic for exact, judge for judgment** — tests / schema / tool-correctness = deterministic; LLM-judge only where judgment is needed. Don't spend a judge where a test works (cheaper *and* more reliable).
- **Inter-agent schema gates** — every handoff validates against the expected structure before a downstream agent consumes it (invariant 2 schema, extended to handoffs). Malformed/poisoned data blocked at the boundary.
- **Loop safeguards** (Block 7) — auto-retry on error, but **kill + reassign after 3 stuck iterations**; per-unit token/iteration **budget guardrail** (the ~15× cost runs away without one); circuit breaker + **human escalation** when agents converge on *unverified* info (agreement ≠ correctness — correlated failures).
- **Idempotent units + checkpoints** — re-running a unit must not double-apply; `.done.md` is the checkpoint, transitions versioned/replayable → a failure re-executes **one unit from its checkpoint, not the whole fan-out**. Idempotency tokens resolve retry ambiguity.
- **Small bounded units** — fewer hallucinations than one big prompt; balance against the over-decomposition guard (Block 7). Simplest architecture that works wins.

## Swap per project

- **Spec file + unit granularity.**
- **DoD gate** — exact build/test/lint + stack security checks.
- **Dependency map edges** — the real work; wrong edge → stale build.
- **Secrets location, reference sources, tool choices.**
- **Conditional plugins** (add only what your stack/DoD needs, used the efficient way):
  - **Language LSP** — §2.
  - **`hookify`** — deterministic constraints → hooks (Block 6b).
  - **`code-review`/`pr-review-toolkit`** — review **branch diff only**; diff via `gh`/git not MCP; isolated subagent returning confidence-gated findings; small model for style, large for logic.
  - **`commit-commands`** — one command for commit→push→PR (batched, `-q`).
  - **`session-report`** — Block 8 report from `.done.md` *paths* (notes stay source of truth).
  - **`security-guidance`** — gated subagent on changed files only, triggered at trust boundaries.

## Failure modes

- **Agent ignores the return contract** → backstop mandatory (summarize to one line, drop rest). Enforce via hook (Block 6b), not hope.
- **Map says independent but isn't** → dependent runs blind. Unsure → **add the edge**. An extra path is cheap; a wrong build is not.
