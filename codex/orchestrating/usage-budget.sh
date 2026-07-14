#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(git -C "$HERE" rev-parse --show-toplevel)"
ORCH_DIR="${ORCH_DIR:-$ROOT/.orchestrator}"
HISTORY="$ORCH_DIR/usage.jsonl"

fail() { echo "FAIL: $*" >&2; exit 1; }
need_file() { [ -s "$1" ] || fail "$1 missing or empty"; }

record() {
  local stream="${1:?JSONL stream required}" meta="${2:?metadata JSON required}" usage row
  need_file "$stream"
  need_file "$meta"
  jq -e '{model,effort,category,success} | all(.[]; . != null)' "$meta" >/dev/null || fail "invalid metadata"
  usage=$(jq -sc '[.[] | select(.type == "turn.completed") | .usage][-1] // empty' "$stream")
  [ -n "$usage" ] || fail "turn.completed usage missing"
  jq -e 'all(.input_tokens,.cached_input_tokens,.output_tokens,.reasoning_output_tokens; type == "number" and . >= 0)' <<<"$usage" >/dev/null || fail "invalid usage fields"
  mkdir -p "$ORCH_DIR"
  row=$(jq -cn --slurpfile meta "$meta" --argjson usage "$usage" --arg at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
    $meta[0] as $m |
    {source:"measured",recorded_at:$at,model:$m.model,effort:$m.effort,category:$m.category,
      scenario:($m.scenario//null),success:$m.success,
      input_tokens:$usage.input_tokens,cached_input_tokens:$usage.cached_input_tokens,
      uncached_input_tokens:($usage.input_tokens-$usage.cached_input_tokens),
      output_tokens:$usage.output_tokens,reasoning_output_tokens:$usage.reasoning_output_tokens,
      total_tokens:($usage.input_tokens+$usage.output_tokens),
      cache_hit_ratio:(if $usage.input_tokens>0 then $usage.cached_input_tokens/$usage.input_tokens else 0 end)}')
  printf '%s\n' "$row" >> "$HISTORY"
  printf '%s\n' "$row"
}

estimate() {
  local model="${1:?model required}" effort="${2:?effort required}" category="${3:?category required}"
  need_file "$HISTORY"
  jq -sc --arg model "$model" --arg effort "$effort" --arg category "$category" '
    [ .[] | select(.source == "measured" and .success and .model == $model and .effort == $effort and .category == $category) | .total_tokens ] | sort as $v |
    if ($v|length)==0 then error("no successful matching history")
    else {source:"estimate",method:"successful historical p75",model:$model,effort:$effort,
      category:$category,samples:($v|length),p75_tokens:$v[(((($v|length)*0.75)|ceil)-1)]}
    end
  ' "$HISTORY"
}

quota() {
  local snapshot="${1:?quota snapshot JSON required}"
  need_file "$snapshot"
  jq -e '.windows | type == "array" and all(.[]; (.duration_minutes|type)=="number" and (.used_percent|type)=="number" and (.reset_at|type)=="string")' "$snapshot" >/dev/null || fail "invalid reported quota snapshot"
  jq '
    .windows as $windows |
    ([ $windows[].used_percent ] | max // 0) as $max |
    {source:"reported",windows:$windows,max_used_percent:$max,
      action:(if $max>=90 then "checkpoint" elif $max>=75 then "shrink" else "continue" end),
      next_wave_size:(if $max>=90 then 0 elif $max>=75 then 1 else null end),
      note:"Window meaning comes from duration_minutes; no token-to-quota conversion."}
  ' "$snapshot"
}

case "${1:-}" in
  record) shift; record "$@" ;;
  estimate) shift; estimate "$@" ;;
  quota) shift; quota "$@" ;;
  *) fail "usage: $0 {record <codex-jsonl> <meta-json>|estimate <model> <effort> <category>|quota <snapshot-json>}" ;;
esac
