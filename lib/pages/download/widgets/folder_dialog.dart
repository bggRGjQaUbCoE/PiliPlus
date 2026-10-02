import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:material_ui/material_ui.dart';

Future<String?> showDownloadFolderNameDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
}) async {
  final controller = TextEditingController(text: initialValue);
  final value = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 1,
        maxLength: 30,
        decoration: const InputDecoration(
          hintText: '请输入文件夹名称',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isEmpty) {
              return;
            }
            Navigator.of(dialogContext).pop(text);
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
  controller.dispose();
  return value;
}

Future<List<String>?> showDownloadFolderPickerDialog({
  required BuildContext context,
  required DownloadCollectionService collectionService,
  String title = '添加到文件夹',
  Iterable<String> initialSelectedIds = const <String>[],
}) async {
  await collectionService.waitForInitialization;
  if (!context.mounted) {
    return null;
  }
  final selectedIds = initialSelectedIds.toSet();
  final result = await showDialog<List<String>>(
    context: context,
    builder: (dialogContext) {
      var folders = collectionService.folders;
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SizedBox(
              width: double.maxFinite,
              child: folders.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('还没有文件夹，先新建一个吧。'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: folders
                            .map(
                              (folder) => CheckboxListTile(
                                dense: true,
                                value: selectedIds.contains(folder.id),
                                title: Text(folder.title),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  if (value == true) {
                                    selectedIds.add(folder.id);
                                  } else {
                                    selectedIds.remove(folder.id);
                                  }
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = await showDownloadFolderNameDialog(
                  context: dialogContext,
                  title: '新建文件夹',
                  initialValue: collectionService.buildDefaultFolderTitle(),
                );
                if (name == null) {
                  return;
                }
                final folder = await collectionService.createFolder(name);
                folders = collectionService.folders;
                selectedIds.add(folder.id);
                setState(() {});
              },
              child: const Text('新建文件夹'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(selectedIds.toList()),
              child: const Text('完成'),
            ),
          ],
        ),
      );
    },
  );
  return result;
}

extension DownloadFolderListExt on List<DownloadFolder> {
  DownloadFolder? byId(String id) {
    for (final item in this) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
