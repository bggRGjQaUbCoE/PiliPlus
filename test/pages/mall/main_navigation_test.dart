import 'dart:io';

import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _MainController extends MainController {
  bool _mallEnabled = false;

  set mallEnabled(bool enabled) => _mallEnabled = enabled;

  @override
  bool get mallEnabled => _mallEnabled;

  @override
  void setSearchBar() {}

  @override
  void checkDefaultSearch([bool shouldCheck = false]) {}
}

void main() {
  late Directory storage;

  setUpAll(() async {
    storage = await Directory.systemTemp.createTemp('piliplus-pr-nav-');
    Hive.init(storage.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.userInfo = await Hive.openBox<UserInfoData>('userInfo');
    Get.put(AccountService());
  });

  setUp(() async {
    await GStorage.setting.clear();
    await GStorage.setting.put(SettingBoxKey.autoUpdate, false);
  });

  tearDownAll(() async {
    Get.reset();
    await Hive.close();
    await storage.delete(recursive: true);
  });

  test(
    'stock navigation is the default and old indices keep their meaning',
    () {
      expect(
        MainController.resolveNavigation(null, showMall: false),
        NavigationBarType.primary,
      );
      expect(
        MainController.resolveNavigation([2, 3, 0, 2, 99], showMall: false),
        [NavigationBarType.mine, NavigationBarType.home],
      );
      expect(
        MainController.resolveNavigation([3, 99], showMall: true),
        [
          NavigationBarType.home,
          NavigationBarType.dynamics,
          NavigationBarType.mall,
          NavigationBarType.mine,
        ],
      );
    },
  );

  test(
    'keeps a saved mall start page available only when the mall is enabled',
    () async {
      await GStorage.setting.put(SettingBoxKey.defaultHomePage, 3);
      final main = _MainController()..setNavBarConfig();
      expect(
        main.navigationBars[main.selectedIndex.value],
        NavigationBarType.home,
      );
      main
        ..mallEnabled = true
        ..setNavBarConfig();
      expect(
        main.navigationBars[main.selectedIndex.value],
        NavigationBarType.mall,
      );
    },
  );

  for (final tabs in [false, true]) {
    testWidgets('updates live navigation with ${tabs ? 'tabs' : 'pages'}', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await GStorage.setting.putAll({
          SettingBoxKey.mainTabBarView: tabs,
          SettingBoxKey.defaultHomePage: 3,
        });
      });
      final main = _MainController()..onInit();
      expect(
        main.navigationBars[main.selectedIndex.value],
        NavigationBarType.home,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Obx(() {
            final key = ValueKey(main.navRevision.value);
            final children = [
              for (final nav in main.navigationBars)
                Center(child: Text(nav.label)),
            ];
            return tabs
                ? TabBarView(
                    key: key,
                    controller: main.controller,
                    children: children,
                  )
                : PageView(
                    key: key,
                    controller: main.controller,
                    children: children,
                  );
          }),
        ),
      );

      main
        ..setIndex(2)
        ..mallEnabled = true
        ..refreshMallNavigation();
      await tester.pumpAndSettle();
      expect(find.text('我的'), findsOneWidget);
      expect(main.selectedIndex.value, 3);

      main.setIndex(2);
      await tester.pumpAndSettle();
      expect(find.text('会员购'), findsOneWidget);

      main.mallGoBack = () async => true;
      await main.onMallBack();
      expect(find.text('会员购'), findsOneWidget);
      main.mallGoBack = () async => false;
      await main.onMallBack();
      await tester.pumpAndSettle();
      expect(find.text('首页'), findsOneWidget);

      main.setIndex(2);
      await tester.pumpAndSettle();
      main
        ..mallEnabled = false
        ..refreshMallNavigation();
      await tester.pumpAndSettle();
      expect(find.text('首页'), findsOneWidget);
      expect(main.navigationBars, NavigationBarType.primary);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      main.onClose();
    });
  }
}
