import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pbenum.dart'
    show IMSettingType;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/msg/msg_like/item.dart';
import 'package:PiliPlus/pages/msg_feed_top/like_me/controller.dart';
import 'package:PiliPlus/pages/whisper_settings/view.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeMePage extends StatefulWidget {
  const LikeMePage({super.key});

  @override
  State<LikeMePage> createState() => _LikeMePageState();
}

class _LikeMePageState extends State<LikeMePage> {
  late final LikeMeController _likeMeController = Get.put(LikeMeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('收到的赞'),
        actions: [
          IconButton(
            onPressed: () => Get.to(
              const WhisperSettingsPage(
                imSettingType: IMSettingType.SETTING_TYPE_OLD_RECEIVE_LIKE,
              ),
            ),
            icon: Icon(
              size: 20,
              Icons.settings,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: refreshIndicator(
        onRefresh: _likeMeController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _likeMeController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, LoadingState loadingState) {
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
      Success(:var response) => Builder(
        builder: (context) {
          Pair<List<MsgLikeItem>, List<MsgLikeItem>> pair = response;
          List<MsgLikeItem> latest = pair.first;
          List<MsgLikeItem> total = pair.second;
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
                    separatorBuilder: (context, index) => divider,
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
                    separatorBuilder: (context, index) => divider,
                  ),
                ],
              ],
            );
          }
          return HttpError(onReload: _likeMeController.onReload);
        },
      ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
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

  Widget _buildItem(
    ThemeData theme,
    MsgLikeItem item,
    ValueChanged<int?> onRemove,
  ) {
    return ListTile(
      onTap: () {
        String? nativeUri = item.item?.nativeUri;
        bool isInvalid =
            nativeUri == null || nativeUri.isEmpty || nativeUri.startsWith('?');
        if (item.counts! > 1) {
          Get.toNamed(
            'msgLikeDetail',
            parameters: {
              'id': item.id!.toString(),
              if (!isInvalid) 'uri': nativeUri,
            },
          );
          return;
        }
        if (isInvalid) {
          return;
        }
        PiliScheme.routePushFromUrl(nativeUri);
      },
      onLongPress: () => showDialog(
        context: context,
        builder: (context) {
          final isNotice = item.noticeState == 0;
          return AlertDialog(
            clipBehavior: Clip.hardEdge,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Get.back();
                    showConfirmDialog(
                      context: context,
                      title: '删除',
                      content: '该条通知删除后，当有新点赞时会重新出现在列表，是否继续？',
                      onConfirm: () => onRemove(item.id),
                    );
                  },
                  dense: true,
                  title: const Text(
                    '删除',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.back();
                    if (isNotice) {
                      showConfirmDialog(
                        context: context,
                        title: '不再通知',
                        content: '这条内容的点赞将不再通知，但仍可在列表内查看，是否继续？',
                        onConfirm: () =>
                            _likeMeController.onSetNotice(item, isNotice),
                      );
                    } else {
                      _likeMeController.onSetNotice(item, isNotice);
                    }
                  },
                  dense: true,
                  title: Text(
                    isNotice ? '不再通知' : '接收通知',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      leading: Column(
        children: [
          const Spacer(),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (
                  var j = 0;
                  j < item.users!.length && j < 4;
                  j++
                ) ...<Widget>[
                  Positioned(
                    left: 15 * (j % 2).toDouble(),
                    top: 15 * (j ~/ 2).toDouble(),
                    child: NetworkImgLayer(
                      width: item.users!.length > 1 ? 30 : 45,
                      height: item.users!.length > 1 ? 30 : 45,
                      type: ImageType.avatar,
                      src: item.users![j].avatar,
                    ),
                  ),
                ],
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
              style: theme.textTheme.titleSmall!.copyWith(
                height: 1.5,
                color: theme.colorScheme.primary,
              ),
            ),
            if (item.counts! > 1)
              TextSpan(
                text: ' 等${item.counts}人',
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                  height: 1.5,
                ),
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
            Text(
              item.item!.title!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.outline,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            DateFormatUtils.dateFormat(item.likeTime),
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 13,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.item?.image?.isNotEmpty == true)
            NetworkImgLayer(
              width: 45,
              height: 45,
              src: item.item!.image,
            ),
          if (item.noticeState == 1) ...[
            if (item.item?.image?.isNotEmpty == true) const SizedBox(width: 4),
            Icon(
              size: 18,
              Icons.notifications_off,
              color: theme.colorScheme.outline,
            ),
          ],
        ],
      ),
    );
  }
}
