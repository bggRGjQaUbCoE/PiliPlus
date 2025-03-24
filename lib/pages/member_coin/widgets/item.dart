import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
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
          int cid =
              await SearchHttp.ab2c(aid: coinItem.aid, bvid: coinItem.bvid);
          Utils.toViewPage(
            'bvid=${coinItem.bvid}&cid=$cid',
            arguments: {
              'videoItem': coinItem,
              'heroTag': Utils.makeHeroTag(coinItem.aid)
            },
          );
        },
        onLongPress: () => imageSaveDialog(
          context: context,
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
                  children: [
                    NetworkImgLayer(
                      src: coinItem.pic,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                    if (coinItem.duration != null)
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
                        value: coinItem.view!,
                        theme: 'gray',
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
