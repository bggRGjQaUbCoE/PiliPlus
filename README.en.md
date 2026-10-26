<div align="center">
    <img width="200" height="200" src="assets/images/logo/logo.png" alt="PiliPlus logo">
    <h1>PiliPlus</h1>
</div>

<div align="center">

[中文](README.md) | English

![GitHub repo size](https://img.shields.io/github/repo-size/bggRGjQaUbCoE/PiliPlus)
![GitHub Repo stars](https://img.shields.io/github/stars/bggRGjQaUbCoE/PiliPlus)
![GitHub all releases](https://img.shields.io/github/downloads/bggRGjQaUbCoE/PiliPlus/total)

</div>

<div align="center">
    <p>A third-party Bilibili client built with Flutter</p>

<img src="assets/screenshots/510shots_so.png" width="32%" alt="PiliPlus mobile screenshot" />
<img src="assets/screenshots/174shots_so.png" width="32%" alt="PiliPlus mobile screenshot" />
<img src="assets/screenshots/850shots_so.png" width="32%" alt="PiliPlus mobile screenshot" />
<br/>
<img src="assets/screenshots/main_screen.png" width="96%" alt="PiliPlus desktop screenshot" />
<br/>
</div>

<br/>

## Download

Download a build from [Releases](https://github.com/bggRGjQaUbCoE/PiliPlus/releases), or clone the repository and build it locally.

## Dolby Vision playback on Android

Dolby Vision Profile 5 defaults to software decoding and the
`gpu-next` renderer to avoid green/purple colors. Detection uses the selected
video track, so it also applies to downloaded videos. Profile 8 (including 8.4)
and other formats retain the normal renderer and preferred hardware-decoding
mode. The preferred decoder is restored when another video is loaded.

In audio/video settings (`音视频设置`), **Dolby Vision Profile 5 decoding**
(`杜比视界 Profile 5 解码`) offers **software compatibility** (mpv `gpu-next`)
and **native Media3** playback. The experimental Profile 5 `mediacodec` and
`mediacodec-copy` options have been removed; saved selections of those modes
resolve to software compatibility. General mpv hardware-decoder settings for
other formats are unchanged. Close and reopen the video after changing modes.

Software mode uses libplacebo; this is not native Dolby Vision display
passthrough. Playback information shows `hwdec=no`, `vo`, and the Dolby Vision
profile. High-resolution Profile 5 videos may use more CPU or stutter with
software decoding. If needed, select a non-Dolby quality.

### Experimental native Media3 mode

Select **Media3 原生播放器（实验性）** in the same Profile 5 setting, then reopen
the video. This is a separate Android full-screen Media3/ExoPlayer activity using
a **SurfaceView**, not an mpv decoder or a Flutter texture. It requires Android
7.0+ and a display and decoder advertising Dolby Vision support. It is independent
of the mpv hardware-decoding switch. Software decoding remains the default.
Playback and controls remain edge-to-edge without whole-edge safe-area padding.
On Android 9+, only buttons overlapping a reported camera cutout move to a nearby
clear position, in portrait or landscape. The timeline and unaffected controls
stay in place; button positions reset when the cutout no longer overlaps them.
The selected video-fit mode still determines any aspect-ratio letterboxing.

An explicit `dvhe.05`/`dvh1.05` codec goes directly to Media3. When codec metadata
is missing (including downloads), mpv probes the selected track and is stopped
before handing Profile 5 to Media3. Profile 8.4, SDR, live streams, and audio-only
playback stay on mpv. Separate DASH video/audio URLs and HTTP headers, or local
video/audio files, are passed to Media3 without mpv's EDL wrapper.

The native UI follows the mpv player's layout: a title/back header with gradient
scrims, a theme-colored buffered timeline above the bottom play/time/fit/speed
controls, and a side lock button. Playback information is available on demand
instead of covering the title. Speed choices, the seek step, double-tap behavior,
long-press speed boost and control timeout follow your existing player settings.
Tap to show/hide controls; double-tap the center to play/pause and the outer
quarters to seek (when quick double-tap is enabled). Holding the video temporarily
boosts speed; releasing or leaving the player restores it. Lock disables these
gestures and locks orientation; tap the video to reveal Unlock. Native video-fit
choices apply only to the current native session.

Back returns the position and speed to PiliPlus without resuming mpv; the play button reopens
Media3 at that position. Completion uses PiliPlus's existing repeat/next-episode
policy. Leaving the native activity stops playback; returning from the background
requires pressing play. Danmaku, external subtitles, mpv filters, SponsorBlock
skipping, background playback and PiP are not supported in this mode. The UI is
native rather than the Flutter/mpv widget: swipe brightness/volume/seeking,
thumbnail previews, custom bottom-control ordering and in-player quality/episode
selection are not yet shared. Native playback errors are reported rather than
silently falling back to HEVC or mpv.

For device trials, compare the same Profile 5 clip with software mode. Tap
**Playback info** to see the active decoder name and `SurfaceView` diagnostic.
Check colors, the device's Dolby Vision indication, split audio synchronization,
seek/resume, rotation, Back, background/foreground, and then a Profile 8.4 clip.
Capability checks do **not** prove correct Dolby Vision output on every device.
If playback fails or looks wrong, select software mode and reopen the video.

## Disclaimer

PiliPlus is a personal project developed for educational purposes, intended only for learning and testing. Please delete it within 24 hours of downloading.
All APIs used were collected from the official website. This project does not provide any cracked content.

Credit to the original project: [guozhigq/pilipala](https://github.com/guozhigq/pilipala).
Credit to the upstream project: [orz12/PiliPalaX](https://github.com/orz12/PiliPalaX).
This repository makes more extensive changes. Thank you to the original authors for sharing their work as open source.

Thank you for using PiliPlus.

## Acknowledgements

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [flutter_meedu_videoplayer](https://github.com/zezo357/flutter_meedu_videoplayer)
- [media-kit](https://github.com/media-kit/media-kit)
- [dio](https://pub.dev/packages/dio)
- And others

## Star History

<a href="https://star-history.dera.page/#bggRGjQaUbCoE/PiliPlus&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://star-history.dera.page/svg?repos=bggRGjQaUbCoE/PiliPlus&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://star-history.dera.page/svg?repos=bggRGjQaUbCoE/PiliPlus&type=Date" />
   <img alt="Star History Chart" src="https://star-history.dera.page/svg?repos=bggRGjQaUbCoE/PiliPlus&type=Date" />
 </picture>
</a>