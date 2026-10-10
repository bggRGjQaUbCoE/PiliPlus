import 'package:PiliPlus/utils/extension/string_ext.dart';

final class DmMask {
  const DmMask({
    required this.cid,
    required this.plat,
    required this.fps,
    required this.time,
    required this.maskUrl,
  });

  final int cid;
  final int plat;
  final int fps;
  final int time;
  final String maskUrl;

  static DmMask? fromJsonOrNull(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      final cid = json['cid'] as int;
      final fps = json['fps'] as int;
      final maskUrl = (json['mask_url'] as String).http2https;
      if (cid <= 0 || fps <= 0 || maskUrl.isEmpty) return null;
      return DmMask(
        cid: cid,
        plat: json['plat'] as int,
        fps: fps,
        time: json['time'] as int,
        maskUrl: maskUrl,
      );
    } catch (_) {
      return null;
    }
  }
}
