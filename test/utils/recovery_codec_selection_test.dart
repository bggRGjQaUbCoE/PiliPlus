import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a selected codec remains preferred during a source refresh', () {
    final preferred = VideoUtils.preferCurrentCodec(
      VideoDecodeFormatType.AVC,
      [VideoDecodeFormatType.AV1, VideoDecodeFormatType.AVC],
    );
    expect(preferred, [VideoDecodeFormatType.AVC, VideoDecodeFormatType.AV1]);
    expect(
      VideoUtils.selectCodec(['av01.0', 'avc1.0'], preferred),
      VideoDecodeFormatType.AVC,
    );
    expect(
      VideoUtils.selectCodec(['av01.0'], preferred),
      VideoDecodeFormatType.AV1,
    );
  });
}
