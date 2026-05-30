#!/usr/bin/env python3
import json
import os
import re
import shlex
import sys


MONITOR_ROLES = {"monitor-agent", "ci-monitor", "delegated-ci-observer"}
POLLING_RE = re.compile(
    r"\b(while|for)\b.*\b(gh\s+(run\s+(view|list)|api)|build\s+logs?|runtime-smoke)\b",
    re.IGNORECASE | re.DOTALL,
)
SLEEP_POLL_RE = re.compile(
    r"\b(Start-Sleep|sleep)\b.*\b(gh\s+(run\s+(view|list)|api)|build\s+logs?|runtime-smoke)\b",
    re.IGNORECASE | re.DOTALL,
)


def _tokens(command):
    try:
        return shlex.split(command, posix=False)
    except ValueError:
        return command.split()


def _normalized(command):
    return " ".join(_tokens(command)).lower()


def is_monitor_role(role):
    return (role or "").strip().lower() in MONITOR_ROLES


def is_blocked_command(command, role):
    if is_monitor_role(role):
        return False

    normalized = _normalized(command)

    if re.search(r"\bgh\s+run\s+watch\b", normalized):
        return True
    if re.search(r"\btail\s+-(?:[a-z]*f|f[a-z]*)\b", normalized):
        return True
    if POLLING_RE.search(command) or SLEEP_POLL_RE.search(command):
        return True
    if "watch" in normalized and re.search(r"\bgh\s+(run\s+(view|list)|api)\b", normalized):
        return True

    return False


def _extract_command(payload):
    if isinstance(payload, dict):
        tool_input = payload.get("tool_input")
        if isinstance(tool_input, dict):
            return tool_input.get("command") or ""
        return payload.get("command") or payload.get("cmd") or ""
    return ""


def main():
    role = os.environ.get("WORKSITE_AGENT_ROLE") or os.environ.get("CODEX_AGENT_ROLE") or "main-agent"
    raw = sys.stdin.read()
    command = raw

    if raw.strip().startswith("{"):
        try:
            command = _extract_command(json.loads(raw))
        except json.JSONDecodeError:
            command = raw

    if is_blocked_command(command, role):
        print(
            "Blocked by worksite CI monitor policy: main agents must delegate long-running CI monitors. "
            "Allowed alternatives: short gh run list/view --json snapshots, or set WORKSITE_AGENT_ROLE=monitor-agent "
            "for an explicitly delegated monitor.",
            file=sys.stderr,
        )
        return 2

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
