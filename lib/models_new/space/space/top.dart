import 'package:PiliPlus/utils/extension/iterable_ext.dart';
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
  TopTitle? title;

  @pragma('vm:notify-debugger-on-exception')
  TopImage.fromJson(Map<String, dynamic> json) {
    final item = json['item'];
    final img = item['image'];
    title = json['title'] == null ? null : TopTitle.fromJson(json['title']);
    _defaultImage = noneNullOrEmptyString(img?['default_image']);
    fullCover = json['cover'];
    double dy = 0;
    try {
      final Map image = img ?? item['animation'];
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

class TopTitle {
  String? title;
  String? subTitle;
  SubTitleColorFormat? subTitleColorFormat;

  TopTitle({
    this.title,
    this.subTitle,
    this.subTitleColorFormat,
  });

  factory TopTitle.fromJson(Map<String, dynamic> json) => TopTitle(
    title: json["title"],
    subTitle: json["sub_title"],
    subTitleColorFormat: json["sub_title_color_format"] == null
        ? null
        : SubTitleColorFormat.fromJson(json["sub_title_color_format"]),
  );
}

class SubTitleColorFormat {
  List<String>? colors;

  SubTitleColorFormat({
    this.colors,
  });

  factory SubTitleColorFormat.fromJson(Map<String, dynamic> json) =>
      SubTitleColorFormat(
        colors: (json["colors"] as List?)?.fromCast(),
      );
}
