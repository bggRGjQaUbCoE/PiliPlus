import 'package:PiliPlus/common/widgets/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/live_follow/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide InkWell;
import 'package:get/get.dart';

class UpPanel extends StatefulWidget {
  const UpPanel({
    required this.dynamicsController,
    super.key,
  });
  final DynamicsController dynamicsController;

  @override
  State<UpPanel> createState() => _UpPanelState();
}

class _UpPanelState extends State<UpPanel> {
  late final controller = widget.dynamicsController;
  late final isTop = controller.upPanelPosition == UpPanelPosition.top;

  void toFollowPage() => Get.to(const LiveFollowPage());

  @override
  Widget build(BuildContext context) {
    final accountService = controller.accountService;
    if (!accountService.isLogin.value) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final upData = controller.upState.value.data;
    final List<UpItem> upList = upData.upList;
    final List<LiveUserItem>? liveList = upData.liveUsers?.items;
    return CustomScrollView(
      scrollDirection: isTop ? Axis.horizontal : Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () => setState(() {
              controller.showLiveUp = !controller.showLiveUp;
            }),
            onLongPress: toFollowPage,
            onSecondaryTap: Utils.isMobile ? null : toFollowPage,
            child: Container(
              alignment: Alignment.center,
              height: isTop ? 76 : 60,
              padding: isTop ? const EdgeInsets.only(left: 12, right: 6) : null,
              child: Text.rich(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                ),
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Live(${upData.liveUsers?.count ?? 0})',
                    ),
                    if (!isTop) ...[
                      const TextSpan(text: '\n'),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          controller.showLiveUp
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ] else
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          controller.showLiveUp
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left,
                          color: theme.colorScheme.primary,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (controller.showLiveUp && liveList?.isNotEmpty == true)
          SliverList.builder(
            itemCount: liveList!.length,
            itemBuilder: (context, index) {
              return upItemBuild(theme, liveList[index]);
            },
          ),
        SliverToBoxAdapter(
          child: upItemBuild(theme, UpItem(face: '', uname: '全部动态', mid: -1)),
        ),
        SliverToBoxAdapter(
          child: Obx(
            () => upItemBuild(
              theme,
              UpItem(
                uname: '我',
                face: accountService.face.value,
                mid: accountService.mid,
              ),
            ),
          ),
        ),
        if (upList.isNotEmpty)
          SliverList.builder(
            itemCount: upList.length,
            itemBuilder: (context, index) {
              return upItemBuild(theme, upList[index]);
            },
          ),
        if (!isTop) const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }

  void _onSelect(UpItem data) {
    controller
      ..currentMid = data.mid
      ..onSelectUp(data.mid);

    data.hasUpdate = false;

    setState(() {});
  }

  Widget upItemBuild(ThemeData theme, UpItem data) {
    final currentMid = controller.currentMid;
    final isLive = data is LiveUserItem;
    bool isCurrent = isLive || currentMid == data.mid || currentMid == -1;

    final isAll = data.mid == -1;
    void toMemberPage() => Get.toNamed('/member?mid=${data.mid}');

    return SizedBox(
      height: 76,
      width: isTop ? 70 : null,
      child: InkWell(
        onTap: () {
          feedBack();
          switch (data) {
            case LiveUserItem():
              PageUtils.toLiveRoom(data.roomId);
            case UpItem():
              _onSelect(data);
              break;
          }
        },
        // onDoubleTap: isLive ? () => _onSelect(data) : null,
        onLongPress: !isAll ? toMemberPage : null,
        onSecondaryTap: !isAll && !Utils.isMobile ? toMemberPage : null,
        child: AnimatedOpacity(
          opacity: isCurrent ? 1 : 0.6,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: data.face != ''
                        ? NetworkImgLayer(
                            width: 38,
                            height: 38,
                            src: data.face,
                            type: ImageType.avatar,
                          )
                        : const CircleAvatar(
                            backgroundColor: Color(0xFF5CB67B),
                            backgroundImage: AssetImage(
                              'assets/images/logo/logo.png',
                            ),
                          ),
                  ),
                  Positioned(
                    top: isLive && !isTop ? -5 : 0,
                    right: isLive ? -6 : 4,
                    child: Badge(
                      smallSize: 8,
                      label: isLive ? const Text(' Live ') : null,
                      textColor: theme.colorScheme.onSecondaryContainer,
                      alignment: AlignmentDirectional.topStart,
                      isLabelVisible: isLive || (data.hasUpdate ?? false),
                      backgroundColor: isLive
                          ? theme.colorScheme.secondaryContainer.withValues(
                              alpha: 0.75,
                            )
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  isTop ? '${data.uname}\n' : data.uname!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: currentMid == data.mid
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    height: 1.1,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
