import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/member_dynamics/controller.dart';
import 'package:flutter_test/flutter_test.dart';

DynamicItemModel item(
  String id, {
  String? tag,
}) {
  final item = DynamicItemModel.fromJson({'id_str': id});
  if (tag != null) item.modules.moduleTag = ModuleTag(text: tag);
  return item;
}

void main() {
  test('removal resolves the current refreshed item by id', () {
    final staleItem = item('delete-me');
    final refreshedItem = item('delete-me');
    final current = [item('keep'), refreshedItem];

    expect(identical(staleItem, refreshedItem), isFalse);
    expect(removeMemberDynamicById(current, staleItem.idStr), isTrue);
    expect(current.map((item) => item.idStr), ['keep']);
  });

  test('missing removal target is a safe no-op', () {
    final current = [item('keep')];

    expect(removeMemberDynamicById(null, 'missing'), isFalse);
    expect(removeMemberDynamicById(current, 'missing'), isFalse);
    expect(current.map((item) => item.idStr), ['keep']);
  });

  test(
    'setting top resolves target and current pin after list replacement',
    () {
      final current = [
        item('ordinary-first', tag: '合集'),
        item('old-pin', tag: '置顶'),
        item('target'),
      ];

      expect(
        reconcileMemberDynamicTop(
          current,
          wasTop: false,
          dynamicId: 'target',
        ),
        isTrue,
      );

      expect(current.map((item) => item.idStr), [
        'target',
        'ordinary-first',
        'old-pin',
      ]);
      expect(current.first.modules.moduleTag?.text, '置顶');
      expect(current.last.modules.moduleTag, isNull);
      expect(current[1].modules.moduleTag?.text, '合集');
    },
  );

  test('unpin only mutates the matching current target', () {
    final current = [
      item('unrelated', tag: '合集'),
      item('target', tag: '置顶'),
    ];

    expect(
      reconcileMemberDynamicTop(
        current,
        wasTop: true,
        dynamicId: 'target',
      ),
      isTrue,
    );

    expect(current.first.modules.moduleTag?.text, '合集');
    expect(current.last.modules.moduleTag, isNull);
    expect(
      reconcileMemberDynamicTop(
        current,
        wasTop: false,
        dynamicId: 'missing',
      ),
      isFalse,
    );
  });
}
