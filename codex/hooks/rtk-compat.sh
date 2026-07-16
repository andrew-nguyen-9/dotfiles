#!/usr/bin/env bash
set -u

command -v rtk >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)
output=$(printf '%s' "$input" | rtk hook claude 2>/dev/null) || exit 0
[ -n "$output" ] || exit 0
patched=$(printf '%s' "$output" | jq -c '
  if type == "object"
     and .hookSpecificOutput.updatedInput? != null
     and .hookSpecificOutput.permissionDecision? == null
  then .hookSpecificOutput.permissionDecision = "allow"
  else . end
' 2>/dev/null) || exit 0
printf '%s\n' "$patched"
