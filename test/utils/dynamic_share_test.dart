import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const url = 'https://www.bilibili.com/opus/42';

  DynamicItemModel item({
    String? text,
    String? title,
    DynamicItemModel? original,
    String id = '42',
  }) {
    return DynamicItemModel.fromJson({'id_str': id})
      ..orig = original
      ..modules.moduleDynamic = ModuleDynamicModel.fromJson({
        if (text != null) 'desc': {'text': text},
        if (title != null)
          'major': {
            'type': 'MAJOR_TYPE_OPUS',
            'opus': {'title': title},
          },
      });
  }

  test('uses the existing title before a plain-text summary', () {
    expect(
      ShareUtils.dynamicText(item(text: '正文', title: '动态标题')),
      '动态标题\n$url',
    );
  });

  test('uses the real summary when the feed has a pinned badge', () {
    final pinned = item(text: '动态正文');
    pinned.modules.moduleTag = ModuleTag(text: '置顶');
    expect(ShareUtils.dynamicText(pinned), '动态正文\n$url');
  });

  test('uses the title from the detail API', () {
    final detail = DynamicItemModel.fromOpusJson({
      'item': {
        'id_str': '42',
        'modules': [
          {
            'module_type': 'MODULE_TYPE_TITLE',
            'module_title': {'text': '详情标题'},
          },
        ],
      },
    });
    expect(ShareUtils.dynamicText(detail), '详情标题\n$url');
  });

  test('normalizes whitespace and truncates by grapheme', () {
    const emoji = '👩‍💻';
    expect(
      ShareUtils.dynamicText(item(text: '  测试\r\n\t${emoji * 160}')),
      '测试 ${emoji * 117}…\n$url',
    );
  });

  test('uses repost text when present and always links the shared item', () {
    final original = item(text: '原动态正文', id: '41');
    expect(
      ShareUtils.dynamicText(item(text: '转发说明', original: original)),
      '转发说明\n$url',
    );
    expect(
      ShareUtils.dynamicText(item(text: '\n', original: original)),
      '原动态正文\n$url',
    );
  });

  test('shares the original URL even without text', () {
    expect(ShareUtils.dynamicText(item(text: '   ')), url);
  });
}
