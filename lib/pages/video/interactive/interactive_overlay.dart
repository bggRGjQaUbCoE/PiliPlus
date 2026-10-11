import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/pages/video/interactive/hotspot_choices.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/question.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_coordinator.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_layout.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_session.dart'
    show NodePlan;
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 画面真实显示矩形（考虑 videoFit 造成的黑边）。
///
/// 互动视频的选项坐标与底部按钮都以「视频画面」为参照系，而不是播放器控件
/// 区域，故 type=1/type=2 都用它做定位基准。
Rect _videoRect(PlPlayerController controller, Size area) {
  final int? vw = controller.width;
  final int? vh = controller.height;
  if (vw == null || vh == null || vw <= 0 || vh <= 0) {
    return Offset.zero & area;
  }
  final FittedSizes fitted = applyBoxFit(
    controller.videoFit.value.boxFit,
    Size(vw.toDouble(), vh.toDouble()),
    area,
  );
  return Alignment.center.inscribe(fitted.destination, Offset.zero & area);
}

/// 互动视频（Stein Gate）浮层。
///
/// 只消费 [InteractiveCoordinator] 暴露的 Rx 状态，不修改任何业务状态；
/// 选项点击一律走 `coordinator.selectChoice`，由 coordinator 保证事务性。
class SteinOverlay extends StatefulWidget {
  const SteinOverlay({
    super.key,
    required this.coordinator,
    required this.plPlayerController,
  });

  final InteractiveCoordinator coordinator;
  final PlPlayerController plPlayerController;

  @override
  State<SteinOverlay> createState() => _SteinOverlayState();
}

class _SteinOverlayState extends State<SteinOverlay> {
  bool _panelOpen = false;

  void _openPanel() {
    widget.plPlayerController.pause();
    setState(() => _panelOpen = true);
  }

  void _closePanel() {
    setState(() => _panelOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final InteractiveCoordinator coordinator = widget.coordinator;
      final SteinUiState state = coordinator.uiState.value;
      final bool visible = coordinator.overlayVisible.value;
      // 播放器控件显隐：互动浮层必须跟着让位（否则盖住返回按钮/进度条）。
      final bool controlsVisible =
          widget.plPlayerController.showControls.value;

      final Widget? layer = switch (state) {
        SteinQuestion(:final NodePlan plan) when visible => _QuestionLayer(
          coordinator: coordinator,
          plan: plan,
          plPlayerController: widget.plPlayerController,
          controlsVisible: controlsVisible,
        ),
        SteinLeaf() when visible => _LeafLayer(coordinator: coordinator),
        SteinError(:final String message) when visible => _ErrorLayer(
          coordinator: coordinator,
          message: message,
        ),
        // idle / loading / autoWaiting：不展示选项浮层
        _ => null,
      };

      final bool showEntry = coordinator.canBacktrack && state is! SteinLoading;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          ?layer,
          if (showEntry)
            AnimatedPositioned(
              duration: kOverlayFollowDuration,
              curve: Curves.easeOut,
              top: 10,
              left: backtrackEntryLeft(controlsVisible: controlsVisible),
              child: _BacktrackEntry(onTap: _openPanel),
            ),
          if (_panelOpen)
            Positioned.fill(
              child: _BacktrackPanel(
                coordinator: coordinator,
                onClose: _closePanel,
              ),
            ),
        ],
      );
    });
  }
}

/// 问题层：按 question.type 选择底部按钮 / 坐标热点，并展示倒计时。
class _QuestionLayer extends StatelessWidget {
  const _QuestionLayer({
    required this.coordinator,
    required this.plPlayerController,
    required this.plan,
    required this.controlsVisible,
  });

  final InteractiveCoordinator coordinator;
  final PlPlayerController plPlayerController;
  final NodePlan plan;
  final bool controlsVisible;

  @override
  Widget build(BuildContext context) {
    final Question? question = plan.question;
    final List<Choice> choices = plan.visibleChoices;
    if (choices.isEmpty) {
      return const SizedBox.shrink();
    }

    final Widget body = question?.isHotspotType == true
        ? _HotspotChoices(
            coordinator: coordinator,
            plan: plan,
            plPlayerController: plPlayerController,
            controlsVisible: controlsVisible,
          )
        : _BottomChoices(
            coordinator: coordinator,
            plan: plan,
            plPlayerController: plPlayerController,
            controlsVisible: controlsVisible,
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _FadeIn(duration: question?.fadeIn, child: body),
        if (question?.countdown != null)
          AnimatedPositioned(
            duration: kOverlayFollowDuration,
            curve: Curves.easeOut,
            top: countdownChipTop(controlsVisible: controlsVisible),
            right: 12,
            child: _CountdownChip(coordinator: coordinator),
          ),
      ],
    );
  }
}

/// 底部选项模式（question.type == 1），还原官方「两列深色半透明按钮」样式。
class _BottomChoices extends StatelessWidget {
  const _BottomChoices({
    required this.coordinator,
    required this.plan,
    required this.plPlayerController,
    required this.controlsVisible,
  });

  final InteractiveCoordinator coordinator;
  final NodePlan plan;
  final PlPlayerController plPlayerController;
  final bool controlsVisible;

  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = plan.visibleChoices;
    // 官方布局：多个选项时两列排布（A/B 一行，C/D 一行）。
    final int columns = choices.length >= 2 ? 2 : 1;
    const double gutter = 6;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size area = Size(constraints.maxWidth, constraints.maxHeight);
        final Rect rect = _videoRect(plPlayerController, area);
        final double usable = rect.width * 0.94;
        final double itemWidth = columns == 1 ? usable : (usable - gutter) / 2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: kOverlayFollowDuration,
              curve: Curves.easeOut,
              left: rect.left + (rect.width - usable) / 2,
              bottom: bottomChoicesOffset(
                areaHeight: area.height,
                videoRect: rect,
                controlsVisible: controlsVisible,
              ),
              width: usable,
              child: Wrap(
                spacing: gutter,
                runSpacing: gutter,
                children: choices.map((Choice choice) {
                  return SizedBox(
                    width: itemWidth,
                    child: _ChoiceButton(
                      text: choice.option ?? choice.title ?? '选项',
                      onTap: () => coordinator.selectChoice(choice),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 单个选项按钮：深色半透明底 + 细白边 + 白色居中文字（同官方观感）。
class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.38),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 坐标定点模式（question.type == 2）：接口 x/y 为原始视频像素坐标，
/// y 以视频底边为原点；外观跟随服务端 skin（无底板透明白字）。
class _HotspotChoices extends StatelessWidget {
  const _HotspotChoices({
    required this.coordinator,
    required this.plPlayerController,
    required this.plan,
    required this.controlsVisible,
  });

  final InteractiveCoordinator coordinator;
  final PlPlayerController plPlayerController;
  final NodePlan plan;
  final bool controlsVisible;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size area = Size(constraints.maxWidth, constraints.maxHeight);
        final Rect rect = _videoRect(plPlayerController, area);
        final int? width = plan.node.edges?.dimension?.displayWidth;
        final int? height = plan.node.edges?.dimension?.displayHeight;
        return InteractiveHotspotChoices(
          choices: plan.visibleChoices,
          videoRect: rect,
          sourceSize: Size(width?.toDouble() ?? 0, height?.toDouble() ?? 0),
          skin: plan.node.edges?.skin,
          onSelected: coordinator.selectChoice,
          fallback: _BottomChoices(
            coordinator: coordinator,
            plan: plan,
            plPlayerController: plPlayerController,
            controlsVisible: controlsVisible,
          ),
        );
      },
    );
  }
}

/// 倒计时（question.duration > 0 时展示，结束由 coordinator 提交默认项）。
class _CountdownChip extends StatelessWidget {
  const _CountdownChip({required this.coordinator});

  final InteractiveCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Obx(() {
        final int ms = coordinator.countdownMs.value;
        final int seconds = (ms / 1000).ceil().clamp(0, 1 << 30);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, size: 16),
            const SizedBox(width: 4),
            Text('${seconds}s'),
          ],
        );
      }),
    );
  }
}

/// 进度回溯入口（issue #2419）。
class _BacktrackEntry extends StatelessWidget {
  const _BacktrackEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 17, color: Colors.white),
              SizedBox(width: 5),
              Text(
                '进度回溯',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 进度回溯面板：章节缩略图条 + 进度圆点 + 重播。
class _BacktrackPanel extends StatelessWidget {
  const _BacktrackPanel({required this.coordinator, required this.onClose});

  final InteractiveCoordinator coordinator;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.86),
      child: Obx(() {
        final List<InteractiveCheckpoint> list = coordinator.history.toList();
        final int current = list.length - 1;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
              child: Row(
                children: [
                  const Text(
                    '进度回溯',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: coordinator.restart,
                    tooltip: '重播',
                    icon: const Icon(
                      Icons.replay,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    tooltip: '关闭',
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final InteractiveCheckpoint cp = list[index];
                  return _ChapterCard(
                    checkpoint: cp,
                    isCurrent: index == current,
                    onTap: index == current
                        ? null
                        : () {
                            onClose();
                            coordinator.backtrackTo(index);
                          },
                  );
                },
              ),
            ),
            _ProgressDots(count: list.length, current: current),
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }
}

/// 单个章节卡：封面缩略图 + 标题，当前章节高亮。
class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.checkpoint,
    required this.isCurrent,
    required this.onTap,
  });

  final InteractiveCheckpoint checkpoint;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String? cover = checkpoint.cover;
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFF00AEEC)
                          : Colors.white.withValues(alpha: 0.15),
                      width: isCurrent ? 1.5 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: cover == null || cover.trim().isEmpty
                      ? const _CoverPlaceholder()
                      : NetworkImgLayer(
                          src: cover.trim(),
                          width: 148,
                          height: 83.25,
                          quality: 100,
                          // 分P截图可能不存在（404），退回占位图标。
                          getPlaceHolder: () => const _CoverPlaceholder(),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      checkpoint.title ?? '第${checkpoint.edgeId ?? '?'}节',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isCurrent
                            ? const Color(0xFF00AEEC)
                            : Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (isCurrent)
                    const Icon(
                      Icons.play_circle_fill,
                      size: 14,
                      color: Color(0xFF00AEEC),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.movie_outlined, size: 20, color: Colors.white24),
    );
  }
}

/// 进度圆点：走过的节点打勾，当前节点用定位针（同官方观感）。
class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < count; i++) {
      if (i > 0) {
        children.add(
          Container(
            width: 14,
            height: 1,
            color: Colors.white.withValues(alpha: 0.25),
          ),
        );
      }
      final bool isCurrent = i == current;
      children.add(
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? Colors.white : Colors.black54,
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: Icon(
            isCurrent ? Icons.place : Icons.check,
            size: 13,
            color: isCurrent ? Colors.black87 : Colors.white,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: children),
    );
  }
}

/// 结束模块。
class _LeafLayer extends StatelessWidget {
  const _LeafLayer({required this.coordinator});

  final InteractiveCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('互动视频已结束'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: coordinator.restart,
                  child: const Text('重新体验'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 失败态（可重试）。
class _ErrorLayer extends StatelessWidget {
  const _ErrorLayer({required this.coordinator, required this.message});

  final InteractiveCoordinator coordinator;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: coordinator.retry,
              child: const Text('重试'),
            ),
            if (kDebugMode) _DebugLog(coordinator: coordinator),
          ],
        ),
      ),
    );
  }
}

/// Debug 模式下的变量诊断日志（帮助定位「带变量的互动视频」的条件/动作失败）。
class _DebugLog extends StatelessWidget {
  const _DebugLog({required this.coordinator});

  final InteractiveCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    final List<String> log = coordinator.session.debugLog;
    if (log.isEmpty) {
      return const SizedBox.shrink();
    }
    final String text = log.length > 8
        ? '…\n${log.sublist(log.length - 8).join('\n')}'
        : log.join('\n');
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.orangeAccent),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface.withValues(alpha: 0.78),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: colorScheme.onSurface),
          child: child,
        ),
      ),
    );
  }
}

/// 淡入动画（question.fade_in_time），无时长时退化为直接显示。
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.duration, required this.child});

  final Duration? duration;
  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctr = AnimationController(
    vsync: this,
    duration: _duration,
  );

  Duration get _duration => (widget.duration?.inMilliseconds ?? 0) > 0
      ? widget.duration!
      : const Duration(milliseconds: 1);

  @override
  void initState() {
    super.initState();
    _ctr.forward();
  }

  @override
  void didUpdateWidget(covariant _FadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        !identical(oldWidget.child, widget.child)) {
      _ctr.duration = _duration;
      _ctr.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctr, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}
