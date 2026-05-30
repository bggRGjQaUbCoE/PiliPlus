#!/usr/bin/env python3
import argparse
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ANDROID_NS = "{http://schemas.android.com/apk/res/android}"


def normalize_activity_name(package_name, manifest_package, activity_name):
    if not activity_name:
        raise ValueError("launcher activity is missing")
    if activity_name.startswith("."):
        if not manifest_package:
            raise ValueError("manifest package is required for relative launcher activity")
        return f"{manifest_package}{activity_name}"
    if "." not in activity_name:
        if not manifest_package:
            raise ValueError("manifest package is required for unqualified launcher activity")
        return f"{manifest_package}.{activity_name}"
    return activity_name


def parse_manifest_launcher(manifest_path):
    tree = ET.parse(manifest_path)
    root = tree.getroot()
    manifest_package = root.attrib.get("package", "")

    for activity in root.findall(".//activity"):
        activity_name = activity.attrib.get(f"{ANDROID_NS}name", "")
        for intent_filter in activity.findall("intent-filter"):
            has_main = any(
                action.attrib.get(f"{ANDROID_NS}name") == "android.intent.action.MAIN"
                for action in intent_filter.findall("action")
            )
            has_launcher = any(
                category.attrib.get(f"{ANDROID_NS}name") == "android.intent.category.LAUNCHER"
                for category in intent_filter.findall("category")
            )
            if has_main and has_launcher:
                return manifest_package, activity_name

    return manifest_package, ""


def parse_resolved_launcher(output, package_name):
    candidates = []
    patterns = (
        r"component=([A-Za-z0-9_.]+/[A-Za-z0-9_.$]+)",
        r"name=([A-Za-z0-9_.]+/[A-Za-z0-9_.$]+)",
        r"([A-Za-z0-9_.]+/[A-Za-z0-9_.$]+)",
    )

    for pattern in patterns:
        candidates.extend(re.findall(pattern, output or ""))

    for component in candidates:
        if component.startswith(f"{package_name}/"):
            return component

    return ""


def resolve_launcher_component(package_name, resolved_launcher, manifest_package, manifest_activity):
    if not package_name:
        raise ValueError("package name is required")

    resolved_component = parse_resolved_launcher(resolved_launcher, package_name)
    if resolved_component:
        return resolved_component

    class_name = normalize_activity_name(package_name, manifest_package, manifest_activity)
    return f"{package_name}/{class_name}"


def query_launcher(package_name):
    result = subprocess.run(
        [
            "adb",
            "shell",
            "cmd",
            "package",
            "resolve-activity",
            "--brief",
            "-a",
            "android.intent.action.MAIN",
            "-c",
            "android.intent.category.LAUNCHER",
            "-p",
            package_name,
        ],
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    return result.stdout


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--package-name", required=True)
    parser.add_argument("--manifest", default="android/app/src/main/AndroidManifest.xml")
    parser.add_argument("--resolved-launcher", default=None)
    parser.add_argument("--resolved-output-file", default=None)
    args = parser.parse_args(argv)

    manifest_package, manifest_activity = parse_manifest_launcher(Path(args.manifest))
    resolved_launcher = args.resolved_launcher
    if resolved_launcher is None:
        resolved_launcher = query_launcher(args.package_name)

    if args.resolved_output_file:
        Path(args.resolved_output_file).write_text(resolved_launcher or "", encoding="utf-8")

    component = resolve_launcher_component(
        package_name=args.package_name,
        resolved_launcher=resolved_launcher,
        manifest_package=manifest_package,
        manifest_activity=manifest_activity,
    )
    print(component)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"launcher resolution failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
