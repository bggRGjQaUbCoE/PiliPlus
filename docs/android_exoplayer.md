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

### Fourth post-mini-player compatibility hardening batch

The fourth follow-up batch connects the server-measured two-pass `loudnorm`
path to Media3 without changing the existing player-volume, mute, audio-focus,
background, or PiP state flows:

- the existing Flutter normalization resolver remains the single source of
  truth for user targets, Bilibili `voiceBalance` measurements, and fallback
  selection, so MPV and ExoPlayer do not interpret the setting separately;
- measured integrated loudness and target offset are converted into a PCM gain,
  while the configured true-peak target is sent separately to Android;
- Media3 uses an app-local `BaseAudioProcessor` in `DefaultAudioSink`. It
  supports 16-bit and float PCM, links all channels to the same gain, lowers
  gain immediately when a decoded frame would exceed the target peak, and
  releases the limiter over 80 ms instead of hard-clipping each sample;
- opening, refreshing, changing part/quality, or reusing the player session
  updates immutable normalization parameters without recreating the ExoPlayer
  instance. A media event also exposes the applied filter for diagnostics;
- `dynaudnorm`, a one-pass `loudnorm` without server measurements, and one
  `highpass=f=<Hz>`, `lowpass=f=<Hz>`, or peaking
  `equalizer=f=<Hz>:t=q:w=<Q>:g=<dB>` stage are represented by Media3 PCM
  approximations. The filter stages are applied per channel before gain/normalization and peak
  limiting; filter ordering is intentionally normalized and still requires a
  real-device listening comparison against MPV. Repeated high-pass stages,
  chained stages outside this supported set, and arbitrary custom FFmpeg
  filters remain explicit unsupported cases. ExoPlayer keeps the original
  audio and shows one notice per unsupported parameter instead of silently
  no-oping or falling back to MPV.

The implementation commit is
`54babbf8f08577771fb600f0f6e63d039c5b6ead`. Formatting and full
`dart analyze` pass; the analyzer reports no errors or warnings and the same
37 existing info diagnostics. All 15 Flutter tests pass, including six new
normalization-resolution tests. Android Debug and Release builds pass.
`flutter analyze` remains blocked before repository analysis by the same
missing Flutter SDK iOS integration-test resource.

The final Release audit APK passed application ID, label, version, universal
ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch4-loudness-audit-v2.apk`
- SHA-256:
  `6511FB1003B4F7AB8DACBD67F99A152DD2A05162ADBA6F1EF581B3F821665381`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device comparison is still required with the same measured video in MPV
and ExoPlayer, including quiet and already-loud material, speaker/headphones,
play/pause, seek, quality/part changes, background playback, app mini-player,
and system PiP. The current implementation closes only the server-measured
two-pass `loudnorm` path after that comparison; dynamic and arbitrary FFmpeg
filters remain explicit compatibility gaps. The audit APK is not a new
delivered version and does not update the release baseline.

### Fifth post-mini-player compatibility hardening batch

The fifth follow-up batch closes the dedicated embedded-text-track selection
entry while preserving the existing Bilibili and external-subtitle workflow:

- the backend-neutral track model distinguishes app-loaded subtitle sources
  from subtitle tracks embedded in the current media. MPV uses its URI marker,
  while Media3 assigns a stable ID to the app-provided subtitle configuration;
- the video settings sheet shows an “embedded subtitle track” entry only when
  real embedded text tracks are present. App-loaded Bilibili/file subtitles are
  not duplicated in that list;
- the shared selector supports disabling embedded subtitles and choosing one
  supported embedded track for MPV and ExoPlayer. Unsupported tracks remain
  visible but cannot be selected;
- selecting an embedded track updates the existing subtitle control to its off
  state. Selecting a Bilibili or external subtitle later clears the Media3 text
  override and enables that app-loaded track; disabling through the existing
  subtitle control disables the full text-track type, so an embedded subtitle
  does not silently reappear;
- these switches reuse the current player session and position. They do not
  recreate the video/audio media source merely to change the selected text
  track, except when the existing workflow first adds or removes an app-loaded
  subtitle configuration.

The implementation commit is
`c3dc337f2c9ff6b8c77fb154bbb16e4235177935`. Formatting and full
`dart analyze` pass; the analyzer reports no errors or warnings and the same 37
existing info diagnostics. All 16 Flutter tests pass, including the new
app-loaded subtitle-track classification test. Android Debug and Release builds
pass. `flutter analyze` remains blocked before repository analysis by the same
missing Flutter SDK iOS integration-test resource:

`dev/integration_tests/ios_app_with_extensions/ios/watch Extension/Assets.xcassets/Complication.complicationset/Graphic Circular.imageset`

The Release audit APK passed application ID, label, version, universal ABI, and
signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch5-embedded-subtitle-audit-v2.apk`
- SHA-256:
  `7930D4A39F33AC74F4D958A06316C0D187948DAB43EC0A1B464F7EF25062ABB2`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

This final audit APK was rebuilt from clean HEAD
`7aec0b81463a6269dd593bdab86d6adc973209d9` with explicit build name, build
number, build time, and commit-hash defines, so subsequent diagnostic reports
identify the exact source state.

Real-device MPV/ExoPlayer comparison is still required with local or network
media containing multiple embedded text tracks: selecting each supported track,
disabling it, switching between embedded and Bilibili/external subtitles in
both directions, play/pause, seek, full screen, background playback, app
mini-player, and system PiP. Media3 bitmap cues and equivalent Flutter vertical
writing remain explicit subtitle gaps. The audit APK is not a new delivered
version and does not update the release baseline.

### Sixth post-mini-player compatibility hardening batch

The sixth follow-up batch closes the automatic-retry and diagnostic path for
future ExoPlayer network/source failures without silently falling back to MPV:

- the Android bridge serializes the Media3 error code/name, source or renderer
  phase, category, recoverable flag, HTTP status, renderer and decoder names,
  current position, playback intent, sanitized media sources, and full cause
  chain instead of reporting only `ExoPlayer: Source error`;
- URL query strings and fragments are removed from both explicit URI fields and
  exception messages before diagnostics reach Flutter, so signed playback URLs
  and authentication parameters are not copied into error reports;
- connection failures, connection timeouts, unspecified network I/O, HTTP 408,
  HTTP 429, and HTTP 5xx use the existing `retryCount` and `retryDelay`
  preferences. Delay increases by the configured base delay for each attempt;
- HTTP 401/403/404, local files, decoder/DRM/unsupported-format errors, inactive
  sessions, and exhausted retry limits do not enter the automatic-retry loop;
- retries reuse the same native ExoPlayer session, restore the failure-time
  position and play/pause intent, and keep the Flutter UI in its previous
  playback-intent state while Media3 emits its post-error non-playing state;
- retry timers are cancelled by a new media request, manual refresh, successful
  READY state, or disposal. A terminal error stops buffering/PiP/wakelock/audio
  activity, shows a category-specific user message, and reports structured
  diagnostics with a non-null synthetic stack trace. Duplicate terminal reports
  are suppressed.

The implementation commit is
`91841cbab07b46561340b2809617a0fdd082c3b7`. Formatting and targeted analysis
pass. Full `dart analyze` has no errors or warnings and retains the same 37
existing info diagnostics. All 18 Flutter tests pass, including structured
error parsing, retry limits, local/inactive-session exclusions, permanent HTTP
failure handling, and incremental delay checks. Android Debug and Release
builds pass. `flutter analyze` remains blocked before repository analysis by
the workspace Flutter SDK's missing iOS integration-test resource:

`dev/integration_tests/ios_app_with_extensions/ios/watch Extension/Assets.xcassets/Complication.complicationset/Graphic Circular.imageset`

Real-device verification is still required for recoverable disconnect/timeout,
HTTP 5xx recovery, retry exhaustion, permanent HTTP errors, decoder failure,
play and pause intent preservation, full screen, background playback, app
mini-player, and system PiP. Historical reports produced by older builds remain
unchanged; this batch improves only diagnostics generated by this and later
builds.

The final Release audit APK was rebuilt from clean HEAD
`bdcedd590f7d412fff658826c7c4df33d6cfd549` with explicit version, build
number, build time, and commit-hash defines. It passed application ID, label,
version, universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch6-error-recovery-audit-v2.apk`
- SHA-256:
  `8479DAF896D0E1EBF3D1C704348556251E20684E42B195B418E01F9FC0ED1A59`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

The audit APK is not a new delivered version and does not update the release
baseline.

### Seventh post-mini-player compatibility hardening batch

The seventh follow-up batch adds ExoPlayer-native still-frame and animated-WebP
capture without falling back to MPV:

- normal player screenshots and comment-editor video screenshots continue to
  use the shared `captureFrame` contract. Android copies the current Media3
  texture `Surface` with `PixelCopy`, corrects video rotation, pixel aspect
  ratio, and Flutter horizontal/vertical flips, then returns PNG bytes to the
  existing `ui.Image` save flows;
- capture reads only the video surface, so Flutter controls, danmaku, subtitles,
  and overlays are not included in the saved frame;
- the existing animated-screenshot range, quality-preset, progress, cancel,
  save, and playback-state UI is shared by both backends. MPV keeps the existing
  `MpvConvertWebp`; ExoPlayer uses a separate `MediaMetadataRetriever` worker on
  the selected video URL and does not seek, reload, or recreate the active
  ExoPlayer session;
- Android encodes individual WebP frames and writes a RIFF animation with
  `VP8X`, `ANIM`, and full-canvas `ANMF` chunks. Sampling runs at up to 12 fps
  and is distributed across the selected interval with a 600-frame cap;
- every conversion writes to a task-specific temporary file and publishes it
  only after the RIFF length is finalized. Cancellation completes the method
  call, interrupts pending work, removes incomplete output, and cannot delete a
  later retry's file. Cancelling the range dialog or conversion restores the
  pre-dialog play state.

The implementation commit is
`51909790a75063e630d24afc2541d5baf83eb532`. Formatting and targeted analysis
pass. Full `dart analyze` has no errors or warnings and retains the same 37
existing info diagnostics. All 20 Flutter tests pass, including screenshot
transform arguments and animated-WebP start/progress/cancel channel coverage.
The Android JVM muxer test passes and verifies the RIFF size, animation flag,
canvas dimensions, animation and frame chunks, frame durations, and odd-byte
padding. Android Debug compilation and Release build pass.

With the writable project Flutter toolchain, full `flutter analyze` now reaches
and completes repository analysis; it returns nonzero only for the same 37
existing info diagnostics, rather than the previously recorded missing iOS SDK
resource.

The Release audit APK was built from clean implementation commit
`51909790a75063e630d24afc2541d5baf83eb532` with explicit version, build number,
build time, and commit-hash defines. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-audit.apk`
- SHA-256:
  `226B54B942B799B45AD114725B74F5A9A4CC469B0A03CDB6D8643153E7460A77`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

No Android device was connected for this batch. Real-device MPV/ExoPlayer
comparison is still required for still and comment screenshots while playing
and paused, landscape/portrait and non-square-pixel media, horizontal/vertical
flips, full screen, and the app mini-player. Animated WebP also requires device
coverage for short and long ranges, presets, progress, cancellation, saving,
failure cleanup, repeat conversion, and proof that the active session position,
buffer, and play/pause state remain unchanged. The audit APK is not a new
delivered version and does not update the release baseline.

On 2026-07-30, the first audit APK reproduced a still-frame failure on a
Samsung SM-S9180 running Android 16 / SDK 36. `PixelCopy` returned code 3,
`ERROR_SOURCE_NO_DATA`, because the Flutter texture-backed surface did not have
a copyable queued frame when capture was requested. This was a real-device
failure of commit `51909790a75063e630d24afc2541d5baf83eb532`, not a Flutter
save-flow error.

Follow-up commit `99f4a11450e6bf059e12495322f7ffc6461f7358` keeps `PixelCopy`
as the fast path, retries `ERROR_SOURCE_NO_DATA` twice after short delays, and
then extracts the frame from the current video URL at the captured playback
position with an independent `MediaMetadataRetriever` worker. The fallback
uses the same request headers and source rotation metadata, preserves pixel
aspect ratio and Flutter flips, and does not seek, pause, reload, or recreate
the active ExoPlayer session. It is not an MPV fallback. If both paths fail,
the error retains both the PixelCopy result and media-source diagnostic.

The follow-up passes Kotlin Debug compilation, full `dart analyze` with no
errors or warnings and the same 37 existing info diagnostics, all 20 Flutter
tests, the Android JVM unit tests, and Android Release build. The replacement
audit APK was built from clean implementation commit
`99f4a11450e6bf059e12495322f7ffc6461f7358` and passed application ID, label,
version, universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-fix-audit.apk`
- SHA-256:
  `E5158B5EEF45D2C0481709C860E2240F9B800C69D054A53821E92EB303CEB24E`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

The Samsung Android 16 screenshot scenario and the remaining batch-seven
matrix still require real-device retesting with the replacement APK. The APK
is an audit build, not a new delivered version, and does not update the release
baseline.

The replacement APK reached the Dart image-decoding stage on the same Samsung
device, proving that the native `ERROR_SOURCE_NO_DATA` recovery returned PNG
bytes. It then failed inside `PlPlayerController.captureFrame` with a collected
native peer. The Flutter SDK contract states that
`instantiateImageCodecFromBuffer` disposes its `ImmutableBuffer` after codec
creation; the app also disposed that buffer in `finally`, causing a second
native release.

Commit `4085cc8ec0d838318fbc64c40b3e8361a9ae149d` moves captured-frame
decoding into a shared helper that uses `instantiateImageCodec(Uint8List)` and
disposes only the codec. Existing screenshot consumers remain responsible for
disposing the returned `ui.Image` after preview/save or comment attachment
encoding. A real Flutter-engine regression test decodes a PNG, disposes the
codec, and verifies that the returned image can still be encoded.

Targeted analysis passes. Full `dart analyze` has no errors or warnings and the
same 37 existing info diagnostics. All 21 Flutter tests pass, including the new
native-resource lifetime test, and Android Release build passes. The second
replacement audit APK was built from clean implementation commit
`4085cc8ec0d838318fbc64c40b3e8361a9ae149d` and passed application ID,
label, version, universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch7-capture-lifetime-fix-audit.apk`
- SHA-256:
  `FC78284B7B2DCA6B1038C2E547C103A8A53767919E69DFA23EF4E3F2508D221E`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Still capture remains pending same-device verification through preview and
save. This audit APK does not update the release baseline.

### Eighth post-mini-player compatibility hardening batch

The eighth follow-up batch starts the final backend-boundary cleanup without
removing real compatibility gaps or the MPV backend that live playback still
requires:

- video-detail subtitle selection no longer reaches either the Media3 or MPV
  controller directly. A shared `PlPlayerController.setApplicationSubtitle`
  operation now owns disabling, inline-data loading, file loading, language,
  label, and MIME dispatch for both backends;
- the video-detail SponsorBlock integration no longer exposes the MPV player
  object merely to satisfy the mixin contract. It continues to use the shared
  player-ready, playing-state, and position-listener APIs, while audio playback
  retains the mixin's existing MPV-backed default implementation;
- the Android setting is no longer labelled experimental or described as a
  switch back to MPV. It accurately names Android Media3 for on-demand video
  and states that live playback is still handled by the compatibility player.

The implementation commit is
`e93a97c20a35590052296d3ee20d16207675129b`. All affected Dart files are
formatted. Full `dart analyze` reports no errors or warnings and retains the
same 37 existing info diagnostics. Full `flutter analyze` completes repository
analysis and returns nonzero only for those same 37 info diagnostics. All 21
Flutter tests pass, and the Android Release build succeeds.

The Release audit APK was built from the clean implementation commit with
explicit version, build number, build time, and commit-hash defines. It passed
application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-backend-cleanup-audit-v2.apk`
- SHA-256:
  `33BA77BEFBC7748AF534747DD6162E4D7EE40913AC339C8D80D53CAF4A218717`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device regression is still required for disabling, loading, and switching
Bilibili and external subtitles in both MPV and Media3 modes, including
SponsorBlock position updates during play, pause, and seek. This batch does not
claim complete MPV removal: live playback, Media3 super-resolution, bitmap and
vertical subtitles, unsupported audio filters, and remaining lifecycle edges
are still explicit gaps. The v2 audit APK uses the corrected local build time
`2026-07-31 11:14:02 +08:00`; the earlier audit file remains on disk but is not
the test target. The audit APK does not update the release baseline.

The second cleanup group moves the remaining point-on-demand rendering choices
out of the player UI and mini-player UI:

- `PlPlayerSurface` is now the shared video-surface boundary. The main player
  and in-app mini player pass only `PlPlayerController` plus layout parameters;
  Media3 Texture rendering and MPV `SimpleVideo` rendering, fit mode, aspect
  override, alignment, fill, and horizontal/vertical flip stay inside the
  adapter widget;
- `PlPlayerSubtitleLayer` similarly owns the Media3 cue renderer versus the MPV
  subtitle renderer. The main player retains the same subtitle configuration,
  drag enablement, padding updates, and Flutter overlay ordering without
  reading either backend controller;
- animated WebP converter selection is isolated behind a shared factory and
  interface. `WebpPreset` is now a backend-neutral model, and the Media3
  converter no longer imports the MPV converter solely to reuse its contract;
- adapter widgets return an empty surface while their selected backend is not
  ready, avoiding forced nullable-controller access during asynchronous player
  release without adding a fallback to the other backend.

The second-group implementation commit is
`76a88888d460dffc89062536a6392edf5a325909`. All affected files are formatted.
Targeted analysis reports no issues. Full `dart analyze` has no errors or
warnings and retains the same 37 existing info diagnostics; full
`flutter analyze` completes repository analysis and returns nonzero only for
those same info diagnostics. All 21 Flutter tests pass, and the Android Release
build succeeds.

The Release audit APK was built from the clean implementation commit with
build time `2026-07-31 15:05:41 +08:00` and passed application ID, label,
version, universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-rendering-boundary-audit.apk`
- SHA-256:
  `F01609EBA9F6F96FB111A21B22A74E922B77CDC3FA8F3B77B58196C32126F6C2`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device regression is required for MPV and Media3 video rendering in the
normal player, full screen, rotation, every fit/aspect mode, both flips,
subtitle display and dragging, in-app mini-player shrink/restore, and animated
WebP start/progress/cancel/save. Live remains MPV-backed and must also be
checked for rendering regression; this refactor does not claim Media3 live
support or complete MPV removal. The audit APK does not update the release
baseline.

The third cleanup group removes the remaining direct MPV-object access from
live-page UI and business code without changing the live backend:

- `PlPlayerController` now exposes a shared video-size listener. Media3 events
  and the MPV size stream publish the same Flutter `Size` value, repeated sizes
  are suppressed, and a new media source clears the cached size so its first
  real dimensions are delivered;
- the live controller registers that shared listener instead of subscribing to
  `videoPlayerController.stream.size`, preserving the existing portrait test
  and `isVertical` update;
- the live header uses shared player readiness, player-info entries, and player
  output-volume application. It no longer reads MPV properties or calls the
  MPV player directly;
- the standalone audio page synchronizes desktop volume into an existing video
  controller through a shared operation that updates common state and always
  reapplies output volume to the selected backend.

The third-group implementation commit is
`7fcdd6d18b3f43588337d55c2d90ac8f56e3e0de`. All affected files are formatted
and targeted analysis reports no issues. Full `dart analyze` has no errors or
warnings and the same 37 existing info diagnostics. Full `flutter analyze`
completes repository analysis and returns nonzero only for those same info
diagnostics. All 21 Flutter tests pass. The Release build command reached the
tool's 120-second wait limit, but its Flutter/Gradle processes then exited
normally and wrote the new APK at `2026-07-31 16:29:54 +08:00`.

The Release audit APK embeds build time `2026-07-31 16:26:56 +08:00` and the
clean implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-live-boundary-audit.apk`
- SHA-256:
  `7D3C4B21ABDFBBEDEE19087FCB38D4029CC72154877BADCFC186A80C023516DA`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device verification is still required for live landscape, portrait, and
square video orientation; size updates after quality or route changes; player
information and player-volume controls; and desktop audio-to-video volume
synchronization. Live playback still uses MPV. This group prepares the UI and
controller boundary for future Media3 live support and does not claim that
support or update the release baseline.

The fourth cleanup group removes player-diagnostics and standalone-audio
backend objects from page widgets:

- the player-information dialog is now a shared widget that accepts only
  structured `PlayerInfoEntry` values. Video and live pages supply entries from
  `PlPlayerController`, so the video header no longer imports `NativePlayer` or
  owns an MPV-specific overload;
- the standalone audio controller owns its MPV readiness, diagnostics, output
  volume, pause, and seek operations. The audio page no longer reads or calls
  the native player and no longer imports the video header merely to show the
  same dialog;
- error-report custom metadata now labels the available player runtimes instead
  of presenting only an `MPV Api Version`. It records Android VOD Media3 and the
  MPV API version still used by compatibility paths.

The fourth-group implementation commit is
`334297bbcdcc058245aa99a201297b2ae08900e4`. All affected files are formatted
and targeted analysis reports no issues. Full `dart analyze` has no errors or
warnings and retains the same 37 existing info diagnostics. Full
`flutter analyze` completes repository analysis and returns nonzero only for
those same info diagnostics. All 21 Flutter tests pass. Android Release
`assembleRelease` succeeds in approximately 276 seconds.

The Release audit APK embeds build time `2026-07-31 16:49:59 +08:00` and the
clean implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-player-diagnostics-boundary-audit.apk`
- SHA-256:
  `3CB35E8D84E734DCC03BAFA32C97D85BBFCF62DF7E3414EB3246CA387DA8E5E2`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device regression is still required for player-information fields,
copying, and player-volume controls in Media3 VOD, MPV VOD, live playback, and
standalone audio; standalone-audio seek and pause-before-navigation behavior;
and the renamed `Player Runtimes` field in newly generated error reports. At
this fourth-group commit, live and standalone audio were MPV-backed. The next
group changes Android live playback to Media3; standalone audio remains MPV.
This audit APK does not update the release baseline.

### Eighth-batch Media3 live playback group

The fifth eighth-batch group removes the Android live-playback exclusion and
connects live semantics through the existing backend-neutral controller:

- Android uses Media3 for live playback whenever the Media3 setting is enabled;
  there is no silent MPV fallback;
- the live flag now travels from `PlPlayerController`, through the Flutter
  method channel, into the native media request. Live media items use a Media3
  `LiveConfiguration` and the source's default live position;
- initial open, manual refresh, quality/route/CDN/audio-only source changes, and
  retry do not seek to a stale absolute position from a previous live window.
  Retry keeps the play/pause intent and returns to the current default live
  position;
- native and Flutter state handling do not publish a live `STATE_ENDED` as VOD
  completion. The existing live UI continues to suppress seeking, progress,
  replay, and long-press speed semantics;
- changing quality, route, or audio-only mode while paused now keeps the live
  session paused. Initial room entry still follows the existing autoplay
  behavior;
- the Android setting and diagnostic runtime text now describe Media3 Android
  video rather than VOD-only Media3.

The existing MPV live-buffer preference is expressed in byte-cache options,
whereas Media3 load control is time based. This group deliberately uses Media3's
default live buffering instead of inventing a lossy conversion. Buffer tuning
remains subject to real-device latency and stability measurements.

The implementation commit is
`585bcfd5dd71ad520fb1a22e80d8ff6d0ad86a46`. Targeted Dart analysis passes,
the Media3 controller test suite covers the explicit live method-channel
request, full `dart analyze` has no errors or warnings and the same 37 existing
info diagnostics, full `flutter analyze` completes repository analysis and
returns nonzero only for those diagnostics, and all 22 Flutter tests pass.
Android Kotlin Debug compilation and Android Release build also pass.

The final Release audit APK embeds build time
`2026-07-31 17:27:51 +08:00` and the clean implementation commit. It passed
application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-media3-live-audit-v2.apk`
- SHA-256:
  `C5BAB51DE83177F240B68FAD4C719B22963EED412CB792845B2210B632C6E465`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

The earlier audit without the paused source-switch preservation fix is not the
test target. Real-device MPV/Media3 comparison is still required for landscape,
portrait, and square live video; AVC/HEVC and every protocol/format combination
actually returned by the service; play/pause; quality, route, codec, and CDN
changes; paused switching; audio-only mode; manual refresh; disconnect/recovery
and retry exhaustion; audio focus, background playback, media notification,
the app mini-player, system PiP, foreground/background transitions, and room
close/reopen. Until that matrix passes, live is implemented but not accepted as
fully compatible. The audit APK does not update the release baseline.

### Eighth-batch subtitle edge group

The sixth eighth-batch group closes the implementation gaps for Media3 bitmap
and vertical subtitle cues without moving subtitle rendering out of the Flutter
overlay:

- image-only Media3 cues are retained. Android encodes PGS/DVB and other cue
  bitmaps as transparent PNG on a bounded single-thread worker, drops stale
  results by cue sequence and media generation, reports encoding failures, and
  compares byte-array contents when suppressing duplicate events;
- bitmap pixel dimensions, viewport-relative width and height, position, line,
  and anchors travel through the existing event channel. Flutter sizes and
  positions the image against the complete video viewport, independently of
  the user padding and drag settings intended for text subtitles;
- vertical-rl and vertical-lr cues use Media3's writing-axis interpretation for
  fractional and numbered lines. Long text flows into further columns, explicit
  newlines preserve empty columns, alignment is applied along the writing axis,
  and mixed text/bitmap cues retain stable z-index order;
- vertical text requests OpenType `vert`/`vrt2` glyphs, rotates sideways Latin
  runs, and carries Media3's `HorizontalTextInVerticalContextSpan` as
  `text-combine-upright`. Vertical shear uses the block-axis `skewY` transform;
- malformed bitmap bytes resolve to an empty image widget instead of surfacing
  a Flutter rendering exception.

The implementation commit is
`985d51a7fd270713af40af324e3aea9a2a1448f4`. Targeted Dart analysis reports no
issues. Full `dart analyze` has no errors or warnings and retains the same 37
existing info diagnostics; full `flutter analyze` completes repository
analysis and returns nonzero only for those diagnostics. All 27 Flutter tests
pass, including bitmap size/anchor, vertical RL/LR position, numbered-line
spacing, long-cue column flow, combined upright text, and malformed image
coverage. Android Kotlin Debug compilation and the Android Release build pass.

The Release audit APK embeds the clean implementation commit and passed
application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-subtitle-edge-audit.apk`
- SHA-256:
  `F84562BDC487741BB514ADB221648966EF836028ED4548E40921EDCDDC9BAFEE`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance remains required with local and network media carrying
PGS or DVB image subtitles, including transparency, size, anchor, cue changes,
switching, disabling, and seeking. WebVTT vertical-rl and vertical-lr require
comparison for multiple columns, Latin/digits, punctuation, styled spans, and
combined upright text in normal view, full screen, rotation, the app
mini-player, and system PiP. These cases must also be compared with MPV using
equivalent media. This group is implemented but not yet accepted as fully
compatible, and the audit APK does not update the release baseline.

### Eighth-batch buffering and decoder-settings group

The seventh eighth-batch group connects existing user-visible playback
preferences to Media3 session construction instead of silently ignoring them:

- `enableHA` selects the MediaCodec policy when the native session is created.
  Enabled sessions use the platform decoder order with fallback; disabled
  sessions restrict video to software-only codecs while leaving audio decoder
  selection unchanged;
- the existing buffer-size preference becomes an explicit Media3 target-buffer
  byte budget. The approximately doubled value preserves the MPV preference's
  separate forward and backward byte budgets as one Media3 total budget;
- VOD applies the speed-adjusted buffer-duration preference to Media3's minimum
  and maximum streaming buffer and backward retention. Live keeps Media3's
  default low-latency time thresholds and applies only the byte budget;
- the Media3 player-information entries expose the effective decoder policy,
  target MiB, and VOD duration, or `live-default` for live time thresholds, so
  device testing can verify that a newly opened session consumed the settings;
- settings text now distinguishes shared behavior from MPV-only autosync,
  video-sync, and concrete hwdec mode lists. Numeric buffer inputs reject zero,
  negative, and non-finite values.

The implementation commit is
`cecd7d3c0fbd2c8470b19cbae208848d67f4744e`. Targeted Dart analysis reports no
issues. Full `dart analyze` has no errors or warnings and retains the same 37
existing info diagnostics; full `flutter analyze` completes repository
analysis and returns nonzero only for those diagnostics. All 29 Flutter tests
pass. Android Kotlin Debug compilation and the Android Release build pass.

The Release audit APK embeds build time `2026-07-31 19:25:43 +08:00` and the
clean implementation commit in all three ABI `libapp.so` files. It passed
application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-buffer-decoder-audit.apk`
- SHA-256:
  `41EBB35F0FAC766786698DB244065C800AF5D4AE6BD77D438D41A976E3F1A6E5`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance remains required for default, small, and large buffer
values across VOD startup, seeking, continuous playback, disconnect recovery,
and memory use; live latency and stability with the default time policy;
hardware-on and software-only decoding with the displayed configuration and
actual decoder names; AVC, HEVC, AV1, split DASH audio/video, local files,
quality and part switches, full screen, background, the app mini-player, and
system PiP. MPV buffer, autosync, video-sync, and hwdec behavior must be
regressed as well. This group is implemented but not yet accepted as fully
compatible, and the audit APK does not update the release baseline.

This status was superseded by real-device feedback on 2026-08-02. On a Samsung
SM-S9180 running Android 16, the `cecd7d3` audit build showed black video for all
tested content while controls remained visible and playback position advanced.
The custom decoder and load-control behavior is therefore no longer considered
implemented pending acceptance; it has been disabled by the compatibility
hotfix documented below and must be reintroduced one setting at a time after
video output is restored.

### Eighth-batch Media3 super-resolution group

The eighth eighth-batch group replaces the remaining ExoPlayer
"not implemented" super-resolution path with a real-time Media3 GPU effect:

- the Android app now includes the matching `media3-effect` 1.10.1 module and
  applies `LanczosResample` to the existing ExoPlayer session and Flutter
  texture. Efficiency scales by at most 1.5 times to a 1080p bound; quality
  scales by at most two times to a 4K bound. The target calculation is
  orientation-neutral, preserves aspect ratio, and never downscales a source
  that is already at or above the selected bound;
- disabled, efficiency, and quality modes switch through the existing public
  player controller and MethodChannel without reopening the media, creating a
  new session, seeking, or changing play/pause intent. A source change clears
  the old output target before resolving the new source size. Existing frame
  capture continues to read the processed texture;
- the PGC default preference now applies to both MPV and Media3. Playback
  information exposes `SuperResolution` as disabled, waiting for source size,
  no-upscale-needed, or the exact Lanczos source and target dimensions;
- settings text accurately distinguishes Media3 Lanczos from the MPV Anime4K
  shader path instead of describing MPV decoder requirements as universal.

The implementation commit is
`720d161ef1812f3ce8481f57b280889753c364ef`. Relevant Dart files are formatted
and targeted Dart analysis reports no issues. Full `dart analyze` has no errors
or warnings; this tool invocation reports 38 existing info diagnostics because
the package-name diagnostic is emitted twice. Full `flutter analyze` completes
repository analysis and returns nonzero only for the established 37 info
diagnostics. All 31 Flutter tests pass, including the new event parsing and
no-reopen MethodChannel coverage. Android Kotlin Debug compilation and unit
tests pass, including four target-size tests for disable, landscape, portrait,
the 4K cap, and no-downscale behavior. The Android Release build also passes.

The final Release audit APK embeds build time `2026-08-01 14:52:12 +08:00` and
the exact implementation commit in all three ABI `libapp.so` files. It passed
application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-media3-super-resolution-audit-v2.apk`
- size: `67,767,758` bytes
- SHA-256:
  `4D07B92A47B12400FA7C365D7A81309EC85AEFEBCDE05091524BC7B146E2CF8C`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

The first audit APK without injected commit and build-time metadata is replaced
by v2 and is not a test target. Real-device acceptance remains required for
disabled/efficiency/quality in-playback switching, preference restore,
play/pause and position retention; 480p, 720p, 1080p, and 4K landscape,
portrait, and square sources; AVC, HEVC, AV1, SDR/HDR, split DASH audio/video,
local files, quality
and part switching; normal view, full screen, rotation, background playback,
the app mini-player, system PiP, and screenshots. Visual result, frame rate,
GPU and memory load, temperature, and battery use must be compared with both
MPV Anime4K modes. The ADB server probe did not return within the available
window, so this group is implemented but not yet accepted as fully compatible.
The audit APK does not update the release baseline.

After the later Samsung black-video feedback, this standalone super-resolution
audit APK is no longer a device-test target because it still contains the
regressed `cecd7d3` player construction. The black-video hotfix v2 below includes
the same super-resolution implementation and is the replacement test target.

On 2026-08-02 the user exercised disabled, efficiency, and quality switching on
the hotfix build and explicitly accepted the current Media3 behavior as an
effective feature. Seamless switching is intentional and does not need to copy
the pause/reload seen when the upstream MPV/Anime4K shader pipeline changes.
The user also accepted that the present Lanczos resampling may have little
obvious visual difference. This closes basic super-resolution effect acceptance;
broader resolution, codec, HDR, screenshot, full-screen, mini-player, PiP, and
performance coverage can be combined with their corresponding regression tests.
It does not waive the rolled-back buffering/decoder-settings gap.

### Eighth-batch black-video compatibility hotfix

Real-device feedback on 2026-08-02 identified a P0 regression in the
`cecd7d3` buffering/decoder audit build on Samsung SM-S9180 with Android 16:
controls and position updates continued, but every tested video remained black.
A separate report from the same build contained an HTTP 403 from one bilivideo
CDN URL; that source failure is tracked independently and does not explain a
session whose playback position advances.

The only native playback-construction changes between the preceding known
playable build and `cecd7d3` were the custom MediaCodec selection/fallback and
`DefaultLoadControl`. Commit
`552e0bc21c7b56c5074e218fde930052a059c6aa` conservatively restores both to
Media3 defaults. This is a regression-boundary rollback, not yet a confirmed
root-cause statement; device evidence is still required to identify which
subcomponent caused the Samsung failure. Flutter continues passing the stored
preferences, but native playback intentionally does not apply them during this
compatibility period. Commit
`e0a3bffb16416ad489286c6ce8006622e2ffdcde` updates settings text and playback
configuration diagnostics to state that effective behavior clearly.

The hotfix also avoids calling `setVideoEffects(emptyList())` while opening a
new source unless a super-resolution effect was actually active on the old
source. This keeps the disabled default path out of Media3's effects pipeline.
Native `onRenderedFirstFrame` is propagated to Flutter and exposed in player
information as `VideoOutput / firstFrameRendered`, allowing a remaining black
screen to be separated into no decoded/rendered first frame versus a later
Surface/Flutter Texture presentation failure.

Relevant Dart files are formatted and targeted analysis reports no issues.
Full `flutter analyze` completes and returns nonzero only for the established 37
info diagnostics, with no new error or warning. All 31 Flutter tests pass.
Android Release Kotlin compilation and the complete Android Release build pass.
The final v2 audit APK passed application ID, label, version, universal ABI, and
signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-black-video-hotfix-audit-v2.apk`
- embedded commit: `e0a3bffb16416ad489286c6ce8006622e2ffdcde`
- build time: `2026-08-02 15:31:34 +08:00`
- size: `67,766,802` bytes
- SHA-256:
  `BA6C5D09BDA28BC9C31B5F36D17EAAEEC8BB7211E6FC2BBE1F517DE9DF6B12B1`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

The first hotfix audit APK without the corrected settings explanation is
superseded by v2 and is not a test target. On 2026-08-02 the user installed v2
on the reporting Samsung Android 16 device and confirmed that video output had
recovered. This closes the reported P0 black-video regression for the tested
playback, and confirms that the restored Media3-default compatibility path can
render video. It does not identify whether custom MediaCodec selection or
`DefaultLoadControl` was the specific cause, and the exact content/scenario
matrix was not reported.

Extended real-device regression remains required for ordinary UGC, PGC, split
DASH media, quality and part changes, full screen, background, app mini-player,
and system PiP. The custom buffering and decoder settings remain rolled back
and must be reintroduced one at a time with device comparison. Consequently the
eighth batch is not yet complete, and the audit APK does not update the formal
release baseline.

### Eighth-batch safe-buffering isolation group

Commit `c04a79fff718b4ce9024883d1bf898af43ddd7cc` reintroduces only Media3 VOD
buffer preferences on top of the Samsung-compatible hotfix. Decoder selection
remains the proven platform-default path, and live sessions retain an entirely
default Media3 `LoadControl`. This keeps the two prior regression variables
separate.

Inspection of Media3 1.10.1's actual `DefaultLoadControl` bytecode confirmed
that the old configuration used the approximately 8 MiB default preference as
a size-first stopping threshold. It could stop loading before the configured
time minimum. The replacement streaming-VOD policy uses a safe time-first
minimum of up to five seconds. After that floor, the requested byte target or
maximum duration can stop loading, and the configured duration is retained as
the back buffer. Very small inputs are clamped to valid boundaries. Local media
keeps Media3's local time thresholds; live keeps all Media3 defaults.

Player information exposes the isolation unambiguously:

- decoder: `platform-default`, plus the requested but intentionally deferred
  hardware/software setting;
- VOD buffer: `custom-safe`, effective target MiB, minimum and maximum time,
  and `timePriority=true`;
- live buffer: `media3-live-default`.

Relevant Dart files are formatted and targeted analysis reports no issues.
Full `flutter analyze` returns nonzero only for the established 37 info
diagnostics and has no new error or warning. All 31 Flutter tests pass. Android
`testDebugUnitTest` passes, including three new policy tests for defaults, tiny
inputs, and live defaults. The complete Android Release build passes. The audit
APK passed application ID, label, version, universal ABI, and signing-certificate
verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-safe-buffer-isolation-audit.apk`
- embedded commit: `c04a79fff718b4ce9024883d1bf898af43ddd7cc`
- build time: `2026-08-02 16:59:28 +08:00`
- size: `67,767,957` bytes
- SHA-256:
  `98DC2B678746CA6C273EA625C0C87A4E06441B16FCE1CE0C83C67ABDDE49C836`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance starts on the reporting Samsung Android 16 device with
ordinary VOD first frame, continuous playback, seeking, and reopen. Player
information must show `buffer=custom-safe` and `firstFrameRendered: true`. If
video remains visible, the old P0 can be narrowed toward decoder selection and
a decoder-only isolation build can follow. If black video returns, this buffer
group must be rolled back before decoder work. Until that result, buffering is
implemented but pending device acceptance, and the eighth batch remains open.

### Eighth-batch standalone-audio Media3 group

Commit `e1db70736210e0a30070c15ffd36d44a90ff8f8d` removes the remaining direct
MPV dependency from the standalone audio page when Android Media3 is selected:

- standalone audio URLs open on the existing Media3 bridge, including the
  required User-Agent, optional Referer, initial position, user buffer values,
  playback speed, and clamped Android player-volume preference;
- play, pause, seek, play/pause toggle, previous/next item, UGC part changes,
  repeat modes, completion, and player diagnostics use backend-neutral audio
  controller state. Media3 completion is edge-triggered so repeated merged
  native state events cannot advance the playlist more than once. Events after
  controller disposal are ignored;
- initial autoplay obtains audio focus before opening the source. Continuous
  playlist and repeat transitions retain the session, while manual pause,
  terminal completion, failure, and disposal release it;
- the audio-session service can route interruption pause/resume, ducking gain,
  becoming-noisy events, and wired/Bluetooth route loss to standalone audio as
  well as video. The media-notification service accepts an explicit standalone
  owner, so metadata, status, position, play/pause, and seek no longer require a
  simultaneous `PlPlayerController` instance;
- stacked standalone audio routes retain owner-specific callbacks. Disposing an
  older route does not clear controls registered by the current route;
- non-Android platforms and Android with Media3 disabled retain the existing MPV
  implementation and amplified desktop-volume semantics.

All changed Dart files are formatted and targeted analysis reports no issues.
Full `dart analyze` has no errors or warnings and retains the established 37
info diagnostics. Full `flutter analyze` completes repository analysis and
returns nonzero only for the same diagnostics. All 34 Flutter tests pass,
including new Media3 completion deduplication, post-disposal event rejection,
and audio-only MethodChannel open/control coverage. The complete Android Release
build passes.

The Release audit APK embeds build time `2026-08-02 20:14:34 +08:00` and the
exact implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-standalone-audio-audit.apk`
- size: `67,783,611` bytes
- SHA-256:
  `DFEB317FAC607A2F91D539CB315B4215F674B421A2D8A700782CB55117DAA589`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance remains required in both Media3 and MPV modes for direct
audio URLs, audio playlists, UGC parts, initial position, play/pause, seeking,
speed, volume, previous/next, and every repeat mode; background and screen-off
playback; notification, lock-screen, and headset controls; interruption
pause/resume and ducking; wired-headset unplug and Bluetooth disconnect; source
errors, rapid item changes, disposal, and route re-entry. This group is
implemented but not yet accepted as fully compatible. The audit APK does not
update the formal release baseline, and the unresolved safe-buffer/decoder and
other eighth-batch gaps keep the eighth batch open.
### Eighth-batch decoder-isolation and dynamic-audio group

On 2026-08-03 the user confirmed on the reporting Samsung SM-S9180 Android 16
device that the safe-buffer isolation build (`c04a79f`) no longer shows black
video, so the previous P0 is narrowed to decoder configuration and the planned
decoder-only isolation step is unblocked.

Commit `3389f5a78beb1d7dca8f2ee1ece6ae7a78df0d74` restores Media3 decoder
selection on top of the safe buffering policy:

- hardware decoding enabled uses the platform MediaCodec order with decoder
  fallback enabled; disabled restricts video-track decoder selection to
  software MediaCodecs while audio-track selection is untouched;
- `PlaybackConfig` now reports `decoder=hardware` or `decoder=software` plus
  `decoderFallback=true`, replacing the deferred `platform-default
  (requested=...)` marker; live still keeps Media3 default low-latency
  `LoadControl` and the VOD `custom-safe` buffer description is retained;
- media source routing is centralized in `resolveMediaUri`: bare local paths
  become `file://` URIs, while `http(s)://` and `content://` URIs pass
  through unchanged. The same helper serves main media and app-loaded
  subtitles.

The same commit adds Media3 equivalents for the previously unsupported
one-pass `loudnorm` (no server measurements) and `dynaudnorm` filters:

- the native `AudioNormalizationProcessor` gains a windowed RMS automatic-gain
  mode with target loudness, maximum gain, frame length, and per-window
  smoothing, followed by the existing true-peak limiter;
- output buffers explicitly inherit the input byte order so reused little-
  endian pool buffers cannot swap PCM16 bytes;
- measured two-pass `loudnorm` keeps the existing static gain/peak-limit path;
  chained and arbitrary custom FFmpeg filters remain an explicit unsupported
  gap with the existing user-facing notice.

All changed Dart files are formatted and targeted analysis reports no issues.
Full `dart analyze` has no errors or warnings and retains the established 37
info diagnostics. Full `flutter analyze` completes repository analysis and
returns nonzero only for the same diagnostics. All 36 Flutter tests pass. The
`:app` Kotlin unit suite (14 tests) passes, including dynamic normalization
gain/limiter behavior, disabled passthrough, and media-URI routing. The
complete Android Release build passes.

The Release audit APK embeds build time `2026-08-03 10:49:16 +08:00` and the
exact implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-decoder-dynamic-audio-audit.apk`
- size: `67,785,840` bytes
- SHA-256:
  `55922DE3801947267B327ADFB696DDA47537DDF4907419ABE738F677AB5883A7`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance remains required with hardware decoding on and off for
AVC, HEVC, AV1, DASH, live, local files, quality/part changes, first frame,
seeking, reconnect, full screen, background, app mini-player, and system PiP,
plus `PlaybackConfig` decoder fields; dynamic volume equalization needs
listening comparison against mpv `dynaudnorm`/one-pass `loudnorm`, including
switching, background, app mini-player, and system PiP. Chained and arbitrary
custom FFmpeg filters and remaining lifecycle edges keep the eighth batch open,
and the audit APK does not update the formal release baseline.

### Eighth-batch audio-filter-chain group

Commit `531f2a854427de4ffccc6af711c01369e6aa6d84` extends the Media3 audio
normalization mapping from single filters to supported filter chains:

- the FFmpeg chain is split on `,` into stages; `volume=` (linear or `dB`
  values) and exactly one `loudnorm=`/`dynaudnorm=` stage are supported;
- volume stages are folded with volume-last semantics: static measured
  loudnorm gain is multiplied by the volume multiplier, and dynamic targets
  are shifted by the corresponding decibels. Multiple volume stages multiply;
  `volume=0` maps to a silent static gain instead of an infinite target;
- a chain containing an unknown stage (for example `compressor=threshold=0.5:ratio=2`) or more
  than one loudness stage falls back with the exact offending stage name in
  the user toast instead of a generic message;
- the MPV path still receives the original full FFmpeg chain unchanged.

All changed Dart files are formatted and targeted analysis reports no issues.
Full `dart analyze` has no errors or warnings and retains the established 37
info diagnostics. Full `flutter analyze` completes repository analysis and
returns nonzero only for the same diagnostics. All 43 Flutter tests pass,
including volume-only and decibel volume chains, volume folding into
dynaudnorm/one-pass/measured loudnorm, exact unsupported-stage reporting,
multi-loudness-stage rejection, and malformed volume rejection. The complete
Android Release build passes.

The Release audit APK embeds build time `2026-08-03 13:31:47 +08:00` and the
exact implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-audio-filter-chain-audit.apk`
- size: `67,790,986` bytes
- SHA-256:
  `A00834A02C86F0632E95DDB94B34F2DEC01A37006F5A1D2888396BD9BDA0EDCA`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device listening comparison against MPV remains required for chains such
as `volume=0.8,loudnorm=...` and `dynaudnorm=...,volume=-3dB`, including
switching, background, app mini-player, and system PiP, plus confirmation that
chains with unknown stages show the specific filter name. Unknown filters,
multiple loudness stages, and arbitrarily complex FFmpeg chains remain an
explicit unsupported gap, and the audit APK does not update the formal release
baseline.

### Eighth-batch decoder software-fallback retry group

Commit `0c647b51ae60defc39c6171e5ca9387e43e596d2` adds one automatic
hardware-to-software fallback retry for Media3 decoder/renderer failures:

- when a failure carries a Media3 decoder error code and hardware decoding was
  enabled, the session rebuilds its `ExoPlayer` with the software-only video
  codec selector, preserving position, play/pause intent, app subtitle state,
  and the super-resolution mode, then re-prepares the same media;
- the fallback is attempted at most once per media open; a second decoder
  failure becomes the existing terminal diagnostic path. Network/source retry
  behavior is unchanged;
- the user toast reports the fallback, `PlaybackConfig` switches to
  `decoder=software`, and terminal diagnostics append
  `softwareVideoFallback: attempted`;
- local-file decoder failures also use the fallback, since software decoding
  is valuable there too.

All changed Dart files are formatted and targeted analysis reports no issues.
Full `dart analyze` has no errors or warnings and retains the established 37
info diagnostics. Full `flutter analyze` completes repository analysis and
returns nonzero only for the same diagnostics. All 48 Flutter tests pass,
including one-shot fallback, no-retry-after-fallback, inactive-session
rejection, local-file fallback, and network-retry isolation. `:app` Kotlin
compilation and unit tests pass, and the complete Android Release build passes.

The Release audit APK embeds build time `2026-08-03 13:48:47 +08:00` and the
exact implementation commit. It passed application ID, label, version,
universal ABI, and signing-certificate verification:

- APK:
  `build/app/outputs/flutter-apk/pili++-2.1.3-2026072808-universal-release-exo-batch8-decoder-fallback-audit.apk`
- size: `67,791,135` bytes
- SHA-256:
  `209A2095E3680757F6A7F7F741759DD215CEF8F2DDB4D4F4709DDB28D1AEC9B6`
- certificate SHA-256:
  `775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`

Real-device acceptance remains required by forcing an actual hardware-decoder
failure (for example an unsupported codec/HDR combination or malformed media)
and confirming the software fallback continues playback without progress loss
or black video, with `PlaybackConfig` showing `decoder=software`; network/source
retry, live playback, and standalone audio must remain unaffected. The audit
APK does not update the formal release baseline.

### Android video-page downward gestures

The first 2026-08-09 audit build was rejected by real-device feedback: the
video pull did not enter the mini player, portrait-full-screen entry had no
animation, and any downward pull in a long detail page could trigger full
screen even when the page was not at the top. That APK is superseded and is no
longer a test target.

The v3 audit was also rejected by real-device feedback: video pulls still did
not enter the mini player, and pointer-down position was not a reliable proxy
for the nested detail view's actual top boundary. The v4 implementation keeps
both gestures backend-neutral but replaces both event chains:

- a deliberate downward swipe is observed directly by the windowed video
  widget, without inferring video bounds from the detail-page root. At 48
  logical pixels it first establishes ownership in the existing in-app
  mini-player service and then pops the detail route. The service reuses the
  same player, Flutter Texture, playback position, and source-rectangle
  animation; neither MPV nor Media3 reopens or seeks the source;
- pulls outside the video are no longer inferred from page-level pointer
  displacement. Distance accumulates only from a user-driven, negative Android
  `OverscrollNotification` while the outer detail scroll position is actually
  at its minimum. Normal scrolling toward the top, ballistic scrolling, and
  pulls in the middle or bottom cannot enter the full-screen path. At 72
  logical pixels the video header completes its finger-following expansion and
  animates to portrait full screen over approximately 260 ms. Explicit portrait
  entry does not rewrite the stored default-full-screen preference;
- per the user's final decision, the entire comment tab is excluded, including
  its tab/header and list. Comment scrolling and pull-to-refresh retain their
  original behavior;
- video raw-pointer observation does not join Flutter's gesture arena.
  Directional bias rejects short, upward, or predominantly horizontal movement,
  and a disabled mini-player setting preserves existing player gestures.

Targeted Dart analysis reports no issues, the complete Flutter suite passes
59/59, and Android Release builds successfully. The v4 audit APK
`build/app/outputs/flutter-apk/pili++-2.1.4-2026080901-universal-release-youtube-pull-gesture-audit-v4.apk`
passes application identity, version, universal ABI, and signing-certificate
verification; its SHA-256 is
`3D4E93956676F6E185C3B29937CEBD06855CD2605F5FAAF32AA7BDAEF2F2526C`.
It was built from the complete current worktree and therefore also contains the
pre-existing uncommitted audio-filter changes; it is not a gesture-only
isolation build.

Real-device acceptance remains required in both MPV and Media3 modes for
playing and paused video, enabled/disabled mini-player preference, portrait
full-screen entry and animation from the top of intro/related content, no
trigger from the middle or bottom, complete comment-tab scroll and refresh,
horizontal seek, vertical brightness/volume, mini-player restore and repeated
entry, and normal/full-screen orientation transitions. Until that comparison
is complete, v4 is implemented but pending device acceptance. All v1-v3 audit
packages are superseded and must not be used.

On 2026-08-10, the user confirmed that the v4 mini-player pull and detail-top
overscroll entry now work, then requested the reverse portrait-full-screen
gesture. V5 adds a backend-neutral upward pull directly on the portrait
full-screen video surface:

- the header follows the finger from full height toward its normal detail-page
  height;
- at 72 logical pixels, the remaining transition completes with the existing
  approximately 260 ms easing curve and exits full screen while explicitly
  retaining portrait orientation;
- releasing before the threshold animates back to full height over 160 ms;
- player-lock, multi-pointer, downward, short, and predominantly horizontal
  gestures do not trigger the exit.

Targeted Dart analysis reports no issues and the complete Flutter suite passes
61/61. Android Release and release-identity verification pass for
`build/app/outputs/flutter-apk/pili++-2.1.5-2026081001-universal-release-portrait-fullscreen-swipe-up-v5.apk`.
Its APK SHA-256 is
`7BF081F42736EDF1B8E4B814D8F5638C40CCE7D43065B268BE8C3E38484C61FA`,
and its signing-certificate SHA-256 remains
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
Real-device acceptance remains required for finger tracking, threshold exit,
short-pull snap-back, locked controls, and MPV/Media3 parity.

### 2026-08-10 upstream sync to 36dec60

`upstream/main@36dec609315cd34f8895cf15607f1cc582a66f01` was merged into
local `main` as `ae6b7aaceefb5d4218693c15825f751c3b7a1f4d`. The merge keeps the
`com.shudo.plusplus` application identity, Media3 dependencies, ExoPlayer
track/player-information controls, subtitles, SponsorBlock, PiP, mini-player
session handoff, and the three video-page pull gestures. It adopts the upstream
SDK 37 configuration and the new `SimpleScaffold`, `MiniScaffold`, status-bar,
intro, refresh, and hit-test layout.

The pre-merge worktree changes were restored after the merge. Full Dart
analysis reports zero errors and warnings with 35 info diagnostics; the full
Flutter suite passes 61/61; Android `:app:testDebugUnitTest` and the Release APK
build pass. The validation APK is
`build/app/outputs/flutter-apk/pili++-2.1.5-2026081001-universal-release-upstream-36dec60-validation.apk`
with SHA-256
`B2A8DC5D266B42571E22EF0A2628DEEB7CC690DDAF6763D4667CF543EDADB1CE`.
Release verification confirms `com.shudo.plusplus`, label `pili++`, version
`2.1.5+2026081001`, universal ABI, and certificate SHA-256
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
This artifact is a sync validation build and does not replace the delivered v5
or update the formal release baseline.

Real-device regression remains pending in both MPV and Media3 modes for VOD,
controls, all three pull gestures, mini-player restore, system PiP, live and
standalone audio, foreground/background transitions, and lifecycle recovery.
Automated verification alone is not evidence that the MPV compatibility
baseline remains fully intact.

### 2026-08-10 refresh-layout semantics hotfix

The Samsung SM-S9180 Android 16 validation build reported repeated
`RenderSemanticsAnnotations was not laid out` and null geometry failures during
Flutter semantics flushing, followed by a secondary first-frame
`Future already completed` error. The stack contains no Media3 native frame.

The upstream `RefreshLayout` skipped layout for its slotted indicator while
both animations were zero, although the semantics tree still visited that
child and requested its `semanticBounds`. The render object now always gives
the hidden indicator a valid zero-size layout and schedules animation changes
through `markNeedsLayout` instead of laying out a child outside the layout
phase. Refresh displacement is passed explicitly by `RefreshIndicator` rather
than read from global Hive state inside the render object.

A semantics-enabled widget regression covers the hidden zero-size state and
the visible 49-pixel state. The focused test and the complete Flutter suite
pass, with 62 total tests. Real-device verification remains required on the
reporting Samsung Android 16 device for initial video-page layout, detail and
comment refresh, portrait-full-screen pull, mini-player restore, route re-entry,
and TalkBack enabled/disabled. The hotfix delivery version is
`2.1.6+2026081002`.

The universal Release APK is
`build/app/outputs/flutter-apk/pili++-2.1.6-2026081002-universal-release-refresh-semantics-hotfix.apk`
with SHA-256
`4685A4A3BCA1D55EF299A529703A1684DB4DDE2946D34DC6DE988C8BBA45E4AF`.
Release verification confirms application ID `com.shudo.plusplus`, label
`pili++`, version `2.1.6+2026081002`, all required universal ABIs, and the
existing certificate SHA-256
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.

### 2026-08-10 YouTube-style pull animation compositing

The supplied Samsung Android 16 recordings were sampled at 60 fps by tracking
the detail-panel boundary. The first pili++ pull contained only 10 distinct
positions over about 0.7 seconds and paused at one position for up to 267 ms;
the comparable YouTube pull contained 31 distinct positions and no pause longer
than about 50 ms. The corresponding implementation rebuilt and relaid out the
entire `ExtendedNestedScrollView` on every animation tick, and committed the
full-screen transition before the pointer was released.

The video header and detail body now keep stable sliver layout extents. Two
isolated `AnimatedBuilder` layers move the existing repaint-bounded player and
detail surface with composited transforms; animation ticks no longer call
page-level `setState` or change the nested-scroll header height. Pointer travel
maps linearly to the available visual travel, and both detail pull-to-fullscreen
and portrait-fullscreen swipe-up commit only on release. The existing 48-pixel
video pull-to-mini-player action, comment-tab exclusion, true-top check, lock
handling, and horizontal/vertical player gestures remain in place.

Focused gesture and composition tests pass 11/11, the complete Flutter suite
passes 66/66, and full Dart analysis reports zero errors and warnings with 35
existing info diagnostics. Android Release and release-identity verification
pass for version `2.1.7+2026081003` at
`build/app/outputs/flutter-apk/pili++-2.1.7-2026081003-universal-release-youtube-pull-animation-v6.apk`.
Its APK SHA-256 is
`39970ED9E752F79B9040CBEEF08DF1B68C524DDB40B24F57AAC13BA783A0E90F`;
the signing-certificate SHA-256 remains
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
MPV/Media3 parity and 120 Hz frame pacing still require real-device replay of
short snap-back, threshold entry, swipe-up exit, portrait video, player
gestures, refresh, mini-player entry, and mini-player restoration.

### 2026-08-10 portrait-full-screen player resize continuity

The V6 Samsung recording exposed a remaining two-stage transition. The black
player region and detail surface moved with pull progress, but the actual
player stayed at its normal detail-page height. Its height changed only after
the full-screen state committed, which looked like a translation followed by a
separate enlargement. The reverse path had the same discontinuity.

`PagePullVideoExpansion` now interpolates the actual player height from the
normal header height to the portrait-full-screen height with the shared pull
animation. `videoPlayer`, its video surface, and its controls therefore relayout
together during both finger tracking and the remaining release animation. The
old fixed-height child translation by half the added black space is removed.
The surrounding sliver extent remains stable and the detail body still uses an
isolated composited translation, so this does not restore full-page layout on
every animation tick.

Focused gesture and transition tests pass 11/11, the complete Flutter suite
passes 66/66, and full Dart analysis reports zero errors and warnings with 35
existing info diagnostics. Android Release and release-identity verification
pass for version `2.1.8+2026081004` at
`build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-pull-resize-v7-final.apk`.
Its APK SHA-256 is
`6748CDFF54C5B3C0BE7C2B5369AEE99CEF4486D838E250EDD2C3F43C6E3E40DA`;
the signing-certificate SHA-256 remains
`775803BD534E2A0984CF8E7796DCF1D82FD7D436F10A1FEDA77C6981F4C44C5C`.
Real-device acceptance remains required in MPV and Media3 for entry, exit,
short-pull snap-back, landscape and portrait media, playing and paused states,
and confirmation that position and size track together without an endpoint
jump.

### 2026-08-11 media replacement aspect-ratio refresh

Automatic continuation reused the same Media3 session but retained the previous
media's display width and height until `onVideoSizeChanged`. The `open` request
did not carry the new video's dimensions, and the Flutter texture view ignored
zero-size reset events. A 4:3 item could therefore leave the reused Texture and
view constrained to 4:3 while the following 9:16 item started; a directly opened
portrait item could also begin with the fallback or stale dimensions.

The backend-neutral controller now sends the selected media's known width and
height with every Media3 `open`. At the start of the new source generation, the
native session clears the previous display state, resets rotation, and resizes
the `SurfaceProducer` from that hint before preparing the source. The decoded
Media3 `VideoSize` remains authoritative and replaces the hint when available.
`ExoPlayerView` now tracks source generations as well as dimensions, so an
unknown-size new source returns to the 16:9 placeholder instead of retaining the
previous item's aspect ratio.

A channel regression opens 1440x1080 and then 1080x1920 media through the same
controller and verifies the second generation carries the portrait dimensions.
Focused Exo tests pass 18/18, the complete Flutter suite passes 67/67, targeted
Dart analysis reports no issues, and Android Debug Kotlin compilation plus the
Release build pass. The signed universal audit APK is
`build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-aspect-ratio-audit.apk`
with SHA-256
`9E1BB226FDA7E5C4A972514D9C60AB2E3F4F7D21E22566E277D148FDC15527F5`;
release identity and certificate verification pass with
`-AllowAlreadyDelivered`. It is an audit artifact and does not replace the
existing 2.1.8 delivery or release baseline.

### 2026-08-15 user acceptance update

The user confirmed real-device acceptance is complete for the following Media3
compatibility groups, including comparison with the MPV path where applicable:

- live playback; standalone audio; subtitle edge media (PGS/DVB bitmap cues and
  vertical WebVTT layouts);
- video-page pull-to-mini-player, portrait full-screen entry/exit, continuous
  player resizing, and 4:3/9:16 source-replacement aspect-ratio refresh;
- native audio/video track selection, player information, loudness normalization,
  and all currently supported audio-filter mappings;
- still capture and animated WebP, including their user-visible save and
  playback-state behavior.

These groups are no longer pending device acceptance. This does not claim
support for arbitrary FFmpeg filter chains, multiple unsupported normalization
stages, process recreation, or remaining platform and lifecycle edge cases.

### 2026-08-15 multiple peaking equalizer mapping

The Media3 audio-filter bridge now accepts multiple peaking FFmpeg equalizer
stages in their original chain order. Each `equalizer=t=q` stage is sent as an
`equalizerBands` entry and processed by its own RBJ biquad state, so repeated
peaking bands are applied serially instead of being rejected as an unsupported
duplicate. The legacy single-band fields remain accepted for older callers.

Malformed parameters and unsupported equalizer types remain explicit
unsupported cases. Multiple loudness stages and arbitrary custom FFmpeg chains
are unchanged and still produce the existing precise unsupported-stage notice.

Dart focused tests pass 22/22, Android `AudioNormalizationProcessorTest` passes
8/8, and the Android Release build succeeds. Real-device listening comparison
against MPV remains required for multiple-band chains, including switching,
background playback, the in-app mini-player, and system PiP; no formal release
baseline or delivery APK is changed by this implementation batch.

### 2026-08-15 shelf filter mapping

The Media3 audio-filter bridge now also accepts the separate FFmpeg shelf
filters:

- `highshelf=f=<Hz>:w=<width>:g=<dB>` maps to an RBJ high-shelf biquad;
- `lowshelf=f=<Hz>:w=<width>:g=<dB>` maps to an RBJ low-shelf biquad;
- `equalizer=t=q` remains the peaking mapping, and supported stages are
  serialized in their original chain order through `equalizerBands`.

The Android processor keeps independent per-channel state for each stage and
uses the legacy single-band fields as a peaking (`q`) band for compatibility.
Other `equalizer` width types and malformed parameters remain explicit
unsupported stages; no MPV fallback is hidden or inferred.

Dart focused tests pass 24/24, Android `AudioNormalizationProcessorTest` passes
11/11, targeted Dart analysis reports no issues, and the Android Release build
succeeds. The signed audit APK is
`build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-shelf-filter-audit-v2.apk`
with SHA-256 `F4245A1398B63FFB5F067B1EB66C59F645D6D915108944C594365EA8B9D2AE5F`.
`tool/verify_release.ps1 -AllowAlreadyDelivered` validates the application ID,
label, version, universal ABI, and existing certificate; it is an audit artifact
and does not update the release baseline. Real-device comparison against MPV
remains required for shelf and multiple-band chains, including switching,
background playback, the in-app mini-player, and system PiP.

### 2026-08-15 concrete hardware-decoder mode mapping

The ExoPlayer `create` channel now receives the selected hardware-decoder mode in
addition to the existing enable/disable flag. Android resolves the value as
follows:

| Requested mode | Media3 Android behavior |
| --- | --- |
| `no` | software-only video MediaCodec selector |
| `mediacodec`, `mediacodec-copy` | Android MediaCodec selector |
| `auto`, `auto-safe`, `auto-copy` | Android platform MediaCodec strategy |
| comma-separated list | first recognized Android candidate |
| `vaapi`, `nvdec`, `d3d11va`, `videotoolbox`, `vulkan`, other non-Android modes | platform default, with an explicit unsupported diagnostic |

The global hardware-decoding switch takes precedence over the requested mode.
`mediacodec-copy` and `auto-copy` intentionally use the same Surface-backed
MediaCodec path: ExoPlayer does not expose mpv's copy-mode output semantics, so
the bridge does not claim a byte-for-byte equivalent. MPV still receives its
original `hwdec` value and behavior.

`PlaybackConfig` includes both the effective decoder class and resolved `hwdec`
description, for example `decoder=software, hwdec=no (software)` or
`hwdec=vaapi (unsupported on Android; platform-default)`. Unsupported requests
therefore remain visible. The software selector applies to video only; audio
decoder selection is unchanged.

`Media3DecoderModeTest` covers software mode, Android-recognized modes,
disabled-hardware precedence, unsupported modes, and candidate-list resolution.
The Dart channel regression covers forwarding `decoderMode`; the focused Flutter
test passes 19/19. Targeted Dart analysis and Android unit tests pass, and the
Android Release build succeeds.

Audit artifact:
`build/app/outputs/flutter-apk/pili++-2.1.8-2026081004-universal-release-exo-hwdec-mode-audit.apk`
(SHA-256 `5F4E78FEF5F69879E8B3F4DC04A7B69566C6459103F2DBD2DDAE67F2B0B36A49`).
Release verification confirms application ID `com.shudo.plusplus`, version
`2.1.8+2026081004`, universal ABI, and the existing signing certificate. The
artifact does not update the formal release baseline.

Real-device acceptance remains required for AVC/HEVC/AV1, DASH, live, local
files, software/hardware switching, decoder-failure fallback, source and part
switches, seeking, background, mini-player, PiP, rotation, and multiple codec
vendors. Until that matrix is replayed, this item is implemented but pending
device acceptance.
