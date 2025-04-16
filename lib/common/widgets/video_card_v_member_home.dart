import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/space/item.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';

// 视频卡片 - 垂直布局
class VideoCardVMemberHome extends StatelessWidget {
  final Item videoItem;

  const VideoCardVMemberHome({
    super.key,
    required this.videoItem,
  });

  void onPushDetail(heroTag) async {
    String goto = videoItem.goto ?? '';
    switch (goto) {
      case 'bangumi':
        Utils.viewBangumi(epId: videoItem.param);
        break;
      case 'av':
        if (videoItem.isPgc == true && videoItem.uri?.isNotEmpty == true) {
          if (Utils.viewPgcFromUri(videoItem.uri!)) {
            return;
          }
        }
        String? aid = videoItem.param;
        String? bvid = videoItem.bvid;
        if (aid == null && bvid == null) {
          return;
        }
        int? cid = videoItem.firstCid;
        cid ??= await SearchHttp.ab2c(aid: aid, bvid: bvid);
        Utils.toViewPage(
          'bvid=${bvid ?? IdUtils.av2bv(int.parse(aid!))}&cid=$cid',
          arguments: {
            'pic': videoItem.cover,
            'heroTag': heroTag,
          },
        );
        break;
      default:
        SmartDialog.showToast(goto);
        Utils.handleWebview(videoItem.uri ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Semantics(
          excludeSemantics: true,
          child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => onPushDetail(Utils.makeHeroTag(videoItem.bvid)),
              onLongPress: () => imageSaveDialog(
                context: context,
                title: videoItem.title,
                cover: videoItem.cover,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        double maxWidth = boxConstraints.maxWidth;
                        double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          children: [
                            NetworkImgLayer(
                              src: videoItem.cover,
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if ((videoItem.duration ?? -1) > 0)
                              PBadge(
                                bottom: 6,
                                right: 7,
                                size: 'small',
                                type: 'gray',
                                text: Utils.timeFormat(videoItem.duration),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                  videoContent(context, videoItem)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget videoContent(BuildContext context, Item videoItem) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
      child: Text(
        '${videoItem.title}\n',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          height: 1.38,
        ),
      ),
    ),
  );
}
