import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:flutter_test/flutter_test.dart';

/// 构造播放数据。[acceptQuality] 对应接口 accept_quality（降序），
/// [available] 对应 dash.video 实际可用的画质流（降序，首个即最高可用档）。
PlayUrlModel _model({
  required List<int> acceptQuality,
  required List<int> available,
}) {
  return PlayUrlModel(
    acceptQuality: acceptQuality,
    dash: Dash(
      video: [
        for (final id in available)
          VideoItem(id: id, quality: VideoQuality.fromCode(id)),
      ],
    ),
  );
}

/// 常见 accept_quality：包含 8K/HDR 等会员档，实际可用档通常更低。
const _fullAccept = <int>[127, 125, 120, 116, 112, 80, 74, 64, 32, 16];

PlayUrlModel _commonModel({required List<int> available}) =>
    _model(acceptQuality: _fullAccept, available: available);

extension on PlayUrlModel {
  int select(int preferred, {Set<int> blocked = const {}}) =>
      findAvailableVideoQuality(preferred, blockedQualities: blocked);
}

void main() {
  group('findAvailableVideoQuality · 屏蔽列表为空时与旧版一致', () {
    test('首选不高于最高可用档时取不超过首选的最高档', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(112), 112);
      expect(model.select(80), 80);
      expect(model.select(116), 116);
    });

    test('首选高于最高可用档时取最高可用档', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(127), 116);
      expect(model.select(120), 116);
    });

    test('每个首选档位下，不传屏蔽集与传空集结果一致', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      for (final qa in const [127, 120, 116, 112, 80, 64, 6]) {
        expect(
          model.findAvailableVideoQuality(qa),
          model.findAvailableVideoQuality(qa, blockedQualities: const {}),
          reason: 'preferred=$qa',
        );
      }
    });

    test('acceptQuality 为 null 时返回最高可用档', () {
      final model = _model(
        acceptQuality: const [],
        available: const [116, 112, 80],
      )..acceptQuality = null;
      expect(model.select(127), 116);
      expect(model.select(80), 116);
      expect(model.select(80, blocked: const {116}), 116);
    });
  });

  group('findAvailableVideoQuality · 屏蔽 1080P 高码率(112)', () {
    const blocked = <int>{112};

    test('A2：首选 >= 116 且视频提供 1080P60 帧时用 1080P60 帧', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(127, blocked: blocked), 116);
      expect(model.select(116, blocked: blocked), 116);
    });

    test('A3：首选为被屏蔽档时降一档到 1080P 高清', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(112, blocked: blocked), 80);
    });

    test('A4：最高可用档被屏蔽时用 1080P 高清而不是高码率', () {
      final model = _commonModel(available: const [112, 80, 64]);
      expect(model.select(127, blocked: blocked), 80);
      expect(model.select(112, blocked: blocked), 80);
    });

    test('A5：首选为 80 时不因屏蔽被升档到 1080P60 帧', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(80, blocked: blocked), 80);
    });

    test('A6：首选档没有对应流时选档不落到被屏蔽画质', () {
      // 首选 80，但实际流只有 112 与 64；accept_quality 仍含 80，
      // 因此选档仍解析到 80（未屏蔽），由兜底链路处理缺流
      final model = _commonModel(available: const [112, 64]);
      expect(model.select(80, blocked: blocked), 80);
    });
  });

  group('fallbackVideo · 兜底视频流', () {
    test('A6：目标画质无对应流时兜底不是被屏蔽画质', () {
      final model = _commonModel(available: const [112, 64]);
      expect(
        model.fallbackVideo(blockedQualities: const {112}).id,
        64,
      );
    });

    test('兜底取首个未被屏蔽的可用流', () {
      final model = _commonModel(available: const [116, 112, 80]);
      expect(model.fallbackVideo(blockedQualities: const {112}).id, 116);
      expect(model.fallbackVideo(blockedQualities: const {116}).id, 112);
      expect(model.fallbackVideo().id, 116);
    });

    test('可用流全部被屏蔽时退回首个流（不中断播放）', () {
      final model = _commonModel(available: const [112, 80]);
      expect(
        model.fallbackVideo(blockedQualities: const {112, 80}).id,
        112,
      );
    });
  });

  group('findAvailableVideoQuality · 多档同屏蔽', () {
    test('A9：同时屏蔽 112 与 116 时选到 80', () {
      final model = _commonModel(available: const [116, 112, 80, 64]);
      expect(model.select(116, blocked: const {112, 116}), 80);
      expect(model.select(127, blocked: const {112, 116}), 80);
    });

    test('A9：80 也不在实际流中时，选档仍由 accept_quality 解析到 80', () {
      final model = _commonModel(available: const [116, 112, 74]);
      expect(model.select(116, blocked: const {112, 116}), 80);
      expect(model.fallbackVideo(blockedQualities: const {116}).id, 112);
    });
  });

  group('findAvailableVideoQuality · 无候选兜底', () {
    test('A7：候选集剔除被屏蔽项后为空时退回旧版结果', () {
      final only80 = _model(acceptQuality: const [80], available: const [80]);
      expect(only80.select(80, blocked: const {80}), 80);

      final only127 = _model(
        acceptQuality: const [127],
        available: const [127],
      );
      expect(only127.select(127, blocked: const {127}), 127);
    });

    test('A7：最高可用档被屏蔽且没有更低未屏蔽档时退回最高可用档', () {
      final model = _model(
        acceptQuality: const [127, 112],
        available: const [112],
      );
      expect(model.select(127, blocked: const {112}), 112);
    });

    test('A7：屏蔽全部候选时不会抛异常', () {
      final model = _model(
        acceptQuality: const [127, 116, 112, 80],
        available: const [112, 80],
      );
      const all = <int>{129, 127, 126, 125, 120, 116, 112, 80, 74, 64, 32, 16, 6};
      for (final qa in const [127, 116, 112, 80, 6]) {
        expect(
          () => model.select(qa, blocked: all),
          returnsNormally,
          reason: 'preferred=$qa',
        );
      }
      expect(model.select(80, blocked: all), 80);
    });
  });

  group('findAvailableVideoQuality · 边界', () {
    test('acceptQuality 为空列表时返回最高可用档而不是抛异常', () {
      final model = _model(
        acceptQuality: const [],
        available: const [116, 80],
      );
      expect(model.select(80), 116);
      // accept_quality 为空时没有候选可换档，退回最高可用档（播放不中断优先）
      expect(model.select(80, blocked: const {116}), 116);
      expect(model.select(80, blocked: const {80}), 116);
    });
  });
}
