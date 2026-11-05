import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoCoverPreviewController extends ChangeNotifier {
  VideoCoverPreviewController._() : _createPlayer = _createPreviewPlayer;

  @visibleForTesting
  VideoCoverPreviewController.forTesting(this._createPlayer);

  static final VideoCoverPreviewController instance =
      VideoCoverPreviewController._();

  final Future<(Player, VideoController)> Function() _createPlayer;
  Player? _player;
  VideoController? _videoController;
  Object? _owner;
  Future<void> _pending = Future.value();
  int _sessionId = 0;

  Object? get owner => _owner;

  VideoController? get videoController => _videoController;

  // Keep native operations in order, including initialization and disposal.
  // Ownership changes immediately so leaving a card also cancels pending work.
  Future<void> play(
    Object owner,
    String url, {
    required bool Function() isCurrent,
  }) {
    final sessionId = ++_sessionId;
    _owner = owner;
    notifyListeners();
    return _enqueue(
      () async {
        bool active() => sessionId == _sessionId && isCurrent();
        if (!active()) return;
        if (_player == null) {
          final (player, controller) = await _createPlayer();
          _player = player;
          _videoController = controller;
        }
        if (!active()) return;
        await _player!.setVolume(0);
        if (!active()) return;
        await _player!.open(
          Media(url, extras: const {'aid': 'no', 'volume': '0'}),
          play: true,
        );
        if (!active()) {
          await _player!.stop();
        } else {
          notifyListeners();
        }
      },
      onError: () {
        if (sessionId == _sessionId) {
          _owner = null;
          notifyListeners();
        }
      },
    );
  }

  Future<void> stop(Object owner) {
    if (_owner != owner) return Future.value();
    _sessionId++;
    _owner = null;
    notifyListeners();
    return _enqueue(() async => _player?.stop());
  }

  void detach(Object owner) {
    stop(owner);
  }

  Future<void> disposeGlobal() {
    _owner = null;
    _sessionId++;
    notifyListeners();
    return _enqueue(() async {
      final player = _player;
      _player = null;
      _videoController = null;
      await player?.dispose();
    });
  }

  Future<void> _enqueue(
    Future<void> Function() action, {
    VoidCallback? onError,
  }) {
    return _pending = _pending.then((_) => action()).catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      if (kDebugMode) {
        debugPrint('video cover preview failed: $error\n$stackTrace');
      }
      onError?.call();
    });
  }

  static Future<(Player, VideoController)> _createPreviewPlayer() async {
    final player = await Player.create(
      configuration: const PlayerConfiguration(
        logLevel: kDebugMode ? MPVLogLevel.warn : MPVLogLevel.error,
        options: {'volume': '0', 'aid': 'no'},
      ),
    );
    try {
      final controller = await VideoController.create(player);
      player.setMediaHeader(
        userAgent: BrowserUa.pc,
        referer: HttpString.baseUrl,
      );
      await player.setVolume(0);
      return (player, controller);
    } catch (_) {
      await player.dispose();
      rethrow;
    }
  }
}
