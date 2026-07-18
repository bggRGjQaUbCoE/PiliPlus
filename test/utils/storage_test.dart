import 'dart:io';

import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_storage_import_test_',
    );
    appSupportDirPath = testDir.path;
    await GStorage.init();
  });

  setUp(() async {
    await Future.wait([GStorage.setting.clear(), GStorage.video.clear()]);
    await GStorage.setting.putAll({'theme': 'old', 'settingOnly': true});
    await GStorage.video.putAll({'quality': 80, 'videoOnly': true});
  });

  tearDownAll(() async {
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('rejects a missing section before changing existing settings', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        GStorage.setting.name: {'theme': 'new'},
      }),
      throwsA(isA<FormatException>()),
    );

    expect(GStorage.setting.toMap(), {'theme': 'old', 'settingOnly': true});
    expect(GStorage.video.toMap(), {'quality': 80, 'videoOnly': true});
  });

  test('rolls both boxes back if writing imported values fails', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        GStorage.setting.name: {'theme': Object()},
        GStorage.video.name: {'quality': 120},
      }),
      throwsA(anything),
    );

    expect(GStorage.setting.toMap(), {'theme': 'old', 'settingOnly': true});
    expect(GStorage.video.toMap(), {'quality': 80, 'videoOnly': true});
  });

  test('valid import replaces both settings sections', () async {
    await GStorage.importAllJsonSettings({
      GStorage.setting.name: {'theme': 'new'},
      GStorage.video.name: {'quality': 120},
    });

    expect(GStorage.setting.toMap(), {'theme': 'new'});
    expect(GStorage.video.toMap(), {'quality': 120});
  });

  group('semantic validation', () {
    Future<void> expectRejected({
      Map<String, dynamic> setting = const {},
      Map<String, dynamic> video = const {},
    }) async {
      final previousSetting = GStorage.setting.toMap();
      final previousVideo = GStorage.video.toMap();

      await expectLater(
        GStorage.importAllJsonSettings({
          GStorage.setting.name: setting,
          GStorage.video.name: video,
        }),
        throwsA(isA<FormatException>()),
      );

      expect(GStorage.setting.toMap(), previousSetting);
      expect(GStorage.video.toMap(), previousVideo);
    }

    test(
      'rejects wrong startup-critical value types without mutation',
      () async {
        for (final key in const [
          SettingBoxKey.horizontalScreen,
          SettingBoxKey.saveReply,
          SettingBoxKey.enableBackgroundPlay,
          SettingBoxKey.enableHttp2,
          SettingBoxKey.enableSystemProxy,
          SettingBoxKey.showWindowTitleBar,
          SettingBoxKey.isWindowMaximized,
          SettingBoxKey.dynamicColor,
          SettingBoxKey.enableLog,
          SettingBoxKey.badCertificateCallback,
          SettingBoxKey.checkDynamic,
          SettingBoxKey.enableMYBar,
          SettingBoxKey.floatingNavBar,
          SettingBoxKey.useSideBar,
          SettingBoxKey.mainTabBarView,
          SettingBoxKey.optTabletNav,
          SettingBoxKey.directExitOnBack,
          SettingBoxKey.showTrayIcon,
          SettingBoxKey.minimizeOnExit,
          SettingBoxKey.pauseOnMinimize,
          SettingBoxKey.autoUpdate,
          SettingBoxKey.hideBottomBar,
          SettingBoxKey.enableSearchWord,
          SettingBoxKey.hideTopBar,
        ]) {
          await expectRejected(setting: {key: 'not-a-boolean'});
        }

        for (final key in const [
          SettingBoxKey.downloadPath,
          SettingBoxKey.displayMode,
          SettingBoxKey.systemProxyHost,
          SettingBoxKey.systemProxyPort,
          SettingBoxKey.blockServer,
        ]) {
          await expectRejected(setting: {key: false});
        }

        for (final key in const [
          SettingBoxKey.dynamicPeriod,
          SettingBoxKey.retryCount,
          SettingBoxKey.retryDelay,
        ]) {
          await expectRejected(setting: {key: 'not-an-integer'});
        }

        for (final key in const [
          SettingBoxKey.uiScale,
          SettingBoxKey.defaultTextScale,
          SettingBoxKey.maxCacheSize,
        ]) {
          await expectRejected(setting: {key: 'not-a-number'});
        }
      },
    );

    test('rejects out-of-range enum indices without mutation', () async {
      for (final key in const [
        SettingBoxKey.themeMode,
        SettingBoxKey.schemeVariant,
        SettingBoxKey.pageTransition,
        SettingBoxKey.barHideType,
        SettingBoxKey.msgBadgeMode,
        SettingBoxKey.dynamicBadgeMode,
        SettingBoxKey.defaultHomePage,
        SettingBoxKey.customColor,
      ]) {
        await expectRejected(setting: {key: 999});
      }
      await expectRejected(
        video: {VideoBoxKey.playRepeat: 999},
      );
    });

    test('rejects malformed and out-of-range lists without mutation', () async {
      await expectRejected(
        setting: {
          SettingBoxKey.windowSize: [1180.0],
        },
      );
      await expectRejected(
        setting: {
          SettingBoxKey.tabBarSort: [0, 999],
        },
      );
      await expectRejected(
        setting: {
          SettingBoxKey.navBarSort: [0, 999],
        },
      );
      await expectRejected(
        setting: {
          SettingBoxKey.msgUnReadTypeV2: [0, 999],
        },
      );
      await expectRejected(
        setting: {
          SettingBoxKey.windowPosition: [0.0],
        },
      );
    });

    test('normalizes valid numeric settings to their runtime types', () async {
      await GStorage.importAllJsonSettings({
        GStorage.setting.name: {
          SettingBoxKey.uiScale: 1,
          SettingBoxKey.windowSize: [1180, 720],
        },
        GStorage.video.name: {
          VideoBoxKey.playSpeedDefault: 2,
        },
      });

      expect(GStorage.setting.get(SettingBoxKey.uiScale), 1.0);
      expect(GStorage.setting.get(SettingBoxKey.windowSize), [1180.0, 720.0]);
      expect(GStorage.video.get(VideoBoxKey.playSpeedDefault), 2.0);
    });
  });
}
