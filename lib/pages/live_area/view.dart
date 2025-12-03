import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_item.dart';
import 'package:PiliPlus/models_new/live/live_area_list/area_list.dart';
import 'package:PiliPlus/pages/live_area/controller.dart';
import 'package:PiliPlus/pages/live_area_detail/view.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sortable_wrap/sortable_wrap.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LiveAreaPage extends StatefulWidget {
  const LiveAreaPage({super.key});

  @override
  State<LiveAreaPage> createState() => _LiveAreaPageState();
}

class _LiveAreaPageState extends State<LiveAreaPage> {
  final _controller = Get.put(LiveAreaController());

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('全部标签'),
        actions: _controller.isLogin
            ? [
                TextButton(
                  onPressed: _controller.onEdit,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Obx(
                    () => Text(_controller.isEditing.value ? '完成' : '编辑'),
                  ),
                ),
                const SizedBox(width: 16),
              ]
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.isLogin)
              Obx(() => _buildFavWidget(theme, _controller.favState.value)),
            Expanded(
              child: Obx(
                () => _buildBody(
                  theme,
                  padding.bottom,
                  _controller.loadingState.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    double bottom,
    LoadingState<List<AreaList>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success(:var response) =>
        response != null && response.isNotEmpty
            ? DefaultTabController(
                length: response.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: response.map((e) => Tab(text: e.name)).toList(),
                    ),
                    Expanded(
                      child: tabBarView(
                        children: response
                            .map(
                              (e) => KeepAliveWrapper(
                                builder: (context) {
                                  if (e.areaList.isNullOrEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return GridView.builder(
                                    padding: EdgeInsets.only(
                                      top: 12,
                                      bottom: bottom + 100,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 100,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          mainAxisExtent: 80,
                                        ),
                                    itemCount: e.areaList!.length,
                                    itemBuilder: (context, index) {
                                      final item = e.areaList![index];
                                      return _tagItem(
                                        theme: theme,
                                        item: item,
                                        onPressed: () {
                                          // success
                                          bool? isFav =
                                              _controller.favInfo[item.id];
                                          if (isFav == true) {
                                            _controller.favInfo[item.id] =
                                                false;
                                            _controller.favState
                                              ..value.data.remove(item)
                                              ..refresh();
                                            (context as Element)
                                                .markNeedsBuild();
                                          } else {
                                            // check
                                            if (_controller
                                                .favState
                                                .value
                                                .isSuccess) {
                                              _controller.favInfo[item.id] =
                                                  true;
                                              _controller.favState
                                                ..value.data.add(item)
                                                ..refresh();
                                              (context as Element)
                                                  .markNeedsBuild();
                                            }
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              )
            : scrollErrorWidget(onReload: _controller.onReload),
      Error(:var errMsg) => scrollErrorWidget(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildFavWidget(
    ThemeData theme,
    LoadingState<List<AreaItem>?> loadingState,
  ) {
    if (loadingState.isSuccess) {
      final List<AreaItem>? list = loadingState.data;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '我的常用标签  '),
                  TextSpan(
                    text: '点击进入标签',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (list != null && list.isNotEmpty) ...[
              SortableWrap(
                onSortStart: (index) {
                  _controller.isEditing.value = true;
                },
                onSorted: (int oldIndex, int newIndex) {
                  list.insert(newIndex, list.removeAt(oldIndex));
                },
                spacing: 12,
                runSpacing: 8,
                children: list
                    .map(
                      (item) => _favTagItem(
                        theme: theme,
                        item: item,
                        onPressed: () {
                          list.remove(item);
                          _controller
                            ..favInfo[item.id] = false
                            ..favState.refresh();
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 4),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _tagItem({
    required ThemeData theme,
    required AreaItem item,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_controller.isEditing.value) {
          if (item.id != 0) {
            onPressed();
          }
          return;
        }

        Get.to(
          LiveAreaDetailPage(
            areaId: item.id,
            parentAreaId: item.parentId,
            parentName: item.parentName ?? '',
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NetworkImgLayer(
                width: 45,
                height: 45,
                src: item.pic,
                type: ImageType.emote,
              ),
              const SizedBox(height: 4),
              Text(
                item.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (item.id != 0)
            Positioned(
              top: 0,
              right: 16,
              child: Obx(() {
                if (_controller.isEditing.value &&
                    _controller.favState.value.isSuccess) {
                  bool? isFav = _controller.favInfo[item.id];
                  if (isFav == null) {
                    isFav = _controller.favState.value.data.contains(item);
                    _controller.favInfo[item.id] = isFav;
                  }
                  return iconButton(
                    size: 17,
                    iconSize: 13,
                    icon: isFav
                        ? const Icon(MdiIcons.check)
                        : const Icon(MdiIcons.plus),
                    bgColor: isFav
                        ? theme.colorScheme.onInverseSurface
                        : theme.colorScheme.secondaryContainer,
                    iconColor: isFav
                        ? theme.colorScheme.outline
                        : theme.colorScheme.onSecondaryContainer,
                    onPressed: onPressed,
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
        ],
      ),
    );
  }

  Widget _favTagItem({
    required ThemeData theme,
    required AreaItem item,
    required VoidCallback onPressed,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline,
            ),
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: SearchText(
            text: item.name!,
            fontSize: 14,
            bgColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            onTap: (value) {
              if (_controller.isEditing.value) {
                onPressed();
                return;
              }

              Get.to(
                LiveAreaDetailPage(
                  areaId: item.id,
                  parentAreaId: item.parentId,
                  parentName: item.parentName ?? '',
                ),
              );
            },
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: Obx(() {
            if (_controller.isEditing.value) {
              final isDark = theme.brightness == Brightness.dark;
              return iconButton(
                size: 16,
                iconSize: 12,
                icon: const Icon(Icons.horizontal_rule),
                bgColor: isDark
                    ? theme.colorScheme.error
                    : theme.colorScheme.errorContainer,
                iconColor: isDark
                    ? theme.colorScheme.onError
                    : theme.colorScheme.onErrorContainer,
                onPressed: onPressed,
              );
            }
            return const SizedBox.shrink();
          }),
        ),
      ],
    );
  }
}
