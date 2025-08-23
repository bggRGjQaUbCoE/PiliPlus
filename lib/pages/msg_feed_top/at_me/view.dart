import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pbenum.dart'
    show IMSettingType;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/msg/msg_at/item.dart';
import 'package:PiliPlus/pages/msg_feed_top/at_me/controller.dart';
import 'package:PiliPlus/pages/whisper_settings/view.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AtMePage extends StatefulWidget {
  const AtMePage({super.key});

  @override
  State<AtMePage> createState() => _AtMePageState();
}

class _AtMePageState extends State<AtMePage> {
  late final AtMeController _atMeController = Get.put(AtMeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('@我的'),
        actions: [
          IconButton(
            onPressed: () => Get.to(
              const WhisperSettingsPage(
                imSettingType: IMSettingType.SETTING_TYPE_OLD_AT_ME,
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
        onRefresh: _atMeController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _atMeController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<MsgAtItem>?> loadingState,
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
                    _atMeController.onLoadMore();
                  }
                  final item = response[index];
                  return ListTile(
                    onTap: () {
                      String? nativeUri = item.item?.nativeUri;
                      if (nativeUri == null ||
                          nativeUri.isEmpty ||
                          nativeUri.startsWith('?')) {
                        return;
                      }
                      PiliScheme.routePushFromUrl(nativeUri);
                    },
                    onLongPress: () => showConfirmDialog(
                      context: context,
                      title: '确定删除该通知?',
                      onConfirm: () =>
                          _atMeController.onRemove(item.id!, index),
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
                          TextSpan(
                            text: " 在${item.item?.business}中@了我",
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
                        if (item.item?.sourceContent?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.item!.sourceContent!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          DateUtil.dateFormat(item.atTime),
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
                            src: item.item?.image,
                          )
                        : null,
                  );
                },
                separatorBuilder: (context, index) => divider,
              )
            : HttpError(onReload: _atMeController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _atMeController.onReload,
      ),
    };
  }
}
