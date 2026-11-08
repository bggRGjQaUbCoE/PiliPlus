import 'dart:math';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/scroll_offset_helper.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class ViewPointsPage extends CommonSlidePage {
  const ViewPointsPage({
    super.key,
    super.enableSlide,
    required this.videoDetailController,
    required this.plPlayerController,
  });

  final VideoDetailController videoDetailController;
  final PlPlayerController? plPlayerController;

  @override
  State<ViewPointsPage> createState() => _ViewPointsPageState();
}

class _ViewPointsPageState extends State<ViewPointsPage>
    with SingleTickerProviderStateMixin, CommonSlideMixin, ScrollOffsetMixin {
  VideoDetailController get videoDetailController =>
      widget.videoDetailController;
  PlPlayerController? get plPlayerController => widget.plPlayerController;

  @override
  final scrollController = ScrollController();

  @override
  late final int itemIndex;
  @override
  int get itemCount => videoDetailController.viewPointList.length;

  ColorScheme get colorScheme => theme.colorScheme;

  @override
  void initState() {
    super.initState();
    final posInSeconds =
        videoDetailController.plPlayerController.position.value;
    itemIndex = max(
      0,
      videoDetailController.viewPointList.indexWhere((e) {
        if (e.from != null && e.to != null) {
          return posInSeconds >= e.from! && posInSeconds < e.to!;
        }
        return false;
      }),
    );
    if (itemIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback(jumpToCurrent);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage() {
    return SimpleScaffold(
      appBar: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Expanded(child: Text('分段信息', style: TextStyle(fontSize: 16))),
            const Text('分段进度条 ', style: TextStyle(fontSize: 16)),
            Obx(
              () => Transform.scale(
                alignment: .centerLeft,
                scale: 0.8,
                child: Switch(
                  value: videoDetailController.showVP.value,
                  onChanged: videoDetailController.showVP.call,
                ),
              ),
            ),
            iconButton(
              context: context,
              size: 30,
              icon: const Icon(Icons.clear),
              tooltip: '关闭',
              onPressed: Get.back,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: enableSlide ? slideList() : buildList(),
    );
  }

  @override
  Widget buildList() {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: 7,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
          ),
          sliver: SliverFixedExtentList.builder(
            itemExtent: 112,
            itemCount: videoDetailController.viewPointList.length,
            itemBuilder: (context, index) {
              final segment = videoDetailController.viewPointList[index];
              return Padding(
                padding: const .only(bottom: 2),
                child: _buildItem(segment, itemIndex == index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(ViewPointSegment segment, bool isCurr) {
    return Material(
      type: .transparency,
      child: InkWell(
        onTap: segment.from != null
            ? () {
                Get.back();
                plPlayerController?.seekTo(Duration(seconds: segment.from!));
              }
            : null,
        child: Padding(
          padding: const .symmetric(horizontal: Style.safeSpace, vertical: 5),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              NetworkImgLayer(
                src: segment.url,
                width: 160,
                height: 100,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  spacing: 10,
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      segment.title ?? '',
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: isCurr
                          ? TextStyle(
                              fontWeight: .bold,
                              color: colorScheme.primary,
                            )
                          : null,
                    ),
                    Text(
                      '${segment.from != null ? DurationUtils.formatDuration(segment.from) : ''} - '
                      '${segment.to != null ? DurationUtils.formatDuration(segment.to) : ''}',
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
