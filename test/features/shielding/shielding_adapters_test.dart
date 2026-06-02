import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShieldingAdapters', () {
    test('maps web recommendation title, owner, category, tags, and reason', () {
      final item = RcmdVideoItemModel.fromJson({
        'id': 1,
        'bvid': 'BV1',
        'cid': 2,
        'goto': 'av',
        'uri': '',
        'pic': '',
        'title': '猫咪睡觉合集',
        'duration': 60,
        'pubdate': 1,
        'owner': {'mid': 42, 'name': 'UP主'},
        'stat': {'view': 1, 'like': 1, 'danmaku': 1},
        'tname': '动物',
        'tag': ['萌宠'],
        'rcmd_reason': {'content': '因为你看过萌宠'},
      });

      final candidate = ShieldingAdapters.fromRecommendationJson(
        item,
        {
          'owner': {'mid': 42, 'name': 'UP主'},
          'tname': '动物',
          'tag': ['萌宠'],
          'rcmd_reason': {'content': '因为你看过萌宠'},
        },
      );

      expect(candidate.title, '猫咪睡觉合集');
      expect(candidate.uid, '42');
      expect(candidate.authorName, 'UP主');
      expect(candidate.reason, '因为你看过萌宠');
      expect(candidate.category, '动物');
      expect(candidate.tags, contains('萌宠'));
    });

    test('maps app recommendation args fields', () {
      final item = RcmdVideoItemAppModel.fromJson({
        'player_args': {'aid': 1, 'cid': 2, 'duration': 60},
        'bvid': 'BV1',
        'cover': '',
        'cover_left_text_1': '1',
        'cover_left_text_2': '1',
        'title': '游戏攻略',
        'args': {'up_id': 88, 'up_name': '玩家', 'tname': '游戏'},
        'rcmd_reason': '',
        'goto': 'av',
        'param': '1',
        'uri': '',
      });

      final candidate = ShieldingAdapters.fromRecommendationJson(
        item,
        {
          'args': {'up_id': 88, 'up_name': '玩家', 'tname': '游戏'},
        },
      );

      expect(candidate.title, '游戏攻略');
      expect(candidate.uid, '88');
      expect(candidate.authorName, '玩家');
      expect(candidate.category, '游戏');
      expect(candidate.reason, isNull);
    });

    test('reason keyword filters recommendation json reason only', () {
      final item = RcmdVideoItemAppModel.fromJson({
        'player_args': {'aid': 1, 'cid': 2, 'duration': 60},
        'bvid': 'BV1',
        'cover': '',
        'cover_left_text_1': '1',
        'cover_left_text_2': '1',
        'title': '正常标题',
        'args': {'up_id': 88, 'up_name': '玩家', 'tname': '游戏'},
        'rcmd_reason': '因为你看过相似内容',
        'goto': 'av',
        'param': '1',
        'uri': '',
      });

      final candidate = ShieldingAdapters.fromRecommendationJson(
        item,
        {
          'args': {'up_id': 88, 'up_name': '玩家', 'tname': '游戏'},
        },
      );

      final rules = ShieldRuleSet(
        rules: [
          ShieldRule(
            id: 'reason',
            type: ShieldRuleType.reasonKeyword,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.recommendation,
            action: ShieldAction.block,
            pattern: '相似内容',
            updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
          ),
        ],
      );

      expect(candidate.reason, '因为你看过相似内容');
      expect(ShieldingAdapters.isVisible(candidate, rules), isFalse);
    });

    test('maps comment content and member fields', () {
      final reply = ReplyInfo(
        mid: Int64(42),
        content: Content(message: '这是一条评论'),
        member: Member(mid: Int64(42), name: '评论者'),
      );

      final candidate = ShieldingAdapters.fromReplyInfo(reply);

      expect(candidate.scope, ShieldScope.comment);
      expect(candidate.body, '这是一条评论');
      expect(candidate.uid, '42');
      expect(candidate.authorName, '评论者');
    });

    test('maps related video title owner and category fields', () {
      final video = HotVideoItemModel.fromJson({
        'aid': 1,
        'cid': 2,
        'bvid': 'BV1',
        'videos': 1,
        'tid': 17,
        'tname': '单机游戏',
        'copyright': 1,
        'pic': '',
        'title': '硬核攻略',
        'pubdate': 1,
        'ctime': 1,
        'desc': '',
        'duration': 60,
        'owner': {'mid': 42, 'name': '玩家UP'},
        'stat': {'view': 1, 'like': 1, 'danmaku': 1},
      });

      final candidate = ShieldingAdapters.fromRelatedVideo(video);

      expect(candidate.scope, ShieldScope.recommendation);
      expect(candidate.title, '硬核攻略');
      expect(candidate.uid, '42');
      expect(candidate.authorName, '玩家UP');
      expect(candidate.category, '单机游戏');
      expect(candidate.tags, isEmpty);
    });

    test(
      'filterList handles all-blocked list without requesting more data',
      () {
        final visible = ShieldingAdapters.filterList(
          [1, 2, 3],
          enabled: true,
          toCandidate: (item) => ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: 'blocked-$item',
          ),
          ruleSet: ShieldRuleSet(
            rules: [
              ShieldRule(
                id: 'all',
                type: ShieldRuleType.keyword,
                matchMode: ShieldMatchMode.regex,
                scope: ShieldScope.recommendation,
                action: ShieldAction.block,
                pattern: r'blocked-\d',
                updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
              ),
            ],
          ),
        );

        expect(visible, isEmpty);
      },
    );

    test(
      'filterList preserves original list when total switch is disabled',
      () {
        final items = [1, 2, 3];
        final visible = ShieldingAdapters.filterList(
          items,
          enabled: true,
          toCandidate: (item) => ShieldCandidate(
            scope: ShieldScope.recommendation,
            title: 'blocked-$item',
          ),
          ruleSet: ShieldRuleSet(
            globalEnabled: false,
            rules: [
              ShieldRule(
                id: 'all',
                type: ShieldRuleType.keyword,
                matchMode: ShieldMatchMode.regex,
                scope: ShieldScope.recommendation,
                action: ShieldAction.block,
                pattern: r'blocked-\d',
                updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
              ),
            ],
          ),
        );

        expect(identical(visible, items), isTrue);
        expect(visible, items);
      },
    );

    test('filterList applies comment-scoped rules to reply info lists', () {
      final visibleReply = ReplyInfo(
        mid: Int64(1),
        content: Content(message: '正常评论'),
        member: Member(mid: Int64(1), name: '用户A'),
      );
      final blockedReply = ReplyInfo(
        mid: Int64(2),
        content: Content(message: '这是一条剧透评论'),
        member: Member(mid: Int64(2), name: '用户B'),
      );

      final visible = ShieldingAdapters.filterList(
        [visibleReply, blockedReply],
        enabled: true,
        ruleSet: ShieldRuleSet(
          rules: [
            ShieldRule(
              id: 'spoiler',
              type: ShieldRuleType.keyword,
              matchMode: ShieldMatchMode.regex,
              scope: ShieldScope.comment,
              action: ShieldAction.block,
              pattern: '剧透',
              updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
            ),
          ],
        ),
        toCandidate: ShieldingAdapters.fromReplyInfo,
      );

      expect(visible, [visibleReply]);
    });

    test('raw recommendation tags stay distinct from category', () {
      final item = RcmdVideoItemModel.fromJson({
        'id': 1,
        'bvid': 'BV1',
        'cid': 2,
        'goto': 'av',
        'uri': '',
        'pic': '',
        'title': '猫咪睡觉合集',
        'duration': 60,
        'pubdate': 1,
        'owner': {'mid': 42, 'name': 'UP主'},
        'stat': {'view': 1, 'like': 1, 'danmaku': 1},
        'tname': '动物',
      });

      final candidate = ShieldingAdapters.fromRecommendationJson(
        item,
        {
          'owner': {'mid': 42, 'name': 'UP主'},
          'tname': '动物',
          'tag': ['萌宠'],
        },
      );

      final rules = ShieldRuleSet(
        rules: [
          ShieldRule(
            id: 'tag-pet',
            type: ShieldRuleType.tag,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.recommendation,
            action: ShieldAction.block,
            pattern: '萌宠',
            updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
          ),
        ],
      );

      expect(candidate.category, '动物');
      expect(candidate.tags, ['萌宠']);
      expect(ShieldingAdapters.isVisible(candidate, rules), isFalse);
    });

    test(
      'filterRecommendationVideos applies category rules to video lists',
      () {
        final visibleVideo = HotVideoItemModel.fromJson({
          'aid': 1,
          'cid': 2,
          'bvid': 'BV1',
          'videos': 1,
          'tid': 17,
          'tname': '音乐',
          'copyright': 1,
          'pic': '',
          'title': '现场合集',
          'pubdate': 1,
          'ctime': 1,
          'desc': '',
          'duration': 60,
          'owner': {'mid': 42, 'name': '音乐UP'},
          'stat': {'view': 1, 'like': 1, 'danmaku': 1},
        });
        final blockedVideo = HotVideoItemModel.fromJson({
          'aid': 2,
          'cid': 3,
          'bvid': 'BV2',
          'videos': 1,
          'tid': 18,
          'tname': '游戏',
          'copyright': 1,
          'pic': '',
          'title': '攻略合集',
          'pubdate': 1,
          'ctime': 1,
          'desc': '',
          'duration': 60,
          'owner': {'mid': 88, 'name': '游戏UP'},
          'stat': {'view': 1, 'like': 1, 'danmaku': 1},
        });

        final visible = ShieldingAdapters.filterRecommendationVideos(
          [visibleVideo, blockedVideo],
          ShieldRuleSet(
            rules: [
              ShieldRule(
                id: 'tag-game',
                type: ShieldRuleType.category,
                matchMode: ShieldMatchMode.exact,
                scope: ShieldScope.recommendation,
                action: ShieldAction.block,
                pattern: '游戏',
                updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
              ),
            ],
          ),
        );

        expect(visible, [visibleVideo]);
      },
    );

    test(
      'filterRecommendationVideos bypasses rules when recommendation is off',
      () {
        final items = [
          HotVideoItemModel.fromJson({
            'aid': 1,
            'cid': 2,
            'bvid': 'BV1',
            'videos': 1,
            'tid': 17,
            'tname': '游戏',
            'copyright': 1,
            'pic': '',
            'title': '攻略合集',
            'pubdate': 1,
            'ctime': 1,
            'desc': '',
            'duration': 60,
            'owner': {'mid': 42, 'name': '游戏UP'},
            'stat': {'view': 1, 'like': 1, 'danmaku': 1},
          }),
        ];

        final visible = ShieldingAdapters.filterRecommendationVideos(
          items,
          ShieldRuleSet(
            recommendationEnabled: false,
            rules: [
              ShieldRule(
                id: 'tag-game',
                type: ShieldRuleType.category,
                matchMode: ShieldMatchMode.exact,
                scope: ShieldScope.recommendation,
                action: ShieldAction.block,
                pattern: '游戏',
                updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
              ),
            ],
          ),
        );

        expect(identical(visible, items), isTrue);
      },
    );

    test('legacy recommendation filters obey recommendation scene switch', () {
      addTearDown(() {
        RecommendFilter.minDurationForRcmd = 0;
        RecommendFilter.minPlayForRcmd = 0;
        RecommendFilter.minLikeRatioForRecommend = 0;
        RecommendFilter.exemptFilterForFollowed = false;
        RecommendFilter.applyFilterToRelatedVideos = false;
        RecommendFilter.rcmdRegExp = RegExp('', caseSensitive: false);
        RecommendFilter.enableFilter = false;
        RecommendFilter.useLegacyTextFilter = false;
        RecommendFilter.shieldRuleSetProvider = null;
      });

      RecommendFilter.minDurationForRcmd = 120;
      RecommendFilter.minPlayForRcmd = 1000;
      RecommendFilter.minLikeRatioForRecommend = 10;
      RecommendFilter.rcmdRegExp = RegExp('剧透', caseSensitive: false);
      RecommendFilter.enableFilter = true;
      RecommendFilter.useLegacyTextFilter = true;
      RecommendFilter.shieldRuleSetProvider = () => ShieldRuleSet(
        recommendationEnabled: false,
        rules: [
          ShieldRule(
            id: 'legacy-title',
            type: ShieldRuleType.keyword,
            matchMode: ShieldMatchMode.exact,
            scope: ShieldScope.recommendation,
            action: ShieldAction.block,
            pattern: '剧透',
            updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
          ),
        ],
      );

      final item = HotVideoItemModel.fromJson({
        'aid': 1,
        'cid': 2,
        'bvid': 'BV1',
        'videos': 1,
        'tid': 17,
        'tname': '游戏',
        'copyright': 1,
        'pic': '',
        'title': '剧透短视频',
        'pubdate': 1,
        'ctime': 1,
        'desc': '',
        'duration': 60,
        'owner': {'mid': 42, 'name': '游戏UP'},
        'stat': {'view': 10, 'like': 0, 'danmaku': 1},
      });

      expect(RecommendFilter.filter(item), isFalse);
      expect(RecommendFilter.filterTitle(item.title), isFalse);
      expect(RecommendFilter.filterLikeRatio(0, 10), isFalse);
    });

    test(
      'legacy title keyword path is disabled after merge into shielding',
      () {
        addTearDown(() {
          RecommendFilter.rcmdRegExp = RegExp('', caseSensitive: false);
          RecommendFilter.enableFilter = false;
          RecommendFilter.useLegacyTextFilter = false;
          RecommendFilter.shieldRuleSetProvider = null;
        });

        RecommendFilter.rcmdRegExp = RegExp('剧透', caseSensitive: false);
        RecommendFilter.enableFilter = true;
        RecommendFilter.shieldRuleSetProvider = () => ShieldRuleSet();

        expect(RecommendFilter.filterTitle('剧透短视频'), isFalse);
      },
    );

    test('legacy numeric recommendation filters stay active', () {
      addTearDown(() {
        RecommendFilter.minDurationForRcmd = 0;
        RecommendFilter.minPlayForRcmd = 0;
        RecommendFilter.minLikeRatioForRecommend = 0;
        RecommendFilter.exemptFilterForFollowed = false;
        RecommendFilter.applyFilterToRelatedVideos = false;
        RecommendFilter.shieldRuleSetProvider = null;
      });

      RecommendFilter.minDurationForRcmd = 120;
      RecommendFilter.minPlayForRcmd = 1000;
      RecommendFilter.minLikeRatioForRecommend = 10;
      RecommendFilter.shieldRuleSetProvider = () => ShieldRuleSet();

      final item = HotVideoItemModel.fromJson({
        'aid': 1,
        'cid': 2,
        'bvid': 'BV1',
        'videos': 1,
        'tid': 17,
        'tname': '游戏',
        'copyright': 1,
        'pic': '',
        'title': '正常短视频',
        'pubdate': 1,
        'ctime': 1,
        'desc': '',
        'duration': 60,
        'owner': {'mid': 42, 'name': '游戏UP'},
        'stat': {'view': 10, 'like': 0, 'danmaku': 1},
      });

      expect(RecommendFilter.filter(item), isTrue);
    });

    test('direct reply target lookup runs before comment shielding', () {
      final controller = _TargetLookupController(targetId: 42);
      final replies = [
        ReplyInfo(
          id: Int64(1),
          mid: Int64(1),
          content: Content(message: '正常评论'),
          member: Member(mid: Int64(1), name: '用户A'),
        ),
        ReplyInfo(
          id: Int64(42),
          mid: Int64(2),
          content: Content(message: '这是一条剧透评论'),
          member: Member(mid: Int64(2), name: '用户B'),
        ),
      ];

      controller.handleListResponse(replies);

      expect(controller.index.value, 1);
      expect(replies.map((reply) => reply.id.toInt()), [1]);
    });
  });
}

class _TargetLookupController extends VideoReplyReplyController {
  _TargetLookupController({required int targetId})
    : super(
        hasRoot: false,
        id: targetId,
        oid: 1,
        rpid: 1,
        dialog: null,
        replyType: 1,
      );

  @override
  List<ReplyInfo> applyShielding(List<ReplyInfo> replies) =>
      replies.where((reply) => !reply.content.message.contains('剧透')).toList();

  @override
  void jumpToItem(int index) {}
}
