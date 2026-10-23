#!/usr/bin/env python3
"""Freeze and prepare the audited Predidit Windows source recipe.

The default build never resolves branches.  `freeze` is a separate maintenance
operation which produces reviewable inputs for a subsequent build.
"""
from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import urllib.request

RECIPE_REPOSITORY = "https://github.com/Predidit/libmpv-win32-video-cmake.git"
RECIPE_COMMIT = "fdf75129fc694b5ca555ce73cffc43bb6943ae13"
ROOT_TARGETS = ["llvm", "llvm-clang", "mpv"]
CMAKE_VERSION = "3.31.6"


def run(args, cwd=None):
    result = subprocess.run([str(x) for x in args], cwd=cwd, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            check=False, timeout=180)
    if result.returncode:
        raise RuntimeError(f"Command failed ({result.returncode}): {args}\n{result.stderr}")
    return result.stdout.strip()


def download(url: str, destination: Path, sha256: str | None = None):
    destination.parent.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(url, timeout=90) as response:
        with destination.open("wb") as stream:
            shutil.copyfileobj(response, stream)
    digest = hashlib.sha256(destination.read_bytes()).hexdigest()
    if sha256 and digest != sha256:
        destination.unlink()
        raise ValueError(f"Download checksum mismatch: {url}")
    return digest


def resolve(repository: str, ref: str) -> str:
    if re.fullmatch(r"[0-9a-f]{40}", ref):
        return ref
    refs = [ref, f"refs/heads/{ref}", f"refs/tags/{ref}", f"refs/tags/{ref}^{{}}"]
    output = run(["git", "ls-remote", "--exit-code", repository, *refs])
    values = dict(line.split()[::-1] for line in output.splitlines())
    for candidate in (f"refs/tags/{ref}^{{}}", f"refs/heads/{ref}",
                      f"refs/tags/{ref}", ref):
        if candidate in values:
            return values[candidate]
    raise ValueError(f"Cannot resolve {repository} at {ref!r}")


EP_HELPER = r'''
if(NOT CMAKE_VERSION VERSION_EQUAL "3.31.6")
  message(FATAL_ERROR "The frozen recipe requires CMake 3.31.6")
endif()
set(_vendored_ep "${CMAKE_BINARY_DIR}/frozen-cmake")
if(NOT EXISTS "${_vendored_ep}/Modules/ExternalProject.cmake")
  file(MAKE_DIRECTORY "${_vendored_ep}/Modules")
  file(COPY "${CMAKE_ROOT}/Modules/ExternalProject.cmake"
            "${CMAKE_ROOT}/Modules/ExternalProject"
       DESTINATION "${_vendored_ep}/Modules")
  execute_process(COMMAND patch -p1 -i
    "${CMAKE_SOURCE_DIR}/packages/cmake-0001-ExternalProject-changes.patch"
    WORKING_DIRECTORY "${_vendored_ep}" RESULT_VARIABLE _patch_result)
  if(NOT _patch_result EQUAL 0)
    message(FATAL_ERROR "Cannot apply the audited ExternalProject patch")
  endif()
endif()
include("${_vendored_ep}/Modules/ExternalProject.cmake")
'''

# No post-install reset to @{u}, cleanup, force-update or incidental fetch.
# Retaining build directories also preserves config.h and linker evidence.
CUSTOM_STEPS = '''function(cleanup _name _last_step)\nendfunction()\n
function(force_rebuild_git _name)\nendfunction()\n
function(force_meson_configure _name)\nendfunction()\n'''

METADATA = r'''
file(WRITE "${CMAKE_BINARY_DIR}/source-inputs.tsv" "")
foreach(_dir toolchain packages)
  get_property(_targets DIRECTORY "${CMAKE_SOURCE_DIR}/${_dir}" PROPERTY BUILDSYSTEM_TARGETS)
  foreach(_target IN LISTS _targets)
    get_property(_ep TARGET "${_target}" PROPERTY _EP_IS_EXTERNAL_PROJECT)
    if(_ep)
      foreach(_field GIT_REPOSITORY GIT_TAG URL URL_HASH DEPENDS SOURCE_DIR)
        get_property(_${_field} TARGET "${_target}" PROPERTY _EP_${_field})
      endforeach()
      file(APPEND "${CMAKE_BINARY_DIR}/source-inputs.tsv"
        "${_target}\t${_GIT_REPOSITORY}\t${_GIT_TAG}\t${_URL}\t${_URL_HASH}\t${_DEPENDS}\t${_SOURCE_DIR}\n")
    endif()
  endforeach()
endforeach()
'''


def rewrite_git_pins(text: str, pins: dict) -> str:
    """Only rewrite literal repository declarations in the audited recipe."""
    def replace(match):
        name, body = match.group(1), match.group(2)
        repo = re.search(r"(?m)^\s*GIT_REPOSITORY\s+(\S+)", body)
        if not repo or name not in pins:
            return match.group(0)
        pin = pins[name]
        if repo.group(1) != pin["repository"]:
            raise ValueError(f"Repository changed for Windows dependency {name}")
        if not re.fullmatch(r"[0-9a-f]{40}", pin["commit"]):
            raise ValueError(f"Windows dependency {name} is not commit locked")
        body = re.sub(r"(?m)^\s*GIT_TAG\s+\S+\s*$", "", body)
        body = re.sub(r"(?m)^\s*GIT_REMOTE_NAME\s+\S+\s*$", "", body)
        return f"ExternalProject_Add({name}\n    GIT_TAG {pin['commit']}\n{body})"
    # All audited ExternalProject_Add bodies close at column zero.  Reject a
    # future recipe rather than silently broadening this controlled transform.
    return re.sub(r"ExternalProject_Add\(([^\s()]+)(.*?\n)\)", replace,
                  text, flags=re.S)


def prepare(recipe: Path, work: Path, pins: dict | None = None):
    if run(["git", "rev-parse", "HEAD"], recipe) != RECIPE_COMMIT:
        raise ValueError("Windows recipe does not match the audited commit")
    if run(["git", "status", "--porcelain"], recipe):
        raise ValueError("Windows recipe checkout must be clean before adaptation")
    (recipe / "cmake/download_externalproject.cmake").write_text(EP_HELPER)
    (recipe / "cmake/custom_steps.cmake").write_text(CUSTOM_STEPS)
    cmakelists = recipe / "packages/CMakeLists.txt"
    original = cmakelists.read_text()
    modified = re.sub(r"(?m)^\s*(mpv-release|mpv-packaging)\s*$", "", original)
    if original == modified:
        raise ValueError("Audited Windows package list has changed")
    cmakelists.write_text(modified)
    cppwinrt = recipe / "toolchain/cppwinrt.cmake"
    original = cppwinrt.read_text()
    modified = original.replace(
        "${EXEC} wget -O <BINARY_DIR>/Windows.winmd https://github.com/microsoft/windows-rs/raw/master/crates/libs/default/Windows.winmd",
        '${CMAKE_COMMAND} -E copy "${PILIPLUS_WINDOWS_WINMD}" <BINARY_DIR>/Windows.winmd')
    if original == modified:
        raise ValueError("Audited Windows.winmd download has changed")
    cppwinrt.write_text(modified)
    top = recipe / "CMakeLists.txt"
    text = top.read_text()
    text = text.replace("set(MAKEJOBS ${CPU_COUNT})", "set(MAKEJOBS ${PILIPLUS_JOBS})")
    top.write_text(text)
    if pins:
        for path in recipe.rglob("*.cmake"):
            if ".git" not in path.parts:
                path.write_text(rewrite_git_pins(path.read_text(), pins))
    with (recipe / "CMakeLists.txt").open("a") as stream:
        stream.write(METADATA)


def configure(recipe: Path, work: Path, cmake="cmake", jobs=2):
    build = work / "build"
    toolchain = work / "toolchain"
    prefix = work / "prefix"
    args = [cmake, "-G", "Ninja", "-S", recipe, "-B", build,
            "-DTARGET_ARCH=x86_64-w64-mingw32", "-DGCC_ARCH=x86-64",
            "-DCOMPILER_TOOLCHAIN=clang", "-DENABLE_CCACHE=OFF",
            "-DCLANG_PACKAGES_LTO=ON", f"-DMAKEJOBS={jobs}", f"-DPILIPLUS_JOBS={jobs}",
            f"-DCMAKE_INSTALL_PREFIX={toolchain}",
            f"-DMINGW_INSTALL_PREFIX={prefix}",
            f"-DSINGLE_SOURCE_LOCATION={work / 'sources'}",
            f"-DRUSTUP_LOCATION={work / 'unused-rustup'}",
            f"-DPILIPLUS_WINDOWS_WINMD={work / 'Windows.winmd'}"]
    print(run(args), file=sys.stderr)
    entries = {}
    for line in (build / "source-inputs.tsv").read_text().splitlines():
        name, repository, ref, url, url_hash, depends, source_dir = line.split("\t")
        entries[name] = dict(repository=repository, ref=ref or "master", url=url,
                             url_hash=url_hash, depends=depends.split(";") if depends else [],
                             source_dir=source_dir)
    closure = set()
    pending = ROOT_TARGETS.copy()
    while pending:
        name = pending.pop()
        if name in closure:
            continue
        if name not in entries:
            raise ValueError(f"Undeclared Windows build dependency {name}")
        closure.add(name)
        pending.extend(entries[name]["depends"])
    if "rustup" in closure:
        raise ValueError("This profile unexpectedly requires floating Rust bootstrap")
    return {name: entries[name] for name in sorted(closure)}


def freeze(recipe: Path, work: Path, cmake: str, output: Path):
    prepare(recipe, work)
    entries = configure(recipe, work, cmake)
    def freeze_entry(item):
        name, value = item
        if value["repository"]:
            sha = resolve(value["repository"], value["ref"])
            print(f"Frozen {name}: {sha}", file=sys.stderr, flush=True)
            return name, {"repository": value["repository"], "commit": sha,
                          "resolved_ref": value["ref"]}
        if value["url"]:
            algorithm, expected = value["url_hash"].split("=", 1)
            target = work / "downloads" / name
            sha = download(value["url"], target)
            actual = hashlib.new(algorithm.lower(), target.read_bytes()).hexdigest()
            if actual.lower() != expected.lower():
                raise ValueError(f"Upstream archive hash mismatch: {name}")
            return name, {"url": value["url"], "sha256": sha,
                          "recipe_hash": value["url_hash"]}
        return name, None
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as executor:
        results = list(executor.map(freeze_entry, entries.items()))
    git = {k: v for k, v in results if v and "repository" in v}
    archives = {k: v for k, v in results if v and "url" in v}
    winmd_repo = "https://github.com/microsoft/windows-rs.git"
    winmd_commit = resolve(winmd_repo, "master")
    winmd_url = f"https://raw.githubusercontent.com/microsoft/windows-rs/{winmd_commit}/crates/libs/default/Windows.winmd"
    winmd_sha = download(winmd_url, work / "Windows.winmd")
    value = {"recipe": {"repository": RECIPE_REPOSITORY, "commit": RECIPE_COMMIT},
             "cmake_version": CMAKE_VERSION, "targets": ROOT_TARGETS,
             "git": git, "archives": archives,
             "closure": sorted(entries),
             "windows_winmd": {"repository": winmd_repo, "commit": winmd_commit,
                               "url": winmd_url, "sha256": winmd_sha}}
    output.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["freeze"])
    parser.add_argument("--recipe", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--cmake", default="cmake")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    freeze(args.recipe.resolve(), args.work.resolve(), args.cmake, args.output.resolve())
