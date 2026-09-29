import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/setting/models/extra_settings.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart';
import 'package:PiliPlus/pages/setting/models/privacy_settings.dart';
import 'package:PiliPlus/pages/setting/models/recommend_settings.dart';
import 'package:PiliPlus/pages/setting/models/style_settings.dart';
import 'package:PiliPlus/pages/setting/models/video_settings.dart';

enum SettingType {
  privacySetting,
  recommendSetting,
  videoSetting,
  playSetting,
  styleSetting,
  extraSetting,
  webdavSetting,
  about,
  ;

  String get title => switch (this) {
    privacySetting => L10n.current.privacySettings,
    recommendSetting => L10n.current.recommendationSettings,
    videoSetting => L10n.current.videoSettings,
    playSetting => L10n.current.playerSettings,
    styleSetting => L10n.current.appearanceSettings,
    extraSetting => L10n.current.extraSettings,
    webdavSetting => L10n.current.webdavSettings,
    about => L10n.current.about,
  };

  List<SettingsModel> get settings => switch (this) {
    .privacySetting => privacySettings,
    .recommendSetting => recommendSettings,
    .videoSetting => videoSettings,
    .playSetting => playSettings,
    .styleSetting => styleSettings,
    .extraSetting => extraSettings,
    _ => throw UnimplementedError(),
  };
}
