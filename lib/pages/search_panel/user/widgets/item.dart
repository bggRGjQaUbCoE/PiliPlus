import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({
    super.key,
    required this.item,
  });

  final SearchUserItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      fontSize: theme.textTheme.labelSmall!.fontSize,
      color: theme.colorScheme.outline,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => Get.toNamed('/member?mid=${item.mid}'),
        child: Row(
          children: [
            const SizedBox(width: 15),
            PendantAvatar(
              avatar: item.upic,
              size: 42,
              isVip: false,
              officialType: item.officialVerify?.type,
              roomId: item.isLive == 1 ? item.roomId : null,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      item.uname!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images/lv/lv${item.isSeniorMember == 1 ? '6_s' : item.level}.png',
                      height: 11,
                      semanticLabel: '等级${item.level}',
                    ),
                  ],
                ),
                Text(
                  '粉丝：${NumUtils.numFormat(item.fans)}  视频：${NumUtils.numFormat(item.videos)}',
                  style: style,
                ),
                if (item.officialVerify?.desc?.isNotEmpty == true)
                  Text(
                    item.officialVerify!.desc!,
                    style: style,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
