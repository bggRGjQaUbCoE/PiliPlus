import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/media/controller.dart';
import 'package:PiliPlus/pages/media/widgets/item.dart';
import 'package:PiliPlus/pages/mine/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaPage extends CommonPage {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends CommonPageState<MediaPage, MediaController>
    with AutomaticKeepAliveClientMixin {
  @override
  MediaController controller = Get.put(MediaController());
  late final MainController _mainController = Get.find<MainController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void listener() {
    if (_mainController.navigationBars[0] != NavigationBarType.media &&
        _mainController.selectedIndex.value == 0) {
      return;
    }
    super.listener();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    Color primary = theme.colorScheme.primary;
    return Material(
        color: Colors.transparent,
        child: ListView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
          const MinePage(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 8),
              for (int i = 0; i < controller.list.length; i++) ...[
                InkWell(
                  onTap: controller.list[i].onTap,
                  borderRadius: StyleString.mdRadius,
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.list[i].icon,
                          color: primary,
                          size: 24.0,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.list[i].title,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
            Obx(
              () => controller.loadingState.value is Loading
                  ? const SizedBox.shrink()
                  : favFolder(theme),
            )
          ],
        ),

    );
  }

  Widget favFolder(ThemeData theme) {
    return Column(
      children: [
        Divider(
          height: 20,
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
        ListTile(
          onTap: () async {
            await Get.toNamed('/fav');
            Future.delayed(const Duration(milliseconds: 150), () {
              controller.onRefresh();
            });
          },
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '收藏夹  ',
                      style: TextStyle(
                          fontSize: theme.textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    if (controller.count.value != -1)
                      TextSpan(
                        text: "${controller.count.value}  ",
                        style: TextStyle(
                          fontSize: theme.textTheme.titleSmall!.fontSize,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          trailing: IconButton(
            tooltip: '刷新',
            onPressed: controller.onRefresh,
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Obx(() => _buildBody(theme, controller.loadingState.value)),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildBody(ThemeData theme, LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success(:var response) => Builder(
          builder: (context) {
            List<FavFolderInfo>? favFolderList = response.list;
            if (favFolderList.isNullOrEmpty) {
              return const SizedBox.shrink();
            }
            bool flag = controller.count.value > favFolderList!.length;
            return ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              itemCount: response.list.length + (flag ? 1 : 0),
              itemBuilder: (context, index) {
                if (flag && index == favFolderList.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14, bottom: 35),
                    child: Center(
                      child: IconButton(
                        tooltip: '查看更多',
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            return theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.5);
                          }),
                        ),
                        onPressed: () async {
                          await Get.toNamed('/fav');
                          Future.delayed(const Duration(milliseconds: 150), () {
                            controller.onRefresh();
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                } else {
                  String heroTag = Utils.makeHeroTag(response.list[index].fid);
                  return FavFolderItem(
                    heroTag: heroTag,
                    item: response.list[index],
                    callback: () => Future.delayed(
                      const Duration(milliseconds: 150),
                      controller.onRefresh,
                    ),
                  );
                }
              },
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
            );
          },
        ),
      Error(:var errMsg) => SizedBox(
          height: 160,
          child: Center(
            child: Text(
              errMsg ?? '',
              textAlign: TextAlign.center,
            ),
          ),
        ),
    };
  }
}
