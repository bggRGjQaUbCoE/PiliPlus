import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';

List<SettingsModel> get advancedSettings => [
  const SwitchModel(
    title: '进入视频页时查询稍后再看状态',
    subtitle: '开启：进入视频页时查询该视频是否已加入稍后再看，'
        '“再看”按钮状态更准确\n关闭：按页面来源推断（原逻辑）',
    leading: Icon(Icons.watch_later_outlined),
    setKey: SettingBoxKey.queryLaterStatus,
    defaultVal: false,
  ),
];
