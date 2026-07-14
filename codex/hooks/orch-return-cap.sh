#!/usr/bin/env bash
# PostToolUse (agent delegation tools) — return-contract warning.
# Codex PostToolUse cannot rewrite tool output. Warn after a return over 4000
# chars, then keep future detail in the done note. Active only during a run.
set -u
input=$(cat)

. "$(dirname "${BASH_SOURCE[0]}")/lib/orch-common.sh"
orch_dir=$(orch_find_dir "$input") || exit 0
orch_gate_open "$orch_dir" || exit 0

# 4000-char ceiling leaves room for legitimate review findings. The dispatch
# contract remains the preventive control; this hook supplies visible evidence.
printf '%s' "$input" | jq -c '
  (.tool_response | if type == "string" then . else tojson end) as $out
  | ($out | length) as $len
  | if $len > 4000 then
      {systemMessage: (
        "RETURN CAP: subagent output was " + ($len | tostring)
        + " chars; Codex cannot rewrite PostToolUse output. Keep future returns to two concise lines and detail in the named done note.")}
    else empty end'
exit 0
