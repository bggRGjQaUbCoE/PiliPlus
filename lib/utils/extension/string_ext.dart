final _regExp = RegExp("^(http:)?//", caseSensitive: false);

extension StringExt on String? {
  String get http2https => this?.replaceFirst(_regExp, "https://") ?? '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
