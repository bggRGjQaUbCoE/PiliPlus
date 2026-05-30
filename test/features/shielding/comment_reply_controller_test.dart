import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReplyController comment shielding', () {
    test('filters nested preview replies with comment scoped rules', () {
      final ruleSet = ShieldRuleSet(
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

      final visible = _ReplyController(ruleSet).applyShielding([parent]);

      expect(visible, [parent]);
      expect(parent.replies.map((reply) => reply.id.toInt()), [2]);
    });

    test('filters first floor root reply in reply detail pages', () {
      final controller = _ReplyReplyController(
        ShieldRuleSet(
          rules: [
            ShieldRule(
              id: 'root-spoiler',
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
      final visibleRoot = ReplyInfo(
        id: Int64(1),
        mid: Int64(1),
        content: Content(message: '正常楼层'),
        member: Member(mid: Int64(1), name: '用户A'),
      );
      final blockedRoot = ReplyInfo(
        id: Int64(2),
        mid: Int64(2),
        content: Content(message: '剧透楼层'),
        member: Member(mid: Int64(2), name: '用户B'),
      );

      expect(controller.applyFirstFloorShielding(visibleRoot), visibleRoot);
      expect(controller.applyFirstFloorShielding(blockedRoot), isNull);
    });
  });
}

class _ReplyController extends ReplyController<MainListReply> {
  _ReplyController(this.ruleSet);

  final ShieldRuleSet ruleSet;

  @override
  ShieldRuleSet get shieldingRuleSet => ruleSet;

  @override
  Object get sourceId => 1;

  @override
  Future<LoadingState<MainListReply>> customGetData() {
    throw UnimplementedError();
  }
}

class _ReplyReplyController extends VideoReplyReplyController {
  _ReplyReplyController(this.ruleSet)
    : super(
        hasRoot: false,
        id: null,
        oid: 1,
        rpid: 1,
        dialog: null,
        replyType: 1,
      );

  final ShieldRuleSet ruleSet;

  @override
  ShieldRuleSet get shieldingRuleSet => ruleSet;

  @override
  void jumpToItem(int index) {}
}
