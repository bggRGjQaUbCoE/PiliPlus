import 'dart:math';

import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/pages/setting/slide_color_picker.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

class SponsorBlockPage extends StatefulWidget {
  const SponsorBlockPage({super.key});

  @override
  State<SponsorBlockPage> createState() => _SponsorBlockPageState();
}

class _SponsorBlockPageState extends State<SponsorBlockPage> {
  final _url = 'https://github.com/hanydd/BilibiliSponsorBlock';
  final _textController = TextEditingController();
  double _blockLimit = Pref.blockLimit;
  final List<Pair<SegmentType, SkipType>> _blockSettings = Pref.blockSettings;
  final List<Color> _blockColor = Pref.blockColor;
  String _userId = Pref.blockUserID;
  bool _blockToast = Pref.blockToast;
  String _blockServer = Pref.blockServer;
  bool _blockTrack = Pref.blockTrack;
  final Rx<bool?> _serverStatus = Rx<bool?>(null);

  Box setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _checkServerStatus() {
    Request().get('$_blockServer/api/status/uptime').then((res) {
      _serverStatus.value =
          res.statusCode == 200 &&
          res.data is String &&
          Utils.isStringNumeric(res.data);
    });
  }

  Widget _blockLimitItem(
    ThemeData theme,
    TextStyle titleStyle,
    TextStyle subTitleStyle,
  ) => Builder(
    builder: (context) {
      return ListTile(
        dense: true,
        onTap: () {
          _textController.text = _blockLimit.toString();
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('最短片段时长', style: titleStyle),
                content: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  controller: _textController,
                  autofocus: true,
                  decoration: const InputDecoration(suffixText: 's'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _blockLimit = max(
                        0.0,
                        double.tryParse(_textController.text) ?? 0.0,
                      );
                      setting.put(SettingBoxKey.blockLimit, _blockLimit);
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        },
        title: Text('最短片段时长', style: titleStyle),
        subtitle: Text(
          '忽略短于此时长的片段',
          style: subTitleStyle,
        ),
        trailing: Text(
          '${_blockLimit}s',
          style: const TextStyle(fontSize: 13),
        ),
      );
    },
  );

  Widget _aboudItem(TextStyle titleStyle, TextStyle subTitleStyle) => ListTile(
    dense: true,
    title: Text('关于空降助手', style: titleStyle),
    subtitle: Text(_url, style: subTitleStyle),
    onTap: () => PageUtils.launchURL(_url),
  );

  Widget _userIdItem(
    ThemeData theme,
    TextStyle titleStyle,
    TextStyle subTitleStyle,
  ) => Builder(
    builder: (context) {
      return ListTile(
        dense: true,
        title: Text('用户ID', style: titleStyle),
        subtitle: Text(_userId, style: subTitleStyle),
        onTap: () {
          final key = GlobalKey<FormState>();
          _textController.text = _userId;
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('用户ID', style: titleStyle),
                content: Form(
                  key: key,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 4,
                    autofocus: true,
                    controller: _textController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\d]+')),
                    ],
                    validator: (value) {
                      if ((value?.length ?? -1) < 30) {
                        return '用户ID要求至少为30个字符长度的纯字符串';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _userId = const Uuid().v4().replaceAll('-', '');
                      setting.put(SettingBoxKey.blockUserID, _userId);
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('随机'),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (key.currentState?.validate() == true) {
                        Get.back();
                        _userId = _textController.text;
                        setting.put(SettingBoxKey.blockUserID, _userId);
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );

  Widget _blockToastItem(TextStyle titleStyle) => Builder(
    builder: (context) {
      void update() {
        _blockToast = !_blockToast;
        setting.put(SettingBoxKey.blockToast, _blockToast);
        (context as Element).markNeedsBuild();
      }

      return ListTile(
        dense: true,
        onTap: update,
        title: Text(
          '显示跳过Toast',
          style: titleStyle,
        ),
        trailing: Transform.scale(
          alignment: Alignment.centerRight,
          scale: 0.8,
          child: Switch(
            value: _blockToast,
            onChanged: (val) => update(),
          ),
        ),
      );
    },
  );

  Widget _blockTrackItem(
    TextStyle titleStyle,
    TextStyle subTitleStyle,
  ) => Builder(
    builder: (context) {
      void update() {
        _blockTrack = !_blockTrack;
        setting.put(SettingBoxKey.blockTrack, _blockTrack);
        (context as Element).markNeedsBuild();
      }

      return ListTile(
        dense: true,
        onTap: update,
        title: Text(
          '跳过次数统计跟踪',
          style: titleStyle,
        ),
        subtitle: Text(
          // from origin extension
          '此功能追踪您跳过了哪些片段，让用户知道他们提交的片段帮助了多少人。同时点赞会作为依据，确保垃圾信息不会污染数据库。在您每次跳过片段时，我们都会向服务器发送一条消息。希望大家开启此项设置，以便得到更准确的统计数据。:)',
          style: subTitleStyle,
        ),
        trailing: Transform.scale(
          alignment: Alignment.centerRight,
          scale: 0.8,
          child: Switch(
            value: _blockTrack,
            onChanged: (val) => update(),
          ),
        ),
      );
    },
  );

  Widget _blockServerItem(
    ThemeData theme,
    TextStyle titleStyle,
    TextStyle subTitleStyle,
  ) => Builder(
    builder: (context) {
      return ListTile(
        dense: true,
        onTap: () {
          _textController.text = _blockServer;
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('服务器地址', style: titleStyle),
                content: TextFormField(
                  keyboardType: TextInputType.url,
                  controller: _textController,
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _blockServer = HttpString.sponsorBlockBaseUrl;
                      setting.put(SettingBoxKey.blockServer, _blockServer);
                      Request.accountManager.blockServer = _blockServer;
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('重置'),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _blockServer = _textController.text;
                      setting.put(SettingBoxKey.blockServer, _blockServer);
                      Request.accountManager.blockServer = _blockServer;
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        },
        title: Text(
          '服务器地址',
          style: titleStyle,
        ),
        subtitle: Text(
          _blockServer,
          style: subTitleStyle,
        ),
      );
    },
  );

  Widget _serverStatusItem(ThemeData theme, TextStyle titleStyle) => Obx(
    () {
      String status;
      Color? color;
      switch (_serverStatus.value) {
        case null:
          status = '——';
        case true:
          status = '正常';
          color = theme.colorScheme.primary;
        case false:
          status = '错误';
          color = theme.colorScheme.error;
      }
      return ListTile(
        dense: true,
        onTap: () {
          _serverStatus.value = null;
          _checkServerStatus();
        },
        title: Text('服务器状态', style: titleStyle),
        trailing: Text(
          status,
          style: TextStyle(fontSize: 13, color: color),
        ),
      );
    },
  );

  void onSelectColor(
    BuildContext context,
    int index,
    Color color,
    Pair<SegmentType, SkipType> item,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Color Picker ',
                style: TextStyle(fontSize: 15),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                style: const TextStyle(fontSize: 13, height: 1),
              ),
              TextSpan(
                text: ' ${item.first.title}',
                style: const TextStyle(fontSize: 13, height: 1),
              ),
            ],
          ),
        ),
        content: SlideColorPicker(
          color: color,
          showResetBtn: true,
          callback: (Color? color) {
            _blockColor[index] = color ?? item.first.color;
            setting.put(
              SettingBoxKey.blockColor,
              _blockColor
                  .map((item) => item.toARGB32().toRadixString(16).substring(2))
                  .toList(),
            );
            (context as Element).markNeedsBuild();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const titleStyle = TextStyle(fontSize: 15);

    final subTitleStyle = TextStyle(
      fontSize: 13,
      color: theme.colorScheme.outline,
    );

    final divider = Divider(
      height: 1,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );

    final sliverDivider = SliverToBoxAdapter(child: divider);

    final dividerL = SliverToBoxAdapter(
      child: Divider(
        thickness: 16,
        color: theme.colorScheme.outline.withValues(alpha: 0.1),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('空降助手')),
      body: CustomScrollView(
        slivers: [
          dividerL,
          SliverToBoxAdapter(child: _serverStatusItem(theme, titleStyle)),
          dividerL,
          SliverToBoxAdapter(
            child: _blockLimitItem(theme, titleStyle, subTitleStyle),
          ),
          sliverDivider,
          SliverToBoxAdapter(child: _blockToastItem(titleStyle)),
          sliverDivider,
          SliverToBoxAdapter(child: _blockTrackItem(titleStyle, subTitleStyle)),
          dividerL,
          SliverList.separated(
            itemCount: _blockSettings.length,
            itemBuilder: (context, index) =>
                _buildItem(theme, index, _blockSettings[index]),
            separatorBuilder: (context, index) => divider,
          ),
          dividerL,
          SliverToBoxAdapter(
            child: _userIdItem(theme, titleStyle, subTitleStyle),
          ),
          sliverDivider,
          SliverToBoxAdapter(
            child: _blockServerItem(theme, titleStyle, subTitleStyle),
          ),
          dividerL,
          SliverToBoxAdapter(child: _aboudItem(titleStyle, subTitleStyle)),
          dividerL,
          SliverToBoxAdapter(
            child: SizedBox(
              height: 55 + MediaQuery.viewPaddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    ThemeData theme,
    int index,
    Pair<SegmentType, SkipType> item,
  ) {
    return Builder(
      builder: (context) {
        Color color = _blockColor[index];
        final isDisable = item.second == SkipType.disable;
        return ListTile(
          dense: true,
          enabled: item.second != SkipType.disable,
          onTap: () => onSelectColor(context, index, color, item),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14, height: 1),
                    ),
                    TextSpan(
                      text: ' ${item.first.title}',
                      style: const TextStyle(fontSize: 14, height: 1),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (btnContext) {
                  return PopupMenuButton<SkipType>(
                    initialValue: item.second,
                    onSelected: (e) {
                      final updateItem = isDisable || e == SkipType.disable;
                      item.second = e;
                      setting.put(
                        SettingBoxKey.blockSettings,
                        _blockSettings.map((e) => e.second.index).toList(),
                      );
                      if (updateItem) {
                        (context as Element).markNeedsBuild();
                      } else {
                        (btnContext as Element).markNeedsBuild();
                      }
                    },
                    itemBuilder: (context) => SkipType.values
                        .map(
                          (item) => PopupMenuItem<SkipType>(
                            value: item,
                            child: Text(item.title),
                          ),
                        )
                        .toList(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.second.title,
                            style: TextStyle(
                              height: 1,
                              fontSize: 14,
                              color: isDisable
                                  ? theme.colorScheme.outline.withValues(
                                      alpha: 0.7,
                                    )
                                  : theme.colorScheme.secondary,
                            ),
                            strutStyle: const StrutStyle(height: 1, leading: 0),
                          ),
                          Icon(
                            MdiIcons.unfoldMoreHorizontal,
                            size: MediaQuery.textScalerOf(context).scale(14),
                            color: isDisable
                                ? theme.colorScheme.outline.withValues(
                                    alpha: 0.7,
                                  )
                                : theme.colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          subtitle: Text(
            item.first.description,
            style: TextStyle(
              fontSize: 12,
              color: isDisable ? null : theme.colorScheme.outline,
            ),
          ),
        );
      },
    );
  }
}
