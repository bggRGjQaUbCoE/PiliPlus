import 'package:PiliPlus/pages/setting/models/dm_settings.dart';
import 'package:PiliPlus/pages/setting/models/dyn_settings.dart';
import 'package:PiliPlus/pages/setting/models/extra_settings.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart';
import 'package:PiliPlus/pages/setting/models/privacy_settings.dart';
import 'package:PiliPlus/pages/setting/models/recommend_settings.dart';
import 'package:PiliPlus/pages/setting/models/reply_settings.dart';
import 'package:PiliPlus/pages/setting/models/style_settings.dart';
import 'package:PiliPlus/pages/setting/models/video_settings.dart';

enum SettingType {
  privacySetting('隐私设置'),
  recommendSetting('推荐流设置'),
  videoSetting('音视频设置'),
  playSetting('播放器设置'),
  dmSetting('弹幕设置'),
  replySetting('评论设置'),
  dynSetting('动态设置'),
  styleSetting('外观设置'),
  extraSetting('其它设置'),
  webdavSetting('WebDAV 设置'),
  about('关于'),
  ;

  final String title;
  const SettingType(this.title);

  List<SettingsModel> get settings => switch (this) {
    .privacySetting => privacySettings,
    .recommendSetting => recommendSettings,
    .videoSetting => videoSettings,
    .playSetting => playSettings,
    .dmSetting => dmSettings,
    .dynSetting => dynSettings,
    .replySetting => replySettings,
    .styleSetting => styleSettings,
    .extraSetting => extraSettings,
    .webdavSetting || .about => throw UnimplementedError(),
  };
}
