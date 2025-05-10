import 'package:PiliPlus/common/skeleton/whisper_item.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/app/im/v1.pb.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/whisper/controller.dart';
import 'package:PiliPlus/pages/whisper/widgets/item.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperPage extends StatefulWidget {
  const WhisperPage({super.key});

  @override
  State<WhisperPage> createState() => _WhisperPageState();
}

class _WhisperPageState extends State<WhisperPage> {
  final _controller = Get.put(WhisperController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
        actions: [
          Obx(() {
            if (_controller.outsideItem.value?.isNotEmpty == true) {
              return Row(
                  children: _controller.outsideItem.value!.map((e) {
                return IconButton(
                  tooltip: e.hasTitle() ? e.title : null,
                  onPressed: () {
                    e.type.action(
                      context: context,
                      controller: _controller,
                    );
                  },
                  icon: Icon(size: 20, e.type.icon),
                );
              }).toList());
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (_controller.threeDotItems.value?.isNotEmpty == true) {
              return PopupMenuButton(
                itemBuilder: (context) {
                  return _controller.threeDotItems.value!
                      .map((e) => PopupMenuItem(
                            onTap: () {
                              e.type.action(
                                context: context,
                                controller: _controller,
                              );
                            },
                            child: Row(
                              children: [
                                Icon(size: 17, e.type.icon),
                                Text('  ${e.title}'),
                              ],
                            ),
                          ))
                      .toList();
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildTopItems,
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 100,
              ),
              sliver: Obx(() => _buildBody(_controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<Session>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const WhisperItemSkeleton();
          },
        ),
      Success(:var response) => response?.isNotEmpty == true
          ? SliverList.separated(
              itemCount: response!.length,
              itemBuilder: (context, index) {
                if (index == response.length - 1) {
                  _controller.onLoadMore();
                }
                return WhisperSessionItem(
                  item: response[index],
                  onSetTop: (isTop, id) =>
                      _controller.onSetTop(index, isTop, id),
                  onRemove: (talkerId) => _controller.onRemove(index, talkerId),
                );
              },
              separatorBuilder: (context, index) => Divider(
                indent: 72,
                endIndent: 20,
                height: 1,
                color: Colors.grey.withOpacity(0.1),
              ),
            )
          : HttpError(
              onReload: _controller.onReload,
            ),
      Error(:var errMsg) => HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        ),
    };
  }

  Widget get _buildTopItems => SliverSafeArea(
        top: false,
        bottom: false,
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                List.generate(_controller.msgFeedTopItems.length, (index) {
              final ThemeData theme = Theme.of(context);
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
                          isLabelVisible: _controller.unreadCounts[index] > 0,
                          label: Text(" ${_controller.unreadCounts[index]} "),
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: theme.colorScheme.onInverseSurface,
                            child: Icon(
                              _controller.msgFeedTopItems[index].icon,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _controller.msgFeedTopItems[index].name,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (!_controller.msgFeedTopItems[index].enabled) {
                    SmartDialog.showToast('已禁用');
                    return;
                  }
                  _controller.unreadCounts[index] = 0;
                  Get.toNamed(
                    _controller.msgFeedTopItems[index].route,
                  );
                },
              );
            }).toList(),
          ),
        ),
      );
}
