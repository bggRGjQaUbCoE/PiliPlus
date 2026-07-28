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

The quality/CDN reload path now keeps the existing native ExoPlayer instance
and replaces only its `MediaSource`. The reload request carries the previous
position and play intent, while speed, volume, mute state, and the current
subtitle selection remain attached to the same player session. Source
generations are attached to native events so events already queued for an
older request cannot overwrite the newer Flutter state.

The user verified the following source-switching scenarios on a real Android
device on 2026-07-26:

- quality switching;
- CDN switching;
- reload after a network error;
- part changes using the new part's own resume position;
- playback state remaining correct after these operations.

The core source-switching batch is therefore verified. Cross-state regression
in full-screen, background/foreground, and picture-in-picture remains part of
the later system-lifecycle batch and must not be inferred from this result.

The user also verified the second-batch rendering and interaction behavior on
the current real Android device on 2026-07-26, including full-screen and
rotation transitions, control locking, video fit/scale/flip behavior, and
gesture interaction. No issue was observed on the tested device. Foldable-only
layout behavior remains a separate device-coverage item until tested on
applicable hardware.

The user verified the third-batch video overlays and progress enhancements on
the local real Android device on 2026-07-26. Danmaku display and interaction,
subtitle selection/rendering and styling, chapter/view-point overlays, seek
previews, high-energy progress, and SponsorBlock showed no issue in the tested
flows. These features use the shared Flutter layer; Exo subtitles are scheduled
by Media3 and rendered through the backend-neutral Flutter subtitle overlay.

### Fourth-batch real-device verification

Automatic picture-in-picture on app exit now uses the same playback-state
handler for ExoPlayer and MPV. On Android 12 and later, playing enables system
auto-enter PiP for the current video page, while pause, completion, playback
errors, and disposal disable it. Android versions before 12 continue to enter
PiP through `onUserLeaveHint`.

The user verified automatic PiP on app exit with ExoPlayer on a real Android
device on 2026-07-26. On 2026-07-28, the user also verified audio focus, media
notification and media-button behavior, and wired-headset/Bluetooth control on
the current real Android device.

Process-death task restoration is explicitly deferred at the user's request and
is not counted as verified.

Completion and Exo playback errors clear wakelock and buffering state and push
the final completed/paused state to the shared media service, preventing stale
playing controls in the notification and lock screen.

Audio-focus and headset/Bluetooth handling has now been brought through the
backend-neutral controller path:

- playback requests audio focus before starting either backend;
- internal source replacement keeps the existing focus instead of abandoning
  and immediately reacquiring it;
- transient focus loss pauses and resumes only when playback was interrupted by
  the system;
- ducking changes the player output gain without modifying the user's Android
  media-volume setting, and restores the exact configured player volume;
- completion, Exo playback failure, manual pause, and disposal release focus;
- unplugging a wired headset or disconnecting an active audio route pauses
  playback through the shared controller;
- media play/pause, seek, fast-forward, and rewind continue through the shared
  audio-service handler; headset next/previous buttons map to the same
  ten-second forward/rewind behavior instead of becoming no-ops.

The implementation passed formatting and targeted static analysis. The user
reported the audio-focus, notification, media-button, wired-headset, and
Bluetooth flows verified on the current real Android device on 2026-07-28.
This result does not replace regression coverage on other Android versions,
audio devices, chipsets, or later code revisions.

### In-app mini player real-device verification

Video detail routes now retain the backend-neutral player session when the
route is popped and hand its existing Texture to a Flutter overlay above the
root navigator. The in-app mini player therefore continues the same playback
session on the home page and other routes without creating a second MPV or
ExoPlayer instance. It can be dragged, paused/resumed, closed, or expanded back
to the current video. Opening another video closes the old mini-player session
before the new video route starts normal playback.

The feature can be enabled or disabled from playback settings and defaults to
disabled. Popping the video route captures the current Flutter video rectangle
and animates that same Texture into the mini-player rectangle. Restoring keeps
the player and media source alive, opens the detail page only to rebuild its
backend-neutral UI and metadata, then animates the mini-player Texture into the
new video rectangle before transferring the retained player reference back to
the page. This path does not call `setDataSource` or seek/reopen the media.

The shrink transition now uses one animation progress for position, size, and
the actual clip radius, so the rounded corners begin changing on the first
movement frame. Restore starts moving the retained Texture back to the captured
video rectangle as soon as the detail route is requested; the detail route is
built concurrently and claims the player on its first rendered frame. The
overlay is removed only after both the movement and page handoff are complete.
The first rendered frame also updates the animation target in page-local
coordinates, so rotation, split-screen, and other window-size changes do not
reuse a stale pre-pop rectangle or restart the running animation. The hidden
page player ignores pointer events until the Texture handoff completes.

Restore arguments are rebuilt from the current video controller state rather
than the route's initial arguments. UGC part, PGC episode, interactive-video,
and local-file changes therefore restore the current aid, bvid, cid, episode,
cover, orientation, and local entry. Opening a live room now dismisses the
retained VOD mini-player before the live controller requests the shared player.

System picture-in-picture remains a separate Android lifecycle feature. Its
auto-enter state now follows the retained player while playback is owned by the
in-app mini player, allowing the mini player to enter system PiP when the app is
backgrounded. In system PiP the retained Texture expands to fill the Activity
instead of leaving the app page and a tiny nested mini player visible. Restoring
the detail route explicitly reapplies auto-enter PiP because the uninterrupted
player does not emit another play event during the handoff.

Expanding system PiP now also completes the retained-session handoff back to
the current `/videoV` route after the Activity has resumed, rather than merely
foregrounding the home page with the in-app mini player still attached. Closing
system PiP does not restore the route because the Activity never reaches the
foreground-resumed condition used by this handoff.

The in-app mini player uses the same content actions as Android system PiP:
ten-second rewind, play/pause, and ten-second fast-forward for VOD, or only
play/pause for live playback. Its top-level controls retain the system-equivalent
expand and close actions. The mini-player bounds preserve the current backend's
reported video aspect ratio, including portrait and square sources, within a
screen-relative maximum size instead of forcing every source into 16:9.

Formatting and targeted static analysis pass for this implementation. On
2026-07-28, the user reported the in-app mini-player and system-PiP round trip
verified on the current real Android device, including:

- pop a playing and a paused VOD route into the in-app mini player;
- continue playback while navigating across home, search, and detail routes;
- drag the mini player and use play, pause, close, and restore controls;
- enable and disable the feature from playback settings;
- verify shrink/expand animation continuity and confirm that restoring does not
  buffer, seek, or recreate the native player session;
- open a different UGC/PGC video while the mini player is active;
- verify danmaku preference, media notification, audio focus, rotation, and
  foreground/background transitions during mini-player playback;
- background the app from the mini player, enter system PiP, and expand system
  PiP back to the current video detail route rather than the mini-player state.

These results mark the feature verified for the tested device and flows. Other
Android versions, form factors, chipsets, and later code revisions still require
normal regression coverage.
