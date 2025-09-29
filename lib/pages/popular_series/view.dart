import 'dart:math';

import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models_new/popular/popular_series_one/config.dart';
import 'package:PiliPlus/pages/popular_series/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularSeriesPage extends StatefulWidget {
  const PopularSeriesPage({super.key});

  @override
  State<PopularSeriesPage> createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> with GridMixin {
  final _controller = Get.put(PopularSeriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(() {
          final config = _controller.config.value;
          if (config != null) {
            return Text(config.name!);
          }
          return const Text('每周必看');
        }),
      ),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ViewSliverSafeArea(
              sliver: Obx(() => _buildBody(_controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<HotVideoItemModel>?> value) {
    switch (value) {
      case Loading():
        return gridSkeleton;
      case Success<List<HotVideoItemModel>?>(:var response):
        Widget sliver;
        if (response != null && response.isNotEmpty == true) {
          sliver = SliverGrid.builder(
            gridDelegate: gridDelegate,
            itemCount: response.length,
            itemBuilder: (context, index) {
              final item = response[index];
              return VideoCardH(
                videoItem: item,
                onTap: () {
                  final config = _controller.config.value;
                  PageUtils.toVideoPage(
                    bvid: item.bvid,
                    cid: item.cid!,
                    extraArguments: {
                      'sourceType': SourceType.playlist,
                      'favTitle': '每周必看 ${config?.label ?? ''}',
                      'mediaId': config?.mediaId,
                      'desc': true,
                      'oid': item.aid,
                      'isContinuePlaying': index != 0,
                    },
                  );
                },
              );
            },
          );
        } else {
          sliver = HttpError(onReload: _controller.onReload);
        }
        if (_controller.config.value case final config?) {
          sliver = SliverMainAxisGroup(
            slivers: [
              _buildSeriesList(config),
              sliver,
            ],
          );
        }
        return sliver;
      case Error(:var errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }

  Widget _buildSeriesList(PopularSeriesConfig config) {
    final colorScheme = ColorScheme.of(context);
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final number = _controller.number;
        final seriesList = _controller.seriesList!;
        final size = MediaQuery.sizeOf(context);
        final padding = MediaQuery.viewPaddingOf(context);
        final width = min(
          min(
            size.width - padding.horizontal - 80,
            size.height - padding.vertical - 48,
          ),
          525.0,
        );
        final currIndex = seriesList.indexWhere((e) => e.number == number);
        final controller = ScrollController(
          initialScrollOffset: max(0, currIndex * 44 + 34 - width / 2),
        );
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: width,
                height: width,
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: seriesList.length,
                  itemExtent: 44,
                  itemBuilder: (context, index) {
                    final item = seriesList[index];
                    final isCurr = index == currIndex;
                    return ListTile(
                      dense: true,
                      minTileHeight: 44,
                      tileColor: isCurr
                          ? Theme.of(context).highlightColor
                          : null,
                      onTap: () {
                        Get.back();
                        if (!isCurr) {
                          _controller
                            ..number = item.number!
                            ..onReload();
                        }
                      },
                      title: Text(
                        item.name!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: isCurr
                          ? const Icon(Icons.check, size: 18)
                          : null,
                      contentPadding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 16,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ).whenComplete(controller.dispose);
      },
      child: Text.rich(
        style: TextStyle(
          height: 1,
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        strutStyle: const StrutStyle(height: 1, leading: 0, fontSize: 14),
        TextSpan(
          children: [
            TextSpan(text: config.label!),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                size: 18,
                Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
    if (_controller.reminder case final reminder?) {
      child = Row(
        spacing: 16,
        children: [
          child,
          Text(
            reminder,
            style: TextStyle(color: colorScheme.outline),
          ),
        ],
      );
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 14, bottom: 7),
        child: child,
      ),
    );
  }
}
