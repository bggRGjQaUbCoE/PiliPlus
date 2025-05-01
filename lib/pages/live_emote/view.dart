import 'dart:math';

import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/live/live_emoticons/datum.dart';
import 'package:PiliPlus/models/live/live_emoticons/emoticon.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/network_img_layer.dart';
import 'controller.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';

class LiveEmotePanel extends StatefulWidget {
  final int roomId;
  final ValueChanged<LiveEmoticon> onChoose;
  final ValueChanged<LiveEmoticon> onSendEmoticonUnique;
  const LiveEmotePanel({
    super.key,
    required this.roomId,
    required this.onChoose,
    required this.onSendEmoticonUnique,
  });

  @override
  State<LiveEmotePanel> createState() => _LiveEmotePanelState();
}

class _LiveEmotePanelState extends State<LiveEmotePanel>
    with AutomaticKeepAliveClientMixin {
  late final LiveEmotePanelController _emotePanelController = Get.put(
    LiveEmotePanelController(widget.roomId),
    tag: widget.roomId.toString(),
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => _buildBody(_emotePanelController.loadingState.value));
  }

  Widget _buildBody(LoadingState<List<LiveEmoteDatum>?> loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => loadingState.response?.isNotEmpty == true
          ? Column(
              children: [
                Expanded(
                  child: tabBarView(
                    controller: _emotePanelController.tabController,
                    children: loadingState.response!.map(
                      (item) {
                        if (item.emoticons.isNullOrEmpty) {
                          return const SizedBox.shrink();
                        }
                        double widthFac =
                            max(1, item.emoticons!.first.width! / 80);
                        double heightFac =
                            max(1, item.emoticons!.first.height! / 80);
                        return GridView.builder(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: widthFac * 40,
                            mainAxisExtent: heightFac * 40,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: item.emoticons!.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  if (item.pkgType == 3) {
                                    widget.onChoose(item.emoticons![index]);
                                  } else {
                                    widget.onSendEmoticonUnique(
                                      item.emoticons![index],
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: NetworkImgLayer(
                                    boxFit: BoxFit.contain,
                                    src: item.emoticons![index].url!,
                                    width: widthFac * 38,
                                    height: heightFac * 38,
                                    type: 'emote',
                                    quality: item.pkgType == 3 ? null : 80,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
                TabBar(
                  controller: _emotePanelController.tabController,
                  padding: const EdgeInsets.only(right: 60),
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  isScrollable: true,
                  tabs: loadingState.response!
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: NetworkImgLayer(
                            width: 24,
                            height: 24,
                            type: 'emote',
                            src: item.currentCover,
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            )
          : _errorWidget(),
      Error() => _errorWidget(loadingState.errMsg),
    };
  }

  Widget _errorWidget([String? errMsg]) => Center(
        child: TextButton.icon(
          onPressed: _emotePanelController.onReload,
          icon: Icon(Icons.refresh),
          label: Text(errMsg ?? '没有数据'),
        ),
      );
}
