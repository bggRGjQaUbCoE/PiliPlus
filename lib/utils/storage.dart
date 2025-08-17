import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/user/danmaku_rule_adapter.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account_adapter.dart';
import 'package:PiliPlus/utils/accounts/account_type_adapter.dart';
import 'package:PiliPlus/utils/accounts/cookie_jar_adapter.dart';
import 'package:PiliPlus/utils/set_int_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class GStorage {
  static late final Box<UserInfoData> userInfo;
  static late final Box<List<String>> historyWord;
  static late final Box<dynamic> localCache;
  static late final Box<dynamic> setting;
  static late final Box<dynamic> video;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    regAdapter();
    // 登录用户信息
    userInfo = await Hive.openBox<UserInfoData>(
      'userInfo',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 2;
      },
    );
    // 本地缓存
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 4;
      },
    );
    // 设置
    setting = await Hive.openBox('setting');
    // 搜索历史
    historyWord = await Hive.openBox<List<String>>(
      'historyWord',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 10;
      },
    );
    // 视频设置
    video = await Hive.openBox('video');

    await Accounts.init();
  }

  static String exportAllSettings() {
    return jsonEncode({
      setting.name: setting.toMap(),
      video.name: video.toMap(),
    });
  }

  static Future<void> importAllSettings(String data) =>
      importAllJsonSettings(jsonDecode(data));

  static Future<void> importAllJsonSettings(Map<String, dynamic> map) async {
    await setting.clear();
    await video.clear();
    await setting.putAll(map[setting.name]);
    await video.putAll(map[video.name]);
  }

  static void regAdapter() {
    Hive
      ..registerAdapter(OwnerAdapter())
      ..registerAdapter(UserInfoDataAdapter())
      ..registerAdapter(LevelInfoAdapter())
      ..registerAdapter(BiliCookieJarAdapter())
      ..registerAdapter(LoginAccountAdapter())
      ..registerAdapter(AccountTypeAdapter())
      ..registerAdapter(SetIntAdapter())
      ..registerAdapter(RuleFilterAdapter());
  }

  static void close() {
    // user.compact();
    // user.close();
    userInfo
      ..compact()
      ..close();
    historyWord
      ..compact()
      ..close();
    localCache
      ..compact()
      ..close();
    setting
      ..compact()
      ..close();
    video
      ..compact()
      ..close();
    Accounts.close();
  }
}
