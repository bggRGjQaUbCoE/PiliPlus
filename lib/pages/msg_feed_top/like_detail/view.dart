import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/card.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/item.dart';
import 'package:PiliPlus/pages/msg_feed_top/like_detail/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeDetailPage extends StatefulWidget {
  const LikeDetailPage({super.key});

  @override
  State<LikeDetailPage> createState() => _LikeDetailPageState();
}

class _LikeDetailPageState extends State<LikeDetailPage> {
  final LikeDetailController _controller = Get.put(
    LikeDetailController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('点赞详情')),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<MsgLikeDetailItem>?> loadingState,
  ) {
    late final divider = Divider(
      indent: 72,
      endIndent: 20,
      height: 6,
      color: Colors.grey.withValues(alpha: 0.1),
    );
    return switch (loadingState) {
      Loading() => SliverList.builder(
        itemCount: 12,
        itemBuilder: (context, index) => const MsgFeedTopSkeleton(),
      ),
      Success(:var response) => SliverMainAxisGroup(
        slivers: [
          if (_controller.card != null) ...[
            _buildCard(_controller.card!),
            SliverToBoxAdapter(
              child: Divider(
                height: 1,
                color: Colors.grey.withValues(alpha: 0.1),
              ),
            ),
          ],
          SliverList.separated(
            itemCount: response!.length,
            itemBuilder: (context, index) {
              if (index == response.length - 1) {
                _controller.onLoadMore();
              }
              return _buildItem(theme, response[index]);
            },
            separatorBuilder: (context, index) => divider,
          ),
        ],
      ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildCard(MsgLikeDetailCard card) {
    return SliverToBoxAdapter(
      child: ListTile(
        onTap: () {
          if (_controller.uri != null) {
            PiliScheme.routePushFromUrl(_controller.uri!);
          }
        },
        title: Text('${card.business}: ${card.title}'),
      ),
    );
  }

  Widget _buildItem(ThemeData theme, MsgLikeDetailItem item) {
    return ListTile(
      onTap: () => Get.toNamed('/member?mid=${item.user!.mid}'),
      leading: NetworkImgLayer(
        width: 45,
        height: 45,
        type: ImageType.avatar,
        src: item.user!.avatar,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "${item.user!.nickname}",
              style: theme.textTheme.titleSmall!.copyWith(
                height: 1.5,
                color: theme.colorScheme.primary,
              ),
            ),
            TextSpan(
              text: " 赞了我",
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DateFormatUtils.dateFormat(item.likeTime),
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 13,
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}
