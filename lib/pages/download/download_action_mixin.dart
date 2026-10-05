import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

const kUpdateConcurrency = 10;

const kMaxUpdateCount = 1000;
bool checkUpdateCount(int count) {
  switch (count) {
    case 0:
      return true;
    case > kMaxUpdateCount:
      SmartDialog.showToast('数量超过$kMaxUpdateCount');
      return true;
  }
  return false;
}

void toastUpdateResult(bool dismiss, bool isSuccess) {
  if (dismiss) {
    SmartDialog.showToast('已取消');
  } else if (isSuccess) {
    SmartDialog.showToast('更新成功');
  } else {
    SmartDialog.showToast('更新失败');
  }
  SmartDialog.dismiss();
}

mixin CommonDownloadActionMixin<T extends StatefulWidget>
    on BaseDownloadActionMixin<T, BiliDownloadEntryInfo> {
  @override
  Future<void> onUpdate(
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  ) async {
    if (checkUpdateCount(multiSelectCtr.checkedCount)) return;

    bool dismiss = false;
    SmartDialog.showLoading(
      onDismiss: () {
        dismiss = true;
        multiSelectCtr.handleSelect();
      },
    );

    bool isSuccess = true;
    for (final chunk in multiSelectCtr.allChecked.mapChunked(
      kUpdateConcurrency,
      toElement,
    )) {
      final res = await Future.wait(chunk);
      if (res.any((e) => !e)) isSuccess = false;
      if (dismiss) break;
    }

    toastUpdateResult(dismiss, isSuccess);
  }
}

mixin BaseDownloadActionMixin<
  T extends StatefulWidget,
  E extends MultiSelectData
>
    on State<T> {
  late ColorScheme colorScheme;
  DownloadService get downloadService;
  BaseMultiSelectMixin<E> get multiSelectCtr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  void onUpdate(
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  );

  void _onUpdateDm() {
    onUpdate((e) => downloadService.downloadDanmaku(entry: e, isUpdate: true));
  }

  void _onUpdateSeg() {
    onUpdate(downloadService.updateSegments);
  }

  void _showUpdateMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: PageUtils.menuPosition(
        renderBox.localToGlobal(renderBox.size.bottomLeft(.zero)),
      ),
      items: [
        PopupMenuItem(
          onTap: _onUpdateDm,
          child: const Text('更新弹幕'),
        ),
        PopupMenuItem(
          onTap: _onUpdateSeg,
          child: const Text('更新片段'),
        ),
      ],
    );
  }

  Widget updateBtn() {
    return Builder(
      builder: (context) => TextButton(
        style: TextButton.styleFrom(visualDensity: .compact),
        onPressed: () => _showUpdateMenu(context),
        child: Text('更新', style: TextStyle(color: colorScheme.onSurface)),
      ),
    );
  }
}
