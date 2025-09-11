import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show SearchItem, SearchItemVideoSubType;
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/reply/reply_search_type.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplySearchItem extends StatelessWidget {
  const ReplySearchItem({
    super.key,
    required this.item,
    required this.type,
  });

  final SearchItem item;
  final ReplySearchType type;

  @override
  Widget build(BuildContext context) {
    String title = '';
    String cover = '';
    String? upNickname;
    String? category;
    int? duration;
    switch (type) {
      case ReplySearchType.video:
        if (item.video.type == SearchItemVideoSubType.UGC) {
          final ugc = item.video.ugc;
          title = ugc.title;
          cover = ugc.cover;
          upNickname = ugc.upNickname;
          duration = ugc.duration.toInt();
        } else {
          final pgc = item.video.pgc;
          title = pgc.title;
          cover = pgc.cover;
          category = pgc.category;
        }
      case ReplySearchType.article:
        final article = item.article;
        title = article.title;
        cover = article.covers.firstOrNull ?? '';
        upNickname = article.upNickname;
    }
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => Get.back(result: (title: title, url: item.url)),
        onLongPress: () => imageSaveDialog(
          title: title,
          cover: cover,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return Stack(
                      children: [
                        NetworkImgLayer(
                          src: cover,
                          width: boxConstraints.maxWidth,
                          height: boxConstraints.maxHeight,
                        ),
                        if (category != null)
                          PBadge(
                            right: 6,
                            top: 6,
                            text: category,
                          ),
                        if (duration != null)
                          PBadge(
                            right: 6,
                            bottom: 6,
                            text: DurationUtils.formatDuration(duration),
                            type: PBadgeType.gray,
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (upNickname != null)
                      Text(
                        'UP: $upNickname',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
