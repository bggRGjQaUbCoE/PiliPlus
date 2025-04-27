import 'package:PiliPlus/common/skeleton/whisper_item.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/msg/session.dart';
import 'package:PiliPlus/pages/whisper/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'controller.dart';

class WhisperPage extends StatefulWidget {
  const WhisperPage({super.key});

  @override
  State<WhisperPage> createState() => _WhisperPageState();
}

class _WhisperPageState extends State<WhisperPage> {
  final _whisperController = Get.put(WhisperController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('消息')),
      body: refreshIndicator(
        onRefresh: () async {
          await _whisperController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildTopItems,
            Obx(() => _buildBody(_whisperController.loadingState.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<SessionList>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const WhisperItemSkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 100,
              ),
              sliver: SliverList.separated(
                itemCount: loadingState.response!.length,
                itemBuilder: (context, index) {
                  if (index == loadingState.response!.length - 1) {
                    _whisperController.onLoadMore();
                  }
                  return WhisperSessionItem(
                    item: loadingState.response![index],
                    onSetTop: (isTop, talkerId) =>
                        _whisperController.onSetTop(index, isTop, talkerId),
                    onRemove: (talkerId) =>
                        _whisperController.onRemove(index, talkerId),
                    onTap: () => _whisperController.onTap(index),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  indent: 72,
                  endIndent: 20,
                  height: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            )
          : HttpError(
              onReload: _whisperController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _whisperController.onReload,
        ),
    };
  }

  Widget get _buildTopItems => SliverSafeArea(
        top: false,
        bottom: false,
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_whisperController.msgFeedTopItems.length,
                (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Badge(
                          isLabelVisible:
                              _whisperController.unreadCounts[index] > 0,
                          label: Text(
                              " ${_whisperController.unreadCounts[index]} "),
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            child: Icon(
                              _whisperController.msgFeedTopItems[index]['icon'],
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _whisperController.msgFeedTopItems[index]['name'],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (!_whisperController.msgFeedTopItems[index]['enabled']) {
                    SmartDialog.showToast('已禁用');
                    return;
                  }
                  _whisperController.unreadCounts[index] = 0;
                  Get.toNamed(
                    _whisperController.msgFeedTopItems[index]['route'],
                  );
                },
              );
            }).toList(),
          ),
        ),
      );
}
