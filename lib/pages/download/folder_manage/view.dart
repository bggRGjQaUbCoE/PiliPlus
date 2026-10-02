import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/pages/download/widgets/folder_card.dart';
import 'package:PiliPlus/pages/download/widgets/folder_dialog.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadFolderManagePage extends StatefulWidget {
  const DownloadFolderManagePage({
    super.key,
    required this.collectionService,
  });

  final DownloadCollectionService collectionService;

  @override
  State<DownloadFolderManagePage> createState() =>
      _DownloadFolderManagePageState();
}

class _DownloadFolderManagePageState extends State<DownloadFolderManagePage> {
  late final List<DownloadFolder> _folders = List<DownloadFolder>.from(
    widget.collectionService.folders,
  );

  List<BiliDownloadEntryInfo> _entriesOf(String folderId) =>
      widget.collectionService.resolveFolderEntries(folderId);

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _folders.removeAt(oldIndex);
    _folders.insert(newIndex, item);
    setState(() {});
  }

  Future<void> _renameFolder(DownloadFolder folder) async {
    final name = await showDownloadFolderNameDialog(
      context: context,
      title: '重命名文件夹',
      initialValue: folder.title,
    );
    if (name == null || name == folder.title) {
      return;
    }
    await widget.collectionService.renameFolder(folder.id, name);
    folder.title = name;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteFolder(DownloadFolder folder) async {
    showConfirmDialog(
      context: context,
      title: const Text('确定删除该文件夹？'),
      content: const Text('只会删除文件夹关联，不会删除本地缓存文件。'),
      onConfirm: () async {
        await widget.collectionService.deleteFolder(folder.id);
        _folders.removeWhere((item) => item.id == folder.id);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('排序文件夹'),
        actions: [
          TextButton(
            onPressed: () async {
              await widget.collectionService.reorderFolders(
                _folders.map((item) => item.id).toList(),
              );
              if (mounted) {
                SmartDialog.showToast('排序完成');
                Get.back();
              }
            },
            child: const Text('完成'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: _folders.length,
        onReorder: _onReorder,
        physics: const AlwaysScrollableScrollPhysics(),
        padding:
            MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
            const EdgeInsets.only(bottom: 100),
        itemBuilder: (context, index) {
          final folder = _folders[index];
          final entries = _entriesOf(folder.id);
          return SizedBox(
            key: Key(folder.id),
            height: 100,
            child: DownloadFolderCard(
              title: folder.title,
              count: entries.length,
              entry: entries.firstOrNull,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: '重命名',
                    onPressed: () => _renameFolder(folder),
                    icon: const Icon(Icons.drive_file_rename_outline),
                  ),
                  IconButton(
                    tooltip: '删除',
                    onPressed: () => _deleteFolder(folder),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
