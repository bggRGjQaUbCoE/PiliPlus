import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/member/coin.dart';
import 'package:PiliPlus/utils/utils.dart';

class MemberCoinsItem extends StatelessWidget {
  final MemberCoinsDataModel coinItem;

  const MemberCoinsItem({
    super.key,
    required this.coinItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          if (coinItem.resourceType != 'ugc') {
            if (coinItem.redirectUrl?.isNotEmpty == true) {
              if (await PiliScheme.routePushFromUrl(coinItem.redirectUrl!,
                  selfHandle: true)) {
                return;
              }
            }
          }
          int cid =
              await SearchHttp.ab2c(aid: coinItem.aid, bvid: coinItem.bvid);
          PageUtils.toVideoPage(
            'bvid=${coinItem.bvid}&cid=$cid',
            arguments: {
              'videoItem': coinItem,
              'heroTag': Utils.makeHeroTag(coinItem.aid)
            },
          );
        },
        onLongPress: () => imageSaveDialog(
          title: coinItem.title,
          cover: coinItem.pic,
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
                  clipBehavior: Clip.none,
                  children: [
                    NetworkImgLayer(
                      src: coinItem.pic,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                    if (coinItem.duration > 0)
                      PBadge(
                        bottom: 6,
                        right: 6,
                        type: 'gray',
                        text: Utils.timeFormat(coinItem.duration),
                      )
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${coinItem.title}\n',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StatView(
                        context: context,
                        value: coinItem.stat.viewStr,
                        theme: 'gray',
                      ),
                      const SizedBox(width: 8),
                      StatDanMu(
                        context: context,
                        theme: 'gray',
                        value: coinItem.stat.danmuStr,
                      ),
                      const Spacer(),
                      Text(
                        Utils.customStampStr(
                            timestamp: coinItem.pubdate, date: 'MM-DD'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
