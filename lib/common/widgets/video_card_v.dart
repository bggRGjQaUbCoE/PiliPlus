import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../models/home/rcmd/result.dart';
import '../../models/model_rec_video_item.dart';
import 'stat/stat.dart';
import '../../utils/id_utils.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';
import 'video_popup_menu.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final BaseRecVideoItemModel videoItem;
  final VoidCallback? onRemove;

  const VideoCardV({
    super.key,
    required this.videoItem,
    this.onRemove,
  });

  bool isStringNumeric(String str) {
    RegExp numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(str);
  }

  void onPushDetail(heroTag) async {
    String goto = videoItem.goto!;
    switch (goto) {
      case 'bangumi':
        PageUtils.viewBangumi(epId: videoItem.param!);
        break;
      case 'av':
        String bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid!);
        int cid = videoItem.cid!;
        if (cid == -1) {
          cid = await SearchHttp.ab2c(aid: videoItem.aid, bvid: bvid);
        }
        PageUtils.toVideoPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            'pic': videoItem.pic,
            'heroTag': heroTag,
          },
        );
        break;
      // 动态
      case 'picture':
        try {
          String type = 'picture';
          String uri = videoItem.uri!;
          String id = '';
          if (uri.startsWith('bilibili://article/')) {
            type = 'read';
            RegExp regex = RegExp(r'\d+');
            Match match = regex.firstMatch(uri)!;
            String matchedNumber = match.group(0)!;
            videoItem.param = int.parse(matchedNumber);
            id = '${videoItem.param}';
          }
          if (uri.startsWith('http')) {
            String id = Uri.parse(uri).path.split('/')[1];
            if (isStringNumeric(id)) {
              PageUtils.pushDynFromId(id: id);
              return;
            }
          }
          Get.toNamed(
            '/articlePage',
            parameters: {
              'id': id,
              'type': type,
            },
          );
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      default:
        SmartDialog.showToast(goto);
        PageUtils.handleWebview(videoItem.uri!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Semantics(
        label: Utils.videoItemSemantics(videoItem),
        excludeSemantics: true,
        child: Card(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => onPushDetail(Utils.makeHeroTag(videoItem.aid)),
            onLongPress: () => imageSaveDialog(
              context: context,
              title: videoItem.title,
              cover: videoItem.pic,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: StyleString.aspectRatio,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      children: [
                        NetworkImgLayer(
                          src: videoItem.pic,
                          width: maxWidth,
                          height: maxHeight,
                        ),
                        if (videoItem.duration > 0)
                          PBadge(
                            bottom: 6,
                            right: 7,
                            size: 'small',
                            type: 'gray',
                            text: Utils.timeFormat(videoItem.duration),
                          )
                      ],
                    );
                  }),
                ),
                videoContent(context)
              ],
            ),
          ),
        ),
      ),
      if (videoItem.goto == 'av')
        Positioned(
          right: -5,
          bottom: -2,
          child: VideoPopupMenu(
            size: 29,
            iconSize: 17,
            videoItem: videoItem,
            onRemove: onRemove,
          ),
        ),
    ]);
  }

  Widget videoContent(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "${videoItem.title}\n",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.38,
                ),
              ),
            ),
            videoStat(context),
            Row(
              children: [
                if (videoItem.goto == 'bangumi') ...[
                  PBadge(
                    text: videoItem.bangumiBadge,
                    stack: 'normal',
                    size: 'small',
                    type: 'line',
                    fs: 9,
                  ),
                  const SizedBox(width: 2),
                ],
                if (videoItem.rcmdReason != null) ...[
                  PBadge(
                    text: videoItem.rcmdReason,
                    stack: 'normal',
                    size: 'small',
                    type: 'color',
                  ),
                  const SizedBox(width: 2),
                ],
                if (videoItem.goto == 'picture') ...[
                  const PBadge(
                    text: '动态',
                    stack: 'normal',
                    size: 'small',
                    type: 'line',
                    fs: 9,
                  ),
                  const SizedBox(width: 2),
                ],
                if (videoItem.isFollowed) ...[
                  const PBadge(
                    text: '已关注',
                    stack: 'normal',
                    size: 'small',
                    type: 'color',
                  ),
                  const SizedBox(width: 2),
                ],
                Expanded(
                  flex: 1,
                  child: Text(
                    videoItem.owner.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      height: 1.5,
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                if (videoItem.goto == 'av') const SizedBox(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget videoStat(context) {
    return Row(
      children: [
        StatView(
          context: context,
          theme: 'gray',
          value: videoItem.stat.viewStr,
          goto: videoItem.goto,
        ),
        const SizedBox(width: 4),
        if (videoItem.goto != 'picture')
          StatDanMu(
            context: context,
            theme: 'gray',
            value: videoItem.stat.danmuStr,
          ),
        if (videoItem is RecVideoItemModel) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.8),
                ),
                text: Utils.formatTimestampToRelativeTime(videoItem.pubdate)),
          ),
          const SizedBox(width: 2),
        ] else if (videoItem is RecVideoItemAppModel &&
            videoItem.desc != null &&
            videoItem.desc!.contains(' · ')) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.8),
                ),
                text: Utils.shortenChineseDateString(
                    videoItem.desc!.split(' · ').last)),
          ),
          const SizedBox(width: 2),
        ]
      ],
    );
  }
}
