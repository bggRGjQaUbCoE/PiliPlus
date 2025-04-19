import 'package:PiliPlus/common/widgets/avatar.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({
    super.key,
    required this.style,
    required this.item,
  });

  final TextStyle style;
  final SearchUserItemModel item;

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(item.mid);
    return InkWell(
      onTap: () => Get.toNamed(
        '/member?mid=${item.mid}',
        arguments: {'heroTag': heroTag, 'face': item.upic},
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Avatar(
            avatar: item.upic ?? '',
            size: 42,
            isVip: false,
            officialType: item.officialVerify?['type'],
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
                '粉丝：${Utils.numFormat(item.fans)}  视频：${Utils.numFormat(item.videos)}',
                style: style,
              ),
              if (item.officialVerify?['desc'] != null &&
                  item.officialVerify?['desc'] != '')
                Text(
                  item.officialVerify?['desc'],
                  style: style,
                ),
            ],
          )
        ],
      ),
    );
  }
}
