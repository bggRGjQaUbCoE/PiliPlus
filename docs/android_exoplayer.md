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

### Post-delivery mini-player lifecycle corrections

On 2026-07-29, the user reported three lifecycle regressions in the delivered
mini-player behavior:

- a completed video left a black mini-player overlay instead of closing it;
- leaving a video page after playback had completed created a useless completed
  mini player;
- popping B, C, or later video-detail routes back to an already mounted video
  page created a duplicate mini player, even though the underlying video page
  was still visible.

The correction keeps completion and route ownership backend-neutral:

- the mini-player service rejects an already completed player before retaining
  it and observes the retained player for a later completion event;
- a completion event releases the retained reference in a microtask, after the
  controller has finished dispatching its current listener set;
- mounted video-detail routes are tracked, and a pop may create a mini player
  only when the exiting route is the sole mounted video-detail route;
- mini-player controls start hidden, appear when the mini player is tapped, and
  fade after three seconds without interaction; button actions restart that
  timer.

Formatting and targeted Dart analysis pass for the affected files. An Android
Release audit build also passes application ID, label, version, ABI, and signing
verification. The audit APK SHA-256 is
`98BFAF6395AD25E99DA15F1E01558579FE0BF6E227919A597BBF6DE14C71ACE9`.

On 2026-07-30, the user confirmed that the corrected in-app mini-player flow no
longer showed an issue on the current real device. This closes the reported
black overlay after completion, completed-page exit, nested video-route
unwinding, and control auto-hide regressions for the tested flow.

This confirmation remains limited to the current device and the user's tested
flow. It does not automatically extend coverage to other Android versions,
form factors, chipsets, interactive-video/local-file restore parameters, or
future code revisions.

### First post-mini-player compatibility hardening batch

The first follow-up compatibility batch removes three player-page dependencies
on the MPV object without claiming that Media3 screenshot or super-resolution
support is complete:

- the mobile player-volume menu is mounted for both backends and applies the
  stored player-output volume through `PlPlayerController`, preserving mute and
  audio-focus ducking behavior;
- frame capture now returns a backend-neutral typed result that distinguishes a
  captured image, a capability that is not yet implemented, and an execution
  failure;
- the normal screenshot action and the comment editor's video-screenshot action
  both use that common result, so ExoPlayer no longer silently returns no image
  in the comment flow;
- both super-resolution entry points now call a backend-neutral controller
  method; ExoPlayer keeps the effective mode disabled, reports the unfinished
  Media3 effect when another mode is selected, and cannot enter the MPV shader
  null-object path;
- the settings-sheet super-resolution entry is no longer hidden in ExoPlayer
  mode.

The actual Media3 frame capture, animated-image capture, and GPU
super-resolution effect remain migration gaps and are not marked compatible by
this batch.

Formatting and full `dart analyze` pass with no errors or warnings; the analyzer
reports the same 37 existing info diagnostics. Three new player-feature result
contract tests pass. `flutter analyze` remains blocked before repository
analysis by the workspace Flutter SDK's missing iOS integration-test resource.

An Android Release audit APK was built and passed application ID, label,
version, universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch1-audit.apk`
- SHA-256:
  `35F2FA1E9F3889860FDD354F0E53BDE7A307BF39085414DF2410C50735003802`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device comparison is still required for MPV and ExoPlayer player-volume
changes, MPV screenshot regression, explicit ExoPlayer screenshot feedback, and
both super-resolution entry points. The audit APK is not a new delivered
version and does not update the release baseline.

### Second post-mini-player compatibility hardening batch

The second follow-up compatibility batch fixes the external-subtitle format and
cue bridge instead of treating every subtitle as plain WebVTT:

- subtitle sources now retain whether they are inline data or a file together
  with their actual WebVTT, SubRip, or SubStation Alpha format;
- the external picker accepts `.vtt`, `.srt`, `.ass`, and `.ssa`
  case-insensitively while Bilibili JSON subtitles continue to be converted to
  inline WebVTT;
- the Flutter method-channel request carries the format MIME type, and the
  Android bridge uses `text/vtt`, `application/x-subrip`, or `text/x-ssa` for
  both data URIs and Media3 subtitle configurations;
- Media3 active cues are sent back as structured cue records rather than one
  flattened string. The bridge retains text alignment, multi-row alignment,
  line and position anchors, cue size, window color, text size, shear, z-order,
  and Android text spans for bold, italic, underline, strikethrough, foreground
  and background colors, font family, and absolute or relative text size;
- the Flutter Texture overlay renders the structured cue list while preserving
  the existing user subtitle style, stroke, padding, drag behavior, and
  backend-neutral control layer.

The MPV track-selection path remains active through the same video-page
controller; this batch does not hide or replace the MPV subtitle entry.

The implementation commit is
`2cd76abe776a45d7d89dc8b9736418fcf8fea21e`. Formatting, full `dart analyze`,
and the complete Flutter test suite pass. The analyzer reports no errors or
warnings and the same 37 existing info diagnostics; all seven tests pass.
`flutter analyze` remains blocked before repository analysis by the workspace
Flutter SDK's missing iOS integration-test resource.

An Android Release audit APK was built from the implementation commit and
passed application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch2-subtitle-audit-v2.apk`
- SHA-256:
  `DB1DAAD7FEA752B8A0B1DD62CD76EA9A91C5D964258BC7A4C38E1CDDCB9E20A9`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device MPV/ExoPlayer comparison is still required for built-in WebVTT,
external VTT/SRT/ASS/SSA, switching and disabling tracks, styled and positioned
cues, full-screen/rotation, and subtitle dragging. Media3 bitmap cues are not
bridged, and vertical-writing metadata is transported but does not yet have an
equivalent Flutter vertical layout. Those edge cases remain explicit gaps. The
audit APK is not a new delivered version and does not update the release
baseline.

### Third post-mini-player compatibility hardening batch

The third follow-up compatibility batch moves native audio/video tracks and
player information behind the backend-neutral controller:

- Media3 serializes available video, audio, and text tracks with stable
  per-source group/track coordinates, selected/supported state, language,
  codec/MIME, bitrate, resolution/frame rate, channel count/sample rate,
  rotation, pixel ratio, and color information;
- the method channel supports automatic selection, disabling a track type, and
  selecting one supported track through `TrackSelectionOverride`;
- MPV tracks are mapped into the same Flutter model and use the same selection
  methods, so the video page no longer needs a backend-specific track menu;
- the settings sheet exposes shared video-track and audio-track selectors for
  both backends;
- ExoPlayer's player-information entry is no longer hidden. The shared dialog
  reports backend, resolution, media source, selected tracks, speed, effective
  player volume, format details, and the Media3 audio/video decoder names;
- “listen to video” now disables or restores the video track through the common
  selection API. ExoPlayer no longer recreates the media source, seeks, or
  drops its buffered state for this toggle. Later source reloads keep the full
  video/audio source pair so restoring video remains possible.

The implementation commit is
`c02aea597c6c41184261a8e32aac401b145e39b6`. Formatting, full `dart analyze`,
and the complete Flutter test suite pass. The analyzer reports no errors or
warnings and the same 37 existing info diagnostics; all nine tests pass.
`flutter analyze` remains blocked before repository analysis by the workspace
Flutter SDK's missing iOS integration-test resource. Android Debug and Release
builds both pass.

The Release audit APK passed application ID, label, version, universal ABI, and
signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch3-tracks-audit.apk`
- SHA-256:
  `60EF362B8B689C2EC3FE63A6BF3EFB498FE129A3C7A7126A2869DC668229894E`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device MPV/ExoPlayer comparison is still required for DASH video/audio
tracks, local files with multiple tracks, automatic/disabled/specific
selection, listen-to-video toggling during play and pause, source reload after
audio-only mode, and all player-information fields. Embedded text tracks are
enumerated by the common/native API and shown in player information, but their
dedicated user selection entry is not part of this audio/video-track batch.
The audit APK is not a new delivered version and does not update the release
baseline.
