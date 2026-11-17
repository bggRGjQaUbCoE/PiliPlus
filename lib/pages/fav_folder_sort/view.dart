import 'package:PiliPlus/common/widgets/reorder_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/fav/video/controller.dart';
import 'package:PiliPlus/pages/fav/video/widgets/item.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class FavFolderSortPage extends StatefulWidget {
  const FavFolderSortPage({super.key, required this.favController});

  final FavController favController;

  @override
  State<FavFolderSortPage> createState() => _FavFolderSortPageState();
}

class _FavFolderSortPageState extends State<FavFolderSortPage>
    with ReorderMixin {
  FavController get _favController => widget.favController;
  bool _saving = false;
  bool _dragging = false;

  late List<FavFolderInfo> sortList = List<FavFolderInfo>.from(
    _favController.loadingState.value.data!,
  );

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('收藏夹排序'),
        actions: [
          TextButton(
            onPressed: _saving || _dragging ? null : _save,
            child: Text(_saving ? '保存中…' : '完成'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody,
    );
  }

  Future<void> _save() async {
    if (_saving || _dragging) return;
    setState(() => _saving = true);
    final order = List<FavFolderInfo>.of(sortList);
    try {
      final result = await FavHttp.sortFavFolder(
        sort: order.map((item) => item.id).join(','),
      );
      if (result.isSuccess) {
        if (!_favController.isClosed) {
          _favController.loadingState.value = Success(order);
        }
        SmartDialog.showToast('排序完成');
        if (mounted && ModalRoute.of(context)?.isCurrent == true) Get.back();
      } else {
        result.toast();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void onReorderItem(int oldIndex, int newIndex) {
    if (oldIndex == 0 || newIndex == 0) {
      SmartDialog.showToast('默认收藏夹不支持排序');
      return;
    }

    sortList.insert(newIndex, sortList.removeAt(oldIndex));

    setState(() {});
  }

  Widget get _buildBody {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      onReorderStart: (_) => setState(() => _dragging = true),
      onReorderEnd: (_) => setState(() => _dragging = false),
      onReorderItem: onReorderItem,
      proxyDecorator: proxyDecorator,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sortList.length,
      padding:
          MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
          const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        final item = sortList[index];
        final key = item.id.toString();
        final child = SizedBox(
          height: 110,
          child: FavVideoItem(
            heroTag: key,
            item: item,
            onLongPress: index == 0
                ? () => SmartDialog.showToast('默认收藏夹不支持排序')
                : null,
          ),
        );
        return index == 0 || _saving
            ? KeyedSubtree(key: ValueKey(item.id), child: child)
            : ReorderableDelayedDragStartListener(
                key: ValueKey(item.id),
                index: index,
                child: child,
              );
      },
    );
  }
}
