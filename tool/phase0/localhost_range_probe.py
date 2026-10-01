"""Phase 0 transport fixture only; not the Dart Accelerator implementation.

Exercises localhost HTTP contracts and the exact Windows libmpv from the
locked media-kit CMake file. No Bilibili requests, app changes or Range splitting.
"""
import argparse
import ctypes
import io
import json
import re
import threading
import time
import urllib.error
import urllib.request
import wave
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


def interval(header, size):
    if header is None:
        return 0, size - 1, 200
    match = re.fullmatch(r"bytes=(\d*)-(\d*)", header)
    if not match or not any(match.groups()):
        raise ValueError("unsupported range")
    left, right = match.groups()
    if not left:
        if int(right) <= 0:
            raise ValueError("empty suffix")
        start, end = max(0, size - int(right)), size - 1
    else:
        start = int(left)
        end = min(int(right), size - 1) if right else size - 1
    if start >= size or end < start:
        raise ValueError("unsatisfiable")
    return start, end, 206


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--libmpv", required=True)
    args = parser.parse_args()
    output = io.BytesIO()
    with wave.open(output, "wb") as audio:
        audio.setnchannels(1)
        audio.setsampwidth(2)
        audio.setframerate(48000)
        audio.writeframes(b"\0\0" * 48000 * 120)
    media = output.getvalue()
    requests = []
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))

    class Origin(BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def log_message(self, *_):
            pass

        def do_HEAD(self):
            self.do_GET()

        def do_GET(self):
            try:
                start, end, status = interval(self.headers.get("Range"), len(media))
            except ValueError:
                self.send_response(416)
                self.send_header("Content-Range", f"bytes */{len(media)}")
                self.send_header("Content-Length", "0")
                self.end_headers()
                return
            self.send_response(status)
            self.send_header("Content-Length", str(end - start + 1))
            self.send_header("Content-Type", "audio/wav")
            self.send_header("Accept-Ranges", "bytes")
            if status == 206:
                self.send_header("Content-Range", f"bytes {start}-{end}/{len(media)}")
            self.end_headers()
            if self.command != "HEAD":
                try:
                    for offset in range(start, end + 1, 65536):
                        self.wfile.write(media[offset:min(offset + 65536, end + 1)])
                except (BrokenPipeError, ConnectionResetError, ConnectionAbortedError):
                    pass

    origin = ThreadingHTTPServer(("127.0.0.1", 0), Origin)
    upstream = f"http://127.0.0.1:{origin.server_port}/fixture.wav"

    class Proxy(BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def log_message(self, *_):
            pass

        def do_HEAD(self):
            self.do_GET()

        def do_GET(self):
            if self.path != "/audio/phase0-fixture-token":
                self.send_response(404)
                self.send_header("Content-Length", "0")
                self.end_headers()
                return
            requests.append({"method": self.command, "range": self.headers.get("Range")})
            headers = {"Range": self.headers["Range"]} if "Range" in self.headers else {}
            request = urllib.request.Request(upstream, method=self.command, headers=headers)
            try:
                response = opener.open(request, timeout=5)
            except urllib.error.HTTPError as error:
                response = error
            with response:
                self.send_response(response.status)
                for name in ("Content-Length", "Content-Type", "Content-Range", "Accept-Ranges"):
                    if response.headers.get(name):
                        self.send_header(name, response.headers[name])
                self.end_headers()
                if self.command != "HEAD":
                    try:
                        while data := response.read(65536):
                            self.wfile.write(data)
                    except (BrokenPipeError, ConnectionResetError, ConnectionAbortedError):
                        pass

    proxy = ThreadingHTTPServer(("127.0.0.1", 0), Proxy)
    for server in (origin, proxy):
        threading.Thread(target=server.serve_forever, daemon=True).start()
    url = f"http://127.0.0.1:{proxy.server_port}/audio/phase0-fixture-token"
    checks = []
    handle = None
    try:
        for name, header, expected in (
            ("closed", "bytes=123-4095", media[123:4096]),
            ("open", f"bytes={len(media)-512}-", media[-512:]),
            ("suffix", "bytes=-256", media[-256:]),
            ("clamped", f"bytes={len(media)-16}-{len(media)+99}", media[-16:]),
        ):
            with opener.open(urllib.request.Request(url, headers={"Range": header}), timeout=5) as response:
                assert response.status == 206
                assert int(response.headers["Content-Length"]) == len(expected)
                assert response.read() == expected
                assert response.headers["Content-Range"].endswith(f"/{len(media)}")
            checks.append(name)
        with opener.open(urllib.request.Request(url, method="HEAD"), timeout=5) as response:
            assert response.status == 200 and response.read() == b""
            assert int(response.headers["Content-Length"]) == len(media)
        checks.append("head")
        with opener.open(url, timeout=5) as response:
            assert response.status == 200 and response.read() == media
        checks.append("no-range")
        for header in (f"bytes={len(media)}-", "bytes=10-5", "bytes=-0"):
            try:
                opener.open(urllib.request.Request(url, headers={"Range": header}), timeout=5)
                raise AssertionError("416 expected")
            except urllib.error.HTTPError as error:
                assert error.code == 416
                assert error.headers["Content-Range"] == f"bytes */{len(media)}"
        checks.append("unsatisfiable")
        try:
            opener.open(url + "-invalid", timeout=5)
            raise AssertionError("404 expected")
        except urllib.error.HTTPError as error:
            assert error.code == 404
        checks.append("token-routing")
        print("HTTP_CONTRACT PASS 8 cases")

        lib = ctypes.CDLL(args.libmpv)
        lib.mpv_create.restype = ctypes.c_void_p
        lib.mpv_initialize.argtypes = [ctypes.c_void_p]
        lib.mpv_set_option_string.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_char_p]
        lib.mpv_command.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_char_p)]
        lib.mpv_get_property_string.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
        lib.mpv_get_property_string.restype = ctypes.c_void_p
        lib.mpv_free.argtypes = [ctypes.c_void_p]
        lib.mpv_terminate_destroy.argtypes = [ctypes.c_void_p]
        handle = lib.mpv_create()
        assert handle
        for key, value in {"vo": "null", "ao": "null", "cache": "no", "demuxer-max-bytes": "65536", "demuxer-readahead-secs": "0", "pause": "yes", "config": "no", "terminal": "no"}.items():
            assert lib.mpv_set_option_string(handle, key.encode(), value.encode()) >= 0
        assert lib.mpv_initialize(handle) >= 0

        def command(*values):
            items = (ctypes.c_char_p * (len(values) + 1))(*(value.encode() for value in values), None)
            assert lib.mpv_command(handle, items) >= 0

        def prop(key):
            ptr = lib.mpv_get_property_string(handle, key.encode())
            if not ptr:
                return None
            try:
                return ctypes.string_at(ptr).decode()
            finally:
                lib.mpv_free(ptr)

        def wait_for(predicate):
            deadline = time.monotonic() + 10
            while time.monotonic() < deadline:
                if predicate():
                    return
                time.sleep(0.05)
            raise AssertionError("libmpv timeout")

        native_start = len(requests)
        command("loadfile", url)
        wait_for(lambda: prop("duration") is not None)
        assert abs(float(prop("duration")) - 120) < 0.1
        command("seek", "80", "absolute+exact")
        command("set", "pause", "no")
        wait_for(lambda: prop("time-pos") is not None and 79.9 <= float(prop("time-pos")) < 82)
        # FFmpeg may read forward instead of issuing a new Range on a forward
        # seek. Do not equate a playback timestamp with a particular byte offset.
        wait_for(lambda: any(item["range"] for item in requests[native_start:]))
        native_requests = requests[native_start:]
        print("WINDOWS_LIBMPV PASS duration=120 seek=80 http-range-observed=true")
        print(json.dumps({"fixture_bytes": len(media), "http_cases": checks, "libmpv_version": prop("mpv-version"), "native_requests": native_requests}, ensure_ascii=False))
    finally:
        if handle:
            lib.mpv_terminate_destroy(handle)
        for server in (proxy, origin):
            server.shutdown()
            server.server_close()
    print("CLEANUP PASS proxy-and-origin-closed")


if __name__ == "__main__":
    main()
