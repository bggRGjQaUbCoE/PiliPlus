import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/page/view.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart';

class SeasonInfoItem extends StatelessWidget {
  const SeasonInfoItem({
    super.key,
    required this.controller,
    required this.downloadService,
    required this.season,
    required this.seasonInfo,
    required this.enableMultiSelect,
    required this.progress,
    required this.updateSeasonDm,
  });

  final BaseMultiSelectMixin<DownloadSeasonInfo> controller;
  final DownloadService downloadService;
  final DownloadSeasonInfo season;
  final SeasonInfo seasonInfo;
  final bool enableMultiSelect;
  final ChangeNotifier progress;
  final ValueChanged<DownloadSeasonInfo> updateSeasonDm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    void onLongPress() => enableMultiSelect
        ? null
        : showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              clipBehavior: Clip.hardEdge,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                DialogOption(
                  onPressed: () {
                    Get.back();
                    showConfirmDialog(
                      context: context,
                      title: const Text('确定删除？'),
                      onConfirm: () async {
                        for (final pageInfo in season.pages) {
                          await GStorage.watchProgress.deleteAll(
                            pageInfo.entries.map((e) => e.cid.toString()),
                          );
                          downloadService.deletePage(
                            pageDirPath: pageInfo.dirPath,
                          );
                        }
                      },
                    );
                  },
                  child: const Text('删除', style: TextStyle(fontSize: 14)),
                ),
                DialogOption(
                  onPressed: () {
                    Get.back();
                    updateSeasonDm(season);
                  },
                  child: const Text('更新弹幕', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (controller.enableMultiSelect.value) {
            controller.onSelect(season);
            return;
          }
          Get.to(
            DownloadPagePage(
              seasonInfo: seasonInfo,
              progress: progress,
            ),
          );
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Style.safeSpace,
            vertical: 5,
          ),
          child: Row(
            spacing: 10,
            children: [
              Stack(
                clipBehavior: .none,
                children: [
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) => NetworkImgLayer(
                        src: seasonInfo.cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                  const PBadge(text: '合集', top: 6.0, right: 6.0),
                  PBadge(
                    text:
                        '${season.pages.fold(0, (a, b) => a + b.entries.length)}个视频',
                    right: 6.0,
                    bottom: 6.0,
                    isBold: false,
                    type: .gray,
                  ),
                  Positioned.fill(
                    child: selectMask(colorScheme, season.checked),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        seasonInfo.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          height: 1.42,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: .end,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          seasonInfo.uname,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: colorScheme.outline,
                          ),
                        ),
                        // pageInfo.entries.first.moreBtn(colorScheme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
