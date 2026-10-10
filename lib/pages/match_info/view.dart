import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/match/match_info/contest.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/match_info/controller.dart';
import 'package:PiliPlus/pages/match_info/widgets/match_info_item.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MatchInfoPage extends StatefulWidget {
  const MatchInfoPage({super.key});

  @override
  State<MatchInfoPage> createState() => _MatchInfoPageState();
}

class _MatchInfoPageState extends CommonDynPageState<MatchInfoPage> {
  @override
  final MatchInfoController controller = Get.putOrFind(
    MatchInfoController.new,
    tag: Get.parameters['cid']!,
  );

  @override
  dynamic get arguments => null;

  @override
  Widget build(BuildContext context) {
    return fabAnimWrapper(
      child: SimpleScaffold(
        appBar: AppBar(title: const Text('比赛详情')),
        body: ViewSafeArea(
          child: refreshIndicator(
            onRefresh: controller.onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                Obx(() => _buildInfo(controller.infoState.value)),
                buildReplyHeader(),
                Obx(() => replyList(controller.loadingState.value)),
              ],
            ),
          ),
        ).constraintWidth(),
        fab: SlideTransition(
          position: fabAnimation,
          child: fabButton,
        ),
      ),
    );
  }

  Widget _buildInfo(LoadingState<MatchContest?> infoState) {
    if (infoState case Success(:final response?)) {
      try {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const .symmetric(vertical: 10),
            child: MatchInfoItem(contest: response),
          ),
        );
      } catch (_) {
        return const SliverToBoxAdapter();
      }
    }
    return const SliverToBoxAdapter();
  }

  @override
  void replyReply(BuildContext context, ReplyInfo replyItem, int? id) {
    EasyThrottle.throttle('replyReply', const Duration(milliseconds: 500), () {
      int oid = replyItem.oid.toInt();
      int rpid = replyItem.id.toInt();
      Get.to(
        SimpleScaffold(
          appBar: AppBar(
            title: const Text('评论详情'),
            shape: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          body: ViewSafeArea(
            child: VideoReplyReplyPanel(
              enableSlide: false,
              id: id,
              oid: oid,
              rpid: rpid,
              isVideoDetail: false,
              replyType: controller.replyType,
              firstFloor: replyItem,
            ),
          ).constraintWidth(),
        ),
      );
    });
  }
}
