import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/msg/msgfeed_at_me.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AtMePage extends StatefulWidget {
  const AtMePage({super.key});

  @override
  State<AtMePage> createState() => _AtMePageState();
}

class _AtMePageState extends State<AtMePage> {
  late final AtMeController _atMeController = Get.put(AtMeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('@我的'),
      ),
      body: refreshIndicator(
        onRefresh: () async {
          await _atMeController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver: Obx(() => _buildBody(_atMeController.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<AtMeItems>?> loadingState) {
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
                  _atMeController.onLoadMore();
                }
                final item = loadingState.response![index];
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
                        _atMeController.onRemove(item.id, index);
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        TextSpan(
                          text: " 在${item.item?.business}中@了我",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.item?.sourceContent?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(item.item!.sourceContent!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        Utils.dateFormat(item.atTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.outline,
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
          : HttpError(onReload: _atMeController.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _atMeController.onReload,
        ),
    };
  }
}
