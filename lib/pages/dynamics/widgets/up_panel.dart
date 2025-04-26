import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/utils.dart';

class UpPanel extends StatefulWidget {
  final DynamicsController dynamicsController;
  const UpPanel({
    required this.dynamicsController,
    super.key,
  });

  @override
  State<UpPanel> createState() => _UpPanelState();
}

class _UpPanelState extends State<UpPanel> {
  List<UpItem> get upList =>
      widget.dynamicsController.upData.value.upList ?? <UpItem>[];
  List<LiveUserItem> get liveList =>
      widget.dynamicsController.upData.value.liveUsers?.items ??
      <LiveUserItem>[];

  @override
  Widget build(BuildContext context) {
    if (widget.dynamicsController.isLogin.value.not) {
      return const SizedBox.shrink();
    }
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: widget.dynamicsController.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 45,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Live(${liveList.length})',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    semanticsLabel:
                        '${widget.dynamicsController.showLiveItems ? '展开' : '收起'}直播中的${liveList.length}个Up',
                  ),
                  Icon(
                    widget.dynamicsController.showLiveItems
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 12,
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  widget.dynamicsController.showLiveItems =
                      !widget.dynamicsController.showLiveItems;
                });
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (widget.dynamicsController.showLiveItems && liveList.isNotEmpty)
          SliverList.builder(
            itemCount: liveList.length,
            itemBuilder: (context, index) {
              return upItemBuild(liveList[index]);
            },
          ),
        SliverToBoxAdapter(
          child: upItemBuild(UpItem(face: '', uname: '全部动态', mid: -1)),
        ),
        SliverToBoxAdapter(
          child: upItemBuild(
            UpItem(
              uname: '我',
              face: widget.dynamicsController.face,
              mid: widget.dynamicsController.ownerMid,
            ),
          ),
        ),
        if (upList.isNotEmpty)
          SliverList.builder(
            itemCount: upList.length,
            itemBuilder: (context, index) {
              return upItemBuild(upList[index]);
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }

  Widget upItemBuild(data) {
    bool isCurrent = widget.dynamicsController.currentMid == data.mid ||
        widget.dynamicsController.currentMid == -1;
    return SizedBox(
      height: 76,
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
                            type: 'avatar',
                          )
                        : const CircleAvatar(
                            backgroundColor: Color(0xFF5CB67B),
                            backgroundImage: AssetImage(
                              'assets/images/logo/logo.png',
                            ),
                          ),
                  ),
                  Positioned(
                    top: data.type == 'live' ? -5 : 0,
                    right: data.type == 'live' ? -6 : 4,
                    child: Badge(
                      smallSize: 8,
                      label: data.type == 'live' ? const Text(' Live ') : null,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      alignment: AlignmentDirectional.topStart,
                      isLabelVisible: data.type == 'live' ||
                          (data.type == 'up' && (data.hasUpdate ?? false)),
                      backgroundColor: data.type == 'live'
                          ? Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.75)
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  data.uname,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.dynamicsController.currentMid == data.mid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
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

class UpPanelSkeleton extends StatelessWidget {
  const UpPanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 45,
          height: 12,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ],
    );
  }
}
