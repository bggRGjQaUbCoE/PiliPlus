import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/detail/widgets/item.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadVideoSortPage extends StatefulWidget {
  const DownloadVideoSortPage({
    super.key,
    required this.title,
    required this.entries,
    required this.onSave,
  });

  final String title;
  final List<BiliDownloadEntryInfo> entries;
  final Future<void> Function(List<int> cids) onSave;

  @override
  State<DownloadVideoSortPage> createState() => _DownloadVideoSortPageState();
}

class _DownloadVideoSortPageState extends State<DownloadVideoSortPage> {
  final _downloadService = Get.find<DownloadService>();
  final _controller = _NoopMultiSelect();
  late final List<BiliDownloadEntryInfo> _sortList =
      List<BiliDownloadEntryInfo>.from(widget.entries);

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _sortList.removeAt(oldIndex);
    _sortList.insert(newIndex, item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () async {
              await widget.onSave(_sortList.map((item) => item.cid).toList());
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
        itemCount: _sortList.length,
        onReorder: _onReorder,
        physics: const AlwaysScrollableScrollPhysics(),
        padding:
            MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
            const EdgeInsets.only(bottom: 100),
        itemBuilder: (context, index) {
          final entry = _sortList[index];
          return SizedBox(
            key: Key(entry.cid.toString()),
            height: 100,
            child: DetailItem(
              entry: entry,
              downloadService: _downloadService,
              showTitle: true,
              onDelete: () {},
              controller: _controller,
              enableTap: false,
              showMoreButton: false,
            ),
          );
        },
      ),
    );
  }
}

class _NoopMultiSelect implements MultiSelectBase<BiliDownloadEntryInfo> {
  @override
  final RxBool enableMultiSelect = false.obs;

  @override
  int get checkedCount => 0;

  @override
  void handleSelect({bool checked = false, bool disableSelect = true}) {}

  @override
  void onRemove() {}

  @override
  void onSelect(BiliDownloadEntryInfo item) {}
}
