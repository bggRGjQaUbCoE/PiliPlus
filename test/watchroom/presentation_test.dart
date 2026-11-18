import 'package:PiliPlus/features/watchroom/presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('joining selects the room before introduction and comments', () {
    expect(RoomTabs.selectedIndex(['简介', '评论'], ['放映厅', '简介', '评论'], 1), 0);
  });
  test(
    'resize preserves comments when introduction moves out of the side panel',
    () {
      expect(
        RoomTabs.selectedIndex(['放映厅', '简介', '评论'], ['放映厅', '评论', '播放列表'], 2),
        1,
      );
      expect(
        RoomTabs.selectedIndex(['放映厅', '评论', '播放列表'], ['放映厅', '简介', '评论'], 1),
        2,
      );
    },
  );
  test(
    'leaving removes the room without changing the selected introduction',
    () {
      expect(RoomTabs.selectedIndex(['放映厅', '简介', '评论'], ['简介', '评论'], 1), 0);
      expect(RoomTabs.selectedIndex(['放映厅', '简介', '评论'], ['简介', '评论'], 2), 1);
    },
  );
  test('a missing or empty panel has a safe first selection', () {
    expect(RoomTabs.selectedIndex(['放映厅'], [], 0), 0);
    expect(RoomTabs.selectedIndex([], ['简介'], 1), 0);
  });
}
