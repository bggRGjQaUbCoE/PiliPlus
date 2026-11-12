import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:flutter_test/flutter_test.dart';

UpItem _up(int mid, {bool? hasUpdate}) =>
    UpItem(mid: mid, uname: 'up$mid', hasUpdate: hasUpdate);

void main() {
  group('FollowUpModel.markUpdatedUps', () {
    test('为尚无更新状态的关注列表项补充官方更新标记', () {
      final upList = [_up(1), _up(2), _up(3)];
      final changed = FollowUpModel.markUpdatedUps(upList, {1, 3});
      expect(changed, isTrue);
      expect(upList[0].hasUpdate, isTrue);
      expect(upList[1].hasUpdate, isNull);
      expect(upList[2].hasUpdate, isTrue);
    });

    test('不覆盖已有的更新状态', () {
      final upList = [_up(1, hasUpdate: false), _up(2, hasUpdate: true)];
      final changed = FollowUpModel.markUpdatedUps(upList, {1, 2});
      expect(changed, isFalse);
      expect(upList[0].hasUpdate, isFalse);
      expect(upList[1].hasUpdate, isTrue);
    });

    test('重复合并不会再次产生变化', () {
      final upList = [_up(1)];
      expect(FollowUpModel.markUpdatedUps(upList, {1}), isTrue);
      expect(FollowUpModel.markUpdatedUps(upList, {1}), isFalse);
    });

    test('忽略列表外的 mid 与空集合', () {
      final upList = [_up(1)];
      expect(FollowUpModel.markUpdatedUps(upList, {2, 3}), isFalse);
      expect(FollowUpModel.markUpdatedUps(upList, {}), isFalse);
      expect(upList.single.hasUpdate, isNull);
    });
  });
}
