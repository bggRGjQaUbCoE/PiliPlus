import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/feedback.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

// 视频卡片 - 垂直布局
class LiveCardVApp extends StatelessWidget {
  final CardLiveItem item;
  final bool showFirstFrame;

  const LiveCardVApp({
    super.key,
    required this.item,
    this.showFirstFrame = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void onLongPress() => imageSaveDialog(
      title: item.title,
      cover: showFirstFrame ? item.systemCover : item.cover,
    );
    return Stack(
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => PageUtils.toLiveRoom(item.roomid),
            onLongPress: onLongPress,
            onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: Style.aspectRatio,
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NetworkImgLayer(
                          src: showFirstFrame ? item.systemCover : item.cover,
                          width: boxConstraints.maxWidth,
                          height: boxConstraints.maxHeight,
                          type: .emote,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(milliseconds: 200),
                            child: videoStat(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                liveContent(theme),
              ],
            ),
          ),
        ),
        if (!item.feedback.isNullOrEmpty)
          Positioned(
            right: -5,
            bottom: -2,
            width: 29,
            height: 29,
            child: IconButton(
              padding: .zero,
              onPressed: () {
                Widget actionButton(Reason r) => SearchText(
                  text: r.name!,
                  onTap: (_) async {
                    Get.back();
                    SmartDialog.showLoading(msg: '正在提交');
                    final res = await LiveHttp.liveFeedback(
                      item.roomid!,
                      r.id!,
                      r.idType!,
                    );
                    SmartDialog.dismiss();
                    if (res.isSuccess) {
                      SmartDialog.showToast('提交成功');
                    } else {
                      res.toast();
                    }
                  },
                );

                final feedback = item.feedback!;
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      contentPadding: const .fromLTRB(24, 16, 24, 19),
                      children: [
                        for (var i in feedback) ...[
                          const SizedBox(height: 5),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: i.title,
                                  style: theme.textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: '\n${i.subtitle}',
                                  style: TextStyle(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: i.reasons!.map(actionButton).toList(),
                          ),
                        ],
                        const Divider(),
                        Center(
                          child: FilledButton.tonal(
                            onPressed: Get.back,
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text('取消'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.more_vert_outlined,
                size: 17,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
      ],
    );
  }

  Widget liveContent(ThemeData theme) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title.toString(),
              textAlign: TextAlign.start,
              style: const TextStyle(letterSpacing: 0.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: .topLeft,
              child: Text(
                item.uname.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  color: theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget videoStat() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 26, left: 10, right: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.transparent, Colors.black54],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.areaName.toString(),
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          if (item.watchedShow?.textLarge case final textLarge?)
            Text(
              textLarge,
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
