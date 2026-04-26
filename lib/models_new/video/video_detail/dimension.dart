class Dimension {
  int? width;
  int? height;

  bool? get cacheWidth {
    if (width != null && height != null) {
      return width! <= height!;
    }
    return null;
  }

  bool get isVertical =>
      width != null && height != null ? height! > width! : false;

  Dimension({this.width, this.height});

  Dimension.fromJson(Map<String, dynamic> json) {
    if (json['rotate'] == 1) {
      width = json['height'] as int?;
      height = json['width'] as int?;
    } else {
      width = json['width'] as int?;
      height = json['height'] as int?;
    }
  }

  @override
  String toString() => 'width: $width, height: $height';
}
