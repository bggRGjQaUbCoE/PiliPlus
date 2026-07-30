import 'package:PiliPlus/plugin/pl_player/models/player_feature_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerFeatureResult', () {
    test('success retains its value', () {
      const result = PlayerFeatureSuccess(42);

      expect(result.value, 42);
    });

    test('unavailable retains a user-facing reason', () {
      const result = PlayerFeatureUnavailable<int>('功能仍在适配');

      expect(result.message, '功能仍在适配');
    });

    test('failure retains diagnostics separately from its message', () {
      final error = StateError('decoder failed');
      final stackTrace = StackTrace.current;
      final result = PlayerFeatureFailure<int>(
        '操作失败',
        error: error,
        stackTrace: stackTrace,
      );

      expect(result.message, '操作失败');
      expect(result.error, same(error));
      expect(result.stackTrace, same(stackTrace));
    });
  });
}
