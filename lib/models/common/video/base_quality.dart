import 'package:PiliPlus/models/video/play/url.dart';

part 'audio_quality.dart';
part 'live_quality.dart';
part 'video_quality.dart';

sealed class BaseQuality {
  final int code;
  final String desc;

  const BaseQuality(this.code, this.desc);

  BaseQuality.fromId(this.code) : desc = code.toString();

  @override
  String toString() => 'code: $code, desc: $desc';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is BaseQuality && other.runtimeType == runtimeType) {
      return code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;
}
