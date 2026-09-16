import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:material_ui/material_ui.dart';

class SearchActivityItem extends StatelessWidget {
  const SearchActivityItem({
    super.key,
    required this.item,
  });

  final SearchActivity item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    void onLongPress() => imageSaveDialog(title: item.title, cover: item.cover);
    return Material(
      type: .transparency,
      child: Column(
        children: [
          InkWell(
            onTap: () => PiliScheme.routePushFromUrl(item.url),
            onLongPress: PlatformUtils.isMobile ? onLongPress : null,
            onSecondaryTap: PlatformUtils.isDesktop ? onLongPress : null,
            child: Padding(
              padding: const .symmetric(horizontal: 12, vertical: 5),
              child: Row(
                spacing: 10,
                crossAxisAlignment: .start,
                children: [
                  Stack(
                    clipBehavior: .none,
                    children: [
                      NetworkImgLayer(
                        src: item.cover,
                        width: 160,
                        height: 100,
                      ),
                      if (item.status == 1)
                        const PBadge(text: '直播', top: 6.0, right: 6.0),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: .start,
                      children: [
                        Text(item.title!),
                        if (item.desc != null)
                          Text(
                            item.desc!,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 14,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}
