import 'dart:async';
import 'dart:ffi';

import 'package:PiliPlus/plugin/pl_player/view/view.dart'
    show resumeAfterWebpDialogCancellation;
import 'package:PiliPlus/plugin/pl_player/widgets/mpv_convert_webp.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'immediate cancellation disposes a delayed mpv handle exactly once',
    () async {
      final initializer = Completer<MpvHandle>();
      var disposeCount = 0;
      final converter = MpvConvertWebp(
        'video-url',
        'output.webp',
        0,
        1,
        contextInitializer: () => initializer.future,
        contextDisposer: (_) => disposeCount += 1,
      );

      final conversion = converter.convert();

      expect(converter.dispose, returnsNormally);
      expect(converter.dispose, returnsNormally);
      initializer.complete(Pointer.fromAddress(1));

      expect(await conversion, isFalse);
      expect(disposeCount, 1);
    },
  );

  test('cancelling the webp dialog resumes prior playback', () async {
    var resumeCount = 0;

    final shouldReturn = await resumeAfterWebpDialogCancellation(
      isConfirmed: false,
      wasPlaying: true,
      resume: () => resumeCount += 1,
    );

    expect(shouldReturn, isTrue);
    expect(resumeCount, 1);
  });

  test(
    'webp dialog confirmation leaves playback paused for conversion',
    () async {
      var resumeCount = 0;

      final shouldReturn = await resumeAfterWebpDialogCancellation(
        isConfirmed: true,
        wasPlaying: true,
        resume: () => resumeCount += 1,
      );

      expect(shouldReturn, isFalse);
      expect(resumeCount, 0);
    },
  );
}
