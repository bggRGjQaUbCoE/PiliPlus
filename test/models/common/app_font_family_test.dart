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
      expect(
        AppFontFamily.sourceHanSansCn.fontFamily,
        'Source Han Sans CN',
      );
      expect(AppFontFamily.miSans.fontFamily, 'MiSans');
      expect(
        AppFontFamily.harmonyOsSansSc.fontFamily,
        'HarmonyOS Sans SC',
      );
      expect(AppFontFamily.lxgwWenKaiGbScreen.label, '霞鹜文楷');
      expect(AppFontFamily.lxgwZhenKaiGb.label, '霞鹜臻楷');
      expect(AppFontFamily.lxgwNeoXiHeiScreen.label, '霞鹜新晰黑');
      expect(AppFontFamily.lxgwZhuqueFangsong.label, '霞鹜朱雀仿宋');
      expect(AppFontFamily.sourceHanSansCn.label, '思源黑体');
      expect(AppFontFamily.sourceHanSerifCn.label, '思源宋体');
      expect(AppFontFamily.fusionPixel.label, '缝合像素字体');
      expect(AppFontFamily.system.downloadUrls, isNull);
      expect(AppFontFamily.system.transferSize, isNull);
      expect(AppFontFamily.system.isSystem, isTrue);

      for (final item in AppFontFamily.values.skip(1)) {
        expect(item.isSystem, isFalse);
        expect(item.fileName, isNotEmpty);
        expect(item.downloadUrls, isNotEmpty);
        for (final url in item.downloadUrls!) {
          expect(url, startsWith('https://'));
        }
        expect(item.downloadSize, greaterThan(0));
        expect(item.transferSize, greaterThanOrEqualTo(item.downloadSize!));
        expect(item.sha256, hasLength(64));
        expect(item.licenseUrl == null, item.licenseNotice == null);

        final archive = item.downloadArchive;
        if (archive != null) {
          expect(archive.entryName, isNotEmpty);
          expect(archive.downloadSize, greaterThan(0));
          expect(archive.sha256, hasLength(64));
          expect(
            archive.licenseEntryName == null,
            archive.licenseFileName == null,
          );
        }
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
