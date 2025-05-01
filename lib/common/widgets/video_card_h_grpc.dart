import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/grpc/app/card/v1/card.pb.dart' as card;
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';

// 视频卡片 - 水平布局
class VideoCardHGrpc extends StatelessWidget {
  const VideoCardHGrpc({
    super.key,
    required this.videoItem,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
  });
  final card.Card videoItem;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;

  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.smallCoverV5.base.args.aid.toInt();
    String type = 'video';
    final String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onLongPress: () => imageSaveDialog(
        title: videoItem.smallCoverV5.base.title,
        cover: videoItem.smallCoverV5.base.cover,
      ),
      onTap: () async {
        if (type == 'ketang') {
          SmartDialog.showToast('课堂视频暂不支持播放');
          return;
        }
        try {
          PiliScheme.routePushFromUrl(videoItem.smallCoverV5.base.uri);
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints boxConstraints) {
                    final double maxWidth = boxConstraints.maxWidth;
                    final double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: videoItem.smallCoverV5.base.cover,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        ),
                        if (videoItem.smallCoverV5.coverRightText1.isNotEmpty)
                          PBadge(
                            text: Utils.timeFormat(
                                videoItem.smallCoverV5.coverRightText1),
                            right: 6.0,
                            bottom: 6.0,
                            type: 'gray',
                          ),
                        if (type != 'video')
                          PBadge(
                            text: type,
                            left: 6.0,
                            bottom: 6.0,
                            type: 'primary',
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              videoContent(context),
            ],
          );
        },
      ),
    );
  }

  Widget videoContent(context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              videoItem.smallCoverV5.base.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: theme.textTheme.bodyMedium!.fontSize,
                height: 1.42,
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showOwner || showPubdate)
            Text(
              videoItem.smallCoverV5.rightDesc1,
              maxLines: 1,
              style: TextStyle(
                fontSize: theme.textTheme.labelMedium!.fontSize,
                height: 1,
                color: theme.colorScheme.outline,
                overflow: TextOverflow.clip,
              ),
            ),
          const SizedBox(height: 3),
          Text(
            videoItem.smallCoverV5.rightDesc2,
            maxLines: 1,
            style: TextStyle(
              fontSize: theme.textTheme.labelMedium!.fontSize,
              height: 1,
              color: theme.colorScheme.outline,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
