#!/usr/bin/env python3
"""Fail if a PE contains FEAT_DotProd (SDOT/UDOT). Snapdragon 850 WOA traps these."""

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


def scan(data: bytes) -> int:
    hits = 0
    for raw, rsz in executable_sections(data):
        blob = data[raw : raw + rsz]
        n = len(blob) - (len(blob) % 4)
        for word in struct.unpack("<%dI" % (n // 4), blob[:n]):
            if is_sdot_udot(word):
                hits += 1
    return hits


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("path")
    parser.add_argument(
        "--file",
        action="append",
        dest="files",
        default=None,
    )
    args = parser.parse_args()
    names = args.files or ["libmpv-2.dll"]

    failed = False
    pe_files: list[str] = []
    for root, _dirs, files in os.walk(args.path):
        for name in files:
            if name.lower().endswith((".exe", ".dll")):
                pe_files.append(os.path.join(root, name))
    by_name = {os.path.basename(p).lower(): p for p in pe_files}

    for name in names:
        path = by_name.get(name.lower())
        if path is None:
            print(f"FAIL missing {name}")
            failed = True
            continue
        data = open(path, "rb").read()
        machine = pe_machine(data)
        if machine != IMAGE_FILE_MACHINE_ARM64:
            print(f"FAIL {name} machine 0x{(machine or 0):04X}")
            failed = True
            continue
        hits = scan(data)
        if hits:
            print(f"FAIL {name} sdot_udot={hits}")
            failed = True
        else:
            print(f"OK   {name} no FEAT_DotProd (sdot/udot)")

    if failed:
        print("Windows ARM64 DotProd check failed", file=sys.stderr)
        return 1
    print("Windows ARM64 DotProd check passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
