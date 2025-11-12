import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/video/introduction/local/controller.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class LocalIntroPanel extends StatefulWidget {
  const LocalIntroPanel({super.key, required this.heroTag});

  final String heroTag;

  @override
  State<LocalIntroPanel> createState() => _LocalIntroPanelState();
}

class _LocalIntroPanelState extends State<LocalIntroPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.find<LocalIntroController>(tag: widget.heroTag);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Obx(() {
      final currIndex = _controller.index.value;
      return SliverFixedExtentList.builder(
        itemCount: _controller.list.length,
        itemBuilder: (context, index) {
          final item = _controller.list[index];
          return _buildItem(theme, currIndex == index, index, item);
        },
        itemExtent: 100,
      );
    });
  }

  Widget _buildItem(
    ThemeData theme,
    bool isCurr,
    int index,
    BiliDownloadEntryInfo entry,
  ) {
    final outline = theme.colorScheme.outline;
    final cover = File(path.join(entry.entryDirPath, PathUtils.coverName));
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: SizedBox(
        height: 98,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              if (isCurr) {
                return;
              }
              _controller.playIndex(index, entry: entry);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StyleString.safeSpace,
                vertical: 5,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      cover.existsSync()
                          ? ClipRRect(
                              borderRadius: StyleString.mdRadius,
                              child: Image.file(
                                cover,
                                width: 140.8,
                                height: 88,
                                fit: BoxFit.cover,
                                cacheHeight: 140.8.cacheSize(context),
                                colorBlendMode: NetworkImgLayer.reduce
                                    ? BlendMode.modulate
                                    : null,
                                color: NetworkImgLayer.reduce
                                    ? NetworkImgLayer.reduceLuxColor
                                    : null,
                              ),
                            )
                          : NetworkImgLayer(
                              src: entry.cover,
                              width: 140.8,
                              height: 88,
                            ),
                      PBadge(
                        text: DurationUtils.formatDuration(
                          entry.totalTimeMilli ~/ 1000,
                        ),
                        right: 6.0,
                        bottom: 6.0,
                        type: PBadgeType.gray,
                      ),
                      if (entry.videoQuality case final videoQuality?)
                        PBadge(
                          text: VideoQuality.fromCode(videoQuality).shortDesc,
                          right: 6.0,
                          top: 6.0,
                          type: PBadgeType.gray,
                        ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: theme.textTheme.bodyMedium!.fontSize,
                                height: 1.42,
                                letterSpacing: 0.3,
                                color: isCurr
                                    ? theme.colorScheme.primary
                                    : null,
                                fontWeight: isCurr ? FontWeight.bold : null,
                              ),
                              maxLines: entry.ep != null ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (entry.pageData?.part case final part?)
                              if (part != entry.title)
                                Text(
                                  part,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            if (entry.ep?.showTitle case final showTitle?)
                              Text(
                                showTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                        if (entry.ownerName case final ownerName?)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              ownerName,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1,
                                color: outline,
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: entry.moreBtn(theme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
