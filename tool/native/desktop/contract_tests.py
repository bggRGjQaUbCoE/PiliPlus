#!/usr/bin/env python3
"""Contract tests with real ELF/PE files; no FFmpeg or LLVM product build."""
import ctypes
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build
import windows_recipe


class DesktopContracts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def test_global_source_vector_cannot_disagree_with_desktop_lock(self):
        lock_path = Path(__file__).with_name("desktop-sources.lock.json")
        lock = json.loads(lock_path.read_text())
        request = {"sources_lock": str(lock_path), "producer": lock["linux"]["recipe"],
                   "sources": lock["linux"]["sources"]}
        path = self.root / "request.json"
        path.write_text(json.dumps(request))
        build.load_inputs(path, "linux")
        request["sources"]["mpv"]["commit"] = "0" * 40
        path.write_text(json.dumps(request))
        with self.assertRaisesRegex(ValueError, "source locks disagree"):
            build.load_inputs(path, "linux")

    def test_windows_recipe_identity_is_checked(self):
        lock_path = Path(__file__).with_name("desktop-sources.lock.json")
        request = {"sources_lock": str(lock_path), "producer": {
            "repository": "Predidit/libmpv-win32-video-cmake", "commit": "0" * 40}}
        path = self.root / "request.json"
        path.write_text(json.dumps(request))
        with self.assertRaisesRegex(ValueError, "producer identity"):
            build.load_inputs(path, "windows")

    def test_git_pins_replace_tracking_branches_and_check_origin(self):
        text = '''ExternalProject_Add(example
    GIT_REPOSITORY https://github.com/example/project.git
    GIT_TAG main
    GIT_REMOTE_NAME origin
    UPDATE_COMMAND ""
)
'''
        pins = {"example": {"repository": "https://github.com/example/project.git",
                            "commit": "1" * 40}}
        result = windows_recipe.rewrite_git_pins(text, pins)
        self.assertIn("GIT_TAG " + "1" * 40, result)
        self.assertNotIn("GIT_TAG main", result)
        self.assertNotIn("GIT_REMOTE_NAME", result)
        pins["example"]["repository"] = "https://github.com/other/project.git"
        with self.assertRaisesRegex(ValueError, "Repository changed"):
            windows_recipe.rewrite_git_pins(text, pins)

    def elf_fixture(self):
        if not shutil.which("cc") or not shutil.which("patchelf"):
            self.skipTest("ELF fixture needs cc and patchelf")
        prefix = self.root / "prefix"
        lib = prefix / "lib"
        lib.mkdir(parents=True)
        (self.root / "dep.c").write_text("int fixture_dep(void) { return 41; }\n")
        (self.root / "main.c").write_text("extern int fixture_dep(void); int fixture(void) { return fixture_dep() + 1; }\n")
        subprocess.run(["cc", "-shared", "-fPIC", "-nostdlib", self.root / "dep.c",
                        "-Wl,-soname,libfixture-dep.so.1", "-o", lib / "libfixture-dep.so.1"], check=True)
        subprocess.run(["cc", "-shared", "-fPIC", "-nostdlib", self.root / "main.c",
                        lib / "libfixture-dep.so.1", "-Wl,-soname,libmpv.so.2", "-o", lib / "libmpv.so.2"], check=True)
        return prefix

    def test_transitive_elf_closure_survives_relocation(self):
        prefix = self.elf_fixture()
        output = self.root / "payload"
        output.mkdir()
        result = build.linux_bundle(prefix / "lib/libmpv.so.2", prefix, output)
        self.assertEqual(set(result["libraries"]), {"libmpv.so.2", "libfixture-dep.so.1"})
        relocated = self.root / "relocated"
        output.rename(relocated)
        shutil.rmtree(prefix)
        code = "import ctypes,sys; p=ctypes.CDLL(sys.argv[1]); assert p.fixture()==42"
        subprocess.run([sys.executable, "-c", code, relocated / "libmpv.so.2"], check=True,
                       env={k: v for k, v in os.environ.items() if k != "LD_LIBRARY_PATH"})

    def test_missing_elf_dependency_is_rejected(self):
        prefix = self.elf_fixture()
        (prefix / "lib/libfixture-dep.so.1").unlink()
        output = self.root / "payload"
        output.mkdir()
        with self.assertRaisesRegex(ValueError, "Unresolved runtime dependency"):
            build.linux_bundle(prefix / "lib/libmpv.so.2", prefix, output)

    def test_wrong_architecture_is_rejected_before_inventory(self):
        prefix = self.elf_fixture()
        path = prefix / "lib/libmpv.so.2"
        value = bytearray(path.read_bytes())
        value[18:20] = (183).to_bytes(2, "little")  # AArch64 ELF machine
        path.write_bytes(value)
        with self.assertRaisesRegex(ValueError, "x86_64 ELF"):
            build.assert_x64(path, "linux")

    def test_pe_closure_includes_non_system_imports(self):
        clang = shutil.which("clang") or shutil.which("clang-18")
        lld = shutil.which("ld.lld") or shutil.which("ld.lld-18")
        if not (clang and lld):
            self.skipTest("PE fixture needs clang and lld")
        (self.root / "dep.c").write_text('__declspec(dllexport) int fixture_dep(void) { return 7; } int fixture_entry(void) { return 1; }\n')
        (self.root / "main.c").write_text('__declspec(dllimport) int fixture_dep(void); __declspec(dllexport) int fixture(void) { return fixture_dep(); } int fixture_entry(void) { return 1; } void *__delayLoadHelper2(void *a, void *b) { return (void*)0; }\n')
        common = [clang, "--target=x86_64-w64-windows-gnu", "-fuse-ld=" + lld,
                  "-shared", "-nostdlib", "-Wl,--entry,fixture_entry"]
        subprocess.run([*common, self.root / "dep.c", "-Wl,--out-implib," + str(self.root / "fixture.a"),
                        "-o", self.root / "fixture.dll"], check=True)
        subprocess.run([*common, self.root / "main.c", self.root / "fixture.a",
                        "-o", self.root / "libmpv-2.dll"], check=True)
        subprocess.run([*common, self.root / "main.c", self.root / "fixture.a",
                        "-Wl,--delayload=fixture.dll", "-o", self.root / "delay.dll"], check=True)
        self.assertEqual(build.pe_needed(self.root / "delay.dll"), ["fixture.dll"])
        output = self.root / "payload"
        output.mkdir()
        result = build.windows_bundle(self.root / "libmpv-2.dll", [self.root], output)
        self.assertEqual(set(result["libraries"]), {"libmpv-2.dll", "fixture.dll"})
        (self.root / "fixture.dll").unlink()
        shutil.rmtree(output)
        output.mkdir()
        with self.assertRaisesRegex(ValueError, "Unresolved PE import"):
            build.windows_bundle(self.root / "libmpv-2.dll", [self.root], output)


if __name__ == "__main__":
    unittest.main(verbosity=2)
