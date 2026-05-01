import 'package:flutter/foundation.dart' show clampDouble;

class Cover {
  String? url;
  late double ratio;

  Cover({required this.ratio});

  Cover.fromJson(Map<String, dynamic> json) {
    url = json['url'] as String?;
    final height = json['height'] as int?;
    final width = json['width'] as int?;
    if (height != null && width != null) {
      ratio = clampDouble(height / width, 0.68, 2.7);
    } else {
      ratio = 1;
    }
  }
}
