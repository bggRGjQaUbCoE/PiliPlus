#!/usr/bin/env python3
import sys


REMINDERS = {
    "SessionStart": (
        "Worksite language policy: use professional English for internal "
        "worksite records, Reasonix artifacts, Codex reviews, hooks, handoffs, "
        "and implementation notes. Keep user-facing decision reports in Chinese."
    ),
    "UserPromptSubmit": (
        "Before writing any report, handoff, or prompt package, declare its "
        "audience as agent-facing, user-facing, or dual-use. Preserve raw user "
        "feedback in its original language and label it as raw user feedback."
    ),
    "Stop": (
        "Stop-event language check: verify each report, handoff, and prompt "
        "package matches its audience classification: English for agent-facing, "
        "Chinese for user-facing, and Chinese decision summary plus English "
        "technical body for dual-use."
    ),
}


def main():
    event = sys.argv[1] if len(sys.argv) > 1 else "SessionStart"
    print(REMINDERS.get(event, REMINDERS["SessionStart"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
