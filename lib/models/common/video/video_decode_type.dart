// ignore_for_file: constant_identifier_names

enum VideoDecodeFormatType {
  DVH1('dvh1'),
  AV1('av01'),
  HEVC('hev1'),
  AVC('avc1');

  String get description => name;
  final String code;

  const VideoDecodeFormatType(this.code);

  static VideoDecodeFormatType fromCode(String code) =>
      values.firstWhere((i) => i.code == code);

  static VideoDecodeFormatType fromString(String val) =>
      values.firstWhere((i) => val.startsWith(i.code));
}
