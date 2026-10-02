import 'dart:io';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as path;

class DownloadFolderCard extends StatelessWidget {
  const DownloadFolderCard({
    super.key,
    required this.title,
    required this.count,
    this.entry,
    this.onTap,
    this.onLongPress,
    this.trailing,
    this.checked = false,
  });

  final String title;
  final int count;
  final BiliDownloadEntryInfo? entry;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: Style.aspectRatio,
                child: LayoutBuilder(
                  builder: (context, boxConstraints) => ClipRRect(
                    borderRadius: Style.mdRadius,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildCover(
                          context,
                          boxConstraints.maxWidth,
                          boxConstraints.maxHeight,
                        ),
                        selectMask(ColorScheme.of(context), checked),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(letterSpacing: 0.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count 个视频',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      count == 0 ? '空文件夹' : '本地离线缓存',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context, double width, double height) {
    if (entry case final entry?) {
      final coverFile = File(path.join(entry.entryDirPath, PathUtils.coverName));
      if (coverFile.existsSync()) {
        return Image.file(
          coverFile,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
      return NetworkImgLayer(
        src: entry.cover,
        width: width,
        height: height,
      );
    }
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondaryContainer,
            theme.colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.folder_outlined,
        size: 34,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
