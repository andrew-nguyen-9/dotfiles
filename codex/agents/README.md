# Codex agent catalog

This catalog documents dispatch choices. It is linked to `~/.codex/agents-docs/`; live custom definitions are TOML files linked into `~/.codex/agents/`.

## Route by task

- locate code, references, or behavior → [explore](explore/README.md)
- implement a bounded unit → [build](build/README.md)
- plan or decompose → [plan](plan/README.md)
- integrate or land → [integrate-land](integrate-land/README.md)
- review code → [review-code](review-code/README.md)
- review docs → [review-docs](review-docs/README.md)
- UI/design work → [design-ui](design-ui/README.md)
- security work → [security](security/README.md)
- Codex tooling/configuration → [meta](meta/README.md)

Use an agent only when delegation is authorized. Codex subagents share the workspace: concurrent writers must own disjoint files, and the root agent owns all git operations.

Built-ins: `default`, `worker`, `explorer`. Installed custom agents: `unit-builder`, `integration-agent`, `blind-judge`.
