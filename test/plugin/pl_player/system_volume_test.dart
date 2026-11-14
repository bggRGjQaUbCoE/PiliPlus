import 'package:PiliPlus/plugin/pl_player/utils/system_volume.dart';
import 'package:flutter_test/flutter_test.dart';

/// 模拟 Android 的整数刻度系统音量 + 播放器里的调音量逻辑
///
/// 原生侧走的是 `adjustStreamVolume(ADJUST_RAISE/ADJUST_LOWER)`，一次一级；
/// 回读是 `getStreamVolume() / max`。这里照抄这套规则，用来验证刻度换算、
/// 上限处理和「上滑再滑回原点刻度不变」这类手势对称性（#2134）。
class VolumeSimulator {
  VolumeSimulator({required this.index, this.steps = 15, int? maxIndex})
    : maxIndex = maxIndex ?? steps - 1,
      _actual = index / steps;

  final int steps;

  /// 系统允许的最高刻度（耳机安全音量上限就落在这里，可以被系统放开）
  int maxIndex;

  int index;

  double _actual;

  /// 手指累积的连续音量，每段滑动开头由 [beginGesture] 对齐系统刻度
  double? _gesture;

  /// 向系统发起调节的次数
  int writes = 0;

  double get actual => _actual;

  double? get gesture => _gesture;

  /// 按下手指，开始一段滑动：连续音量对齐系统当前刻度显示的百分比
  void beginGesture() {
    _gesture = volumeAnchor(volume: _actual, steps: steps);
  }

  /// 抬起手指
  void endGesture() {
    _gesture = null;
  }

  /// 相当于滑动手势里的一次 adjustVolume(delta)
  void adjust(double delta) {
    _gesture ??= volumeAnchor(volume: _actual, steps: steps);
    _gesture = (_gesture! + delta).clamp(
      volumeAnchorForIndex(0, steps),
      volumeAnchorForIndex(steps, steps),
    );
    final move = _pendingMove;
    if (move == 0) return;
    writes++;

    final requested = index + move;
    final next = requested.clamp(0, maxIndex);
    if (next != requested || next == index) {
      // 系统拒绝（上限/下限）或被上限截断：连续音量退回当前刻度的显示值，
      // 界面数值停在那一级；继续往上划还会再试
      _gesture = volumeAnchor(volume: _actual, steps: steps);
      return;
    }
    index = next;
    _actual = index / steps;
  }

  /// 连续音量当前落在第几级、和系统实际刻度差几级
  int get _pendingMove =>
      resolveVolumeIndex(
        percent: _gesture! * 100,
        steps: steps,
      ) -
      index;

  /// 连续划 [count] 次，每次 [delta]，返回划完后的系统刻度
  int drag(double delta, int count) {
    for (var i = 0; i < count; i++) {
      adjust(delta);
    }
    return index;
  }
}

void main() {
  group('刻度换算', () {
    test('系统刻度的显示值向上取整', () {
      // 15 级系统：10/15 = 66.6…%，标 67%
      expect(volumeStepLabel(10, 15), 67);
      expect(volumeStepLabel(9, 15), 60);
      expect(volumeStepLabel(11, 15), 74);
      expect(volumeStepLabel(0, 15), 0);
      expect(volumeStepLabel(15, 15), 100);
      // 30 级系统：3/30 = 10%，浮点误差不能算成 11%
      expect(volumeStepLabel(3, 30), 10);
    });

    test('连续音量落到第几级', () {
      // 到 67% 就是第 10 级，退到 66% 就回第 9 级
      expect(resolveVolumeIndex(percent: 67, steps: 15), 10);
      expect(resolveVolumeIndex(percent: 66, steps: 15), 9);
      expect(resolveVolumeIndex(percent: 73, steps: 15), 10);
      expect(resolveVolumeIndex(percent: 74, steps: 15), 11);
      expect(resolveVolumeIndex(percent: 0, steps: 15), 0);
      expect(resolveVolumeIndex(percent: 100, steps: 15), 15);
    });

    test('滑动起点落在两级正中，上下行程相同', () {
      // 15 级：第 10 级 66.6…%、下一级 73.3…%，中点向上取整 = 70%
      expect(volumeAnchor(volume: 10 / 15, steps: 15), closeTo(0.70, 1e-9));
      // 25 级：第 10 级 40%、下一级 44%，中点 42%
      expect(volumeAnchor(volume: 10 / 25, steps: 25), closeTo(0.42, 1e-9));
      // 最高一级的下一级是 106.6…%，中点向上取整 = 104%，下划仍要走半级
      expect(volumeAnchor(volume: 1, steps: 15), closeTo(1.04, 1e-9));
      // 最低一级的下一级是 6.6…%，中点向上取整 = 4%
      expect(volumeAnchor(volume: 0, steps: 15), closeTo(0.04, 1e-9));
    });
  });

  group('滑动调音量', () {
    test('上滑到下一级刻度才升一级，滑回原点落回原刻度', () {
      final simulator = VolumeSimulator(index: 10)..beginGesture();

      // 起点 70%，滑到 74% 升一级
      expect(simulator.drag(0.005, 8), 11);
      // 往回滑到 67% 以下才降级，落回原来的刻度
      expect(simulator.drag(-0.005, 8), 10);
      expect(simulator.actual, closeTo(10 / 15, 1e-9));
    });

    test('起点的上下行程相同，方向不影响触发距离', () {
      final up = VolumeSimulator(index: 10)..beginGesture();
      final down = VolumeSimulator(index: 10)..beginGesture();

      // 70% 起算：上 4% 到 74% 升一级，下 4% 到 66% 降一级
      expect(up.drag(0.005, 8), 11);
      expect(down.drag(-0.005, 8), 9);
    });

    test('不足半级刻度的滑动不改系统音量', () {
      final simulator = VolumeSimulator(index: 10)..beginGesture();

      expect(simulator.drag(0.005, 7), 10);
      expect(simulator.drag(0.005, 1), 11);
    });

    test('最高一级往下滑也要走完半级才降级', () {
      final simulator = VolumeSimulator(index: 15)..beginGesture();
      // 起点 104%，回到 100% 仍是最高一级
      expect(simulator.drag(-0.005, 8), 15);
      expect(simulator.drag(-0.005, 1), 14);
    });

    test('松手后重新滑动，同样的行程落回原来的刻度', () {
      final simulator = VolumeSimulator(index: 10)..beginGesture();

      expect(simulator.drag(0.005, 8), 11);
      simulator
        ..endGesture()
        ..beginGesture();
      // 第 11 级 73.3…%、第 12 级 80%，起点回到 77%，回滑 4% 落回第 10 级
      expect(simulator.drag(-0.005, 8), 10);
    });

    test('同样的滑动距离，快滑和慢滑结果一致', () {
      final fast = VolumeSimulator(index: 10)
        ..beginGesture()
        ..adjust(0.2);
      final slow = VolumeSimulator(index: 10)..beginGesture();
      // 慢滑分 20 帧，每帧 1%
      for (var i = 0; i < 20; i++) {
        slow.adjust(0.01);
      }

      expect(fast.index, slow.index);
    });

    test('25 级刻度按自己的一级推进', () {
      final simulator = VolumeSimulator(index: 10, steps: 25)..beginGesture();

      // 起点 42%，第 11 级标 44%
      expect(simulator.drag(0.01, 1), 10);
      expect(simulator.drag(0.01, 1), 11);
    });

    // 上限锁在哪一级跟机型、耳机、系统版本都有关，这里拿几个不同位置当样例：
    // 不是只针对某个固定比例生效
    for (final cap in [4, 9, 12]) {
      test('系统上限锁在第 $cap 级时不会空涨，反向能正常降下来', () {
        final simulator = VolumeSimulator(index: cap, maxIndex: cap)
          ..beginGesture();

        expect(simulator.drag(0.01, 40), cap);
        expect(simulator.actual, closeTo(cap / 15, 1e-9));
        // 连续音量不会被系统顶着一路涨上去，最多再攒一级
        expect(
          simulator.gesture,
          lessThanOrEqualTo(
            volumeAnchor(volume: simulator.actual, steps: 15) + 1 / 15 + 1e-9,
          ),
        );
        // 但还会继续尝试（用户可能在系统弹窗里点了允许）
        final writes = simulator.writes;
        expect(simulator.drag(0.01, 20), cap);
        expect(simulator.writes, greaterThan(writes));

        simulator
          ..endGesture()
          ..beginGesture();
        expect(simulator.drag(-0.01, 10), lessThan(cap));
      });
    }

    test('系统上限放开后继续上滑能接着涨', () {
      final simulator = VolumeSimulator(index: 9, maxIndex: 9)..beginGesture();
      expect(simulator.drag(0.01, 20), 9);

      // 用户在系统提示里点了「允许」，上限放开
      simulator.maxIndex = 14;
      expect(simulator.drag(0.01, 20), greaterThan(9));
    });
  });
}
