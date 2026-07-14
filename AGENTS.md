# dotfiles

- Stack: markdown docs + bash/zsh scripts (macOS dotfiles; no build system)
- Map: README.md (read before coding)
- DoD: test `bash codex/verify.sh` — green before "done" (build/lint: none)
- Test-one: `bash codex/design-guidelines/validate.sh <doc.md>`
- Secrets: none — never commit
- Branches: dg/<unit>
- Must-not-touch: codex/AGENTS.md, codex/RTK.md (global-instruction sources, symlinked to ~/.codex — edits there change every project)
