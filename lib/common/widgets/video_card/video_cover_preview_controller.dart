import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoCoverPreviewController extends ChangeNotifier {
  VideoCoverPreviewController._();

  static final VideoCoverPreviewController instance =
      VideoCoverPreviewController._();

  Player? _player;
  VideoController? _videoController;
  Object? _owner;
  Future<void>? _initializing;
  int _sessionId = 0;

  Object? get owner => _owner;

  VideoController? get videoController => _videoController;

  Future<void> play(Object owner, String url) async {
    final sessionId = ++_sessionId;
    await _ensurePlayer();
    final player = _player;
    if (player == null || sessionId != _sessionId) return;

    _owner = owner;
    notifyListeners();

    try {
      await player.setVolume(0);
      await player.open(
        Media(
          url,
          extras: const {
            'aid': 'no',
            'volume': '0',
          },
        ),
        play: true,
      );
      if (_owner == null && sessionId == _sessionId) {
        await player.stop();
      }
    } catch (err, stackTrace) {
      if (kDebugMode) {
        debugPrint('video cover preview play failed: $err\n$stackTrace');
      }
      if (_owner == owner) {
        _owner = null;
        notifyListeners();
      }
    }
  }

  Future<void> stop(Object owner) async {
    if (_owner != owner) return;
    _sessionId++;
    _owner = null;
    notifyListeners();
    try {
      await _player?.stop();
    } catch (err, stackTrace) {
      if (kDebugMode) {
        debugPrint('video cover preview stop failed: $err\n$stackTrace');
      }
    }
  }

  void detach(Object owner) {
    if (_owner != owner) return;
    _sessionId++;
    _owner = null;
    notifyListeners();
    _player?.stop().catchError((Object err, StackTrace stackTrace) {
      if (kDebugMode) {
        debugPrint('video cover preview detach failed: $err\n$stackTrace');
      }
    });
  }

  Future<void> disposeGlobal() async {
    _owner = null;
    _sessionId++;
    notifyListeners();
    final player = _player;
    _player = null;
    _videoController = null;
    _initializing = null;
    await player?.dispose();
  }

  Future<void> _ensurePlayer() {
    if (_player != null && _videoController != null) {
      return Future.value();
    }
    return _initializing ??= _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final player = await Player.create(
        configuration: const PlayerConfiguration(
          logLevel: kDebugMode ? MPVLogLevel.warn : MPVLogLevel.error,
          options: {
            'volume': '0',
            'aid': 'no',
          },
        ),
      );
      final videoController = await VideoController.create(player);
      player.setMediaHeader(
        userAgent: BrowserUa.pc,
        referer: HttpString.baseUrl,
      );
      await player.setVolume(0);
      _player = player;
      _videoController = videoController;
      notifyListeners();
    } finally {
      _initializing = null;
    }
  }
}
