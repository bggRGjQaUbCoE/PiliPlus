import 'dart:io';

import 'package:PiliPlus/models/common/app_font_family.dart';
import 'package:PiliPlus/pages/setting/widgets/app_font_family_dialog.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final Directory supportDir;

  setUpAll(() {
    supportDir = Directory.systemTemp.createTempSync('piliplus-font-test-');
    appSupportDirPath = supportDir.path;
  });

  tearDownAll(() {
    supportDir.deleteSync(recursive: true);
  });

  testWidgets('offers downloads before custom fonts can be selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppFontFamilyDialog(value: AppFontFamily.system),
      ),
    );

    expect(find.text('系统默认'), findsOneWidget);
    expect(find.text('霞鹜文楷'), findsOneWidget);
    expect(find.text('思源宋体'), findsOneWidget);
    expect(find.text('24.8 MB'), findsOneWidget);
    expect(find.text('11.1 MB'), findsOneWidget);
    expect(find.byTooltip('下载字体'), findsNWidgets(2));

    final radios = tester
        .widgetList<Radio<AppFontFamily>>(
          find.byType(Radio<AppFontFamily>),
        )
        .toList(growable: false);
    expect(radios.map((radio) => radio.enabled), [true, false, false]);
  });
}
