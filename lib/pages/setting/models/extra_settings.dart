import 'dart:io';

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart'
    show touchSlopH;
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart'
    show ImageGridView;
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show DynamicsDataModel;
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide RefreshIndicator;
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<SettingsModel> get extraSettings => [
  if (PlatformUtils.isDesktop)
    NormalModel(
      title: '缓存路径',
      getSubtitle: () => downloadPath,
      leading: const Icon(Icons.storage),
      onTap: _showDownPathDialog,
    ),
  SplitModel(
    normalModel: const NormalModel.split(
      title: '空降助手',
      subtitle: '点击配置',
      leading: Icon(CustomIcons.shield_play_arrow),
    ),
    switchModel: SwitchModel.split(
      defaultVal: false,
      setKey: SettingBoxKey.enableSponsorBlock,
      onTap: (context) => Get.toNamed('/sponsorBlock'),
    ),
  ),
  PopupModel<SkipType>(
    title: '番剧片头/片尾跳过类型',
    leading: const Icon(MdiIcons.debugStepOver),
    value: () => Pref.pgcSkipType,
    items: SkipType.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.pgcSkipType, value.index)
        .whenComplete(setState),
  ),
  SwitchModel(
    title: '横屏分P/合集列表显示在Tab栏',
    leading: const Icon(Icons.format_list_numbered_rtl_sharp),
    setKey: SettingBoxKey.horizontalSeasonPanel,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: '横屏播放页在侧栏打开UP主页',
    leading: const Icon(Icons.account_circle_outlined),
    setKey: SettingBoxKey.horizontalMemberPage,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: '横屏在侧栏打开图片预览',
    leading: const Icon(Icons.photo_outlined),
    setKey: SettingBoxKey.horizontalPreview,
    defaultVal: false,
    onChanged: (value) => ImageGridView.horizontalPreview = value,
  ),
  const SwitchModel(
    title: '禁用 SSL 证书验证',
    subtitle: '谨慎开启，禁用容易受到中间人攻击',
    leading: Icon(Icons.security),
    needReboot: true,
    setKey: SettingBoxKey.badCertificateCallback,
  ),
  getBanWordModel(
    title: '动态关键词过滤',
    key: SettingBoxKey.banWordForDyn,
    onChanged: (value) {
      DynamicsDataModel.banWordForDyn = value;
      DynamicsDataModel.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  NormalModel(
    title: '横向滑动阈值',
    getSubtitle: () => '当前:「${Pref.touchSlopH}」',
    onTap: _showTouchSlopDialog,
    leading: const Icon(Icons.pan_tool_alt_outlined),
  ),
  NormalModel(
    title: '刷新滑动距离',
    leading: const Icon(Icons.refresh),
    getSubtitle: () => '当前滑动距离: ${Pref.refreshDragPercentage}x',
    onTap: _showRefreshDragDialog,
  ),
  NormalModel(
    title: '刷新指示器高度',
    leading: const Icon(Icons.height),
    getSubtitle: () => '当前指示器高度: ${Pref.refreshDisplacement}',
    onTap: _showRefreshDialog,
  ),
  SwitchModel(
    title: '侧滑关闭二级页面',
    leading: const Icon(CustomIcons.touch_app_rotate_270),
    setKey: SettingBoxKey.slideDismissReplyPage,
    defaultVal: Platform.isIOS,
    onChanged: (value) => CommonSlideMixin.slideDismissReplyPage = value,
  ),
  const SwitchModel(
    title: '展示追番时间表',
    leading: Icon(MdiIcons.chartTimelineVariantShimmer),
    setKey: SettingBoxKey.showPgcTimeline,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: '长按/右键显示图片菜单',
    leading: const Icon(Icons.menu),
    setKey: SettingBoxKey.enableImgMenu,
    defaultVal: false,
    onChanged: (value) => ImageGridView.enableImgMenu = value,
  ),
  const SwitchModel(
    title: '快速收藏',
    subtitle: '点击设置默认收藏夹\n点按收藏至默认，长按选择文件夹',
    leading: Icon(Icons.bookmark_add_outlined),
    setKey: SettingBoxKey.enableQuickFav,
    onTap: _showFavDialog,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '启用HTTP/2',
    leading: Icon(Icons.swap_horizontal_circle_outlined),
    setKey: SettingBoxKey.enableHttp2,
    defaultVal: false,
    needReboot: true,
  ),
  const NormalModel(
    title: '连接重试次数',
    subtitle: '为0时禁用',
    leading: Icon(Icons.repeat),
    onTap: _showReplyCountDialog,
  ),
  const NormalModel(
    title: '连接重试间隔',
    subtitle: '实际间隔 = 间隔 * 第x次重试',
    leading: Icon(Icons.more_time_outlined),
    onTap: _showReplyDelayDialog,
  ),
  NormalModel(
    title: '最大缓存大小',
    getSubtitle: () {
      final num = Pref.maxCacheSize;
      return '当前最大缓存大小: 「${num == 0 ? '无限' : CacheManager.formatSize(Pref.maxCacheSize)}」';
    },
    leading: const Icon(Icons.delete_outlined),
    onTap: _showCacheDialog,
  ),
];

void _showDownPathDialog(BuildContext context, VoidCallback setState) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Get.back();
              Utils.copyText(downloadPath);
            },
            dense: true,
            title: const Text('复制', style: TextStyle(fontSize: 14)),
          ),
          ListTile(
            onTap: () {
              Get.back();
              final defPath = defDownloadPath;
              if (downloadPath == defPath) return;
              downloadPath = defPath;
              setState();
              Get.find<DownloadService>().initDownloadList();
              GStorage.setting.delete(SettingBoxKey.downloadPath);
            },
            dense: true,
            title: const Text('重置', style: TextStyle(fontSize: 14)),
          ),
          ListTile(
            onTap: () async {
              Get.back();
              final path = await FilePicker.getDirectoryPath();
              if (path == null || path == downloadPath) return;
              downloadPath = path;
              setState();
              Get.find<DownloadService>().initDownloadList();
              GStorage.setting.put(SettingBoxKey.downloadPath, path);
            },
            dense: true,
            title: const Text('设置新路径', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    ),
  );
}

void _showTouchSlopDialog(BuildContext context, VoidCallback setState) {
  String initialValue = Pref.touchSlopH.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('横向滑动阈值'),
      content: TextFormField(
        autofocus: true,
        initialValue: initialValue,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (value) => initialValue = value,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = double.parse(initialValue);
              Get.back();
              touchSlopH = val;
              await GStorage.setting.put(SettingBoxKey.touchSlopH, val);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

Future<void> _showRefreshDragDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: '刷新滑动距离',
      min: 0.1,
      max: 0.5,
      divisions: 8,
      precise: 2,
      value: Pref.refreshDragPercentage,
      suffix: 'x',
    ),
  );
  if (res != null) {
    kDragContainerExtentPercentage = res;
    await GStorage.setting.put(SettingBoxKey.refreshDragPercentage, res);
    setState();
  }
}

Future<void> _showRefreshDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: '刷新指示器高度',
      min: 10.0,
      max: 100.0,
      divisions: 9,
      value: Pref.refreshDisplacement,
    ),
  );
  if (res != null) {
    displacement = res;
    await GStorage.setting.put(SettingBoxKey.refreshDisplacement, res);
    if (WidgetsBinding.instance.rootElement case final context?) {
      context.visitChildElements(_visitor);
    }
    setState();
  }
}

void _visitor(Element context) {
  if (!context.mounted) return;
  if (context.widget is RefreshIndicator) {
    context.markNeedsBuild();
  } else {
    context.visitChildren(_visitor);
  }
}

Future<void> _showFavDialog(BuildContext context) async {
  if (Accounts.main.isLogin) {
    final res = await FavHttp.allFavFolders(Accounts.main.mid);
    if (res case Success(:final response)) {
      final list = response.list;
      if (list == null || list.isEmpty) {
        return;
      }
      final quickFavId = Pref.quickFavId;
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.hardEdge,
          title: const Text('选择默认收藏夹'),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 18),
          content: SingleChildScrollView(
            child: RadioGroup(
              onChanged: (value) {
                Get.back();
                GStorage.setting.put(SettingBoxKey.quickFavId, value);
                SmartDialog.showToast('设置成功');
              },
              groupValue: quickFavId,
              child: Column(
                children: list
                    .map(
                      (item) => RadioListTile(
                        toggleable: true,
                        dense: true,
                        title: Text(item.title),
                        value: item.id,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );
    } else {
      res.toast();
    }
  }
}

Future<void> _showReplyCountDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: '连接重试次数',
      min: 0,
      max: 8,
      divisions: 8,
      precise: 0,
      value: Pref.retryCount.toDouble(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.retryCount, res.toInt());
    setState();
    SmartDialog.showToast('重启生效');
  }
}

Future<void> _showReplyDelayDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: '连接重试间隔',
      min: 0,
      max: 1000,
      divisions: 10,
      precise: 0,
      value: Pref.retryDelay.toDouble(),
      suffix: 'ms',
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.retryDelay, res.toInt());
    setState();
    SmartDialog.showToast('重启生效');
  }
}

void _showCacheDialog(BuildContext context, VoidCallback setState) {
  String valueStr = '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('最大缓存大小'),
      content: TextField(
        autofocus: true,
        onChanged: (value) => valueStr = value,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
        ],
        decoration: const InputDecoration(suffixText: 'MB'),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            try {
              final val = num.parse(valueStr);
              Get.back();
              await GStorage.setting.put(
                SettingBoxKey.maxCacheSize,
                val * 1024 * 1024,
              );
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}
