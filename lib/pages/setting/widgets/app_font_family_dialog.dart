import 'package:PiliPlus/models/common/app_font_family.dart';
import 'package:PiliPlus/services/app_font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppFontFamilyDialog extends StatelessWidget {
  const AppFontFamilyDialog({
    super.key,
    required this.value,
  });

  final AppFontFamily value;

  static String _sizeLabel(AppFontFamily font) =>
      '${(font.downloadSize! / (1024 * 1024)).toStringAsFixed(1)} MB';

  Future<void> _download(BuildContext context, AppFontFamily font) async {
    try {
      await AppFontManager.download(font);
      if (context.mounted) {
        SmartDialog.showToast('${font.label}下载完成');
      }
    } catch (error) {
      if (context.mounted) {
        SmartDialog.showToast(error.toString());
      }
    }
  }

  void _select(BuildContext context, AppFontFamily font) {
    if (AppFontManager.isDownloaded(font)) {
      Navigator.of(context).pop(font);
    }
  }

  Widget _buildTile(
    BuildContext context,
    AppFontFamily font, [
    AppFontDownloadProgress? progress,
  ]) {
    final downloaded = AppFontManager.isDownloaded(font);
    final progressValue = progress == null || progress.total <= 0
        ? null
        : progress.received / progress.total;
    final subtitle = font.isSystem
        ? null
        : progress != null
        ? progress.total > 0
              ? '正在下载 ${(progressValue! * 100).round()}%'
              : '正在连接 GitHub'
        : downloaded
        ? '已下载 · ${_sizeLabel(font)}'
        : _sizeLabel(font);

    Widget? trailing;
    if (!font.isSystem) {
      trailing = SizedBox.square(
        dimension: 40,
        child: progress != null
            ? Center(
                child: SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : downloaded
            ? Tooltip(
                message: '已下载',
                child: Icon(
                  Icons.download_done_rounded,
                  color: ColorScheme.of(context).primary,
                ),
              )
            : IconButton(
                tooltip: '下载字体',
                onPressed: () => _download(context, font),
                icon: const Icon(Icons.download_rounded),
              ),
      );
    }

    return ListTile(
      dense: true,
      leading: Radio<AppFontFamily>(
        value: font,
        enabled: downloaded,
      ),
      title: Text(
        font.label,
        style: TextTheme.of(context).titleMedium,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: trailing,
      onTap: downloaded ? () => _select(context, font) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: const Text('App字体'),
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 380),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: RadioGroup<AppFontFamily>(
            groupValue: value,
            onChanged: (font) {
              if (font != null) _select(context, font);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppFontFamily.values
                  .map((font) {
                    if (font.isSystem) return _buildTile(context, font);
                    return ValueListenableBuilder(
                      valueListenable: AppFontManager.downloadProgressOf(font),
                      builder: (context, progress, _) =>
                          _buildTile(context, font, progress),
                    );
                  })
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}
