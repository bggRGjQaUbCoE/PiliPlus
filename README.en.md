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
(`杜比视界 Profile 5 解码`) offers software compatibility mode and two experimental
hardware modes: `mediacodec` and `mediacodec-copy`. All three use `gpu-next`.
Enable hardware decoding (`开启硬解`) before trying either hardware mode;
turning it off forces software decoding. Close and reopen the video after
changing modes, then compare the same Profile 5 clip.

Playback information shows the requested `hwdec` separately from the active
`hwdec`, along with `vo` and the Dolby Vision profile. An active `hwdec` of `no`
means software decoding, even if a hardware mode was requested. Hardware
capabilities do not guarantee correct Dolby colors; if a trial produces
green/purple colors, a black screen, or playback errors, switch back to software
compatibility mode. No native-library fork is required to try these options.

This rendering path uses libplacebo; it is not
native Dolby Vision display passthrough. High-resolution Profile 5 videos may
use more CPU or stutter with software decoding. If needed, select a non-Dolby
quality.

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