import 'package:PiliPlus/common/widgets/video_card/shield_quick_action.dart';
import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoCardShieldQuickAction', () {
    test('offers user keyword and uid as separate UP actions', () {
      final options = VideoCardShieldQuickAction.upRuleOptions(
        upName: '测试UP',
        upUid: 12345,
      );

      expect(options, hasLength(2));
      expect(options[0].type, ShieldRuleType.uid);
      expect(options[0].pattern, '12345');
      expect(options[0].label, '屏蔽用户 UID: 12345');
      expect(options[1].type, ShieldRuleType.userKeyword);
      expect(options[1].matchMode, ShieldMatchMode.token);
      expect(options[1].pattern, '测试UP');
      expect(options[1].label, '屏蔽用户名关键词: 测试UP');
    });

    test('falls back to username keyword action when uid is missing', () {
      final options = VideoCardShieldQuickAction.upRuleOptions(
        upName: '测试UP',
      );

      expect(options, hasLength(1));
      expect(options.single.type, ShieldRuleType.userKeyword);
      expect(options.single.matchMode, ShieldMatchMode.token);
      expect(options.single.pattern, '测试UP');
      expect(options.single.label, '屏蔽用户名关键词: 测试UP');
    });
  });
}
