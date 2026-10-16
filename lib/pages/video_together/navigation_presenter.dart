import 'dart:async';

import 'package:PiliPlus/services/video_together/models.dart';
import 'package:PiliPlus/services/video_together/navigation.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/session.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract final class VideoTogetherNavigationPresenter {
  static const countdownDuration = Duration(seconds: 5);

  static BuildContext? _dialogContext;
  static int _requestRevision = 0;

  static Future<VideoTogetherOpenVideoResult> open(
    String url, {
    required bool force,
  }) async {
    final action = VideoTogetherNavigationPolicy.actionFor(
      mode: VideoTogetherPreferences.navigationMode,
      isVideoPage: Get.currentRoute == '/videoV',
      force: force,
    );
    if (action == VideoTogetherNavigationAction.defer) {
      return VideoTogetherOpenVideoResult.deferred;
    }
    if (action == VideoTogetherNavigationAction.open) {
      cancel();
      return _route(url);
    }

    final context = Get.context;
    if (context == null) return VideoTogetherOpenVideoResult.deferred;

    cancel();
    final requestRevision = _requestRevision;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _dialogContext = dialogContext;
        return _VideoTogetherNavigationCountdownDialog(
          duration: countdownDuration,
          videoTitle:
              VideoTogetherSession.instance.room.value?.videoTitle ?? '',
          url: url,
        );
      },
    );
    if (requestRevision != _requestRevision) {
      return VideoTogetherOpenVideoResult.deferred;
    }
    _dialogContext = null;
    if (!_roomStillTargets(url)) {
      return VideoTogetherOpenVideoResult.deferred;
    }
    if (confirmed != true) return VideoTogetherOpenVideoResult.dismissed;
    return _route(url);
  }

  static void cancel() {
    _requestRevision += 1;
    final context = _dialogContext;
    _dialogContext = null;
    if (context != null && context.mounted) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop(false);
    }
  }

  static Future<VideoTogetherOpenVideoResult> _route(String url) async {
    final handled = await PiliScheme.routePushFromUrl(
      url,
      selfHandle: true,
      off: Get.currentRoute == '/videoV',
    );
    return handled
        ? VideoTogetherOpenVideoResult.opened
        : VideoTogetherOpenVideoResult.unsupported;
  }

  static bool _roomStillTargets(String url) {
    final session = VideoTogetherSession.instance;
    final roomUrl = session.room.value?.url;
    return session.inRoom &&
        roomUrl != null &&
        VideoTogetherMediaIdentity.fromUrl(roomUrl).sameAs(
          VideoTogetherMediaIdentity.fromUrl(url),
        );
  }
}

class _VideoTogetherNavigationCountdownDialog extends StatefulWidget {
  const _VideoTogetherNavigationCountdownDialog({
    required this.duration,
    required this.videoTitle,
    required this.url,
  });

  final Duration duration;
  final String videoTitle;
  final String url;

  @override
  State<_VideoTogetherNavigationCountdownDialog> createState() =>
      _VideoTogetherNavigationCountdownDialogState();
}

class _VideoTogetherNavigationCountdownDialogState
    extends State<_VideoTogetherNavigationCountdownDialog> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        Navigator.of(context).pop(true);
      } else {
        setState(() => _remainingSeconds -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.videoTitle.trim();
    return AlertDialog(
      title: const Text('房间已切换视频'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.isEmpty ? '是否进入房间当前视频？' : '是否进入“$title”？'),
          const SizedBox(height: 8),
          Text(
            widget.url,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
          const SizedBox(height: 12),
          Text('将在 $_remainingSeconds 秒后自动进入'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('立即进入'),
        ),
      ],
    );
  }
}
