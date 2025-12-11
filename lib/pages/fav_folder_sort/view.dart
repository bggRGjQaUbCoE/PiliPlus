import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/fav/video/controller.dart';
import 'package:PiliPlus/pages/fav/video/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavFolderSortPage extends StatefulWidget {
  const FavFolderSortPage({super.key, required this.favController});

  final FavController favController;

  @override
  State<FavFolderSortPage> createState() => _FavFolderSortPageState();
}

class _FavFolderSortPageState extends State<FavFolderSortPage> {
  FavController get _favController => widget.favController;

  final GlobalKey _key = GlobalKey();
  late List<FavFolderInfo> sortList = List<FavFolderInfo>.from(
    _favController.loadingState.value.data!,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('收藏夹排序'),
        actions: [
          TextButton(
            onPressed: () async {
              var res = await FavHttp.sortFavFolder(
                sort: sortList.map((item) => item.id).join(','),
              );
              if (res.isSuccess) {
                SmartDialog.showToast('排序完成');
                _favController.loadingState.value = Success(sortList);
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
    if (oldIndex == 0 || newIndex == 0) {
      SmartDialog.showToast('默认收藏夹不支持排序');
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final tabsItem = sortList.removeAt(oldIndex);
    sortList.insert(newIndex, tabsItem);

    setState(() {});
  }

  Widget get _buildBody {
    return ReorderableListView.builder(
      key: _key,
      onReorder: onReorder,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sortList.length,
      padding:
          MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
          const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        final item = sortList[index];
        final key = item.id.toString();
        return SizedBox(
          key: Key(key),
          height: 98,
          child: FavVideoItem(
            heroTag: key,
            item: item,
            onLongPress: index == 0
                ? () => SmartDialog.showToast('默认收藏夹不支持排序')
                : null,
          ),
        );
      },
    );
  }
}
