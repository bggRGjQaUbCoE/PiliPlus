"""Synthetic AVI video + separate PCM audio, for opt-in native EDL tests."""
import argparse
from pathlib import Path
import struct
import wave


def chunk(tag, data):
    return tag + struct.pack('<I', len(data)) + data + (b'\0' if len(data) % 2 else b'')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('directory', type=Path)
    root = parser.parse_args().directory
    root.mkdir(parents=True, exist_ok=True)
    width, height, fps, frames = 64, 64, 2, 120
    size = width * height * 3
    avih = struct.pack('<14I', 1000000 // fps, size * fps, 0, 0x10,
                       frames, 0, 1, size, width, height, 0, 0, 0, 0)
    strh = struct.pack('<4s4sIHHIIIIIIIIhhhh', b'vids', b'DIB ', 0, 0, 0,
                       0, 1, fps, 0, frames, size, 0xffffffff, 0,
                       0, 0, width, height)
    strf = struct.pack('<IiiHHIIiiII', 40, width, height, 1, 24, 0, size, 0, 0, 0, 0)
    hdrl = chunk(b'LIST', b'hdrl' + chunk(b'avih', avih) +
                 chunk(b'LIST', b'strl' + chunk(b'strh', strh) + chunk(b'strf', strf)))
    image = bytes([16, 80, 160]) * (width * height)
    movi = chunk(b'LIST', b'movi' + b''.join(chunk(b'00db', image) for _ in range(frames)))
    idx = chunk(b'idx1', b''.join(struct.pack('<4sIII', b'00db', 0x10, 4 + i * (size + 8), size) for i in range(frames)))
    (root / 'video.avi').write_bytes(chunk(b'RIFF', b'AVI ' + hdrl + movi + idx))
    with wave.open(str(root / 'audio.wav'), 'wb') as audio:
        audio.setnchannels(1)
        audio.setsampwidth(2)
        audio.setframerate(48000)
        audio.writeframes(b'\0\0' * 48000 * 60)
    print('NATIVE_FIXTURE PASS duration=60 video=AVI audio=PCM-WAV')


if __name__ == '__main__':
    main()
