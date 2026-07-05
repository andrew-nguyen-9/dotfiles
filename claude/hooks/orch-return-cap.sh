#!/usr/bin/env bash
# PostToolUse (Task|Agent) — return-contract cap.
# A subagent return over 4000 chars violates the <=2-line contract; truncate it
# before it floods the orchestrator window. Active ONLY with a live .orchestrator/.
# updatedToolOutput replaces the tool result (supported per hooks docs) — live.
set -u
input=$(cat)

. "$(dirname "${BASH_SOURCE[0]}")/lib/orch-common.sh"
orch_dir=$(orch_find_dir "$input") || exit 0
orch_gate_open "$orch_dir" || exit 0

# ponytail: 4000-char ceiling, not 2 lines — leaves room for legit review findings.
# Tail-preserving: keep first ~3200 + marker + last ~800 chars so the trailing
# {"id","status",...} contract JSON agents append LAST survives truncation.
printf '%s' "$input" | jq -c '
  (.tool_response | if type == "string" then . else tojson end) as $out
  | ($out | length) as $len
  | if $len > 4000 then
      {hookSpecificOutput: {hookEventName: "PostToolUse",
        updatedToolOutput: (
          ($out[0:3200])
          + "\n…[truncated by return-cap hook: " + (($len - 4000) | tostring) + " chars dropped — return contract is <=2 lines; detail belongs in .done.md on disk]…\n"
          + ($out[($len - 800):$len]))}}
    else empty end'
exit 0
