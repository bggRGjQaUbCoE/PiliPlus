import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/utils/page_utils.dart';

Future<void> openDownloadEntry({
  required BiliDownloadEntryInfo entry,
  DownloadVideoPlayContext? playContext,
}) async {
  final future = PageUtils.toVideoPage(
    aid: entry.avid,
    cid: entry.cid,
    cover: entry.cover,
    title: entry.showTitle,
    isVertical: entry.pageData?.isVertical ?? false,
    extraArguments: {
      'sourceType': SourceType.file,
      'entry': entry,
      'dirPath': entry.entryDirPath,
      ...?playContext?.toArguments(),
    },
  );
  if (future != null) {
    await future;
  }
}
