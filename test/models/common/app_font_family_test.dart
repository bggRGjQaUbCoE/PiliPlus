import 'package:PiliPlus/models/common/app_font_family.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFontFamily', () {
    test('uses stable runtime font metadata', () {
      expect(AppFontFamily.system.fontFamily, isNull);
      expect(
        AppFontFamily.lxgwWenKaiGbScreen.fontFamily,
        'LXGW WenKai GB Screen',
      );
      expect(
        AppFontFamily.lxgwZhenKaiGb.fontFamily,
        'LXGW ZhenKai GB',
      );
      expect(
        AppFontFamily.sourceHanSerifCn.fontFamily,
        'Source Han Serif CN',
      );
      expect(AppFontFamily.lxgwWenKaiGbScreen.label, '霞鹜文楷');
      expect(AppFontFamily.lxgwZhenKaiGb.label, '霞鹜臻楷');
      expect(AppFontFamily.sourceHanSerifCn.label, '思源宋体');
      expect(AppFontFamily.system.downloadUrls, isNull);
      expect(AppFontFamily.system.isSystem, isTrue);

      for (final item in AppFontFamily.values.skip(1)) {
        expect(item.isSystem, isFalse);
        expect(item.fileName, isNotEmpty);
        expect(item.downloadUrls, isNotEmpty);
        for (final url in item.downloadUrls!) {
          expect(url, startsWith('https://'));
        }
        expect(item.downloadSize, greaterThan(0));
        expect(item.sha256, hasLength(64));
      }
    });

    test('restores persisted names', () {
      for (final item in AppFontFamily.values) {
        expect(AppFontFamily.fromName(item.name), item);
      }
    });

    test('falls back to the system font for unknown values', () {
      expect(AppFontFamily.fromName(null), AppFontFamily.system);
      expect(AppFontFamily.fromName('removedFont'), AppFontFamily.system);
    });
  });
}
