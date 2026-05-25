enum SourceType { fileImage, networkImage, livePhoto }

class SourceModel {
  final SourceType sourceType;
  final String url;
  final String? liveUrl;
  final int? width;
  final int? height;
  final bool isLongPic;
  final num? size;

  const SourceModel({
    this.sourceType = .networkImage,
    required this.url,
    this.liveUrl,
    this.width,
    this.height,
    this.isLongPic = false,
    this.size,
  });
}
