import importlib.util
import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
HELPER = ROOT / ".github" / "scripts" / "android_runtime_smoke_launch.py"
SMOKE_SCRIPT = ROOT / ".github" / "scripts" / "android_runtime_smoke.sh"
WORKFLOW = ROOT / ".github" / "workflows" / "android_runtime_smoke.yml"


def load_helper():
    spec = importlib.util.spec_from_file_location("android_runtime_smoke_launch", HELPER)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class RuntimeSmokeLaunchTest(unittest.TestCase):
    def test_dev_package_fallback_uses_real_activity_class(self):
        helper = load_helper()

        component = helper.resolve_launcher_component(
            package_name="com.example.piliplus.dev",
            resolved_launcher="",
            manifest_package="com.example.piliplus",
            manifest_activity=".MainActivity",
        )

        self.assertEqual(component, "com.example.piliplus.dev/com.example.piliplus.MainActivity")

    def test_default_package_fallback_still_launches_main_activity(self):
        helper = load_helper()

        component = helper.resolve_launcher_component(
            package_name="com.example.piliplus",
            resolved_launcher="",
            manifest_package="com.example.piliplus",
            manifest_activity=".MainActivity",
        )

        self.assertEqual(component, "com.example.piliplus/com.example.piliplus.MainActivity")

    def test_package_manager_resolution_is_preferred(self):
        helper = load_helper()

        component = helper.resolve_launcher_component(
            package_name="com.example.piliplus.dev",
            resolved_launcher="component=com.example.piliplus.dev/com.example.piliplus.MainActivity",
            manifest_package="wrong.package",
            manifest_activity=".WrongActivity",
        )

        self.assertEqual(component, "com.example.piliplus.dev/com.example.piliplus.MainActivity")

    def test_missing_launcher_activity_fails_clearly(self):
        helper = load_helper()

        with self.assertRaisesRegex(ValueError, "launcher activity"):
            helper.resolve_launcher_component(
                package_name="com.example.piliplus.dev",
                resolved_launcher="",
                manifest_package="com.example.piliplus",
                manifest_activity="",
            )

    def test_smoke_script_no_longer_hardcodes_relative_main_activity(self):
        script = SMOKE_SCRIPT.read_text(encoding="utf-8")

        self.assertNotIn('${PACKAGE_NAME}/.MainActivity', script)
        self.assertIn("android_runtime_smoke_launch.py", script)

    def test_workflow_tracks_launch_helper_changes(self):
        workflow = WORKFLOW.read_text(encoding="utf-8")

        self.assertIn(".github/scripts/android_runtime_smoke_launch.py", workflow)


if __name__ == "__main__":
    unittest.main()
