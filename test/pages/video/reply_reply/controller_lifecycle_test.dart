import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reply controller closes its inherited scroll controller', () {
    final controller = VideoReplyReplyController(
      hasRoot: false,
      id: null,
      oid: 1,
      rpid: 2,
      dialog: null,
      replyType: 1,
    )..onClose();

    expect(
      () => controller.scrollController.addListener(() {}),
      throwsFlutterError,
    );
  });
}
