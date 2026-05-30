import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReplyController comment shielding', () {
    late ShieldSettingsStore store;

    setUp(() async {
      store = ShieldSettingsStore(box: _MemoryBox());
      await store.clear();
    });

    tearDown(() async {
      await store.clear();
    });

    test('filters nested preview replies with comment scoped rules', () async {
      await store.save(
        ShieldRuleSet(
          rules: [
            ShieldRule(
              id: 'spoiler',
              type: ShieldRuleType.keyword,
              matchMode: ShieldMatchMode.exact,
              scope: ShieldScope.comment,
              action: ShieldAction.block,
              pattern: '剧透',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
          ],
        ),
      );
      final parent = ReplyInfo(
        id: Int64(1),
        mid: Int64(1),
        content: Content(message: '正常主评论'),
        member: Member(mid: Int64(1), name: '用户A'),
        replies: [
          ReplyInfo(
            id: Int64(2),
            mid: Int64(2),
            content: Content(message: '正常子评论'),
            member: Member(mid: Int64(2), name: '用户B'),
          ),
          ReplyInfo(
            id: Int64(3),
            mid: Int64(3),
            content: Content(message: '剧透子评论'),
            member: Member(mid: Int64(3), name: '用户C'),
          ),
        ],
      );

      final visible = _ReplyController().applyShielding([parent]);

      expect(visible, [parent]);
      expect(parent.replies.map((reply) => reply.id.toInt()), [2]);
    });
  });
}

class _ReplyController extends ReplyController<MainListReply> {
  @override
  Object get sourceId => 1;

  @override
  Future<LoadingState<MainListReply>> customGetData() {
    throw UnimplementedError();
  }
}

class _MemoryBox implements ShieldSettingsBox {
  final values = <String, Object?>{};

  @override
  Object? get(String key, {Object? defaultValue}) =>
      values.containsKey(key) ? values[key] : defaultValue;

  @override
  Future<void> put(String key, Object? value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}
