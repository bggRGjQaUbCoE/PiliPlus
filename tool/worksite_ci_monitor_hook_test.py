import importlib.util
import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
HOOK = ROOT / ".codex" / "hooks" / "guard_ci_monitor.py"


def load_hook():
    spec = importlib.util.spec_from_file_location("guard_ci_monitor", HOOK)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class WorksiteCiMonitorHookTest(unittest.TestCase):
    def test_blocks_gh_run_watch_for_main_agent(self):
        hook = load_hook()

        self.assertTrue(hook.is_blocked_command("gh run watch 123 -R CometDash77/PiliAvalon-Worksite", "main-agent"))

    def test_allows_short_json_run_view_for_main_agent(self):
        hook = load_hook()

        self.assertFalse(
            hook.is_blocked_command(
                "gh run view 123 -R CometDash77/PiliAvalon-Worksite --json databaseId,status,conclusion",
                "main-agent",
            )
        )

    def test_allows_watch_for_monitor_agent(self):
        hook = load_hook()

        self.assertFalse(hook.is_blocked_command("gh run watch 123 --exit-status", "monitor-agent"))

    def test_blocks_open_ended_polling_loop(self):
        hook = load_hook()

        command = "while ($true) { gh run view 123 --json status; Start-Sleep 30 }"

        self.assertTrue(hook.is_blocked_command(command, "main-agent"))

    def test_blocks_follow_style_tail(self):
        hook = load_hook()

        self.assertTrue(hook.is_blocked_command("tail -f runtime-smoke.log", "main-agent"))


if __name__ == "__main__":
    unittest.main()
