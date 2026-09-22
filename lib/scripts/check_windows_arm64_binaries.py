#!/usr/bin/env python3
"""Fail if a Windows ARM64 bundle is not PE-ARM64 or contains v8.1/v8.2 opcodes."""

from __future__ import annotations

import argparse
import os
import struct
import sys

IMAGE_FILE_MACHINE_ARM64 = 0xAA64
IMAGE_SCN_MEM_EXECUTE = 0x20000000


def pe_machine(data: bytes) -> int | None:
    if data[:2] != b"MZ" or len(data) < 64:
        return None
    e_lfanew = struct.unpack_from("<I", data, 0x3C)[0]
    if data[e_lfanew : e_lfanew + 4] != b"PE\0\0":
        return None
    return struct.unpack_from("<H", data, e_lfanew + 4)[0]


def executable_sections(data: bytes) -> list[tuple[int, int]]:
    e_lfanew = struct.unpack_from("<I", data, 0x3C)[0]
    nsec = struct.unpack_from("<H", data, e_lfanew + 6)[0]
    optsz = struct.unpack_from("<H", data, e_lfanew + 20)[0]
    sec0 = e_lfanew + 24 + optsz
    secs: list[tuple[int, int]] = []
    for i in range(nsec):
        off = sec0 + i * 40
        rsz = struct.unpack_from("<I", data, off + 16)[0]
        raw = struct.unpack_from("<I", data, off + 20)[0]
        chars = struct.unpack_from("<I", data, off + 36)[0]
        if chars & IMAGE_SCN_MEM_EXECUTE and rsz > 0:
            secs.append((raw, rsz))
    return secs


def is_cas(word: int) -> bool:
    return (
        ((word >> 23) & 0x7F) == 0x11
        and ((word >> 21) & 1) == 1
        and ((word >> 15) & 1) == 0
        and ((word >> 10) & 0x3F) == 0x1F
    )


def is_ldadd_family(word: int) -> bool:
    return (
        ((word >> 24) & 0x3F) == 0x38
        and ((word >> 21) & 1) == 1
        and ((word >> 10) & 0x1F) <= 7
    )


def is_sdot_udot(word: int) -> bool:
    if (word >> 31) & 1:
        return False
    if (
        ((word >> 24) & 0x1F) == 0x0E
        and ((word >> 21) & 7) == 4
        and ((word >> 10) & 0x3F) == 0x25
    ):
        return True
    return (
        ((word >> 24) & 0x1F) == 0x0F
        and ((word >> 22) & 3) == 2
        and ((word >> 12) & 0xF) == 0x0E
        and ((word >> 10) & 1) == 0
    )


def scan_opcodes(data: bytes) -> dict[str, int]:
    counts = {"cas": 0, "ldadd_family": 0, "sdot_udot": 0}
    for raw, rsz in executable_sections(data):
        blob = data[raw : raw + rsz]
        n = len(blob) - (len(blob) % 4)
        for word in struct.unpack("<%dI" % (n // 4), blob[:n]):
            if is_cas(word):
                counts["cas"] += 1
            if is_ldadd_family(word):
                counts["ldadd_family"] += 1
            if is_sdot_udot(word):
                counts["sdot_udot"] += 1
    return counts


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("path")
    parser.add_argument(
        "--opcode-file",
        action="append",
        dest="opcode_files",
        default=None,
    )
    parser.add_argument("--allow-missing-opcode-files", action="store_true")
    args = parser.parse_args()
    opcode_files = args.opcode_files or ["libmpv-2.dll", "libEGL.dll", "libGLESv2.dll"]

    failed = False
    pe_files: list[str] = []
    for root, _dirs, files in os.walk(args.path):
        for name in files:
            if name.lower().endswith((".exe", ".dll")):
                pe_files.append(os.path.join(root, name))
    if not pe_files:
        print(f"no PE files under {args.path}", file=sys.stderr)
        return 1

    print(f"Checking PE machine type under {args.path}")
    for path in pe_files:
        data = open(path, "rb").read()
        machine = pe_machine(data)
        rel = os.path.relpath(path, args.path)
        if machine is None:
            print(f"FAIL {rel} is not a PE file")
            failed = True
            continue
        if machine != IMAGE_FILE_MACHINE_ARM64:
            print(f"FAIL {rel} machine 0x{machine:04X} (want ARM64 0xAA64)")
            failed = True
            continue
        print(f"OK   {rel} ARM64")

    print("Checking ARMv8.1 / ARMv8.2 opcodes (cas, ldadd, sdot, udot)")
    by_name = {os.path.basename(p).lower(): p for p in pe_files}
    for name in opcode_files:
        path = by_name.get(name.lower())
        if path is None:
            if args.allow_missing_opcode_files:
                print(f"SKIP missing {name}")
                continue
            print(f"FAIL missing {name}")
            failed = True
            continue
        counts = scan_opcodes(open(path, "rb").read())
        hits = sum(counts.values())
        if hits:
            print(
                f"FAIL {name} cas={counts['cas']} "
                f"ldadd={counts['ldadd_family']} sdot_udot={counts['sdot_udot']}"
            )
            failed = True
        else:
            print(f"OK   {name} no v8.1/v8.2 opcodes")

    engine = by_name.get("flutter_windows.dll")
    if engine:
        counts = scan_opcodes(open(engine, "rb").read())
        print(
            f"INFO flutter_windows.dll cas={counts['cas']} "
            f"ldadd={counts['ldadd_family']} sdot_udot={counts['sdot_udot']}"
        )
        if counts["sdot_udot"]:
            print("FAIL flutter_windows.dll contains SDOT/UDOT; Flutter 3.47.5 cannot target Snapdragon 835")
            failed = True
        elif counts["cas"] + counts["ldadd_family"]:
            print("WARN flutter_windows.dll has LSE encodings (Google prebuilt; may be CRT dispatch)")

    if failed:
        print("Windows ARM64 Snapdragon 835 baseline check failed", file=sys.stderr)
        return 1
    print("Windows ARM64 baseline check passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
