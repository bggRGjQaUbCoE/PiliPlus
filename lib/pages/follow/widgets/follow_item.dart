import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/follow/result.dart';
import 'package:PiliPlus/pages/follow/index.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/utils.dart';

class FollowItem extends StatelessWidget {
  final FollowItemModel item;
  final FollowController? ctr;
  final ValueChanged? callback;

  const FollowItem({
    super.key,
    required this.item,
    this.callback,
    this.ctr,
  });

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(item.mid);
    return ListTile(
      onTap: () {
        feedBack();
        Get.toNamed('/member?mid=${item.mid}',
            arguments: {'face': item.face, 'heroTag': heroTag});
      },
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: heroTag,
            child: NetworkImgLayer(
              width: 45,
              height: 45,
              type: 'avatar',
              src: item.face,
            ),
          ),
          if (item.officialVerify?['type'] == 0 ||
              item.officialVerify?['type'] == 1)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Icon(
                  Icons.offline_bolt,
                  color: item.officialVerify?['type'] == 0
                      ? Colors.yellow
                      : Colors.lightBlueAccent,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        item.uname!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        item.sign!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: ctr?.isOwner.value == true
          ? SizedBox(
              height: 34,
              child: FilledButton.tonal(
                onPressed: () {
                  Utils.actionRelationMod(
                    context: context,
                    mid: item.mid,
                    isFollow: item.attribute != -1,
                    callback: callback,
                    followStatus: {'special': item.special, 'tag': item.tag},
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  foregroundColor: item.attribute == -1
                      ? null
                      : Theme.of(context).colorScheme.outline,
                  backgroundColor: item.attribute == -1
                      ? null
                      : Theme.of(context).colorScheme.onInverseSurface,
                ),
                child: Text(
                  '${item.attribute == -1 ? '' : '已'}关注',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )
          : null,
    );
  }
}
