#!/usr/bin/env python3
"""Build the selected platform and collect an installable/bundle artifact."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import plistlib
import subprocess
import sys
import tarfile
import zipfile

ROOT = Path(__file__).resolve().parents[2]


def run(*args, cwd=ROOT, env=None):
    print("+ " + " ".join(map(str, args)), flush=True)
    command = list(map(str, args))
    command[0] = shutil.which(command[0]) or command[0]
    subprocess.run(command, cwd=cwd, env=env, check=True)


def one(paths, description):
    result = list(paths)
    if len(result) != 1:
        raise ValueError("Expected one " + description + ", got " + str(len(result)))
    return result[0]


def build(platform, output):
    env = os.environ.copy()
    # patch.ps1 treats GITHUB_WORKSPACE as the application root. Keep the two
    # repository checkouts as siblings for committed pubspec_overrides.yaml.
    env["GITHUB_WORKSPACE"] = str(ROOT)
    if platform == "ohos":
        temp = Path(os.environ["RUNNER_TEMP"])
        sdk, exported, cache = temp / "piliplus-flutter-ohos", temp / "PiliPlus-ohos-build", temp / "piliplus-ohos-pub-cache"
        env.update({"PUB_CACHE": str(cache), "PILIPLUS_MEDIA_KIT_ROOT": str(ROOT.parent / "media-kit"),
            "PILIPLUS_OHOS_FLUTTER_ROOT": str(sdk), "PILIPLUS_OHOS_BUILD": str(exported)})
        policy = ROOT / "tool/ohos/approved_integration.json"
        lock = json.loads((ROOT / "tool/native/inputs.lock.json").read_text())
        policy_sha = lock["platforms"]["ohos"]["application_source_policy_sha256"]
        with policy.open("rb") as source:
            if hashlib.file_digest(source, "sha256").hexdigest() != policy_sha:
                raise ValueError("OHOS source policy differs from the reviewed application lock")
        policy_args = ("--source-policy", "approved-integration", "--source-policy-sha256", policy_sha)
        run(sys.executable, "tool/ohos/ohos.py", "check-source", *policy_args, env=env)
        run(sys.executable, "-m", "unittest", "discover", "-s", "tool/ohos", "-p", "test_*.py", "-v", env=env)
        run(sys.executable, "tool/ohos/prepare_sdk.py", "--flutter-root", sdk, "--pub-cache", cache, env=env)
        run(sys.executable, "tool/ohos/ohos.py", "doctor", "--flutter", sdk / "bin/flutter", env=env)
        run(sys.executable, "tool/ohos/ohos.py", "prepare-build", "--output", exported, *policy_args, env=env)
        run(sys.executable, exported / "tool/ohos/build.py", "--workspace", exported,
            "--flutter-root", sdk, "--pub-cache", cache, env=env)
        run(sys.executable, "tool/ohos/ohos.py", "check-source", *policy_args, env=env)
        shutil.copy2(exported / "build/ohos/hap/entry-default-unsigned.hap", output / "PiliPlus-ohos-arm64-unsigned.hap")
        return
    if platform in ("linux", "windows"):
        run(sys.executable, ROOT / "tool/native/check_api.py", "--platform", platform,
            "--media-kit", ROOT.parent / "media-kit", "--output", output / "native-api-check.json", env=env)
    run("pwsh", "-NoLogo", "-NoProfile", "-File", "lib/scripts/build.ps1", platform, env=env)
    run("pwsh", "-NoLogo", "-NoProfile", "-File", "lib/scripts/patch.ps1", platform, env=env)
    common = ("--release", "--dart-define-from-file=pili_release.json", "--no-pub")
    if platform == "android":
        # The selected four-ABI native profile is compiled for API 26. Never
        # advertise an APK minimum below its native library's deployment target.
        lock = json.loads((ROOT / "tool/native/inputs.lock.json").read_text())
        api = lock["platforms"]["android"]["source"]["toolchain"]["android_api"]
        gradle = ROOT / "android/app/build.gradle.kts"
        original = gradle.read_text()
        needle = "minSdk = flutter.minSdkVersion"
        ndk_needle = "ndkVersion = flutter.ndkVersion"
        if original.count(needle) != 1 or original.count(ndk_needle) != 1:
            raise ValueError("Review the changed Android SDK declarations before building")
        ndk = lock["platforms"]["android"]["source"]["toolchain"]["ndk"]
        adapted = original.replace(needle, f"minSdk = maxOf(flutter.minSdkVersion, {api})")
        gradle.write_text(adapted.replace(ndk_needle, 'ndkVersion = "' + ndk + '"'))
        run("flutter", "build", "apk", *common, "--split-per-abi", env=env)
        paths = list((ROOT / "build/app/outputs/flutter-apk").glob("app-*-release.apk"))
        expected = {"app-arm64-v8a-release.apk", "app-armeabi-v7a-release.apk", "app-x86_64-release.apk"}
        if {p.name for p in paths} != expected:
            raise ValueError("Android APK architecture coverage differs from the supported App targets")
        for path in paths:
            shutil.copy2(path, output / path.name.replace("app-", "PiliPlus-"))
    elif platform == "windows":
        run("flutter", "build", "windows", *common, env=env)
        bundle = ROOT / "build/windows/x64/runner/Release"
        if not list(bundle.glob("*.exe")):
            raise ValueError("Windows executable is missing")
        with zipfile.ZipFile(output / "PiliPlus-windows-x86_64.zip", "w", zipfile.ZIP_DEFLATED) as archive:
            for path in sorted(bundle.rglob("*")):
                if path.is_file():
                    archive.write(path, path.relative_to(bundle))
    elif platform == "linux":
        run("flutter", "build", "linux", *common, env=env)
        bundle = ROOT / "build/linux/x64/release/bundle"
        if not bundle.is_dir():
            raise ValueError("Linux bundle is missing")
        for library in (bundle / "lib").glob("*.so*"):
            check = subprocess.run(["ldd", str(library)], capture_output=True, text=True, check=True)
            if "not found" in check.stdout + check.stderr:
                raise ValueError("Unresolved runtime dependency in " + str(library) + ": " + check.stdout)
        (output / "INSTALL.txt").write_text(
            "Extract the archive and run PiliPlus/piliplus.\n"
            "This Ubuntu 24.04 build requires compatible GTK3, WebKit2GTK4.1, graphics, font and audio libraries.\n"
            "The native package dependency evidence records libmpv's required system SONAMEs.\n"
            "Compilation and dependency resolution were checked; device playback was not exercised by this workflow.\n")
        with tarfile.open(output / "PiliPlus-linux-x86_64.tar.gz", "w:gz") as archive:
            archive.add(bundle, arcname="PiliPlus")
    elif platform == "macos":
        run("flutter", "build", "macos", *common, env=env)
        bundle = one((ROOT / "build/macos/Build/Products/Release").glob("*.app"), "macOS application")
        metadata = plistlib.loads((bundle / "Contents/Info.plist").read_bytes())
        architectures = subprocess.check_output(["lipo", "-archs", str(bundle / "Contents/MacOS" / metadata["CFBundleExecutable"])], text=True).split()
        if set(architectures) != {"arm64", "x86_64"}:
            raise ValueError("The macOS application must include both supported architectures")
        run("ditto", "-c", "-k", "--sequesterRsrc", "--keepParent", bundle, output / "PiliPlus-macos-universal.zip", env=env)
    elif platform == "ios":
        run("flutter", "build", "ios", *common, "--no-codesign", env=env)
        bundle = ROOT / "build/ios/iphoneos/Runner.app"
        for framework in sorted((bundle / "Frameworks").glob("*.framework")):
            run("codesign", "--force", "--sign", "-", "--preserve-metadata=identifier,entitlements", framework, env=env)
        stage = output.parent / "ios-package"
        (stage / "Payload").mkdir(parents=True)
        shutil.copytree(bundle, stage / "Payload/Runner.app", symlinks=True)
        run("zip", "-r", "-y", output / "PiliPlus-ios-unsigned.ipa", "Payload", cwd=stage, env=env)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=("android", "windows", "linux", "ios", "macos", "ohos"), required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    log = Path(os.environ.get("RUNNER_TEMP", str(output.parent))) / "application-build.log"
    # Mirror subprocess output using the same interpreter, preserving its exit
    # status instead of letting a shell pipeline hide build failures.
    if not os.environ.get("PILIPLUS_BUILD_LOG_CHILD"):
        env = dict(os.environ, PILIPLUS_BUILD_LOG_CHILD="1")
        output.rmdir()
        with log.open("w", encoding="utf-8") as destination:
            process = subprocess.Popen([sys.executable, __file__, *sys.argv[1:]], env=env,
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
            for line in process.stdout:
                destination.write(line)
                destination.flush()
                print(line, end="", flush=True)
            raise SystemExit(process.wait())
    build(args.platform, output)


if __name__ == "__main__":
    main()
