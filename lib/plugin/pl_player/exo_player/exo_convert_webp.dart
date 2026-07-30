import 'dart:async';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/mpv_convert_webp.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get_rx/get_rx.dart';

class ExoConvertWebp implements AnimatedWebpConverter {
  ExoConvertWebp(
    this.controller,
    this.url,
    this.outFile,
    this.start,
    this.end, {
    this.progress,
    this.preset = WebpPreset.def,
  });

  static int _nextTaskId = 1;

  final ExoPlayerController controller;
  final String url;
  final String outFile;
  final double start;
  final double end;
  final RxDouble? progress;
  final WebpPreset preset;
  final int _taskId = _nextTaskId++;

  Timer? _progressTimer;
  bool _disposed = false;

  @override
  Future<bool> convert() async {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 250), (
      _,
    ) async {
      if (_disposed) return;
      try {
        progress?.value = await controller.animatedWebpProgress(_taskId);
      } catch (_) {}
    });
    try {
      final success = await controller
          .startAnimatedWebp(
            taskId: _taskId,
            url: url,
            outFile: outFile,
            headers: const {
              'User-Agent': BrowserUa.pc,
              'Referer': HttpString.baseUrl,
            },
            start: Duration(milliseconds: (start * 1000).round()),
            end: Duration(milliseconds: (end * 1000).round()),
            preset: preset.flag,
          )
          .catchError((Object error, StackTrace stackTrace) {
            Utils.reportError(
              'ExoPlayer animated WebP conversion failed: $error',
              stackTrace,
            );
            return false;
          });
      if (success) progress?.value = 1;
      return success;
    } finally {
      _progressTimer?.cancel();
      _progressTimer = null;
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _progressTimer?.cancel();
    _progressTimer = null;
    unawaited(
      controller.cancelAnimatedWebp(_taskId).catchError((Object error) {
        Utils.reportError(
          'ExoPlayer animated WebP cancellation failed: $error',
          StackTrace.current,
        );
      }),
    );
  }
}
