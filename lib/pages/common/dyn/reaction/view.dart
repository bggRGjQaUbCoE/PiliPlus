import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reaction/item.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/common/dyn/reaction/controller.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class DynReactPage extends StatelessWidget {
  const DynReactPage({
    super.key,
    required this.id,
    this.isPortrait = true,
    required this.controller,
  });

  final Object id;
  final bool isPortrait;
  final DynReactController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.loadingState.value == .loading()) {
      controller.queryData();
    }
    Widget buildBody(
      ThemeData theme,
      LoadingState<List<DynReactionItem>?> state,
    ) {
      return switch (state) {
        Loading() => const SliverFillRemaining(child: m3eLoading),
        Success(:final response) =>
          response != null && response.isNotEmpty
              ? SliverList.builder(
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    if (index == response.length - 1) {
                      controller.onLoadMore();
                    }

                    final item = response[index];
                    return ListTile(
                      dense: true,
                      safeArea: false,
                      visualDensity: .standard,
                      onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                      leading: PendantAvatar(item.face!, size: 36),
                      title: Text.rich(
                        TextSpan(
                          text: item.name,
                          style: const TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: ' ${item.action}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : HttpError(onReload: controller.onReload),
        Error(:final errMsg) => HttpError(
          errMsg: errMsg,
          onReload: controller.onReload,
        ),
      };
    }

    final child = CustomScrollView(
      key: const PageStorageKey(DynType.reaction),
      slivers: [
        SliverPadding(
          padding: .only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
          ),
          sliver: Obx(() => buildBody(theme, controller.loadingState.value)),
        ),
      ],
    );
    if (isPortrait) return child;
    return refreshIndicator(onRefresh: controller.onRefresh, child: child);
  }
}
