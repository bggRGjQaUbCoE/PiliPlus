import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_info.dart';
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
  Future<bool> onUpdate(
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  ) async {
    if (checkUpdateCount(multiSelectCtr.checkedCount)) return false;

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

    return isSuccess;
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

  Future<void> updatePageDm(DownloadPageInfo pageInfo) => updatePage(
    pageInfo,
    (e) => downloadService.downloadDanmaku(entry: e, isUpdate: true),
  );

  Future<void> updatePageSeg(DownloadPageInfo pageInfo) =>
      updatePage(pageInfo, downloadService.updateSegments);

  Future<void> updatePageVolume(DownloadPageInfo pageInfo) =>
      updatePage(pageInfo, downloadService.updateVolume);

  Future<void> updatePagePlayInfo(DownloadPageInfo pageInfo) =>
      updatePage(pageInfo, downloadService.updatePlayInfo);

  Future<void> updatePageSeasonInfo(DownloadPageInfo pageInfo) => updatePage(
    pageInfo,
    downloadService.updateSeasonInfo,
  ).then(downloadService.refreshIfUpdated);

  Future<bool> updatePage(
    DownloadPageInfo pageInfo,
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  ) async {
    if (checkUpdateCount(pageInfo.entries.length)) return false;

    bool dismiss = false;
    SmartDialog.showLoading(onDismiss: () => dismiss = true);

    bool isSuccess = true;
    for (final chunk in pageInfo.entries.mapChunked(
      kUpdateConcurrency,
      toElement,
    )) {
      final res = await Future.wait(chunk);
      if (res.any((e) => !e)) isSuccess = false;
      if (dismiss) break;
    }

    toastUpdateResult(dismiss, isSuccess);

    return isSuccess;
  }

  Future<bool> onUpdate(
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  );

  void _onUpdateDm() {
    onUpdate((e) => downloadService.downloadDanmaku(entry: e, isUpdate: true));
  }

  void _onUpdateSeg() => onUpdate(downloadService.updateSegments);

  void _onUpdateVolume() => onUpdate(downloadService.updateVolume);

  void _onUpdateSeasonInfo() =>
      onUpdate(downloadService.updateSeasonInfo)
          .then(downloadService.refreshIfUpdated);

  void _onUpdatePlayInfo() => onUpdate(downloadService.updatePlayInfo);

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
        PopupMenuItem(
          onTap: _onUpdateSeasonInfo,
          child: const Text('更新合集信息'),
        ),
        PopupMenuItem(
          onTap: _onUpdateVolume,
          child: const Text('更新音量均衡'),
        ),
        PopupMenuItem(
          onTap: _onUpdatePlayInfo,
          child: const Text('更新字幕、分段信息'),
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
