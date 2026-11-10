import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/services/local_blacklist_cleanup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalBlacklistCleanupService.isDeletedAccountResult', () {
    test('only treats Bilibili business code -404 as a deleted account', () {
      expect(
        LocalBlacklistCleanupService.isDeletedAccountResult(
          const Error('用户不存在', code: -404),
        ),
        isTrue,
      );
      expect(
        LocalBlacklistCleanupService.isDeletedAccountResult(
          const Error('请求错误', code: -400),
        ),
        isFalse,
      );
      expect(
        LocalBlacklistCleanupService.isDeletedAccountResult(
          const Error('权限不足', code: -403),
        ),
        isFalse,
      );
      expect(
        LocalBlacklistCleanupService.isDeletedAccountResult(
          const Error('网络错误'),
        ),
        isFalse,
      );
      expect(
        LocalBlacklistCleanupService.isDeletedAccountResult(
          const Success<Object?>(null),
        ),
        isFalse,
      );
    });
  });
}
