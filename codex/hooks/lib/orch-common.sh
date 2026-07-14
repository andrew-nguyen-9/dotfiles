# Shared preamble for the orch-*.sh hooks (read-cap and return-cap):
# resolve the live .orchestrator/ dir + check its lifecycle gate. Sourced, not
# executed — no shebang, no `set -u` (inherits the caller's).
#
# Usage in a hook script:
#   . "$(dirname "${BASH_SOURCE[0]}")/lib/orch-common.sh"
#   orch_dir=$(orch_find_dir "$input") || exit 0
#   orch_gate_open "$orch_dir" || exit 0
#
# orch_find_dir <json-input>: prints the live .orchestrator/ dir path, or
# fails (nonzero, no output) if none found — caller must `exit 0` on failure
# (fail-open: no live orchestrator run means the guard stays inactive).
#
# .orchestrator may live in the main worktree while a task runs from a linked
# worktree or submodule root. Resolve via the common dir: (1) its parent, else
# (2) core.worktree from the common config (submodule / linked-worktree root),
# else (3) the first `worktree list` entry that has one. git absent/failing or
# nothing found → fail (caller exits 0), unchanged from before.
orch_find_dir() {
  command -v jq >/dev/null 2>&1 || return 1

  local dir common wt
  dir=$(printf '%s' "$1" | jq -r '.cwd // empty' 2>/dev/null)
  [ -n "$dir" ] || dir="${CODEX_PROJECT_DIR:-$PWD}"

  if [ -d "$dir/.orchestrator" ]; then
    printf '%s\n' "$dir/.orchestrator"
    return 0
  fi

  common=$(git -C "$dir" rev-parse --git-common-dir 2>/dev/null) || return 1
  [ -n "$common" ] || return 1
  case "$common" in /*) ;; *) common="$dir/$common" ;; esac

  if [ -d "$(dirname "$common")/.orchestrator" ]; then
    printf '%s\n' "$(dirname "$common")/.orchestrator"
    return 0
  fi

  wt=$(git config -f "$common/config" core.worktree 2>/dev/null)
  case "$wt" in /*) ;; ?*) wt="$common/$wt" ;; esac
  if [ -n "$wt" ] && [ -d "$wt/.orchestrator" ]; then
    printf '%s\n' "$wt/.orchestrator"
    return 0
  fi

  while IFS= read -r wt; do
    [ -n "$wt" ] || continue
    if [ -d "$wt/.orchestrator" ]; then
      printf '%s\n' "$wt/.orchestrator"
      return 0
    fi
  done < <(git -C "$dir" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p')

  return 1
}

# orch_gate_open <orch-dir>: succeeds (0) when the hook should stay ARMED,
# fails (1) when state.md explicitly says non-running — caller exits 0 on
# failure. Lifecycle gate: dormant ONLY on an explicit non-running state.md;
# armed otherwise. Signal = the FIRST `state:` line anywhere in the file
# (case-insensitive, optional leading whitespace) after BOM strip — decoration
# lines (markdown comments, headings) before it are skipped, so they can't
# silently disarm. NO `state:` line anywhere (empty/blank/0-byte/decoration-only
# file) stays ARMED (same as a missing file), so a truncated/racing write can't
# silently disarm. Tolerant match: -iE accepts case and missing-space variants
# (state:running, State: running). jq-less/fail-open: missing/unreadable
# state.md keeps it active.
orch_gate_open() {
  local state first
  state="$1/state.md"
  [ -f "$state" ] || return 0
  first=$(LC_ALL=C tr -d '\357\273\277' < "$state" | grep -i -m1 '^[[:space:]]*state:')
  [ -n "$first" ] || return 0
  printf '%s' "$first" | grep -qiE '^[[:space:]]*state:[[:space:]]*running'
}
