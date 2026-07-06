#!/usr/bin/env bash
# Self-check for claude/design-system-creator/. Exit 0 = green.
# Checks: expected files present, line caps, internal pointers resolve,
# portable paths (no hardcoded /Users|/home), router block intact.
set -u
cd "$(dirname "$0")"
fail=0
say() { echo "FAIL: $1"; fail=1; }

files=(README.md interview.md modes.md challenge.md north-star.md ui-kit.md validate.sh)
for f in "${files[@]}"; do [ -f "$f" ] || say "$f missing"; done

# caps: dogfood the corpus's 250-line density budget
for f in *.md; do
  n=$(wc -l < "$f")
  [ "$n" -le 250 ] || say "$f is $n lines (>250 cap)"
done

# every local file mentioned in a doc must exist in this folder
for f in *.md; do
  for ref in $(grep -o '`[a-z-]*\.md`\|`validate\.sh`' "$f" | tr -d '\`' | sort -u); do
    [ -f "$ref" ] || say "$f points at $ref, which does not exist"
  done
done

# portability: $HOME/~ only, never a literal user path
if grep -nE '/(Users|home)/[a-zA-Z]' ./*.md; then say "hardcoded user path (use \$HOME or ~)"; fi

# router must exist and name all five modes
grep -q 'INSTRUCTIONS TO CLAUDE' README.md || say "README.md lost its router block"
for m in SCRATCH EXTRACT UPDATE REVAMP CHALLENGE; do
  grep -q "$m" README.md || say "README.md router missing mode $m"
done

# the target template must carry every file its own cap table promises
for t in INDEX.md FOUNDATIONS.md UI-KIT.md VOICE.md PATTERNS.md DECISIONS.md; do
  grep -q "design/$t" north-star.md || say "north-star.md missing skeleton/row for design/$t"
done

[ "$fail" -eq 0 ] && echo "OK: design-system-creator green"
exit $fail
