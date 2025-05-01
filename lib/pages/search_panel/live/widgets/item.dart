import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveItem extends StatelessWidget {
  final SearchLiveItemModel liveItem;

  const LiveItem({super.key, required this.liveItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          Get.toNamed('/liveRoom?roomid=${liveItem.roomid}');
        },
        onLongPress: () => imageSaveDialog(
          title: liveItem.title?.map((item) => item['text']).join() ?? '',
          cover: liveItem.cover,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(StyleString.imgRadius),
              child: AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  double maxWidth = boxConstraints.maxWidth;
                  double maxHeight = boxConstraints.maxHeight;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        src: liveItem.cover,
                        type: 'emote',
                        width: maxWidth,
                        height: maxHeight,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 200),
                          child: liveStat(
                            liveItem.online,
                            liveItem.cateName,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            liveContent(theme)
          ],
        ),
      ),
    );
  }

  Widget liveContent(ThemeData theme) => Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 8, 9, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    for (var i in liveItem.title!) ...[
                      TextSpan(
                        text: i['text'],
                        style: TextStyle(
                          letterSpacing: 0.3,
                          color: i['type'] == 'em'
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  liveItem.uname!,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: theme.textTheme.labelMedium!.fontSize,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget liveStat(int? online, String? cateName) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(top: 22, left: 8, right: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cateName!,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          Text(
            '围观:${online.toString()}',
            style: const TextStyle(fontSize: 11, color: Colors.white),
          )
        ],
      ),
    );
  }
}
