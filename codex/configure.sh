#!/usr/bin/env bash
set -euo pipefail

CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"

apply_config() {
  mkdir -p "$CODEX_DIR"
  CODEX_CONFIG="$CODEX_DIR/config.toml" CODEX_NOTIFY="$CODEX_DIR/notify.sh" python3 <<'PY'
import ast
import json
import os
import re
import tempfile
from pathlib import Path

path = Path(os.environ["CODEX_CONFIG"])
lines = path.read_text().splitlines(keepends=True) if path.exists() else []

def table(line):
    match = re.match(r"^\s*\[([^]]+)]\s*(?:#.*)?(?:\r?\n)?$", line)
    return match.group(1).strip() if match else None

def bounds(name):
    start = next((i for i, line in enumerate(lines) if table(line) == name), None)
    if start is None:
        return None
    end = next((i for i in range(start + 1, len(lines)) if table(lines[i]) is not None), len(lines))
    return start, end

def assignment(line, key):
    return re.match(rf"^\s*{re.escape(key)}\s*=", line) is not None

defaults = {
    "sandbox_mode": '"workspace-write"',
    "approval_policy": '"on-request"',
    "approvals_reviewer": '"auto_review"',
    "notify": json.dumps([os.environ["CODEX_NOTIFY"]]),
}

root_end = next((i for i, line in enumerate(lines) if table(line) is not None), len(lines))
missing = []
for key, value in defaults.items():
    found = [i for i in range(root_end) if assignment(lines[i], key)]
    if found:
        lines[found[0]] = f"{key} = {value}\n"
        for i in reversed(found[1:]):
            del lines[i]
            root_end -= 1
    else:
        missing.append(f"{key} = {value}\n")
if missing:
    separator = ["\n"] if root_end < len(lines) else []
    lines[root_end:root_end] = missing + separator

tui = bounds("tui")
if tui:
    start, end = tui
    found = [i for i in range(start + 1, end) if assignment(lines[i], "notifications")]
    value = 'notifications = ["agent-turn-complete", "approval-requested"]\n'
    if found:
        lines[found[0]] = value
        for i in reversed(found[1:]):
            del lines[i]
    else:
        lines[end:end] = [value]
else:
    if lines and lines[-1].strip():
        lines.append("\n")
    lines.extend(["[tui]\n", 'notifications = ["agent-turn-complete", "approval-requested"]\n'])

serena = bounds("mcp_servers.serena")
if serena:
    start, end = serena
    command = next((i for i in range(start + 1, end) if assignment(lines[i], "command")), None)
    args_at = next((i for i in range(start + 1, end) if assignment(lines[i], "args")), None)
    if command is not None and args_at is None:
        lines[command + 1:command + 1] = ['args = ["--enable-web-dashboard", "false", "--open-web-dashboard", "false"]\n']
    elif command is not None:
        rhs = lines[args_at].split("=", 1)[1].lstrip()
        args_end = args_at + 1
        parsed = None
        while True:
            try:
                parsed = ast.literal_eval(rhs)
                break
            except (SyntaxError, ValueError):
                if args_end >= end:
                    break
                rhs += lines[args_end]
                args_end += 1
        if isinstance(parsed, list) and all(isinstance(value, str) for value in parsed):
            filtered = []
            i = 0
            flags = ("--enable-web-dashboard", "--open-web-dashboard")
            while i < len(parsed):
                value = parsed[i]
                if value in flags:
                    i += 2 if i + 1 < len(parsed) and not parsed[i + 1].startswith("--") else 1
                    continue
                if any(value.startswith(flag + "=") for flag in flags):
                    i += 1
                    continue
                filtered.append(value)
                i += 1
            filtered.extend(["--enable-web-dashboard", "false", "--open-web-dashboard", "false"])
            lines[args_at:args_end] = ["args = " + json.dumps(filtered, separators=(", ", ": ")) + "\n"]
        else:
            print("WARNING: Serena args are not a plain string array; leaving them unchanged", file=os.sys.stderr)

data = "".join(lines)
old = path.read_text() if path.exists() else None
if old != data:
    fd, temp = tempfile.mkstemp(dir=path.parent, prefix="config.toml.")
    try:
        with os.fdopen(fd, "w") as handle:
            handle.write(data)
        if path.exists():
            os.chmod(temp, path.stat().st_mode)
        os.replace(temp, path)
    finally:
        if os.path.exists(temp):
            os.unlink(temp)
PY
}

apply_config
echo "Codex runtime defaults: configured"
