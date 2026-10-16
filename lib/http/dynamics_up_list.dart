import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';

Future<LoadingState<FollowUpModel>> loadAllDynamicUps(
  FollowUpModel firstPage,
  Future<LoadingState<FollowUpModel>> Function(String offset) loadPage,
) async {
  final ups = FollowUpModel.fromUpList(null);
  final offsets = <String>{};

  var page = firstPage;
  ups.addAllUpList(page.upList ?? const []);
  while (page.hasMore == true) {
    final offset = page.offset;
    if (offset == null || offset.isEmpty) {
      return const Error('动态UP列表缺少分页游标，请刷新重试');
    }
    if (!offsets.add(offset)) {
      return const Error('动态UP列表分页未推进，请刷新重试');
    }
    final result = await loadPage(offset);
    if (result case Success(:final response)) {
      page = response;
      ups.addAllUpList(page.upList ?? const []);
    } else {
      return result;
    }
  }

  // Keep server order within each group, with unread UPs ahead of read UPs.
  firstPage
    ..upList = [
      ...ups.upList!.where((item) => item.hasUpdate == true),
      ...ups.upList!.where((item) => item.hasUpdate != true),
    ]
    ..hasMore = page.hasMore
    ..offset = page.offset;
  return Success(firstPage);
}
