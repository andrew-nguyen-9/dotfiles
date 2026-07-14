# Orchestration plugin policy

Scope standing context and hooks by measured value, not feature count. Machine-local enablement, authentication, caches, and credentials stay outside this repository.

## Decisions

| capability | provenance reviewed | permissions/hooks/context | decision and native overlap |
|---|---|---|---|
| Caveman | `JuliusBrussee/caveman`, Codex manifest 0.1.0, MIT | Skill text plus local `SessionStart` echo hook; bundled shrink MCP exists outside the kept manifest | Keep installed skill. Dispatch explicitly says Caveman ultra because startup/default propagation does not prove ultra mode in subagents. Do not enable `caveman-shrink`; concise briefs and native compaction lack measured insufficiency. |
| Ponytail | `DietrichGebert/ponytail` 4.8.4, MIT | Skills plus Node hooks on `SessionStart`, `SubagentStart`, and `UserPromptSubmit`; MCP package exists but is not needed | Keep installed skill and explicit Ponytail ultra dispatch contract. Do not duplicate its YAGNI rules in a new plugin or enable its MCP for orchestration. |
| Superpowers | `obra/superpowers` 6.1.1, MIT | Codex manifest exposes skills and no bundled hooks; workflows add process/context cost | Keep on demand for approved design, TDD, debugging, plan, and verification work. Benchmark against native Codex behavior before broader standing use. |
| Hookify | Anthropic local plugin | Python hooks can run on every prompt, tool use, and stop | Do not globally enable for orchestration. Repository-native Codex hooks already cover secrets, reads, returns, RTK, and synthetic checks with less standing surface. Reconsider only for a repeated enforceable failure. |
| gstack | local gstack checkout; 56 wrappers already parked | Each exposed wrapper adds discovery context; router retains task access | Keep wrappers parked. Expose router or a demonstrated task-specific skill only. |
| Serena / Context7 | machine-local MCP integrations; revision not repository-managed | Symbol navigation or remote documentation may add startup/tool/context cost | Enable per repository only when native search or authoritative current docs cannot cover the task. Never make either an orchestration default. |
| review / commit helpers | installed skill/plugin catalog plus native Codex review and git | Mostly prompt/workflow behavior; overlaps native review and direct git | Keep callable, not mandatory standing context. Retain globally only after paired success/token evidence. |
| new orchestration plugin | none | Would add manifest, hooks, maintenance, and trust review | Do not create. Current Markdown, Bash, `jq`, native agents, and hooks cover the accepted design. |

## Evidence

- RTK resolves to Rust Token Killer 0.42.4. Trusted runtime smoke proved the Codex Bash hook invoked RTK before a supported `git status --short` command.
- `rtk gain` could not open its tracking database. Measured RTK savings are unavailable.
- `rtk discover` found 55 supported missed commands and about 4.9K tokens of estimated opportunity. This is an estimate, not savings.
- Codex PostToolUse supports warnings/stopping, not output replacement. The repository hook now warns; the two-line dispatch contract prevents oversized returns.
- Current active collaboration tool exposes no profile selector. Role instructions therefore travel in the dispatch prompt instead of claiming a custom profile was applied.
- No Claude file changes are justified before paired live evidence shows equal success plus lower tokens or a missed safety/correctness control. Installed-but-disabled behavior is not changed from repository guesses.

## Maintenance

On upgrade:

1. Record marketplace/repository revision and manifest version.
2. Diff permissions, MCP servers, lifecycle events, commands, and standing skill descriptions.
3. Review changed hook hashes through native `/hooks`; never bypass interactive hook trust.
4. Re-run `bash codex/hooks/test.sh`, the trusted `--runtime` smoke, representative benchmark regression, and `bash codex/verify.sh --installed`.
5. Remove or narrow a plugin only after repeated paired evidence. Keep token measurements, estimates, and reported quota snapshots separate.

Credential rotation/removal remains user-owned. Do not read, copy, or commit machine-local credential values.
