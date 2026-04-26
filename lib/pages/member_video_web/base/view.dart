import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/pages/member_video_web/base/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract class BaseVideoWebState<
  S extends StatefulWidget,
  R,
  T extends BaseVideoItemModel,
  V extends EnumWithLabel
>
    extends State<S>
    with GridMixin {
  late final String name;
  BaseVideoWebCtr<R, T, V> get controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    name = args['name'];
  }

  List<V> get values;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(name),
        actions: [
          Obx(
            () {
              final order = controller.order.value;
              return PopupMenuButton<V>(
                tooltip: '排序',
                icon: const Icon(Icons.sort),
                initialValue: order,
                onSelected: controller.queryBySort,
                itemBuilder: (_) => values
                    .map((e) => PopupMenuItem(value: e, child: Text(e.label)))
                    .toList(),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: refreshIndicator(
        onRefresh: controller.onRefresh,
        child: CustomScrollView(
          physics: ReloadScrollPhysics(controller: controller),
          slivers: [
            SliverPadding(
              padding: .only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => buildBody(colorScheme, controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(
    ColorScheme colorScheme,
    LoadingState<List<T>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverMainAxisGroup(
                slivers: [
                  buildHeader(colorScheme),
                  ?buildTags(colorScheme),
                  SliverGrid.builder(
                    gridDelegate: gridDelegate,
                    itemCount: response.length,
                    itemBuilder: (context, index) {
                      if (index == response.length - 1) {
                        controller.onLoadMore();
                      }
                      // TODO: dimension
                      return VideoCardH(videoItem: response[index]);
                    },
                  ),
                ],
              )
            : HttpError(onReload: controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  Widget? buildTags(ColorScheme colorScheme) => null;

  Widget buildHeader(ColorScheme colorScheme) {
    return SliverPinnedHeader(
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const .fromLTRB(14, 0, 8, 4),
        child: Stack(
          alignment: .centerLeft,
          children: [
            ?buildCount(),
            Center(child: buildPageBtn(colorScheme)),
          ],
        ),
      ),
    );
  }

  Widget? buildCount() {
    final count = controller.count;
    if (count == null) return null;
    return Text(
      '共 $count 视频',
      style: const TextStyle(height: 1),
      strutStyle: const StrutStyle(leading: 0, height: 1),
    );
  }

  Widget? buildPageBtn(ColorScheme colorScheme) {
    final totalPage = controller.totalPage;
    if (totalPage == null) return null;
    final page = controller.page - 1;
    final canBackward = page > 1;
    final canForward = page < totalPage;
    const size = 30.0;
    const iconSize = 24.0;

    final backwardBtn = iconButton(
      size: size,
      iconSize: iconSize,
      tooltip: canBackward ? '上一页' : null,
      icon: const Icon(Icons.keyboard_arrow_left),
      onPressed: canBackward ? () => controller.jumpToPage(page - 1) : null,
    );

    final forwardBtn = iconButton(
      size: size,
      iconSize: iconSize,
      tooltip: canForward ? '下一页' : null,
      icon: const Icon(Icons.keyboard_arrow_right),
      onPressed: canForward ? () => controller.jumpToPage(page + 1) : null,
    );

    final pageIndicator = SearchText(
      height: 1,
      text: '$page / $totalPage',
      borderRadius: const .all(.circular(4)),
      padding: const .symmetric(horizontal: 10, vertical: 5),
      onTap: (_) => showJumpDialog(page),
    );

    return Row(
      spacing: 6,
      mainAxisSize: .min,
      children: [
        backwardBtn,
        pageIndicator,
        forwardBtn,
      ],
    );
  }

  void showJumpDialog(int page) {
    var pageStr = page.toString();

    void onSubmit([_]) {
      try {
        controller.jumpToPage(
          int.parse(pageStr).clamp(1, controller.totalPage!),
        );
      } catch (e) {
        SmartDialog.showToast(e.toString());
      }
    }

    showConfirmDialog(
      context: context,
      title: const Text('跳至: '),
      content: TextFormField(
        autofocus: true,
        initialValue: pageStr,
        onChanged: (value) => pageStr = value,
        decoration: const InputDecoration(
          labelText: '页数',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onFieldSubmitted: (_) {
          Get.back();
          onSubmit();
        },
      ),
      onConfirm: onSubmit,
    );
  }
}
