# Android ExoPlayer backend

## Goal

The MPV behavior in PiliPlus is the compatibility baseline. Selecting ExoPlayer
must not change which player features are available or how the existing Flutter
player UI behaves.

An Exo migration is complete only when every MPV-backed user flow has one of:

1. an equivalent Exo/Media3 implementation;
2. a backend-neutral Flutter implementation shared by MPV and Exo; or
3. a documented replacement that provides the same user-visible outcome.

Hiding an MPV feature, silently doing nothing, or asking the user to switch back
to MPV does not count as compatibility.

## Architecture

The player UI, controls, gestures, danmaku, subtitles, progress overlays, and
business logic must remain backend-neutral Flutter code.

```text
Video pages and business features
              |
      backend-neutral player API
         /                 \
   MPV adapter         Media3 adapter
         \                 /
       Flutter Texture and shared PLVideoPlayer UI
```

On Android, Media3 renders to a Flutter `Texture` through
`TextureRegistry.SurfaceProducer`. It must not use an `AndroidView`,
`PlayerView`, or another native view layered over the Flutter controls.

## Compatibility gates

The Exo backend cannot be considered the default replacement until the
following groups pass on a real Android device.

### Rendering and interaction

- video, Flutter controls, danmaku, subtitles, and overlays share one layer tree
- single tap, double tap, long press, horizontal seek, brightness/volume slide
- pinch/scale, full screen, rotation, foldable layouts, and control locking
- every video fit mode plus horizontal and vertical flip

### Playback state

- open, play, pause, seek, replay, repeat, completion, and error recovery
- duration, position, buffering, buffered position, speed, and resolution
- quality changes preserve position, play state, speed, volume, and mute state
- online DASH video/audio merge, audio-only mode, local files, and live streams

### Video features

- danmaku display, tap actions, trends, advanced danmaku, and send actions
- Bilibili subtitles, external subtitles, subtitle style, and subtitle dragging
- chapters/view points, seek thumbnails, high-energy progress, and SponsorBlock
- interactive videos, UGC, PGC, courses, playlists, collections, and local video

### Audio and tracks

- app/player volume, mute, audio focus, background audio, and media notification
- audio normalization/loudness behavior
- audio/video/subtitle track selection and player information

### System and utilities

- picture-in-picture, app background/foreground, screen off/on, and task restore
- screenshot, animated-image capture, share/save flows, and DLNA handoff
- CDN reload, retry, network changes, decoder failure, and process lifecycle

## Working rule

Business and UI code must not read MPV state directly. New work should go
through the backend-neutral player API. Remaining direct MPV access is migration
debt and must be tracked until removed or isolated inside the MPV adapter.

Every batch requires:

1. static analysis and Android release compilation;
2. a signed APK built from the exact source state;
3. real-device regression against the same scenarios in MPV mode; and
4. no regression accepted as “Exo does not support it”.

## Current migration status

### Real-device verified

- The Flutter control layer can be shown and hidden by tapping the video.
- Double-tap play/pause works.
- Horizontal seek and vertical brightness/volume gestures work.
- Long-press temporary speed-up works.

These interaction items were verified by the user on a real Android device on
2026-07-26.

### Implemented, awaiting real-device verification

The quality/CDN reload path now keeps the existing native ExoPlayer instance
and replaces only its `MediaSource`. The reload request carries the previous
position and play intent, while speed, volume, mute state, and the current
subtitle selection remain attached to the same player session. Source
generations are attached to native events so events already queued for an
older request cannot overwrite the newer Flutter state.

The following scenarios still need side-by-side device verification against
MPV before this batch can be marked complete:

- switch quality while playing and while paused;
- switch CDN while playing and while paused;
- reload after a network error;
- change parts and confirm that the new part uses its own resume position;
- confirm speed, volume, mute, subtitle selection, danmaku, and control-layer
  state after each switch;
- repeat the checks in normal, full-screen, background/foreground, and
  picture-in-picture states where applicable.
