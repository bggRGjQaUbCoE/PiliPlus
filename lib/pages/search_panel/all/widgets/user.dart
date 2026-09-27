import 'dart:io' show Platform;

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart'
    show pushVideoH;
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart';

const _kItemWidth = 140.0;
const _kItemHeight = _kItemWidth / Style.aspectRatio16x9;
const _kRadius = Radius.circular(6);
const _kBorderRadius = BorderRadius.all(_kRadius);

class SearchAllUserItem extends StatelessWidget {
  const SearchAllUserItem({
    super.key,
    required this.item,
  });

  final SearchUser item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final descStyle = TextStyle(color: colorScheme.outline, fontSize: 12.5);
    return Material(
      type: .transparency,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          InkWell(
            onTap: () => Get.toNamed('/member?mid=${item.mid}'),
            child: Padding(
              padding: const .symmetric(horizontal: 12, vertical: 5),
              child: Row(
                spacing: 10,
                children: [
                  PendantAvatar(
                    item.upic,
                    size: 50,
                    liveBottom: -3,
                    liveFontSize: 11,
                    officialType: item.officialVerify?.type,
                    roomId: item.isLive == 1 ? item.roomId : null,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            Flexible(child: Text(item.uname!)),
                            BiliUtils.levelPicture(
                              item.level!,
                              isSeniorMember: item.isSeniorMember == 1,
                              height: 11,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            text:
                                '${NumUtils.numFormat(item.fans)}粉丝 · ${NumUtils.numFormat(item.videos)}个视频',
                            children: item.officialVerify?.desc != null
                                ? [
                                    TextSpan(
                                      text: '    ${item.officialVerify!.desc}',
                                    ),
                                  ]
                                : null,
                          ),
                          maxLines: 1,
                          style: descStyle,
                          overflow: .ellipsis,
                        ),
                        if (item.usign case final sign? when sign.isNotEmpty)
                          Text(
                            sign,
                            maxLines: 1,
                            style: descStyle,
                            overflow: .ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item.res case final list? when list.isNotEmpty)
            Padding(
              padding: const .only(top: 5),
              child: SizedBox(
                height:
                    _kItemHeight + MediaQuery.textScalerOf(context).scale(60),
                child: ListView.builder(
                  itemCount: list.length,
                  scrollDirection: .horizontal,
                  itemExtent: _kItemWidth + 10,
                  padding: const .only(left: 12),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final video = list[index];
                    return _buildVideoItem(
                      colorScheme,
                      index == list.length - 1
                          ? const .only(right: 12)
                          : const .only(right: 10),
                      video,
                    );
                  },
                ),
              ),
            ),
          Divider(
            height: 14,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

Widget _buildVideoItem(
  ColorScheme colorScheme,
  EdgeInsets padding,
  SearchVideoItemModel video,
) {
  void onLongPress() => imageSaveDialog(
    title: video.title,
    cover: video.cover,
    aid: video.aid,
    bvid: video.bvid,
  );
  return Padding(
    padding: padding,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: .opaque,
        onTap: () => pushVideoH(video),
        onLongPress: PlatformUtils.isMobile
            ? () {
                Platform.isIOS
                    ? HapticFeedback.heavyImpact()
                    : HapticFeedback.vibrate();
                onLongPress();
              }
            : null,
        onSecondaryTap: PlatformUtils.isDesktop ? onLongPress : null,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Stack(
              clipBehavior: .none,
              children: [
                NetworkImgLayer(
                  src: video.cover,
                  width: _kItemWidth,
                  height: _kItemHeight,
                  borderRadius: _kBorderRadius,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: .bottomLeft,
                    padding: const .fromLTRB(8, 6, 8, 4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: .bottomCenter,
                        end: .topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                      borderRadius: .vertical(bottom: _kRadius),
                    ),
                    child: Row(
                      crossAxisAlignment: .end,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        StatWidget(
                          type: .play,
                          value: video.stat.view,
                          color: Colors.white,
                        ),
                        Text(
                          DurationUtils.formatDuration(video.duration),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                video.title,
                maxLines: 2,
                overflow: .ellipsis,
                style: const TextStyle(height: 1.4, fontSize: 12.5),
              ),
            ),
            Text(
              DateFormatUtils.dateFormat(video.pubdate),
              style: TextStyle(color: colorScheme.outline, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
