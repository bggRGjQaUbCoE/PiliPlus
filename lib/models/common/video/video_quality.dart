import 'package:PiliPlus/models/video/play/url.dart' show FormatItem;

final class VideoQuality {
  final int code;
  final String desc;
  final String shortDesc;

  const VideoQuality(this.code, this.desc, this.shortDesc);

  @override
  String toString() => 'code: $code, desc: $desc, shortDesc: $shortDesc';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is VideoQuality) {
      return code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;

  static const VideoQuality hdrVivid = .new(129, 'HDR Vivid', 'HDR Vivid');
  static const VideoQuality super8k = .new(127, '8K 超高清', '8K');
  static const VideoQuality dolbyVision = .new(126, '杜比视界', '杜比');
  static const VideoQuality hdr = .new(125, 'HDR 真彩', 'HDR');
  static const VideoQuality super4K = .new(120, '4K 超高清', '4K');
  static const VideoQuality high108060 = .new(116, '1080P 60帧', '1080P60');
  static const VideoQuality high1080plus = .new(112, '1080P 高码率', '1080P+');
  static const VideoQuality superResolution = .new(100, '智能修复', '智能修复');
  static const VideoQuality high1080 = .new(80, '1080P 高清', '1080P');
  static const VideoQuality high72060 = .new(74, '720P 60帧', '720P60');
  static const VideoQuality high720 = .new(64, '720P 准高清', '720P');
  static const VideoQuality clear480 = .new(32, '480P 标清', '480P');
  static const VideoQuality fluent360 = .new(16, '360P 流畅', '360P');
  static const VideoQuality speed240 = .new(6, '240P 极速', '240P');

  static const List<VideoQuality> values = [
    hdrVivid,
    super8k,
    dolbyVision,
    hdr,
    super4K,
    high108060,
    high1080plus,
    superResolution,
    high1080,
    high72060,
    high720,
    clear480,
    fluent360,
    speed240,
  ];

  static final _codeMap = {for (final i in values) i.code: i};

  factory VideoQuality.fromId(int id, String idStr) =>
      VideoQuality(id, idStr, idStr);

  factory VideoQuality.fromCode(int code) =>
      _codeMap[code] ?? .fromId(code, code.toString());

  static VideoQuality? safeFromCode(int code) => _codeMap[code];

  factory VideoQuality.fromFormat(int code, List<FormatItem>? formats) {
    if (formats != null && formats.isNotEmpty) {
      for (final format in formats) {
        if (format.quality == code) {
          try {
            return VideoQuality(
              code,
              format.newDesc!,
              format.displayDesc!,
            );
          } catch (_) {}
        }
      }
    }

    return .fromCode(code);
  }
}
