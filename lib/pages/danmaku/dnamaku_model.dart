sealed class DanmakuExtra {
  String get mid;
  Object get id;

  const DanmakuExtra();
}

class VideoDanmaku extends DanmakuExtra {
  @override
  final int id;
  @override
  final String mid;

  bool isLike;

  VideoDanmaku({required this.id, required this.mid, this.isLike = false});
}

class LiveDanmaku extends DanmakuExtra {
  @override
  final String id;
  @override
  final String mid;
  final String uname;

  const LiveDanmaku({required this.id, required this.mid, required this.uname});
}
