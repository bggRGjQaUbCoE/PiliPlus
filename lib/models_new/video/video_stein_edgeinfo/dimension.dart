/// 分P分辨率：/x/stein/edgeinfo_v2 的 `data.edges.dimension`。
class Dimension {
  int? width;
  int? height;
  int? rotate;

  /// 像素宽高比字符串（如 "1:1"），为空表示方形像素
  String? sar;

  Dimension({this.width, this.height, this.rotate, this.sar});

  /// 展示宽（考虑 rotate 90/270 交换宽高）
  int? get displayWidth {
    final bool rotated = rotate == 90 || rotate == 270;
    if (rotated) {
      return height ?? width;
    }
    return width ?? height;
  }

  /// 展示高（考虑 rotate 90/270 交换宽高）
  int? get displayHeight {
    final bool rotated = rotate == 90 || rotate == 270;
    if (rotated) {
      return width ?? height;
    }
    return height ?? width;
  }

  static int? _asInt(dynamic v) {
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

  factory Dimension.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Dimension();
    }
    return Dimension(
      width: _asInt(json['width']),
      height: _asInt(json['height']),
      rotate: _asInt(json['rotate']),
      sar: json['sar'] is String ? json['sar'] as String : null,
    );
  }
}
