enum VideoTogetherNavigationMode {
  always,
  videoPageOnly,
  never,
  countdown,
}

enum VideoTogetherNavigationAction {
  open,
  defer,
  confirm,
}

enum VideoTogetherOpenVideoResult {
  opened,
  deferred,
  dismissed,
  unsupported,
}

typedef VideoTogetherOpenVideo = Future<VideoTogetherOpenVideoResult> Function(
  String url, {
  required bool force,
});

abstract final class VideoTogetherNavigationPolicy {
  static VideoTogetherNavigationAction actionFor({
    required VideoTogetherNavigationMode mode,
    required bool isVideoPage,
    bool force = false,
  }) {
    if (force) return VideoTogetherNavigationAction.open;
    return switch (mode) {
      VideoTogetherNavigationMode.always => VideoTogetherNavigationAction.open,
      VideoTogetherNavigationMode.videoPageOnly =>
        isVideoPage
            ? VideoTogetherNavigationAction.open
            : VideoTogetherNavigationAction.defer,
      VideoTogetherNavigationMode.never => VideoTogetherNavigationAction.defer,
      VideoTogetherNavigationMode.countdown =>
        VideoTogetherNavigationAction.confirm,
    };
  }
}
