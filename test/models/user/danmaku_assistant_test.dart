import 'package:PiliPlus/models/user/danmaku_assistant.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final defaults = DanmakuAssistantConfig.defaults();
  final config = defaults.copyWith(
    absoluteRules: const ['测试屏蔽词'],
    gentleRules: const ['text', '考古'],
    blockDateStamps: true,
    blockTimeStamps: true,
    blockPeopleCounts: true,
  );

  test('all filters are opt-in by default', () {
    expect(defaults.absoluteRules, isEmpty);
    expect(defaults.gentleRules, isEmpty);
    expect(defaults.blockDateStamps, isFalse);
    expect(defaults.blockTimeStamps, isFalse);
    expect(defaults.blockPeopleCounts, isFalse);
    expect(defaults.blockShortCheckIns, isFalse);
  });

  group('danmaku assistant matching', () {
    const cases = <(String, bool)>[
      ('10月1日 1000人', true),
      ('12:00 1000人', true),
      ('1000人', true),
      ('2009年9月9日9时9分', true),
      ('2025.8探访古迹', true),
      ('包含测试屏蔽词的弹幕', true),
      ('考古', true),
      ('考古现场很有意思', false),
      ('今天有1000人来看这个视频', false),
      ('这个视频在2009年9月9日发布', false),
      ('12:00开始播放正片', false),
    ];

    for (final (text, expectedBlocked) in cases) {
      test(text, () {
        expect(config.match(text) != null, expectedBlocked);
      });
    }
  });

  test('short check-ins follow their dedicated switch', () {
    const text = '2026年前来考古';
    expect(defaults.match(text), isNull);
    expect(
      defaults.copyWith(blockShortCheckIns: true).match(text),
      isNotNull,
    );
  });

  test('gentle rules only ignore leading and trailing whitespace', () {
    final gentle = defaults.copyWith(gentleRules: const ['text']);
    expect(gentle.match(' text '), isNotNull);
    expect(gentle.match('TEXT'), isNull);
    expect(gentle.match('te xt'), isNull);
    expect(gentle.match('text message'), isNull);
  });

  test('storage round trip preserves settings', () {
    final custom = defaults.copyWith(
      absoluteRules: const ['foo'],
      gentleRules: const ['bar'],
      blockDateStamps: false,
      blockShortCheckIns: true,
    );

    final restored = DanmakuAssistantConfig.fromStorage(custom.toStorage());
    expect(restored.absoluteRules, ['foo']);
    expect(restored.gentleRules, ['bar']);
    expect(restored.blockDateStamps, isFalse);
    expect(restored.blockTimeStamps, isFalse);
    expect(restored.blockPeopleCounts, isFalse);
    expect(restored.blockShortCheckIns, isTrue);
  });
}
