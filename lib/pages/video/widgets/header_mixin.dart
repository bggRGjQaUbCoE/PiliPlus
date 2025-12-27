import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/menu_row.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin HeaderMixin<T extends StatefulWidget> on State<T> {
  PlPlayerController get plPlayerController;

  bool get isFullScreen => plPlayerController.isFullScreen.value;

  Future<void>? showBottomSheet(
    StatefulWidgetBuilder builder, {
    double? padding,
  }) {
    return PageUtils.showVideoBottomSheet(
      context,
      isFullScreen: () => isFullScreen,
      padding: padding,
      child: StatefulBuilder(
        builder: (context, setState) => plPlayerController.darkVideoPage
            ? Theme(
                data: Theme.of(this.context),
                child: builder(this.context, setState),
              )
            : builder(context, setState),
      ),
    );
  }

  Widget resetBtn(
    ThemeData theme,
    Object def,
    VoidCallback onPressed, {
    bool isDanmaku = true,
  }) {
    return iconButton(
      tooltip: '默认值: $def',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        onPressed();
        if (isDanmaku) {
          // plPlayerController.putDanmakuSettings();
        } else {
          plPlayerController.putSubtitleSettings();
        }
      },
      iconColor: theme.colorScheme.outline,
      size: 24,
      iconSize: 24,
    );
  }

  /// 弹幕功能
  Future<void> showSetDanmaku({bool isLive = false}) async {
    // 屏蔽类型
    const blockTypesList = [
      (value: 2, label: '滚动'),
      (value: 5, label: '顶部'),
      (value: 4, label: '底部'),
      (value: 6, label: '彩色'),
      (value: 7, label: '高级'),
    ];

    final danmakuController = plPlayerController.danmakuController;

    final isFullScreen = this.isFullScreen;

    await showBottomSheet(
      (context, setState) {
        final theme = Theme.of(context);

        void setOptions() => danmakuController?.updateOption(
          DanmakuOptions.get(
            notFullscreen: !isFullScreen,
            speed: plPlayerController.playbackSpeed,
          ),
        );

        final sliderTheme = SliderThemeData(
          trackHeight: 10,
          trackShape: const MSliderTrackShape(),
          thumbColor: theme.colorScheme.primary,
          activeTrackColor: theme.colorScheme.primary,
          inactiveTrackColor: theme.colorScheme.onInverseSurface,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        );

        void updateLineHeight(double val) {
          DanmakuOptions.danmakuLineHeight = val.toPrecision(1);
          setState(() {});
          setOptions();
        }

        void updateDuration(double val) {
          DanmakuOptions.danmakuDuration = val.toPrecision(1);
          setState(() {});
          setOptions();
        }

        void updateStaticDuration(double val) {
          DanmakuOptions.danmakuStaticDuration = val.toPrecision(1);
          setState(() {});
          setOptions();
        }

        void updateFontSizeFS(double val) {
          DanmakuOptions.danmakuFontScaleFS = val;
          setState(() {});
          if (isFullScreen) {
            setOptions();
          }
        }

        void updateFontSize(double val) {
          DanmakuOptions.danmakuFontScale = val;
          setState(() {});
          if (!isFullScreen) {
            setOptions();
          }
        }

        void updateStrokeWidth(double val) {
          DanmakuOptions.danmakuStrokeWidth = val;
          setState(() {});
          setOptions();
        }

        void updateFontWeight(double val) {
          DanmakuOptions.danmakuFontWeight = val.toInt();
          setOptions();
        }

        void updateOpacity(double val) {
          plPlayerController.danmakuOpacity.value = val;
          setState(() {});
        }

        void updateShowArea(double val) {
          DanmakuOptions.danmakuShowArea = val.toPrecision(1);
          setState(() {});
          setOptions();
        }

        void onUpdateBlockType(int blockType, bool blocked) {
          if (blocked) {
            DanmakuOptions.blockTypes.remove(blockType);
          } else {
            DanmakuOptions.blockTypes.add(blockType);
          }
          DanmakuOptions.blockColorful = DanmakuOptions.blockTypes.contains(6);
          setState(() {});
          setOptions();
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(
                    height: 45,
                    child: Center(
                      child: Text('弹幕设置', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isLive) ...[
                    Row(
                      children: [
                        Text('智能云屏蔽 ${plPlayerController.danmakuWeight} 级'),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Get
                            ..back()
                            ..toNamed(
                              '/danmakuBlock',
                              arguments: plPlayerController,
                            ),
                          child: Text(
                            "屏蔽管理(${plPlayerController.filters.count})",
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 6,
                        left: 10,
                        right: 10,
                      ),
                      child: SliderTheme(
                        data: sliderTheme,
                        child: Slider(
                          min: 0,
                          max: 10,
                          value: plPlayerController.danmakuWeight.toDouble(),
                          divisions: 10,
                          label: '${plPlayerController.danmakuWeight}',
                          onChanged: (val) =>
                              plPlayerController.danmakuWeight = val.toInt(),
                          onChangeEnd: (val) => GStorage.setting.put(
                            SettingBoxKey.danmakuWeight,
                            val.toInt(),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Text('按类型屏蔽'),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 10,
                        children: blockTypesList.map(
                          (e) {
                            final blocked = DanmakuOptions.blockTypes.contains(
                              e.value,
                            );
                            return ActionRowLineItem(
                              onTap: () => onUpdateBlockType(e.value, blocked),
                              text: e.label,
                              selectStatus: blocked,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  SetSwitchItem(
                    title: '海量弹幕',
                    contentPadding: EdgeInsets.zero,
                    titleStyle: const TextStyle(fontSize: 14),
                    defaultVal: DanmakuOptions.massiveMode,
                    setKey: SettingBoxKey.danmakuMassiveMode,
                    onChanged: (value) {
                      DanmakuOptions.massiveMode = value;
                      setState(() {});
                      setOptions();
                    },
                  ),
                  SetSwitchItem(
                    title: '滚动弹幕固定速度',
                    contentPadding: EdgeInsets.zero,
                    titleStyle: const TextStyle(fontSize: 14),
                    defaultVal: DanmakuOptions.scrollFixedVelocity,
                    setKey: SettingBoxKey.danmakuFixedV,
                    onChanged: (value) {
                      DanmakuOptions.scrollFixedVelocity = value;
                      setState(() {});
                      setOptions();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('显示区域 ${DanmakuOptions.danmakuShowArea * 100}%'),
                      resetBtn(
                        theme,
                        '50.0%',
                        () => updateShowArea(0.5),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0.1,
                        max: 1,
                        value: DanmakuOptions.danmakuShowArea,
                        divisions: 9,
                        label: '${DanmakuOptions.danmakuShowArea * 100}%',
                        onChanged: updateShowArea,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('不透明度 ${plPlayerController.danmakuOpacity * 100}%'),
                      resetBtn(
                        theme,
                        '100.0%',
                        () => updateOpacity(1.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: plPlayerController.danmakuOpacity.value,
                        divisions: 10,
                        label: '${plPlayerController.danmakuOpacity * 100}%',
                        onChanged: updateOpacity,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '字体粗细 ${DanmakuOptions.danmakuFontWeight + 1}（可能无法精确调节）',
                      ),
                      resetBtn(
                        theme,
                        6,
                        () => updateFontWeight(5),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 8,
                        value: DanmakuOptions.danmakuFontWeight.toDouble(),
                        divisions: 8,
                        label: '${DanmakuOptions.danmakuFontWeight + 1}',
                        onChanged: updateFontWeight,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('描边粗细 ${DanmakuOptions.danmakuStrokeWidth}'),
                      resetBtn(
                        theme,
                        1.5,
                        () => updateStrokeWidth(1.5),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0,
                        max: 5,
                        value: DanmakuOptions.danmakuStrokeWidth,
                        divisions: 10,
                        label: DanmakuOptions.danmakuStrokeWidth
                            .toStringAsFixed(0),
                        onChanged: updateStrokeWidth,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '字体大小 ${(DanmakuOptions.danmakuFontScale * 100).toStringAsFixed(1)}%',
                      ),
                      resetBtn(
                        theme,
                        '100.0%',
                        () => updateFontSize(1.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0.5,
                        max: 2.5,
                        value: DanmakuOptions.danmakuFontScale,
                        divisions: 20,
                        label:
                            '${(DanmakuOptions.danmakuFontScale * 100).toStringAsFixed(1)}%',
                        onChanged: updateFontSize,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '全屏字体大小 ${(DanmakuOptions.danmakuFontScaleFS * 100).toStringAsFixed(1)}%',
                      ),
                      resetBtn(
                        theme,
                        '120.0%',
                        () => updateFontSizeFS(1.2),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 0.5,
                        max: 2.5,
                        value: DanmakuOptions.danmakuFontScaleFS,
                        divisions: 20,
                        label:
                            '${(DanmakuOptions.danmakuFontScaleFS * 100).toStringAsFixed(1)}%',
                        onChanged: updateFontSizeFS,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('滚动弹幕时长 ${DanmakuOptions.danmakuDuration} 秒'),
                      resetBtn(
                        theme,
                        7.0,
                        () => updateDuration(7.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 1,
                        max: 50,
                        value: DanmakuOptions.danmakuDuration,
                        divisions: 49,
                        label: DanmakuOptions.danmakuDuration.toString(),
                        onChanged: updateDuration,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('静态弹幕时长 ${DanmakuOptions.danmakuStaticDuration} 秒'),
                      resetBtn(
                        theme,
                        4.0,
                        () => updateStaticDuration(4.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 1,
                        max: 50,
                        value: DanmakuOptions.danmakuStaticDuration,
                        divisions: 49,
                        label: DanmakuOptions.danmakuStaticDuration.toString(),
                        onChanged: updateStaticDuration,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('弹幕行高 ${DanmakuOptions.danmakuLineHeight}'),
                      resetBtn(
                        theme,
                        1.6,
                        () => updateLineHeight(1.6),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: sliderTheme,
                      child: Slider(
                        min: 1.0,
                        max: 3.0,
                        value: DanmakuOptions.danmakuLineHeight,
                        onChanged: updateLineHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    await DanmakuOptions.save();
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  const MSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 3;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
