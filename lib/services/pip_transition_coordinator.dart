import 'dart:async';
import 'dart:math' show min;

import 'package:flutter/animation.dart' show Curve, Curves;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show Offset, Rect, Size;
import 'package:flutter/scheduler.dart';

/// 应用内小窗生命周期相位。
/// hidden: 无小窗;entering: 收起动画中;active: 活跃(可拖动/可交互);
/// restoring: 归位动画中(展开)。
enum PipPhase { hidden, entering, active, restoring }

/// 小窗位置与双击缩放档位的会话级记忆(应用存活期内),视频/直播小窗共用。
/// 每次 startPip 都会重建 OverlayEntry 与窗体 State,不存这里的话
/// 新会话总是回到默认右下角。
class PipWindowMemory {
  PipWindowMemory._();

  /// 上次摆放的窗口左上角(全局坐标);恢复时按当前屏幕钳回界内
  static Offset? position;
  static double scale = 1.0;

  /// 小窗长/短边比例(所有设备档一致:200:112),竖屏上限换算用
  static const double pipAspectRatio = 200 / 112;

  /// 小窗默认长边基准(未乘缩放档位),按当前窗口短边分档:手机(短边<600)
  /// 维持现状 200、平板 260、大平板/桌面 300。取短边而非物理屏幕,桌面窗口
  /// 缩小 / 平板左右分屏时随之回落到较低档。长短边比保持 200:112(≈16:9),
  /// 双击缩放档位仍乘在此之上;极端窄窗口下的越界由窗体位置钳制兜底。
  static double basePipLong(Size screen) {
    final shortest = min(screen.width, screen.height);
    if (shortest < 600) return 200;
    if (shortest < 840) return 260;
    return 300;
  }

  static double basePipShort(Size screen) => basePipLong(screen) * 112 / 200;

  /// 连续缩放(捏合/滚轮)与双击档位共用的合法区间:下限保证长边 ≥140dp
  /// (控件可点)。上限按视频方向分流:
  /// - 横屏视频:长边 ≤ 0.95×屏幕短边(旋转安全,不随方向变化);
  /// - 竖屏视频:长边(高) ≤ factor×min(屏高, 屏宽×宽高比),其中 factor
  ///   在竖屏屏上取 0.8(竖屏小窗铺在竖屏上会占满屏宽,留边距不贴满),
  ///   横屏屏上取 0.95(竖屏小窗靠边放是自然组合,保持宽松上限)。
  /// 把 [scale] 钳入该区间返回;旋转后上限变小(竖屏屏拉大后转横屏)由
  /// 窗体 build 按新屏幕重新钳制自动缩小。
  static double clampScaleContinuous(
    double scale,
    Size screen, {
    required bool isVertical,
  }) {
    final base = basePipLong(screen);
    final minScale = 140 / base;
    final double maxScale = (isVertical
            ? min(screen.height, screen.width * pipAspectRatio) *
                (screen.width < screen.height ? 0.8 : 0.95)
            : min(screen.width, screen.height) * 0.95) /
        base;
    if (maxScale <= minScale) return minScale;
    return scale.clamp(minScale, maxScale);
  }
}

/// 应用内小窗过渡动画协调器(视频/直播小窗各持一实例)。
///
/// 只管理相位、源/目标矩形与恢复握手,不持有 overlay 或控制器引用——
/// 与挂载方式(OverlayEntry / 常驻 Host)无关,便于后续生命周期重构时整体迁移。
///
/// 恢复握手(展开的完成条件):归位动画播完 且 恢复页面就绪(上报目标矩形),
/// 二者齐备才回调 [onRestoreFinished] 让宿主 service 关闭 overlay,
/// 同时回调页面的 onCompleted 亮出页内播放器,保证无黑屏窗口期。
class PipTransitionCoordinator extends ChangeNotifier {
  /// 收起/归位动画时长,与路由转场同步
  static const Duration animDuration = Duration(milliseconds: 300);

  /// X 关闭的缩小淡出时长
  static const Duration closeFadeDuration = Duration(milliseconds: 180);

  static const Curve animCurve = Curves.easeOutCubic;

  /// 归位后页面迟迟未上报(路由被拦截/页面构建异常)的兜底时限
  static const Duration _restoreAttachTimeout = Duration(seconds: 2);

  PipPhase _phase = PipPhase.hidden;
  PipPhase get phase => _phase;

  /// 收起时页面播放器的屏幕矩形;也是点击展开时目标矩形的预估值
  Rect? _sourceRect;
  Rect? get sourceRect => _sourceRect;

  /// 恢复页面上报的真实目标矩形(相对页面根 ≈ 页面落定后的全局坐标)
  Rect? _restoreTargetRect;

  VoidCallback? _onRestorePageReady;
  bool _restoreAnimationDone = false;
  Timer? _restoreTimer;

  /// 握手双条件满足时由协调器回调:宿主 service 在此移除 overlay 并清理引用
  /// (即把原本瞬时执行的非销毁式 stopPip 推迟到此刻)
  VoidCallback? onRestoreFinished;

  /// build/layout 阶段(如新页面 initState 触发的 stopPip→reset)不能同步
  /// notifyListeners——会对 overlay 里的窗体 markNeedsBuild,触发
  /// "setState during build"(与旧代码对 isNativePip 延帧处理同因)。
  /// 相位等字段本身始终同步更新,同步读取方(phase 判断/attach 防御)不受影响,
  /// 仅监听重建推迟到帧尾。
  void _notify() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  /// 小窗出现(收起开始)。sourceRect 为空时无动画,直接以活跃态出现。
  void beginEnter({Rect? sourceRect}) {
    _cancelRestoreHandshake();
    _sourceRect = sourceRect;
    _phase = sourceRect == null ? PipPhase.active : PipPhase.entering;
    _notify();
  }

  /// 收起动画播完,由窗体回调
  void markEnterDone() {
    if (_phase != PipPhase.entering) return;
    _phase = PipPhase.active;
    _notify();
  }

  /// 进入归位相位(点击展开/返回展开)。
  /// 返回 false 表示当前没有可归位的小窗(hidden),调用方走旧的瞬时路径。
  bool beginRestore() {
    switch (_phase) {
      case PipPhase.hidden:
        return false;
      case PipPhase.restoring:
        return true; // 幂等
      case PipPhase.entering:
        // 收起动画未完成就要求展开(快速往返):跳过剩余入场动画直接归位,
        // 窗口矩形会有一次跳变,属可接受的罕见路径
        _phase = PipPhase.active;
      case PipPhase.active:
        break;
    }
    _restoreAnimationDone = false;
    _onRestorePageReady = null;
    // 点击展开并行原则:动画立即以收起时的源矩形为预估目标起飞,
    // 页面就绪后经 attachRestorePage 校正
    _restoreTargetRect = _sourceRect;
    _phase = PipPhase.restoring;
    _restoreTimer?.cancel();
    _restoreTimer = Timer(_restoreAttachTimeout, _onRestoreTimeout);
    _notify();
    return true;
  }

  /// 恢复页面就绪后上报目标矩形与完成回调。
  /// targetRect 为空表示量取失败,沿用预估目标(降级为原地消失)。
  /// 若协调器已不在归位相位(超时回退/被强制关闭),立即回调,
  /// 防止页面停留在透明占位。
  void attachRestorePage({
    Rect? targetRect,
    required VoidCallback onCompleted,
  }) {
    if (_phase != PipPhase.restoring) {
      onCompleted();
      return;
    }
    _restoreTimer?.cancel();
    _restoreTimer = null;
    if (targetRect != null && targetRect != _restoreTargetRect) {
      _restoreTargetRect = targetRect;
      _notify();
    }
    _onRestorePageReady = onCompleted;
    _tryFinishRestore();
  }

  /// 归位动画播完,由窗体回调
  void markRestoreAnimationDone() {
    if (_phase != PipPhase.restoring) return;
    _restoreAnimationDone = true;
    _tryFinishRestore();
  }

  void _tryFinishRestore() {
    if (_phase != PipPhase.restoring ||
        !_restoreAnimationDone ||
        _onRestorePageReady == null) {
      return;
    }
    final pageReady = _onRestorePageReady;
    _cancelRestoreHandshake();
    _phase = PipPhase.hidden;
    // 先让宿主移除 overlay,再亮出页面播放器,同一帧内完成交接
    onRestoreFinished?.call();
    pageReady?.call();
    _notify();
  }

  void _onRestoreTimeout() {
    if (_phase != PipPhase.restoring || _onRestorePageReady != null) return;
    // 页面一直未就绪:窗口回到活跃态兜底,仍可交互,不卡死
    _cancelRestoreHandshake();
    _phase = PipPhase.active;
    _notify();
  }

  /// 小窗被瞬时关闭(X 关闭、被其他视频抢占等)时由 stopPip 调用
  void reset() {
    _cancelRestoreHandshake();
    _sourceRect = null;
    _phase = PipPhase.hidden;
    _notify();
  }

  void _cancelRestoreHandshake() {
    _restoreTimer?.cancel();
    _restoreTimer = null;
    _onRestorePageReady = null;
    _restoreAnimationDone = false;
    _restoreTargetRect = null;
  }

  /// 依据相位与动画进度解析窗口当前矩形;miniRect 为活跃态的窗口矩形
  Rect resolveRect({required Rect miniRect, required double progress}) {
    return switch (_phase) {
      PipPhase.entering => Rect.lerp(
        _sourceRect ?? miniRect,
        miniRect,
        progress,
      )!,
      PipPhase.restoring => Rect.lerp(
        miniRect,
        _restoreTargetRect ?? miniRect,
        progress,
      )!,
      _ => miniRect,
    };
  }

  /// 过渡期间圆角同步变化:收起 0→base,归位 base→0
  double resolveRadius({required double base, required double progress}) {
    return switch (_phase) {
      PipPhase.entering => base * progress,
      PipPhase.restoring => base * (1 - progress),
      _ => base,
    };
  }
}
