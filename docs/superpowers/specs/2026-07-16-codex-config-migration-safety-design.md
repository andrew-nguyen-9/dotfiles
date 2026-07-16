# Codex config migration safety

## Problem

The Codex config merger replaced only the first line of an existing multiline `notify` array. Its remaining values became invalid top-level TOML, preventing Codex from parsing `$HOME/.codex/config.toml`.

## Design

- Preserve the existing multiline-assignment replacement fix and regression fixture in `codex/configure.sh` and `codex/configure.test.sh`.
- Make `bash codex/verify.sh --installed` ask Codex to parse the installed config, so string-presence checks cannot accept malformed TOML.
- Add one invariant to Session A-D: stateful config migrations require representative existing-state fixtures and validation by the authoritative consumer.
- Use no new TOML parser or dependency; Codex remains the authoritative validator.

## Acceptance

- A multiline existing `notify` assignment is replaced without dangling values.
- The synthetic config remains byte-stable on a second merge and is accepted by Codex.
- Installed verification fails when Codex cannot parse `config.toml`.
- Sessions A-D all carry the migration-safety invariant.
- `bash codex/verify.sh` and `bash codex/verify.sh --installed` pass.
