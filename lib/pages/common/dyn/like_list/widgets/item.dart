import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show ModuleAuthor;
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart';

class DynLikeItem extends StatelessWidget {
  const DynLikeItem({super.key, required this.item});

  final ModuleAuthor item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final author = item.author;
    final hasSign = author.hasSign();
    return Material(
      type: .transparency,
      child: InkWell(
        onTap: () => Get.toNamed('/member?mid=${item.mid}'),
        child: Column(
          crossAxisAlignment: hasSign ? .center : .start,
          children: [
            Padding(
              padding: const .symmetric(horizontal: 12, vertical: 10),
              child: Row(
                spacing: 12,
                crossAxisAlignment: .start,
                children: [
                  PendantAvatar(
                    author.face,
                    size: 34,
                    badgeSize: 14,
                    pendantImage: author.hasPendant()
                        ? author.pendant.image
                        : null,
                    vipStatus: author.hasVip() ? author.vip.status : null,
                    officialType: author.hasOfficial()
                        ? author.official.type
                        : null,
                  ),
                  Expanded(
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            Flexible(
                              child: Text(
                                author.name,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: TextStyle(
                                  color:
                                      (author.vip.status > 0 &&
                                          author.vip.type == 2)
                                      ? colorScheme.vipColor
                                      : null,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            BiliUtils.levelPicture(
                              author.level.toInt(),
                              isSeniorMember: author.isSeniorMember == 1,
                              height: 11,
                            ),
                          ],
                        ),
                        if (hasSign)
                          Text(
                            author.sign,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 60,
              endIndent: 15,
              height: 0.3,
              color: colorScheme.outline.withValues(alpha: 0.08),
            ),
          ],
        ),
      ),
    );
  }
}
