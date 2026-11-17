import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late Directory temp;
  setUpAll(() async {
    temp = await Directory.systemTemp.createTemp('piliplus-images-');
    Hive.init(temp.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.localCache = await Hive.openBox('localCache');
  });
  tearDownAll(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });
  testWidgets(
    'custom empty placeholders reserve the same image slot as a loaded cover',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: NetworkImgLayer(
              src: null,
              width: 120,
              height: 80,
              getPlaceHolder: () => const SizedBox.shrink(),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(NetworkImgLayer)), const Size(120, 80));
    },
  );
}
