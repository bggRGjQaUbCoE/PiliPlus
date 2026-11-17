import 'package:flutter/painting.dart' show BorderRadius, ImageProvider;

enum SourceType { fileImage, networkImage, livePhoto }

class SourceModel {
  final SourceType sourceType;
  final String url;
  final String? liveUrl;
  final int? width;
  final int? height;
  final bool isLongPic;
  final ImageProvider? previewImageProvider;
  final BorderRadius? heroBorderRadius;

  const SourceModel({
    this.sourceType = SourceType.networkImage,
    required this.url,
    this.liveUrl,
    this.width,
    this.height,
    this.isLongPic = false,
    this.previewImageProvider,
    this.heroBorderRadius,
  });
}
