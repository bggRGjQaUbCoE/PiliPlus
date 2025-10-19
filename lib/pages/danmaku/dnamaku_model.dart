sealed class DanmakuExtra {
  Object get mid;
  Object get id;

  const DanmakuExtra();
}

class VideoDanmaku extends DanmakuExtra {
  @override
  final int id;
  @override
  final String mid;

  int like;

  bool isLike;

  VideoDanmaku({
    required this.id,
    required this.mid,
    this.like = 0,
    this.isLike = false,
  });
}

class LiveDanmaku extends DanmakuExtra {
  @override
  final Object id;
  @override
  final Object mid;

  final int dmType;

  final Object ts;
  final Object ct;

  const LiveDanmaku({
    required this.id,
    required this.mid,
    required this.dmType,
    required this.ts,
    required this.ct,
  });
}
