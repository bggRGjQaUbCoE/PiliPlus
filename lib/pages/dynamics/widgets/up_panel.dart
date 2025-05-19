import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
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
  List<UpItem>? get upList => widget.dynamicsController.upData.value.upList;
  List<LiveUserItem>? get liveList =>
      widget.dynamicsController.upData.value.liveUsers?.items;
  late final isTop =
      widget.dynamicsController.upPanelPosition == UpPanelPosition.top;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!widget.dynamicsController.isLogin.value) {
      return const SizedBox.shrink();
    }
    return CustomScrollView(
      scrollDirection: isTop ? Axis.horizontal : Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: widget.dynamicsController.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {
              setState(() {
                widget.dynamicsController.showLiveItems =
                    !widget.dynamicsController.showLiveItems;
              });
            },
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
                      text:
                          'Live(${widget.dynamicsController.upData.value.liveUsers?.count ?? "0"})',
                    ),
                    if (!isTop) ...[
                      const TextSpan(text: '\n'),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          widget.dynamicsController.showLiveItems
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
                          widget.dynamicsController.showLiveItems
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
        if (widget.dynamicsController.showLiveItems &&
            liveList?.isNotEmpty == true)
          SliverList.builder(
            itemCount: liveList!.length,
            itemBuilder: (context, index) {
              return upItemBuild(theme, liveList![index]);
            },
          ),
        SliverToBoxAdapter(
          child: upItemBuild(theme, UpItem(face: '', uname: '全部动态', mid: -1)),
        ),
        SliverToBoxAdapter(
          child: upItemBuild(
            theme,
            UpItem(
              uname: '我',
              face: widget.dynamicsController.face,
              mid: widget.dynamicsController.ownerMid,
            ),
          ),
        ),
        if (upList?.isNotEmpty == true)
          SliverList.builder(
            itemCount: upList!.length,
            itemBuilder: (context, index) {
              return upItemBuild(theme, upList![index]);
            },
          ),
        if (!isTop) const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }

  Widget upItemBuild(theme, data) {
    bool isCurrent = widget.dynamicsController.currentMid == data.mid ||
        widget.dynamicsController.currentMid == -1;
    return SizedBox(
      height: 76,
      width: isTop ? 70 : null,
      child: InkWell(
        onTap: () {
          feedBack();
          if (data.type == 'up') {
            widget.dynamicsController.currentMid = data.mid;
            widget.dynamicsController
              ..upInfo.value = data
              ..onSelectUp(data.mid);

            data.hasUpdate = false;

            setState(() {});
          } else if (data.type == 'live') {
            Get.toNamed('/liveRoom?roomid=${data.roomId}');
          }
        },
        onLongPress: () {
          if (data.mid == -1) {
            return;
          }
          String heroTag = Utils.makeHeroTag(data.mid);
          Get.toNamed('/member?mid=${data.mid}',
              arguments: {'face': data.face, 'heroTag': heroTag});
        },
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
                    top: data.type == 'live' && !isTop ? -5 : 0,
                    right: data.type == 'live' ? -6 : 4,
                    child: Badge(
                      smallSize: 8,
                      label: data.type == 'live' ? const Text(' Live ') : null,
                      textColor: theme.colorScheme.onSecondaryContainer,
                      alignment: AlignmentDirectional.topStart,
                      isLabelVisible: data.type == 'live' ||
                          (data.type == 'up' && (data.hasUpdate ?? false)),
                      backgroundColor: data.type == 'live'
                          ? theme.colorScheme.secondaryContainer
                              .withValues(alpha: 0.75)
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  isTop ? '${data.uname}\n' : data.uname,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.dynamicsController.currentMid == data.mid
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
