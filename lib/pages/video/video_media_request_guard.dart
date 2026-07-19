typedef VideoMediaIdentity = ({
  int aid,
  String bvid,
  int cid,
  int? epId,
  int? seasonId,
});

typedef VideoMediaRequestToken = ({
  int generation,
  VideoMediaIdentity media,
});

/// Binds an asynchronous side request to the media that started it.
///
/// The generation invalidates requests immediately when a reset starts, before
/// the controller has finished replacing all of its mutable media fields. The
/// identity comparison is a second line of defence for direct media changes.
final class VideoMediaRequestGuard {
  int _generation = 0;

  VideoMediaRequestToken capture(VideoMediaIdentity media) => (
    generation: _generation,
    media: media,
  );

  bool isCurrent(
    VideoMediaRequestToken request,
    VideoMediaIdentity currentMedia,
  ) => request.generation == _generation && request.media == currentMedia;

  void invalidate() {
    _generation += 1;
  }
}
