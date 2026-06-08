import 'package:PiliPlus/pages/video/quiet_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('effectiveShowTemporaryContent', () {
    test('keeps the global gate authoritative', () {
      expect(
        effectiveShowTemporaryContent(
          globalShow: true,
          temporaryHide: false,
        ),
        isTrue,
      );
      expect(
        effectiveShowTemporaryContent(globalShow: true, temporaryHide: true),
        isFalse,
      );
      expect(
        effectiveShowTemporaryContent(globalShow: false, temporaryHide: false),
        isFalse,
      );
      expect(
        effectiveShowTemporaryContent(globalShow: false, temporaryHide: true),
        isFalse,
      );
    });
  });

  group('quietControlsEffectiveTabIndex', () {
    test('moves off the selected comments tab when comments are hidden', () {
      expect(
        quietControlsEffectiveTabIndex(
          currentIndex: 1,
          previousLength: 3,
          nextLength: 2,
          previousHadReply: true,
          nextHasReply: false,
          showIntro: true,
        ),
        0,
      );
    });

    test('shifts playlist index left when comments are hidden before it', () {
      expect(
        quietControlsEffectiveTabIndex(
          currentIndex: 2,
          previousLength: 3,
          nextLength: 2,
          previousHadReply: true,
          nextHasReply: false,
          showIntro: true,
        ),
        1,
      );
    });

    test('shifts playlist index right when comments are restored before it', () {
      expect(
        quietControlsEffectiveTabIndex(
          currentIndex: 1,
          previousLength: 2,
          nextLength: 3,
          previousHadReply: false,
          nextHasReply: true,
          showIntro: true,
        ),
        2,
      );
    });

    test('keeps a valid index when comments are the first tab', () {
      expect(
        quietControlsEffectiveTabIndex(
          currentIndex: 0,
          previousLength: 2,
          nextLength: 1,
          previousHadReply: true,
          nextHasReply: false,
          showIntro: false,
        ),
        0,
      );
    });
  });
}
