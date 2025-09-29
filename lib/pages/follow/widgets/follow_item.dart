import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/pages/share/view.dart' show UserModel;
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowItem extends StatelessWidget {
  final FollowItemModel item;
  final bool? isOwner;
  final ValueChanged? callback;
  final ValueChanged<UserModel>? onSelect;

  const FollowItem({
    super.key,
    required this.item,
    this.callback,
    this.isOwner,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (onSelect != null) {
            onSelect!.call(
              UserModel(
                mid: item.mid,
                name: item.uname!,
                avatar: item.face!,
              ),
            );
          } else {
            feedBack();
            Get.toNamed('/member?mid=${item.mid}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              PendantAvatar(
                size: 45,
                badgeSize: 14,
                avatar: item.face,
                officialType: item.officialVerify?.type,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.uname!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (item.sign != null)
                      Text(
                        item.sign!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
              if (isOwner ?? false)
                SizedBox(
                  height: 34,
                  child: FilledButton.tonal(
                    onPressed: () => RequestUtils.actionRelationMod(
                      context: context,
                      mid: item.mid,
                      isFollow: item.attribute != -1,
                      callback: callback,
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      foregroundColor: item.attribute == -1
                          ? null
                          : colorScheme.outline,
                      backgroundColor: item.attribute == -1
                          ? null
                          : colorScheme.onInverseSurface,
                    ),
                    child: Text(
                      '${item.attribute == -1 ? '' : '已'}关注',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
