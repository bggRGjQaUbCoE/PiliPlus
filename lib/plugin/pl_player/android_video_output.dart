import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/models/dolby_vision_profile5_mode.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:synchronized/synchronized.dart';

/// Keeps media-kit's native surface ownership, but manages its renderer and size.
///
/// The wrapped controller must use vo=null and attach its surface on load.
/// Its built-in resizing only supports vo=gpu, not gpu-next.
class AndroidVideoOutput extends VideoController {
  AndroidVideoOutput(
    Player player,
    this._surfaceController, {
    required String hardwareDecoding,
    required DolbyVisionProfile5Mode Function() profile5Mode,
    this.onNativePlaybackRequested,
    required void Function(Object, StackTrace) onError,
  }) : _hardwareDecoding = hardwareDecoding,
       _profile5Mode = profile5Mode,
       _onError = onError,
       super(player, _surfaceController.configuration) {
    assert(configuration.vo == 'null');
    assert(configuration.androidAttachSurfaceAfterVideoParameters == false);
    id.value = _surfaceController.id.value;
    _surfaceController.rect.addListener(_onVideoParams);
    player.onLoadHooks.add(_onLoad);
    // Finish outstanding resizes before media-kit releases the old surface.
    player.onUnloadHooks.insert(0, _onUnload);
    player.release.add(_dispose);
  }

  static const _channel = MethodChannel('com.alexmercerind/media_kit_video');

  final VideoController _surfaceController;
  final String _hardwareDecoding;
  final DolbyVisionProfile5Mode Function() _profile5Mode;
  final VoidCallback? onNativePlaybackRequested;
  final void Function(Object, StackTrace) _onError;
  final _lock = Lock();
  bool _active = false;
  bool _disposed = false;
  bool _profile5 = false;
  int _generation = 0;

  @override
  Future<void> get waitUntilFirstFrameRendered =>
      _surfaceController.waitUntilFirstFrameRendered;

  void _setRenderer(String renderer) {
    if (player.getProperty('vo') == renderer) return;
    player.setProperty('vo', renderer);
    if (player.getProperty('vo') != renderer) {
      throw StateError('Unable to select Android video renderer: $renderer');
    }
  }

  void _onLoad() {
    _generation++;
    _profile5 = false;
    rect.value = Rect.zero;
    try {
      player.setProperty('hwdec', _hardwareDecoding);
      _setRenderer('gpu');
      _active = true;
    } catch (error, stackTrace) {
      _onError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _onUnload() {
    _active = false;
    _generation++;
    return _lock.synchronized(() {
      rect.value = Rect.zero;
    });
  }

  void _onVideoParams() {
    final size = _surfaceController.rect.value;
    if (!_active || _disposed || size == null || size.isEmpty) return;
    final generation = _generation;
    unawaited(_resize(size, generation));
  }

  Future<void> _resize(Rect size, int generation) async {
    bool requestNativePlayback = false;
    try {
      await _lock.synchronized(() async {
        if (!_active || _disposed || generation != _generation) return;

        // Read the actual selected track, including local files and EDL streams.
        final profile = player.getProperty(
          'current-tracks/video/dolby-vision-profile',
        );
        if (profile == '5' && !_profile5) {
          rect.value = Rect.zero;
          // Sample the preference on each media load, not on player creation.
          final mode = _profile5Mode();
          if (mode == DolbyVisionProfile5Mode.media3) {
            if (onNativePlaybackRequested == null) {
              throw StateError('Media3 playback is not connected');
            }
            _profile5 = true;
            _active = false;
            requestNativePlayback = true;
            return;
          }
          final hwdec = mode.hwdec;
          player.setProperty('hwdec', hwdec);
          if (player.getProperty('hwdec') != hwdec) {
            throw StateError('Unable to select Dolby Vision decoder: $hwdec');
          }
          _profile5 = true;
        }

        await _channel.invokeMethod<void>(
          'VideoOutputManager.SetSurfaceTextureSize',
          {
            'handle': player.handle.toString(),
            'width': size.width.toInt().toString(),
            'height': size.height.toInt().toString(),
          },
        );
        if (!_active || _disposed || generation != _generation) return;

        player.setProperty(
          'android-surface-size',
          '${size.width.toInt()}x${size.height.toInt()}',
        );
        _setRenderer(_profile5 ? 'gpu-next' : 'gpu');
        rect.value = size;
      });
      // Stopping mpv runs the unload hook, which also acquires this lock.
      if (requestNativePlayback && !_disposed && generation == _generation) {
        onNativePlaybackRequested!();
      }
    } catch (error, stackTrace) {
      if (!_disposed && generation == _generation) {
        rect.value = Rect.zero;
        _onError(error, stackTrace);
      }
    }
  }

  @override
  Future<void>? setSize({int? width, int? height}) =>
      _surfaceController.setSize(width: width, height: height);

  Future<void> _dispose() async {
    if (_disposed) return;
    _disposed = true;
    _active = false;
    _generation++;
    _surfaceController.rect.removeListener(_onVideoParams);
    player.onLoadHooks.remove(_onLoad);
    player.onUnloadHooks.remove(_onUnload);
    await _lock.synchronized(() {
      id.dispose();
      rect.dispose();
    });
  }
}
