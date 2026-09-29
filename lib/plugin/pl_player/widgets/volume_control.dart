import 'dart:async' show StreamSubscription;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 桌面底部控制栏音量控件：
/// 默认只显示音量按钮，点击后展开音量滑块，再次点击收起；
/// 右键按钮可静音 / 取消静音（也会同步 isMuted，M 键行为保持一致）。
class VolumeControl extends StatefulWidget {
  const VolumeControl({
    super.key,
    required this.plPlayerController,
    required this.width,
  });

  final PlPlayerController plPlayerController;
  final double width;

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  StreamSubscription<bool>? _controlsSubscription;
  bool _expanded = false;
  double _lastVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _controlsSubscription = widget.plPlayerController.showControls.listen(
      (visible) {
        // 控制栏被外部强制隐藏（锁定控制栏、退出全屏等）时同步收起并释放锁
        if (!visible && _expanded) {
          widget.plPlayerController.volumePanelShowing = false;
          if (mounted) {
            setState(() => _expanded = false);
          }
        }
      },
    );
  }

  /// 滑块就地嵌在控制栏内；展开期间控制栏常驻，不参与自动隐藏
  void _togglePanel() {
    final expanded = !_expanded;
    setState(() => _expanded = expanded);
    widget.plPlayerController.volumePanelShowing = expanded;
  }

  @override
  void dispose() {
    _controlsSubscription?.cancel();
    widget.plPlayerController.volumePanelShowing = false;
    super.dispose();
  }

  void _toggleMute() {
    final ctr = widget.plPlayerController;
    final volume = ctr.volume.value;
    if (volume > 0) {
      _lastVolume = volume;
      ctr
        ..setVolume(0)
        ..isMuted = true;
    } else {
      ctr
        ..setVolume(_lastVolume > 0 ? _lastVolume : 1.0)
        ..isMuted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctr = widget.plPlayerController;
    return Obx(
      () {
        final volume = ctr.volume.value;
        final maxVolume = ctr.maxVolume;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ComBtn(
              width: widget.width,
              height: 30,
              tooltip: _expanded ? '收起音量（右键静音）' : '音量（右键静音）',
              icon: Icon(
                volume <= 0
                    ? Icons.volume_off
                    : volume / maxVolume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
                size: 24,
                color: Colors.white,
              ),
              onTap: _togglePanel,
              onSecondaryTap: _toggleMute,
            ),
            if (_expanded)
              SizedBox(
                width: 76,
                height: 30,
                child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 2.5,
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white38,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                  ),
                  child: Slider(
                    value: volume.clamp(0.0, maxVolume).toDouble(),
                    max: maxVolume,
                    onChanged: (value) {
                      ctr
                        ..setVolume(value)
                        ..isMuted = value == 0;
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
