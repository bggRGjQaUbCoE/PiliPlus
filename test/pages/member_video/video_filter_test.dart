import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member_video/video_filter.dart';
import 'package:material_ui/material_ui.dart' show RangeValues;
import 'package:flutter_test/flutter_test.dart';

SpaceArchiveItem _item({
  required int play,
  int? progress,
  int? duration,
}) {
  return SpaceArchiveItem.fromJson({
    'title': 'test',
    'play': play,
    if (progress != null || duration != null)
      'history': {'progress': progress, 'duration': duration},
  });
}

void main() {
  group('MemberVideoFilter.shouldHide', () {
    test('no active filter hides nothing', () {
      final filter = MemberVideoFilter();
      expect(filter.hasActiveFilter, isFalse);
      expect(filter.shouldHide(_item(play: 0)), isFalse);
      expect(filter.shouldHide(_item(play: 999999999, progress: 10)), isFalse);
    });

    test('min play threshold hides lower plays (A1)', () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = true
        ..minPlay = 100000;
      expect(filter.shouldHide(_item(play: 99999)), isTrue);
      expect(filter.shouldHide(_item(play: 100000)), isFalse);
      expect(filter.shouldHide(_item(play: 100001)), isFalse);
    });

    test('max play threshold hides higher plays (A2)', () {
      final filter = MemberVideoFilter()
        ..enableMaxPlay = true
        ..maxPlay = 500000;
      expect(filter.shouldHide(_item(play: 500001)), isTrue);
      expect(filter.shouldHide(_item(play: 500000)), isFalse);
      expect(filter.shouldHide(_item(play: 499999)), isFalse);
    });

    test('min and max combine as interval', () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = true
        ..minPlay = 10000
        ..enableMaxPlay = true
        ..maxPlay = 1000000;
      expect(filter.shouldHide(_item(play: 9999)), isTrue);
      expect(filter.shouldHide(_item(play: 1000001)), isTrue);
      expect(filter.shouldHide(_item(play: 500000)), isFalse);
    });

    test('null view is not hidden by play thresholds (A17)', () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = true
        ..enableMaxPlay = true;
      // stat.view == null 时两个阈值都不隐藏
      final item = SpaceArchiveItem.fromJson({'title': 'x', 'play': null});
      expect(item.stat.view, isNull);
      expect(filter.shouldHide(item), isFalse);
    });

    test('hideCompleted hides fully watched (A3/A13)', () {
      final filter = MemberVideoFilter()..hideCompleted = true;
      expect(
        filter.shouldHide(_item(play: 1, progress: 100, duration: 100)),
        isTrue,
      );
      expect(
        filter.shouldHide(_item(play: 1, progress: 30, duration: 100)),
        isFalse,
      );
      expect(filter.shouldHide(_item(play: 1)), isFalse);
    });

    test('hideInProgress hides partially watched (A3/A14)', () {
      final filter = MemberVideoFilter()..hideInProgress = true;
      expect(
        filter.shouldHide(_item(play: 1, progress: 30, duration: 100)),
        isTrue,
      );
      expect(
        filter.shouldHide(_item(play: 1, progress: 100, duration: 100)),
        isFalse,
      );
      expect(filter.shouldHide(_item(play: 1)), isFalse);
    });

    test('both watched switches hide all watched (A15)', () {
      final filter = MemberVideoFilter()
        ..hideCompleted = true
        ..hideInProgress = true;
      expect(
        filter.shouldHide(_item(play: 1, progress: 100, duration: 100)),
        isTrue,
      );
      expect(
        filter.shouldHide(_item(play: 1, progress: 30, duration: 100)),
        isTrue,
      );
      expect(filter.shouldHide(_item(play: 1)), isFalse);
    });

    test('incomplete history data is not watched (A17)', () {
      final filter = MemberVideoFilter()
        ..hideCompleted = true
        ..hideInProgress = true;
      expect(filter.shouldHide(_item(play: 1, progress: 100)), isFalse);
      expect(filter.shouldHide(_item(play: 1, duration: 100)), isFalse);
    });

    test('reset clears all switches', () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = true
        ..enableMaxPlay = true
        ..hideCompleted = true
        ..hideInProgress = true;
      expect(filter.hasActiveFilter, isTrue);
      filter.reset();
      expect(filter.hasActiveFilter, isFalse);
      expect(filter.shouldHide(_item(play: 1, progress: 1, duration: 2)), isFalse);
    });
  });

  group('slider endpoint <-> filter mapping', () {
    test('fresh filter maps to fully-open slider endpoints (A1/A41)', () {
      final filter = MemberVideoFilter();
      final values = filter.toSliderValues();
      expect(values.start, 0.0);
      expect(values.end, MemberVideoFilter.playSliderMax.toDouble());
      expect(filter.hasActiveFilter, isFalse);
    });

    test('enabled min/max map to their values (A1/A42/A43)', () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = true
        ..minPlay = 100000
        ..enableMaxPlay = true
        ..maxPlay = 1000000;
      final values = filter.toSliderValues();
      expect(values.start, 100000.0);
      expect(values.end, 1000000.0);
    });

    test('disabled min uses slider start 0, disabled max uses slider max (A1)',
        () {
      final filter = MemberVideoFilter()
        ..enableMinPlay = false
        ..minPlay = 100000
        ..enableMaxPlay = false
        ..maxPlay = 1000000;
      final values = filter.toSliderValues();
      expect(values.start, 0.0);
      expect(values.end, MemberVideoFilter.playSliderMax.toDouble());
    });

    test('applySliderValues: start 0 disables min, end max disables max (A1/A45/A47)',
        () {
      final filter = MemberVideoFilter()
        ..applySliderValues(
          RangeValues(0.0, MemberVideoFilter.playSliderMax.toDouble()),
        );
      expect(filter.enableMinPlay, isFalse);
      expect(filter.enableMaxPlay, isFalse);
      expect(filter.hasActiveFilter, isFalse);
      // 不限制时列表不应隐藏任何视频
      expect(filter.shouldHide(_item(play: 0)), isFalse);
      expect(filter.shouldHide(_item(play: 999999999)), isFalse);
    });

    test('applySliderValues: middle interval enables both (A1/A46/A48)', () {
      final filter = MemberVideoFilter()
        ..applySliderValues(const RangeValues(100000.0, 1000000.0));
      expect(filter.enableMinPlay, isTrue);
      expect(filter.minPlay, 100000);
      expect(filter.enableMaxPlay, isTrue);
      expect(filter.maxPlay, 1000000);
      expect(filter.shouldHide(_item(play: 99999)), isTrue);
      expect(filter.shouldHide(_item(play: 1000001)), isTrue);
      expect(filter.shouldHide(_item(play: 500000)), isFalse);
    });

    test('applySliderValues: start > 0, end at max enables min only (A1)', () {
      final filter = MemberVideoFilter()
        ..applySliderValues(
          RangeValues(100000.0, MemberVideoFilter.playSliderMax.toDouble()),
        );
      expect(filter.enableMinPlay, isTrue);
      expect(filter.minPlay, 100000);
      expect(filter.enableMaxPlay, isFalse);
      expect(filter.shouldHide(_item(play: 99999)), isTrue);
      expect(filter.shouldHide(_item(play: 100000)), isFalse);
      expect(filter.shouldHide(_item(play: 999999999)), isFalse);
    });

    test('roundtrip: apply then read back yields same endpoints (A1)', () {
      final filter = MemberVideoFilter();
      const original = RangeValues(50000.0, 2000000.0);
      filter.applySliderValues(original);
      final round = filter.toSliderValues();
      expect(round.start, original.start);
      expect(round.end, original.end);
    });
  });

  group('interval clamping', () {
    test('slider onChanged keeps start <= end via RangeSlider contract (A5)',
        () {
      final filter = MemberVideoFilter()
        ..applySliderValues(const RangeValues(100000.0, 1000000.0));
      // RangeSlider 保证 thumb 不交叉；这里验证应用合法区间后语义正确
      expect(filter.minPlay, lessThanOrEqualTo(filter.maxPlay));
    });

    test('end clamped to playSliderMax when input exceeds it (A5/A53)', () {
      final filter = MemberVideoFilter()
        // 模拟输入 >500万：超出上界折为不限制上限
        ..applySliderValues(
          RangeValues(
            100000.0,
            (MemberVideoFilter.playSliderMax + 1000000).toDouble(),
          ),
        );
      // end >= max → 不启用上限
      expect(filter.enableMaxPlay, isFalse);
    });
  });
}

