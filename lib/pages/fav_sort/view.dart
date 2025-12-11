import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavSortPage extends StatefulWidget {
  const FavSortPage({super.key, required this.favDetailController});

  final FavDetailController favDetailController;

  @override
  State<FavSortPage> createState() => _FavSortPageState();
}

class _FavSortPageState extends State<FavSortPage> {
  FavDetailController get _favDetailController => widget.favDetailController;

  final GlobalKey _key = GlobalKey();
  late List<FavDetailItemModel> sortList = List<FavDetailItemModel>.from(
    _favDetailController.loadingState.value.data!,
  );
  List<String> sort = <String>[];

  void onLoadMore() {
    if (_favDetailController.isEnd) {
      return;
    }
    _favDetailController.onLoadMore().whenComplete(() {
      try {
        if (_favDetailController.loadingState.value.isSuccess) {
          List<FavDetailItemModel> list =
              _favDetailController.loadingState.value.data!;
          sortList.addAll(list.skip(sortList.length));
          if (mounted) {
            setState(() {});
          }
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('排序: ${_favDetailController.folderInfo.value.title}'),
        actions: [
          TextButton(
            onPressed: () async {
              if (sort.isEmpty) {
                Get.back();
                return;
              }
              var res = await FavHttp.sortFav(
                mediaId: _favDetailController.mediaId,
                sort: sort.join(','),
              );
              if (res.isSuccess) {
                SmartDialog.showToast('排序完成');
                _favDetailController.loadingState.value = Success(sortList);
                Get.back();
              } else {
                res.toast();
              }
            },
            child: const Text('完成'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final oldItem = sortList[oldIndex];
    final newItem = sortList.getOrNull(
      oldIndex > newIndex ? newIndex - 1 : newIndex,
    );
    sort.add(
      '${newItem == null ? '0:0' : '${newItem.id}:${newItem.type}'}:${oldItem.id}:${oldItem.type}',
    );

    final tabsItem = sortList.removeAt(oldIndex);
    sortList.insert(newIndex, tabsItem);

    setState(() {});
  }

  Widget get _buildBody {
    final child = ReorderableListView.builder(
      key: _key,
      onReorder: onReorder,
      physics: const AlwaysScrollableScrollPhysics(),
      padding:
          MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
          const EdgeInsets.only(bottom: 100),
      itemCount: sortList.length,
      itemBuilder: (context, index) {
        final item = sortList[index];
        return SizedBox(
          key: Key(item.id.toString()),
          height: 98,
          child: FavVideoCardH(item: item),
        );
      },
    );
    if (!_favDetailController.isEnd) {
      return NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 300) {
            onLoadMore();
          }
          return false;
        },
        child: child,
      );
    }
    return child;
  }
}
