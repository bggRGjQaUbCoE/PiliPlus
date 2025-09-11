import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/pages/common/slide/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPointsPage extends CommonCollapseSlidePage {
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

class _ViewPointsPageState
    extends CommonCollapseSlidePageState<ViewPointsPage> {
  VideoDetailController get videoDetailController =>
      widget.videoDetailController;
  PlPlayerController? get plPlayerController => widget.plPlayerController;

  int currentIndex = -1;

  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        primary: false,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text('分段信息'),
        toolbarHeight: 45,
        actions: [
          const Text(
            '分段进度条 ',
            style: TextStyle(fontSize: 16),
          ),
          Obx(
            () => Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.8,
              child: Switch(
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                  if (states.isNotEmpty &&
                      states.first == WidgetState.selected) {
                    return const Icon(Icons.done);
                  }
                  return null;
                }),
                value: videoDetailController.plPlayerController.showVP.value,
                onChanged: (value) {
                  videoDetailController.plPlayerController.showVP.value = value;
                },
              ),
            ),
          ),
          iconButton(
            context: context,
            size: 30,
            icon: Icons.clear,
            tooltip: '关闭',
            onPressed: Get.back,
          ),
          const SizedBox(width: 16),
        ],
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      body: enableSlide ? slideList(theme) : buildList(theme),
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    return ListView.builder(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: 7,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
      ),
      itemCount: videoDetailController.viewPointList.length,
      itemBuilder: (context, index) {
        Segment segment = videoDetailController.viewPointList[index];
        if (currentIndex == -1 && segment.from != null && segment.to != null) {
          final positionSeconds =
              videoDetailController.plPlayerController.positionSeconds.value;
          if (positionSeconds >= segment.from! &&
              positionSeconds < segment.to!) {
            currentIndex = index;
          }
        }
        final isCurr = currentIndex == index;
        return _buildItem(theme, segment, isCurr);
      },
    );
  }

  Widget _buildItem(ThemeData theme, Segment segment, bool isCurr) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: segment.from != null
            ? () {
                Get.back();
                plPlayerController
                  ?..danmakuController?.clear()
                  ..videoPlayerController?.seek(
                    Duration(seconds: segment.from!),
                  );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImgLayer(
                src: segment.url,
                width: 140.8,
                height: 88,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      segment.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: isCurr
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    ),
                    Text(
                      '${segment.from != null ? DurationUtils.formatDuration(segment.from) : ''} - '
                      '${segment.to != null ? DurationUtils.formatDuration(segment.to) : ''}',
                      style: TextStyle(color: theme.colorScheme.outline),
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
