import 'package:PiliPlus/utils/parse_string.dart';

class Top {
  List<TopImage>? imgUrls;

  Top({this.imgUrls});

  @pragma('vm:notify-debugger-on-exception')
  Top.fromJson(Map<String, dynamic> json) {
    try {
      imgUrls = (json['result'] as List?)
          ?.map((e) => TopImage.fromJson(e))
          .toList();
    } catch (_) {}
  }
}

class TopImage {
  String? _defaultImage;
  late final String fullCover;
  String get header => _defaultImage ?? fullCover;
  late final double dy;

  @pragma('vm:notify-debugger-on-exception')
  TopImage.fromJson(Map<String, dynamic> json) {
    _defaultImage = noneNullOrEmptyString(
      json['item']['image']?['default_image'],
    );
    fullCover = json['cover'];
    double dy = 0;
    try {
      final Map image = json['item']['image'] ?? json['item']['animation'];
      if (image['location'] case String locStr when (locStr.isNotEmpty)) {
        final location = locStr
            .split('-')
            .skip(1)
            .take(2)
            .map(num.parse)
            .toList();
        if (location.length == 2) {
          final num height = image['height'];
          final start = location[0];
          final end = location[1];
          dy = (start + end) / height - 1;
        }
      }
    } catch (_) {}
    this.dy = dy;
  }
}
