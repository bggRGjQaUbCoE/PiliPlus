import 'package:PiliPlus/plugin/pl_player/models/double_tap_seek_layout.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DoubleTapSeekZoneSettingPage extends StatefulWidget {
  const DoubleTapSeekZoneSettingPage({super.key});

  @override
  State<DoubleTapSeekZoneSettingPage> createState() =>
      _DoubleTapSeekZoneSettingPageState();
}

class _DoubleTapSeekZoneSettingPageState
    extends State<DoubleTapSeekZoneSettingPage> {
  static const double _handleWidth = 28;

  late double _backwardPercent;
  late double _forwardPercent;
  final ValueNotifier<int> _dragRefresh = ValueNotifier<int>(0);

  DoubleTapSeekLayout get _layout => DoubleTapSeekLayout.normalize(
    backwardPercent: _backwardPercent.round(),
    forwardPercent: _forwardPercent.round(),
  );
  double get _centerPercent => 100 - _backwardPercent - _forwardPercent;
  double get _backwardFraction => _backwardPercent / 100;
  double get _centerFraction => _centerPercent / 100;
  double get _forwardFraction => _forwardPercent / 100;

  @override
  void initState() {
    super.initState();
    final layout = DoubleTapSeekLayout.normalize(
      backwardPercent: Pref.doubleTapBackwardZone,
      forwardPercent: Pref.doubleTapForwardZone,
    );
    _backwardPercent = layout.backwardPercent.toDouble();
    _forwardPercent = layout.forwardPercent.toDouble();
  }

  void _updateBackward(double nextValue) {
    final next = DoubleTapSeekLayout.clampBackwardPercentDouble(
      nextValue,
      forwardPercent: _forwardPercent,
    );
    if ((_backwardPercent - next).abs() < 0.001) {
      return;
    }
    _backwardPercent = next;
    _dragRefresh.value++;
  }

  void _updateForward(double nextValue) {
    final next = DoubleTapSeekLayout.clampForwardPercentDouble(
      nextValue,
      backwardPercent: _backwardPercent,
    );
    if ((_forwardPercent - next).abs() < 0.001) {
      return;
    }
    _forwardPercent = next;
    _dragRefresh.value++;
  }

  void _reset() {
    setState(() {
      _backwardPercent = DoubleTapSeekLayout.defaultBackwardPercent.toDouble();
      _forwardPercent = DoubleTapSeekLayout.defaultForwardPercent.toDouble();
    });
    _dragRefresh.value++;
  }

  void _save() {
    final layout = _layout;
    GStorage.setting
      ..put(SettingBoxKey.doubleTapBackwardZone, layout.backwardPercent)
      ..put(SettingBoxKey.doubleTapForwardZone, layout.forwardPercent);
    SmartDialog.showToast('双击区域已保存');
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 56),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => ValueListenableBuilder(
                      valueListenable: _dragRefresh,
                      builder: (_, _, _) => _buildPreview(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _dragRefresh,
                  builder: (_, _, _) => _buildBottomPanel(context, _layout),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    tooltip: '返回',
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '双击快进/快退区域',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(onPressed: _reset, child: const Text('重置')),
                  const SizedBox(width: 4),
                  FilledButton(onPressed: _save, child: const Text('保存')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(
    double width,
    double height,
  ) {
    final layout = _layout;
    final backwardWidth = width * _backwardFraction;
    final centerWidth = width * _centerFraction;
    final forwardWidth = width * _forwardFraction;
    final backwardHandleLeft = backwardWidth - _handleWidth / 2;
    final forwardHandleLeft = backwardWidth + centerWidth - _handleWidth / 2;
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: backwardWidth,
          child: _PreviewSection(
            color: const Color(0x332968ff),
            title: '左侧双击快退',
            subtitle: '${layout.backwardPercent}%',
            alignment: Alignment.centerLeft,
          ),
        ),
        Positioned(
          left: backwardWidth,
          top: 0,
          bottom: 0,
          width: centerWidth,
          child: _PreviewSection(
            color: const Color(0x22111111),
            title: '中间播放/暂停',
            subtitle: '${layout.centerPercent}%',
            alignment: Alignment.center,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: forwardWidth,
          child: _PreviewSection(
            color: const Color(0x33ff7a00),
            title: '右侧双击快进',
            subtitle: '${layout.forwardPercent}%',
            alignment: Alignment.centerRight,
          ),
        ),
        Positioned(
          left: backwardHandleLeft,
          top: 0,
          bottom: 0,
          child: _PreviewHandle(
            label: '快退',
            onHorizontalDragUpdate: (details) {
              if (width <= 0) {
                return;
              }
              _updateBackward(
                _backwardPercent + details.delta.dx / width * 100,
              );
            },
          ),
        ),
        Positioned(
          left: forwardHandleLeft,
          top: 0,
          bottom: 0,
          child: _PreviewHandle(
            label: '快进',
            onHorizontalDragUpdate: (details) {
              if (width <= 0) {
                return;
              }
              _updateForward(_forwardPercent - details.delta.dx / width * 100);
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Column(
            children: [
              const Text(
                '拖动两条分隔线，实时预览双击命中范围',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                '当前预览区域高度：${height.round()} px',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPanel(BuildContext context, DoubleTapSeekLayout layout) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '拖动提示',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '左侧分隔线控制“快退区”宽度，右侧分隔线控制“快进区”宽度；左右侧支持 1%~40%，中间区域自动保留为播放/暂停。',
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PercentChip(label: '左侧', value: layout.backwardPercent),
              _PercentChip(label: '中间', value: layout.centerPercent),
              _PercentChip(label: '右侧', value: layout.forwardPercent),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dragRefresh.dispose();
    super.dispose();
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.alignment,
  });

  final Color color;
  final String title;
  final String subtitle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: alignment == Alignment.centerLeft
                ? CrossAxisAlignment.start
                : alignment == Alignment.centerRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewHandle extends StatelessWidget {
  const _PreviewHandle({
    required this.label,
    required this.onHorizontalDragUpdate,
  });

  final String label;
  final GestureDragUpdateCallback onHorizontalDragUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      child: SizedBox(
        width: _DoubleTapSeekZoneSettingPageState._handleWidth,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xDD1A1A1A),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0x44FFFFFF)),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PercentChip extends StatelessWidget {
  const _PercentChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x221A73E8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$label $value%',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
