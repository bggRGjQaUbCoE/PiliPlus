import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/msg/msgfeed_reply_me.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';

import '../../../utils/app_scheme.dart';
import 'controller.dart';

class ReplyMePage extends StatefulWidget {
  const ReplyMePage({super.key});

  @override
  State<ReplyMePage> createState() => _ReplyMePageState();
}

class _ReplyMePageState extends State<ReplyMePage> {
  late final _replyMeController = Get.put(ReplyMeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('回复我的')),
      body: refreshIndicator(
        onRefresh: () async {
          await _replyMeController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver:
                  Obx(() => _buildBody(_replyMeController.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<ReplyMeItems>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const MsgFeedTopSkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.separated(
              itemCount: loadingState.response!.length,
              itemBuilder: (context, int index) {
                if (index == loadingState.response!.length - 1) {
                  _replyMeController.onLoadMore();
                }

                ReplyMeItems item = loadingState.response![index];
                return ListTile(
                  onTap: () {
                    String? nativeUri = item.item?.nativeUri;
                    if (nativeUri != null) {
                      PiliScheme.routePushFromUrl(
                        nativeUri,
                        businessId: item.item?.businessId,
                        oid: item.item?.subjectId,
                      );
                    }
                  },
                  onLongPress: () {
                    showConfirmDialog(
                      context: context,
                      title: '确定删除该通知?',
                      onConfirm: () {
                        _replyMeController.onRemove(item.id, index);
                      },
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      Get.toNamed('/member?mid=${item.user?.mid}');
                    },
                    child: NetworkImgLayer(
                      width: 45,
                      height: 45,
                      type: 'avatar',
                      src: item.user?.avatar,
                    ),
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${item.user?.nickname}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        if (item.isMulti == 1)
                          TextSpan(
                            text: " 等人",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 12),
                          ),
                        TextSpan(
                          text:
                              " 对我的${item.item?.business}发布了${item.counts}条评论",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(item.item?.sourceContent ?? "",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      if (item.item?.targetReplyContent != null &&
                          item.item?.targetReplyContent != "")
                        Text("| ${item.item?.targetReplyContent}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    height: 1.5)),
                      if (item.item?.rootReplyContent != null &&
                          item.item?.rootReplyContent != "")
                        Text(" | ${item.item?.rootReplyContent}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    height: 1.5)),
                      Text(
                        Utils.dateFormat(item.replyTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  indent: 72,
                  endIndent: 20,
                  height: 6,
                  color: Colors.grey.withOpacity(0.1),
                );
              },
            )
          : HttpError(onReload: _replyMeController.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _replyMeController.onReload,
        ),
    };
  }
}
