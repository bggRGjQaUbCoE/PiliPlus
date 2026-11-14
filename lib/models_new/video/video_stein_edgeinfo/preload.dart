/// 预加载信息：/x/stein/edgeinfo_v2 的 `data.preload`。
class Preload {
  List<PreloadVideo>? video;

  Preload({this.video});

  factory Preload.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Preload();
    }
    final dynamic list = json['video'];
    final List<PreloadVideo> videos = <PreloadVideo>[];
    if (list is List) {
      for (final dynamic item in list) {
        try {
          videos.add(PreloadVideo.fromJson(item));
        } catch (_) {}
      }
    }
    return Preload(video: videos);
  }
}

class PreloadVideo {
  int? aid;
  int? cid;

  PreloadVideo({this.aid, this.cid});

  factory PreloadVideo.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return PreloadVideo();
    }
    int? asInt(dynamic v) {
      if (v is int) {
        return v;
      }
      if (v is num) {
        return v.toInt();
      }
      if (v is String) {
        return int.tryParse(v) ?? double.tryParse(v)?.toInt();
      }
      return null;
    }

    return PreloadVideo(
      aid: asInt(json['aid']),
      cid: asInt(json['cid']),
    );
  }
}
