#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"

fail() { echo "FAIL: $*" >&2; return 1; }

validate_plan() {
  local dir="${1:?orchestrator directory required}" prd="$1/prd.json" unit brief ref path
  command -v jq >/dev/null 2>&1 || { fail "jq missing"; return 1; }
  [ -s "$prd" ] || { fail "$prd missing"; return 1; }
  [ -s "$dir/depmap.md" ] || { fail "$dir/depmap.md missing"; return 1; }

  jq -e '
    . as $p |
    def status($id): $p.units[] | select(.id == $id) | .status;
    def visit($id; $stack; $done):
      if ($done | index($id)) then $done
      elif ($stack | index($id)) then error("dependency cycle: \($id)")
      else
        (reduce (($p.units[] | select(.id == $id) | .depends[]) // empty) as $d
          ($done; visit($d; ($stack + [$id]); .))) + [$id] | unique
      end;
    def globstem($s): $s | split("*")[0];
    def overlaps($a; $b):
      ($a == $b) or
      (($a | contains("*")) and ($b | startswith(globstem($a)))) or
      (($b | contains("*")) and ($a | startswith(globstem($b))));
    ($p.units | type == "array" and length > 0) and
    (($p.units | map(.id) | unique | length) == ($p.units | length)) and
    all($p.units[];
      (.id | type == "string" and length > 0) and
      (.status == "todo" or .status == "active" or .status == "done" or .status == "blocked") and
      (.depends | type == "array") and (.owned | type == "array" and length > 0) and
      all(.owned[]; type == "string" and length > 0) and
      (.check | type == "string" and length > 0) and
      (.note | type == "string" and length > 0) and
      (.upstream | type == "array") and
      all(.depends[]; . as $d | any($p.units[]; .id == $d))) and
    ((reduce $p.units[].id as $id ([]; visit($id; []; .))) | length == ($p.units | length)) and
    ([ $p.units[] | select(
      (.status == "todo" or .status == "active") and
      all(.depends[]; status(.) == "done")) ] as $ready |
      (([$p.units[] | select(.status != "done")] | length) == 0 or ($ready | length) > 0) and
      ([ $ready[] | .id as $id | .owned[] | {id:$id,path:.} ] as $owners |
        all(range(0; $owners | length); . as $i |
          all(range($i + 1; $owners | length); . as $j |
            ($owners[$i].id == $owners[$j].id) or
            (overlaps($owners[$i].path; $owners[$j].path) | not)))))
  ' "$prd" >/dev/null || { fail "invalid dependency, ownership, or ready-unit state"; return 1; }

  while IFS= read -r unit; do
    grep -Fq "| $unit |" "$dir/depmap.md" || { fail "$unit missing from depmap.md"; return 1; }
    brief="$dir/briefs/$unit.md"
    [ -s "$brief" ] || { fail "$brief missing"; return 1; }
    grep -qi 'owned files:' "$brief" || { fail "$brief missing owned files"; return 1; }
    grep -qi 'DoD:' "$brief" || { fail "$brief missing runnable verification"; return 1; }
    grep -qi 'Note:' "$brief" || { fail "$brief missing note path"; return 1; }
    grep -qi 'Upstream symbols:' "$brief" || { fail "$brief missing upstream symbols"; return 1; }
  done < <(jq -r '.units[].id' "$prd")

  while IFS= read -r ref; do
    [ -n "$ref" ] || continue
    path="${ref%%::*}"
    case "$path" in
      /*) [ -e "$path" ] || { fail "upstream missing: $ref"; return 1; } ;;
      *) [ -e "$ROOT/$path" ] || { fail "upstream missing: $ref"; return 1; } ;;
    esac
  done < <(jq -r '
    . as $p |
    def status($id): $p.units[] | select(.id == $id) | .status;
    $p.units[] |
    select((.status == "todo" or .status == "active") and all(.depends[]; status(.) == "done")) |
    .upstream[]?
  ' "$prd")

  echo "Orchestration plan validation: PASS"
}

self_test() {
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  mkdir -p "$tmp/briefs"
  cat > "$tmp/depmap.md" <<'EOF'
| unit | depends on | files owned | verification |
|---|---|---|---|
| a | none | `a.md` | `true` |
| b | a | `b.md` | `true` |
EOF
  for unit in a b; do
    cat > "$tmp/briefs/$unit.md" <<EOF
# $unit
- Owned files: $unit.md
- DoD: true
- Note: $unit.done.md
- Upstream symbols: none
EOF
  done
  cat > "$tmp/prd.json" <<'EOF'
{"units":[
  {"id":"a","status":"done","depends":[],"owned":["a.md"],"check":"true","note":"a.done.md","upstream":[]},
  {"id":"b","status":"todo","depends":["a"],"owned":["b.md"],"check":"true","note":"b.done.md","upstream":[]}
]}
EOF

  validate_plan "$tmp" >/dev/null || fail "valid plan rejected"

  jq '.units[0].status="todo" | .units[0].depends=["b"] | .units[1].depends=["a"]' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "cycle accepted"

  jq '.units[0].depends=[] | .units[1].depends=["a"] | .units[0].owned=[]' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "empty ownership accepted"

  jq '.units[0].owned=["same/**"] | .units[1].owned=["same/new.md"] | .units[1].depends=[]' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "ready ownership overlap accepted"

  jq '.units[1].owned=["b.md"] | .units[1].depends=["a"] | .units[0].status="done" | .units[1].check=""' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "missing check accepted"

  jq '.units[1].check="true" | .units[1].upstream=["missing/file.sh::run"]' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "missing upstream accepted"

  jq '.units[1].upstream=[] | .units[0].status="blocked" | .units[1].status="todo"' "$tmp/prd.json" > "$tmp/case.json"
  mv "$tmp/case.json" "$tmp/prd.json"
  ! validate_plan "$tmp" >/dev/null 2>&1 || fail "no-ready plan accepted"

  echo "Orchestration plan self-test: PASS"
}

case "${1:-}" in
  --self-test) self_test ;;
  *) validate_plan "${1:-$ROOT/.orchestrator}" ;;
esac
