import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/member/seasons.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/utils/utils.dart';

class MemberSeasonsItem extends StatelessWidget {
  final MemberArchiveItem seasonItem;

  const MemberSeasonsItem({
    super.key,
    required this.seasonItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          int cid =
              await SearchHttp.ab2c(aid: seasonItem.aid, bvid: seasonItem.bvid);
          Utils.toViewPage(
            'bvid=${seasonItem.bvid}&cid=$cid',
            arguments: {
              'videoItem': seasonItem,
              'heroTag': Utils.makeHeroTag(seasonItem.aid)
            },
          );
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                double maxWidth = boxConstraints.maxWidth;
                double maxHeight = boxConstraints.maxHeight;
                return Stack(
                  children: [
                    NetworkImgLayer(
                      src: seasonItem.pic,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                    if (seasonItem.pubdate != null)
                      PBadge(
                        bottom: 6,
                        right: 6,
                        type: 'gray',
                        text: Utils.customStampStr(
                            timestamp: seasonItem.pubdate, date: 'YY-MM-DD'),
                      )
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seasonItem.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StatView(
                        context: context,
                        value: Utils.numFormat(seasonItem.view!),
                        theme: 'gray',
                      ),
                      const Spacer(),
                      Text(
                        Utils.customStampStr(
                            timestamp: seasonItem.pubdate, date: 'YY-MM-DD'),
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
