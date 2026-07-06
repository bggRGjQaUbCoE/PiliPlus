import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, VoteCard, ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';

mixin ReplyVoteMixin on CommonListController<MainListReply, ReplyInfo> {
  VoteCard? voteCard;

  @override
  bool customHandleResponse(bool isRefresh, Success<MainListReply> response) {
    if (isRefresh) {
      final res = response.response;
      if (res.hasVoteCard()) {
        voteCard = res.voteCard;
      }
    }
    return super.customHandleResponse(isRefresh, response);
  }
}
