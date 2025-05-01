import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/msg/msgfeed_like_me.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';

import '../../../utils/app_scheme.dart';
import 'controller.dart';

class LikeMePage extends StatefulWidget {
  const LikeMePage({super.key});

  @override
  State<LikeMePage> createState() => _LikeMePageState();
}

class _LikeMePageState extends State<LikeMePage> {
  late final LikeMeController _likeMeController = Get.put(LikeMeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收到的赞'),
      ),
      body: refreshIndicator(
        onRefresh: () async {
          await _likeMeController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver:
                  Obx(() => _buildBody(_likeMeController.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const MsgFeedTopSkeleton();
          },
        ),
      Success() => () {
          final theme = Theme.of(context);
          Pair<List<LikeMeItems>, List<LikeMeItems>> pair =
              loadingState.response;
          List<LikeMeItems> latest = pair.first;
          List<LikeMeItems> total = pair.second;
          if (latest.isNotEmpty || total.isNotEmpty) {
            return SliverMainAxisGroup(
              slivers: [
                if (latest.isNotEmpty) ...[
                  _buildHeader(theme, '最新'),
                  SliverList.separated(
                    itemBuilder: (context, index) {
                      if (total.isEmpty && index == latest.length - 1) {
                        _likeMeController.onLoadMore();
                      }
                      return _buildItem(
                        theme,
                        latest[index],
                        (id) {
                          _likeMeController.onRemove(id, index, true);
                        },
                      );
                    },
                    itemCount: latest.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 72,
                        endIndent: 20,
                        height: 6,
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                ],
                if (total.isNotEmpty) ...[
                  _buildHeader(theme, '累计'),
                  SliverList.separated(
                    itemBuilder: (context, index) {
                      if (index == total.length - 1) {
                        _likeMeController.onLoadMore();
                      }
                      return _buildItem(
                        theme,
                        total[index],
                        (id) {
                          _likeMeController.onRemove(id, index, false);
                        },
                      );
                    },
                    itemCount: total.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 72,
                        endIndent: 20,
                        height: 6,
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                ],
              ],
            );
          }
          return HttpError(onReload: _likeMeController.onReload);
        }(),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _likeMeController.onReload,
        ),
    };
  }

  Widget _buildHeader(ThemeData theme, String title) {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: theme.textTheme.labelLarge!.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(ThemeData theme, LikeMeItems item, ValueChanged onRemove) {
    return ListTile(
      onTap: () {
        String? nativeUri = item.item?.nativeUri;
        if (nativeUri != null) {
          PiliScheme.routePushFromUrl(nativeUri);
        }
      },
      onLongPress: () {
        showConfirmDialog(
          context: context,
          title: '确定删除该通知?',
          onConfirm: () {
            onRemove(item.id);
          },
        );
      },
      leading: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (var j = 0;
                    j < item.users!.length && j < 4;
                    j++) ...<Widget>[
                  Positioned(
                      left: 15 * (j % 2).toDouble(),
                      top: 15 * (j ~/ 2).toDouble(),
                      child: NetworkImgLayer(
                        width: item.users!.length > 1 ? 30 : 45,
                        height: item.users!.length > 1 ? 30 : 45,
                        type: 'avatar',
                        src: item.users![j].avatar,
                      )),
                ]
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "${item.users![0].nickname}",
              style: theme.textTheme.titleSmall!
                  .copyWith(height: 1.5, color: theme.colorScheme.primary),
            ),
            if (item.counts! > 1)
              TextSpan(
                text: ' 等${item.counts}人',
                style: theme.textTheme.titleSmall!
                    .copyWith(fontSize: 12, height: 1.5),
              ),
            TextSpan(
              text: " 赞了我的${item.item?.business}",
              style: theme.textTheme.titleSmall!.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.item?.title?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(item.item!.title!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.colorScheme.outline, height: 1.5)),
          ],
          const SizedBox(height: 4),
          Text(
            Utils.dateFormat(item.likeTime),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 13,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      trailing: item.item?.image != null && item.item?.image != ""
          ? NetworkImgLayer(
              width: 45,
              height: 45,
              type: 'cover',
              src: item.item?.image,
            )
          : null,
    );
  }
}
