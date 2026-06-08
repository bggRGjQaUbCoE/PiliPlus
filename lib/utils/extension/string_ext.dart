final _regExp = RegExp("^(http:)?//", caseSensitive: false);

extension NullableStringExt on String? {
  String get http2https => this?.replaceFirst(_regExp, "https://") ?? '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension StringExt on String {
  String subLength(int length) {
    if (this.length < length) return this;
    return substring(0, length);
  }
}
