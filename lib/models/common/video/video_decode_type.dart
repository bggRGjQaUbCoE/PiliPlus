// ignore_for_file: constant_identifier_names

enum VideoDecodeFormatType {
  DVH1(['dvh1']),
  AV1(['av01']),
  HEVC(['hev1', 'hvc1']),
  AVC(['avc1']);

  String get description => name;
  final List<String> codes;

  const VideoDecodeFormatType(this.codes);

  static VideoDecodeFormatType fromCode(String code) =>
      values.firstWhere((i) => i.codes.contains(code));

  static VideoDecodeFormatType fromString(String val) =>
      values.firstWhere((i) => i.codes.any(val.startsWith));
}
