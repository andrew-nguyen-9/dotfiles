# dotfiles

- Stack: markdown docs + bash/zsh scripts (macOS dotfiles; no build system)
- Map: README.md (read before coding)
- DoD: test `bash claude/design-guidelines/validate.sh` — green before "done" (build/lint: none)
- Test-one: `bash claude/design-guidelines/validate.sh <doc.md>`
- Secrets: none — never commit
- Branches: dg/<unit>
- Must-not-touch: claude/CLAUDE.md, claude/RTK.md (global-instruction sources, symlinked to ~/.claude — edits there change every project)
