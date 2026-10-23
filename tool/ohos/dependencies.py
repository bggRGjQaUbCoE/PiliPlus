#!/usr/bin/env python3
"""Prepare pinned OHOS package copies without modifying the source checkout.

Only an exported workspace with ohos/source-manifest.json is accepted.  The
root pubspec is retained apart from adding real OHOS implementations; overrides
live in pubspec_overrides.yaml.  Downloads are checked against the committed
archive digest or Git commit.  This is source preparation, not a HAP/device test.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import tempfile
from urllib.parse import unquote, urljoin, urlparse
from urllib.request import urlopen

import source_policy


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "dependencies.json"
PATCHES = HERE / "package_patches"
MATERIAL_PATCHES = (
    "modal_barrier_material.patch", "navigation_drawer.patch", "popup_menu.patch",
    "fab.patch", "text_field.patch", "scaffold.patch", "refresh_indicator.patch",
    "tabs.patch", "bottom_sheet_android.patch",
)


def _run(*args: str, cwd: Path | None = None) -> str:
    result = subprocess.run(args, cwd=cwd, check=False, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(f"{' '.join(args[:3])} failed:\n{result.stderr.strip()}")
    return result.stdout.strip()


def _guard(workspace: Path) -> Path:
    # The committed helper is deliberately loaded from inside its export.
    # Its location is not evidence that the target is a source checkout.
    workspace = Path(os.path.abspath(workspace))
    if any(path.is_symlink() for path in (workspace, *workspace.parents)):
        raise RuntimeError("Dependency preparation does not follow workspace symlinks")
    if (workspace / ".git").exists() or (workspace / ".git").is_symlink():
        raise RuntimeError("Dependency preparation must not run in the source checkout")
    required = ("ohos/source-manifest.json", "ohos/upstream-files.json", "ohos/build-profile.json5",
                "pubspec.yaml", "pubspec.lock")
    outputs = (".ohos-dependencies/prepared.json", ".dart_tool/package_config.json",
               "pubspec_overrides.yaml", "ohos/dependency-report.json", "ohos/source-pubspec-overrides.yaml")
    for relative in (*required, *outputs):
        target = workspace
        for part in Path(relative).parts:
            target /= part
            if target.is_symlink():
                raise RuntimeError(f"Dependency preparation does not follow symlinks: {relative}")
        if relative in required and not target.is_file():
            raise RuntimeError(f"Use ohos.py prepare first: exported file is missing: {relative}")
    source = json.loads((workspace / "ohos/source-manifest.json").read_text())
    if source.get("schema") != 1 or source.get("original_file_changes"):
        raise RuntimeError("The source manifest does not describe a preserved upstream export")
    for key in ("source_commit", "base_commit"):
        if not re.fullmatch(r"[0-9a-f]{40}", source.get(key, "")):
            raise RuntimeError(f"The source manifest has no complete {key}")
    return workspace


def _safe_extract(data: bytes, destination: Path) -> None:
    with tarfile.open(fileobj=io.BytesIO(data)) as archive:
        # Python 3.12's data filter also rejects links escaping the extraction root.
        if hasattr(tarfile, "data_filter"):
            def source_filter(member: tarfile.TarInfo, root: str):
                # audio_service's publishing-only .pubignore links to its
                # monorepo root; it is not a package/runtime build input.
                if member.name == ".pubignore" and member.issym():
                    return None
                return tarfile.data_filter(member, root)
            archive.extractall(destination, filter=source_filter)
        else:
            for member in archive.getmembers():
                target = (destination / member.name).resolve()
                if not target.is_relative_to(destination.resolve()) or member.issym() or member.islnk():
                    raise RuntimeError(f"Unsafe archive entry: {member.name}")
            archive.extractall(destination)


def _repository(source: dict, cache: Path) -> Path:
    commit = source["commit"]
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise RuntimeError("Every Git source must be pinned to a complete commit")
    repo = cache / "git" / commit
    if not repo.exists():
        repo.mkdir(parents=True)
        _run("git", "init", "--bare", "--quiet", str(repo))
    available = subprocess.run(
        ["git", "--git-dir", str(repo), "cat-file", "-e", f"{commit}^{{commit}}"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    ).returncode == 0
    if not available:
        _run("git", "--git-dir", str(repo), "fetch", "--quiet", "--depth=1", source["url"], commit)
    if _run("git", "--git-dir", str(repo), "rev-parse", f"{commit}^{{commit}}") != commit:
        raise RuntimeError("Git source does not match its pinned commit")
    return repo


def _git_tree(source: dict, cache: Path, relative: str, destination: Path) -> None:
    repo = _repository(source, cache)
    tree = source["commit"] + (f":{relative}" if relative not in ("", ".") else "")
    result = subprocess.run(["git", "--git-dir", str(repo), "archive", tree], capture_output=True)
    if result.returncode:
        raise RuntimeError(f"Cannot export pinned Git directory {relative}: {result.stderr.decode()}")
    destination.mkdir(parents=True, exist_ok=True)
    _safe_extract(result.stdout, destination)


def _hosted(spec: dict, cache: Path, destination: Path) -> None:
    digest = spec["sha256"]
    archive = cache / "archives" / f"{digest}.tar.gz"
    archive.parent.mkdir(parents=True, exist_ok=True)
    if archive.exists():
        data = archive.read_bytes()
    else:
        with urlopen(spec["url"], timeout=90) as response:
            data = response.read()
    if hashlib.sha256(data).hexdigest() != digest:
        raise RuntimeError(f"Archive digest mismatch: {spec['url']}")
    if not archive.exists():
        archive.write_bytes(data)
    destination.mkdir(parents=True)
    _safe_extract(data, destination)


def _section(text: str, key: str) -> tuple[int, int]:
    match = re.search(rf"(?m)^{re.escape(key)}:[^\n]*\n", text)
    if match is None:
        raise RuntimeError(f"pubspec section is missing: {key}")
    following = re.search(r"(?m)^[A-Za-z_][A-Za-z_0-9]*:", text[match.end():])
    return match.start(), match.end() + following.start() if following else len(text)


def _dependency(package: Path, name: str, value: str | dict | None) -> None:
    path = package / "pubspec.yaml"
    text = path.read_text()
    start, end = _section(text, "dependencies")
    block = text[start:end]
    # Values are JSON, a YAML subset, to avoid altering unrelated YAML structure.
    expression = rf"(?m)^  {re.escape(name)}:[^\n]*(?:\n(?:[ \t]{{4,}}[^\n]*|[ \t]*))*(?:\n|$)"
    block, count = re.subn(expression, "", block)
    if count > 1:
        raise RuntimeError(f"Duplicate dependency {name}")
    if value is not None:
        block = block.replace("dependencies:\n", f"dependencies:\n  {name}: {json.dumps(value)}\n", 1)
    path.write_text(text[:start] + block + text[end:])


def _environment(package: Path) -> None:
    path = package / "pubspec.yaml"
    text = path.read_text()
    start, end = _section(text, "environment")
    old = text[start:end]
    new = 'environment:\n  sdk: ">=3.12.0 <4.0.0"\n'
    if re.search(r"(?m)^  flutter:", old):
        new += '  flutter: ">=3.44.0"\n'
    path.write_text(text[:start] + new + "\n" + text[end:])


def _platform(package: Path, plugin: str, dart_plugin: str | None = None) -> None:
    path = package / "pubspec.yaml"
    text = path.read_text()
    if re.search(r"(?m)^      ohos:", text):
        if dart_plugin:
            text = re.sub(r"(?m)^      ohos:\n", f"      ohos:\n        dartPluginClass: {dart_plugin}\n", text, count=1)
    else:
        stanza = f"      ohos:\n        pluginClass: {plugin}\n"
        if dart_plugin:
            stanza += f"        dartPluginClass: {dart_plugin}\n"
        text, count = re.subn(r"(?m)^    platforms:\n", "    platforms:\n" + stanza, text, count=1)
        if count != 1:
            raise RuntimeError(f"Plugin platform registration missing in {package.name}")
    path.write_text(text)


def _apply(package: Path, patch: Path) -> None:
    for relative in re.findall(r"(?m)^\+\+\+ b/(.+)$", patch.read_text()):
        target = (package / relative).resolve()
        if not target.is_relative_to(package.resolve()):
            raise RuntimeError(f"Patch target escapes its package: {relative}")
        if target.is_file():
            # Some pub archives contain CRLF ArkTS.  Review patches use LF.
            data = target.read_bytes()
            if b"\r\n" in data:
                target.write_bytes(data.replace(b"\r\n", b"\n"))
    check = subprocess.run(["git", "apply", "--check", str(patch)], cwd=package, capture_output=True)
    if check.returncode == 0:
        _run("git", "apply", str(patch), cwd=package)
        return
    reverse = subprocess.run(["git", "apply", "--reverse", "--check", str(patch)], cwd=package, capture_output=True)
    if reverse.returncode:
        raise RuntimeError(f"Package patch drift: {patch.name}\n{check.stderr.decode()}")


def _overlay(package: Path, folder: str) -> None:
    source = PATCHES / folder
    if source.exists():
        shutil.copytree(source, package, dirs_exist_ok=True)


def _clean_native(package: Path) -> None:
    # Published examples can contain developer SDK paths.  They are not inputs
    # to a plugin HAP and must not be imported into this platform build.
    native = package / "ohos"
    if not native.exists():
        return
    for path in sorted(native.rglob("*"), key=lambda p: len(p.parts), reverse=True):
        if path.name in ("local.properties", "oh-package-lock.json5") or path.suffix in (".p12", ".p7b", ".cer"):
            path.unlink(missing_ok=True)
        elif path.is_dir() and path.name in (".ohpm", ".hvigor", "build", "oh_modules"):
            shutil.rmtree(path)


def _platform_cases(package: Path) -> int:
    changed = 0
    for path in (package / "lib").rglob("*.dart"):
        text = path.read_text()
        updated, n1 = re.subn(r"case TargetPlatform\.android:(?!\s*\n\s*case TargetPlatform\.ohos:)",
                              "case TargetPlatform.android:\n      case TargetPlatform.ohos:", text)
        updated, n2 = re.subn(r"TargetPlatform\.android\s*\|\|(?!\s*TargetPlatform\.ohos)",
                              "TargetPlatform.android || TargetPlatform.ohos ||", updated)
        updated, n3 = re.subn(r"TargetPlatform\.android(?!\s*(?:\|\||:))\s+=>",
                              "TargetPlatform.android || TargetPlatform.ohos =>", updated)
        if text != updated:
            path.write_text(updated)
        changed += n1 + n2 + n3
    return changed


def _nativeapi(package: Path) -> None:
    # The locked upstream ships a generated pure-Dart mirror of its public API.
    # Its OS operations throw; this preserves value types without a desktop C
    # build hook or fabricated successful window/tray operations on OHOS.
    (package / "lib/nativeapi.dart").write_text(
        "library;\nexport 'src/web/generated.dart';\nexport 'src/run_native_app_web.dart';\n"
    )
    path = package / "lib/src/web/unsupported.dart"
    text = path.read_text().replace(
        "nativeapi is not available on the web. Guard the call with kIsWeb.",
        "Desktop nativeapi operations are unavailable on OHOS. Guard calls with PlatformUtils.isDesktop.",
    )
    path.write_text(text)
    _dependency(package, "cnativeapi", None)


def _local_native_modules(workspace: Path, directory: Path, manifest: dict) -> list[dict]:
    # Flutter registers Pub plugins, but it does not discover a plugin's nested
    # source HAR. Hvigor needs this real module path to compile its code/routes.
    profile_path = workspace / "ohos/build-profile.json5"
    profile = json.loads(profile_path.read_text())
    modules = profile["modules"]
    registered = []
    for spec in manifest.get("native_modules", []):
        native = (directory / spec["package"] / spec["path"]).resolve()
        if not native.is_relative_to(directory.resolve()):
            raise RuntimeError(f"Native module escapes isolated dependencies: {spec['name']}")
        native_package = json.loads((native / "oh-package.json5").read_text())
        entry = (native / native_package["main"]).resolve()
        if native_package["name"] != spec["name"] or not entry.is_relative_to(native) or not entry.is_file():
            raise RuntimeError(f"Native module has no matching real package entry: {spec['name']}")
        module = {
            "name": spec["name"],
            "srcPath": Path(os.path.relpath(native, workspace / "ohos")).as_posix(),
            "targets": [{"name": "default", "applyToProducts": ["default"]}],
        }
        existing = [item for item in modules if item["name"] == spec["name"]]
        if existing and existing != [module]:
            raise RuntimeError(f"A different native module is already registered: {spec['name']}")
        if not existing:
            modules.append(module)
        registered.append(module)
    profile_path.write_text(json.dumps(profile, indent=2) + "\n")
    return registered


def _recipe_digest(workspace: Path) -> str:
    digest = hashlib.sha256()
    paths = [Path(__file__).resolve(), MANIFEST, *sorted(PATCHES.rglob("*"))]
    paths += [workspace / "lib/scripts/material" / name for name in MATERIAL_PATCHES]
    for path in paths:
        if path.is_file() and "__pycache__" not in path.parts:
            digest.update(path.name.encode())
            digest.update(b"\0")
            digest.update(path.read_bytes())
    return digest.hexdigest()


def _package_hashes(directory: Path) -> dict:
    # Pub/Flutter may generate caches and OHPM HAR links.  These receipts cover
    # all runtime Dart/native source, package manifests and our patches' inputs.
    included = {".dart", ".ets", ".ts", ".cpp", ".c", ".h", ".yaml"}
    return {
        path.relative_to(directory).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(directory.rglob("*"))
        if path.is_file() and path.suffix in included
        and not any(part in (".dart_tool", ".ohpm", ".hvigor", "oh_modules", "build") for part in path.relative_to(directory).parts)
    }


def _adapt_packages(workspace: Path, directory: Path, manifest: dict, cache: Path) -> dict:
    repositories = manifest["repositories"]
    def graft(name: str, repository: str, source: str, target: str = "ohos") -> None:
        _git_tree(repositories[repository], cache, source, directory / name / target)
    graft("audio_service", "audio_service_native", "audio_service/ohos")
    _platform(directory / "audio_service", "AudioServicePlugin")
    graft("audio_session", "audio_session_native", "ohos")
    graft("audio_session", "audio_session_native", "lib/src", ".ohos-source")
    shutil.copyfile(directory / "audio_session/.ohos-source/ohos.dart", directory / "audio_session/lib/src/ohos.dart")
    shutil.rmtree(directory / "audio_session/.ohos-source")
    _apply(directory / "audio_session", PATCHES / "audio-session-core.patch")
    _platform(directory / "audio_session", "AudioSessionPlugin")
    graft("native_device_orientation", "orientation_native", "ohos")
    _platform(directory / "native_device_orientation", "NativeDeviceOrientationPlugin")
    graft("image_cropper", "image_cropper_native", "image_cropper/ohos")
    _platform(directory / "image_cropper", "ImageCropperPlugin")
    graft("file_picker_ohos", "file_picker_native", "ohos/ohos")
    graft("file_picker_ohos", "file_picker_native", ".", ".origin-license")
    for name in ("LICENSE", "LICENSE.md"):
        origin = directory / "file_picker_ohos/.origin-license" / name
        if origin.is_file():
            shutil.copyfile(origin, directory / "file_picker_ohos" / name)
    shutil.rmtree(directory / "file_picker_ohos/.origin-license")
    _nativeapi(directory / "nativeapi")
    for name in ("connectivity_plus_ohos", "permission_handler_ohos", "share_plus_ohos", "file_picker_ohos"):
        _overlay(directory / name, name)
    for name, interface, version in (
        ("connectivity_plus_ohos", "connectivity_plus_platform_interface", "2.1.0"),
        ("device_info_plus_ohos", "device_info_plus_platform_interface", "8.1.0"),
        ("permission_handler_ohos", "permission_handler_platform_interface", "^4.4.1"),
        ("share_plus_ohos", "path_provider", "^2.1.5"),
    ):
        _dependency(directory / name, interface, version)
    # An old OHOS release accidentally declares lint rules as a runtime
    # dependency, conflicting with the application's own lint version.
    _dependency(directory / "device_info_plus_ohos", "flutter_lints", None)
    _platform(directory / "connectivity_plus_ohos", "ConnectivityPlusOhosPlugin", "ConnectivityPlusOhos")
    _platform(directory / "permission_handler_ohos", "PermissionHandlerOhosPlugin", "PermissionHandlerOhosAdapter")
    permission_library = directory / "permission_handler_ohos/lib/permission_handler_ohos.dart"
    permission_library.write_text("export 'permission_handler_ohos_adapter.dart';\n" + permission_library.read_text())
    for package, dependency, version in (
        ("flutter_inappwebview_ohos", "flutter_inappwebview_platform_interface", "1.3.0+1"),
        ("flutter_inappwebview_platform_interface", "flutter_inappwebview_internal_annotations", "1.1.1"),
    ):
        _dependency(directory / package, dependency, version)
    # This fork's unrelated localhost error-page change is not part of OHOS.
    # The original implementation is retained in the package overlay.
    for path in sorted(PATCHES.glob("*.patch")):
        if path.name == "audio-session-core.patch":
            continue
        package = path.name.split("--", 1)[0]
        _apply(directory / package, path)
    applied = []
    for name in MATERIAL_PATCHES:
        _apply(directory / "material_ui", workspace / "lib/scripts/material" / name)
        applied.append(name)
    cases = sum(_platform_cases(directory / name) for name in ("material_ui", "cupertino_ui"))
    for name in manifest["packages"]:
        _clean_native(directory / name)
    return {"upstream_material_patches": applied, "ohos_platform_arms": cases,
            "native_modules": _local_native_modules(workspace, directory, manifest)}


def dependency_inputs(workspace: Path, manifest: dict) -> dict:
    """Accept either the old lock or the explicitly approved integrated lock.

    Existing overrides are replaceable only when their exact source bytes and
    the retained OHOS recipe were both named in the approved source policy.
    """
    policy = source_policy.from_export(workspace)
    lock_digest = hashlib.sha256((workspace / "pubspec.lock").read_bytes()).hexdigest()
    override_path = workspace / "pubspec_overrides.yaml"
    result = {"mode": "addition-only", "source_lock_sha256": lock_digest,
              "source_overrides_sha256": None, "compatibility_decisions": []}
    expected = manifest["baseline_lock_sha256"]
    if policy is not None:
        approved = policy["dependencies"]
        if approved["recipe_sha256"] != hashlib.sha256(MANIFEST.read_bytes()).hexdigest():
            raise RuntimeError("OHOS dependency recipe differs from the approved integration policy")
        expected = approved["lock_sha256"]
        original_overrides = source_policy.safe_file(workspace, "pubspec_overrides.yaml").read_bytes()
        if hashlib.sha256(original_overrides).hexdigest() != approved["overrides_sha256"]:
            raise RuntimeError("Approved application dependency overrides changed")
        result.update(mode=source_policy.MODE, source_overrides_sha256=approved["overrides_sha256"],
                      retained_recipe_sha256=approved["recipe_sha256"],
                      compatibility_decisions=approved.get("compatibility_decisions", []))
    elif override_path.exists():
        raise RuntimeError("Refusing to overwrite an existing pubspec_overrides.yaml without an approved source policy")
    if lock_digest != expected:
        raise RuntimeError("The upstream lock changed; review dependencies against the approved source policy before preparing OHOS")
    return result


def write_overrides(workspace: Path, overrides: dict, inputs: dict) -> None:
    target = workspace / "pubspec_overrides.yaml"
    expected = inputs["source_overrides_sha256"]
    if expected is not None:
        original = source_policy.safe_file(workspace, "pubspec_overrides.yaml").read_bytes()
        if hashlib.sha256(original).hexdigest() != expected:
            raise RuntimeError("Approved application dependency overrides changed during preparation")
        # Preserve the exact input for the final build receipt and human review.
        with (workspace / "ohos/source-pubspec-overrides.yaml").open("xb") as stream:
            stream.write(original)
    elif target.exists() or target.is_symlink():
        raise RuntimeError("Refusing to overwrite an existing pubspec_overrides.yaml")
    target.write_text(json.dumps({"dependency_overrides": overrides}, indent=2) + "\n")


def prepare(workspace: Path, cache: Path | None = None) -> dict:
    workspace = _guard(workspace)
    manifest = json.loads(MANIFEST.read_text())
    directory = workspace / ".ohos-dependencies"
    marker = directory / "prepared.json"
    manifest_digest = hashlib.sha256(MANIFEST.read_bytes()).hexdigest()
    recipe_digest = _recipe_digest(workspace)
    if marker.exists():
        report = json.loads(marker.read_text())
        if report.get("recipe_sha256") != recipe_digest or report.get("package_source_sha256") != _package_hashes(directory):
            raise RuntimeError("Dependency recipe or prepared source changed; create a fresh exported workspace")
        return report
    if directory.exists():
        raise RuntimeError("Incomplete dependency directory exists; prepare a fresh export or remove only .ohos-dependencies")
    inputs = dependency_inputs(workspace, manifest)
    original_lock_digest = inputs["source_lock_sha256"]
    cache = (cache or Path(os.environ.get("PILIPLUS_OHOS_SOURCE_CACHE", workspace / ".ohos-source-cache"))).resolve()
    cache.mkdir(parents=True, exist_ok=True)
    directory.mkdir()
    for name, spec in manifest["packages"].items():
        if name == "cnativeapi":
            continue  # removed from nativeapi's OHOS-only dependency graph
        print(f"OHOS dependency: {name}", flush=True)
        destination = directory / name
        if spec["source"] == "hosted":
            _hosted(spec, cache, destination)
        elif spec["source"] == "git":
            _git_tree(manifest["repositories"][spec["repository"]], cache, spec["path"], destination)
        else:
            destination.mkdir()
        pubspec = destination / "pubspec.yaml"
        if pubspec.exists():
            # Published packages may retain a monorepo resolution declaration.
            text = re.sub(r"(?m)^resolution: workspace\s*\n", "", pubspec.read_text())
            pubspec.write_text(text)
            if spec.get("environment_compat"):
                _environment(destination)
    compatibility = _adapt_packages(workspace, directory, manifest, cache)
    overrides = dict(manifest["upstream_hosted_pins"])
    overrides.update(manifest.get("compatibility_pins", {}))
    overrides.update(manifest["upstream_git_pins"])
    for name, spec in manifest["packages"].items():
        if name == "cnativeapi":
            continue
        overrides[name] = {"path": f".ohos-dependencies/{name}"}
        if spec.get("direct"):
            _dependency(workspace, name, "any")
    write_overrides(workspace, overrides, inputs)
    media_bound = (workspace / "ohos/media-backend.json").is_file()
    report = {
        "schema": 1, "manifest_sha256": manifest_digest,
        "recipe_sha256": recipe_digest, "upstream_lock_sha256": original_lock_digest,
        "source_policy": inputs,
        "package_source_sha256": _package_hashes(directory),
        "status": "dependency-sources-prepared", "pub_get_passed": False,
        "hap_built": False, "device_validated": False,
        "packages": {name: spec for name, spec in manifest["packages"].items() if name != "cnativeapi"},
        "desktop_isolation": "nativeapi's upstream generated pure-Dart unsupported mirror; cnativeapi C hook removed from this graph",
        "deferred": {name: value for name, value in manifest["deferred"].items()
                     if name != "media_kit" or not media_bound},
        "device_validation_required": manifest["device_validation_required"], **compatibility,
    }
    marker.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    (workspace / "ohos/dependency-report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    return report


def patch(workspace: Path, pub_cache: Path) -> dict:
    """Verify that pub resolved all prepared overrides into this export.

    Package patches are applied before resolution.  This separate step provides
    the integration gate and deliberately does not mutate a global pub cache.
    """
    workspace = _guard(workspace)
    config_path = workspace / ".dart_tool/package_config.json"
    config = json.loads(config_path.read_text())
    expected = json.loads((workspace / ".ohos-dependencies/prepared.json").read_text())
    if expected.get("recipe_sha256") != _recipe_digest(workspace):
        raise RuntimeError("Dependency recipe changed after preparation; prepare a fresh export")
    if expected.get("package_source_sha256") != _package_hashes(workspace / ".ohos-dependencies"):
        raise RuntimeError("Prepared package runtime source changed after preparation")
    packages = {item["name"]: item for item in config["packages"]}
    checked = []
    for name in expected["packages"]:
        if name not in packages:
            raise RuntimeError(f"Resolved package is missing: {name}")
        uri = urljoin(config_path.as_uri(), packages[name]["rootUri"])
        actual = Path(unquote(urlparse(uri).path)).resolve()
        wanted = (workspace / ".ohos-dependencies" / name).resolve()
        if actual != wanted:
            raise RuntimeError(f"Package {name} resolves outside its isolated copy: {actual}")
        checked.append(name)
    if "cnativeapi" in packages:
        raise RuntimeError("Desktop cnativeapi unexpectedly re-entered the OHOS dependency graph")
    native_modules = json.loads((workspace / "ohos/build-profile.json5").read_text())["modules"]
    for module in expected.get("native_modules", []):
        if [item for item in native_modules if item["name"] == module["name"]] != [module]:
            raise RuntimeError(f"Prepared native module is missing or changed: {module['name']}")
    expected["status"] = "dependency-graph-resolved"
    expected["pub_get_passed"] = True
    expected["verified_local_packages"] = checked
    expected["pub_cache"] = str(pub_cache.resolve())
    (workspace / "ohos/dependency-report.json").write_text(json.dumps(expected, ensure_ascii=False, indent=2) + "\n")
    return expected


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    for command in ("prepare", "patch"):
        child = sub.add_parser(command)
        child.add_argument("--workspace", type=Path, required=True)
        child.add_argument("--cache", type=Path)
        child.add_argument("--pub-cache", type=Path)
    args = parser.parse_args()
    try:
        if args.command == "prepare":
            report = prepare(args.workspace, args.cache)
        else:
            if args.pub_cache is None:
                parser.error("patch requires --pub-cache")
            report = patch(args.workspace, args.pub_cache)
    except (OSError, ValueError, RuntimeError) as error:
        parser.exit(1, f"OHOS dependencies: {error}\n")
    print(json.dumps({"status": report["status"], "packages": len(report["packages"]), "hap_built": False}))


if __name__ == "__main__":
    main()
