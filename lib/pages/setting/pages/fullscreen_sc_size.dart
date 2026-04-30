import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/extra_hittest_stack.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';

const kFullScreenSCWidth = 255.0;

class FullScreenScSize extends StatefulWidget {
  const FullScreenScSize({super.key});

  @override
  State<FullScreenScSize> createState() => _FullScreenScSizeState();
}

class _FullScreenScSizeState extends State<FullScreenScSize> {
  double _width = Pref.fullScreenSCWidth;
  final _randomSC = SuperChatItem.random;
  late EdgeInsets _padding;
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
    final padding = MediaQuery.viewPaddingOf(context);
    _padding = .only(
      right: padding.right + 17,
      left: padding.left + 25,
      bottom: padding.bottom + 25,
    );
    _colorScheme = ColorScheme.of(context);
  }

  void _onReset() {
    _width = kFullScreenSCWidth;
    GStorage.setting.delete(SettingBoxKey.fullScreenSCWidth);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('全屏 SC 大小设置'),
        actions: [
          TextButton(onPressed: _onReset, child: const Text('重置')),
        ],
      ),
      body: Padding(padding: _padding, child: _buildBody),
    );
  }

  Widget get _buildBody {
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
                  child: Transform.rotate(
                    angle: math.pi / 4,
                    child: Icon(
                      size: 18,
                      Icons.open_in_full,
                      color: _colorScheme.onSecondaryContainer,
                    ),
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
