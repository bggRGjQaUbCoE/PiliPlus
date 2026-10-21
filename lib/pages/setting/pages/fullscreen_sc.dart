import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/extra_hittest_stack.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

const kFullScreenSCWidth = 255.0;

class FullScreenSc extends StatefulWidget {
  const FullScreenSc({super.key});

  @override
  State<FullScreenSc> createState() => _FullScreenScState();
}

class _FullScreenScState extends State<FullScreenSc> {
  var _width = Pref.fullScreenSCWidth;
  var _enable = Pref.enableFullScreenSC;
  var _opacity = Pref.fullScreenSCOpacity;
  var _scale = Pref.fullScreenSCScale;

  final _randomSC = SuperChatItem.random;
  late ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      landscapeLeftMode();
    } else if (Platform.isIOS) {
      landscapeRightMode();
    }
  }

  @override
  void dispose() {
    if (PlatformUtils.isMobile) {
      if (Pref.horizontalScreen) {
        fullMode();
      } else {
        portraitUpMode();
      }
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorScheme = ColorScheme.of(context);
  }

  void _onReset() {
    _scale = 1.0;
    _opacity = 1.0;
    _enable = true;
    _width = kFullScreenSCWidth;
    GStorage.setting.deleteAll({
      SettingBoxKey.enableFullScreenSC,
      SettingBoxKey.fullScreenSCWidth,
      SettingBoxKey.fullScreenSCOpacity,
      SettingBoxKey.fullScreenSCScale,
    });
    setState(() {});
  }

  void _onEnableChanged([_]) {
    _enable = !_enable;
    setState(() {});
    GStorage.setting.put(SettingBoxKey.enableFullScreenSC, _enable);
  }

  void _onOpacityChanged(double value) {
    _opacity = value.toPrecision(2);
    setState(() {});
  }

  void _onOpacityChangeEnd(double value) {
    GStorage.setting.put(SettingBoxKey.fullScreenSCOpacity, _opacity);
  }

  void _onScaleChanged(double value) {
    _scale = value.toPrecision(2);
    setState(() {});
  }

  void _onScaleChangeEnd(double value) {
    GStorage.setting.put(SettingBoxKey.fullScreenSCScale, _scale);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('全屏 SuperChat 设置'),
            Transform.scale(
              scale: 0.8,
              alignment: .centerRight,
              child: Switch(
                value: _enable,
                onChanged: _onEnableChanged,
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: _onReset, child: const Text('重置'))],
      ),
      body: SafeArea(
        top: false,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10,
            thumbSize: const WidgetStatePropertyAll(Size(4, 25)),
          ),
          child: Stack(
            children: [
              if (_enable)
                Padding(
                  padding: const .only(right: 17, left: 25, bottom: 25),
                  child: Opacity(
                    opacity: _opacity,
                    child: Transform.scale(
                      scale: _scale,
                      alignment: .bottomLeft,
                      child: _buildSC,
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Align(
                  alignment: .topRight,
                  child: Container(
                    padding: const .symmetric(horizontal: 16),
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                '不透明度: ${_opacity.toStringAsFixed(2)}',
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Slider(
                                min: 0.1,
                                max: 1.0,
                                padding: .zero,
                                value: _opacity,
                                onChanged: _onOpacityChanged,
                                onChangeEnd: _onOpacityChangeEnd,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text('缩放: ${_scale.toStringAsFixed(2)}'),
                            ),
                            Expanded(
                              flex: 7,
                              child: Slider(
                                min: 0.1,
                                max: 1.0,
                                padding: .zero,
                                value: _scale,
                                onChanged: _onScaleChanged,
                                onChangeEnd: _onScaleChangeEnd,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildSC {
    return Align(
      alignment: .bottomLeft,
      child: ExtraHitTestStack(
        clipBehavior: .none,
        children: [
          SizedBox(
            width: _width,
            child: IgnorePointer(
              child: SuperChatCard(
                item: _randomSC,
                persistentSC: true,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: -17,
            width: 34,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRight,
              child: GestureDetector(
                behavior: .opaque,
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: _colorScheme.secondaryContainer.withValues(
                      alpha: .8,
                    ),
                  ),
                  child: Icon(
                    size: 18,
                    CustomIcons.open_in_full_rotate_45,
                    color: _colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _width = math.max(25.0, _width + details.delta.dx);
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    GStorage.setting.put(SettingBoxKey.fullScreenSCWidth, _width);
  }
}
