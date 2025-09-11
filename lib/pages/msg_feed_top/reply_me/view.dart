import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pbenum.dart'
    show IMSettingType;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/msg/msg_reply/item.dart';
import 'package:PiliPlus/pages/msg_feed_top/reply_me/controller.dart';
import 'package:PiliPlus/pages/whisper_settings/view.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyMePage extends StatefulWidget {
  const ReplyMePage({super.key});

  @override
  State<ReplyMePage> createState() => _ReplyMePageState();
}

class _ReplyMePageState extends State<ReplyMePage> {
  late final _replyMeController = Get.put(ReplyMeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('回复我的'),
        actions: [
          IconButton(
            onPressed: () => Get.to(
              const WhisperSettingsPage(
                imSettingType: IMSettingType.SETTING_TYPE_OLD_REPLY_ME,
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
        onRefresh: _replyMeController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _replyMeController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<MsgReplyItem>?> loadingState,
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
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.separated(
                itemCount: response!.length,
                itemBuilder: (context, int index) {
                  if (index == response.length - 1) {
                    _replyMeController.onLoadMore();
                  }

                  MsgReplyItem item = response[index];
                  return ListTile(
                    onTap: () {
                      String? nativeUri = item.item?.nativeUri;
                      if (nativeUri == null ||
                          nativeUri.isEmpty ||
                          nativeUri.startsWith('?')) {
                        return;
                      }
                      PiliScheme.routePushFromUrl(
                        nativeUri,
                        businessId: item.item?.businessId,
                        oid: item.item?.subjectId,
                      );
                    },
                    onLongPress: () => showConfirmDialog(
                      context: context,
                      title: '确定删除该通知?',
                      onConfirm: () =>
                          _replyMeController.onRemove(item.id, index),
                    ),
                    leading: GestureDetector(
                      onTap: () => Get.toNamed('/member?mid=${item.user?.mid}'),
                      child: NetworkImgLayer(
                        width: 45,
                        height: 45,
                        type: ImageType.avatar,
                        src: item.user?.avatar,
                      ),
                    ),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${item.user?.nickname}",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (item.isMulti == 1)
                            TextSpan(
                              text: " 等人",
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          TextSpan(
                            text:
                                " 对我的${item.item?.business}发布了${item.counts}条评论",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.item?.sourceContent ?? "",
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        if (item.item?.targetReplyContent != null &&
                            item.item?.targetReplyContent != "")
                          Text(
                            "| ${item.item?.targetReplyContent}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.outline,
                              height: 1.5,
                            ),
                          ),
                        if (item.item?.rootReplyContent != null &&
                            item.item?.rootReplyContent != "")
                          Text(
                            " | ${item.item?.rootReplyContent}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.outline,
                              height: 1.5,
                            ),
                          ),
                        Text(
                          DateFormatUtils.dateFormat(item.replyTime),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 13,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => divider,
              )
            : HttpError(onReload: _replyMeController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _replyMeController.onReload,
      ),
    };
  }
}
