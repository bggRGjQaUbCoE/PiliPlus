import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/bangumi/info.dart';
import 'package:PiliPlus/pages/common/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class IntroDetail extends CommonCollapseSlidePage {
  final BangumiInfoModel bangumiDetail;
  final dynamic videoTags;

  const IntroDetail({
    super.key,
    required this.bangumiDetail,
    this.videoTags,
  });

  @override
  State<IntroDetail> createState() => _IntroDetailState();
}

class _IntroDetailState extends CommonCollapseSlidePageState<IntroDetail> {
  late final TextStyle smallTitle = TextStyle(
    fontSize: 12,
    color: Theme.of(context).colorScheme.onSurface,
  );

  @override
  Widget get buildPage {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          GestureDetector(
            onTap: Get.back,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 35,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 2),
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(3))),
              ),
            ),
          ),
          Expanded(
            child: enableSlide ? slideList() : buildList,
          )
        ],
      ),
    );
  }

  @override
  Widget get buildList => ListView(
        controller: ScrollController(),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        children: [
          SelectableText(
            widget.bangumiDetail.title!,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              StatView(
                context: context,
                theme: 'gray',
                value: Utils.numFormat(widget.bangumiDetail.stat!['views']),
                size: 'medium',
              ),
              const SizedBox(width: 6),
              StatDanMu(
                context: context,
                theme: 'gray',
                value: Utils.numFormat(widget.bangumiDetail.stat!['danmakus']),
                size: 'medium',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                widget.bangumiDetail.areas!.first['name'],
                style: smallTitle,
              ),
              const SizedBox(width: 6),
              Text(
                widget.bangumiDetail.publish!['pub_time_show'],
                style: smallTitle,
              ),
              const SizedBox(width: 6),
              Text(
                widget.bangumiDetail.newEp!['desc'],
                style: smallTitle,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '简介：',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          SelectableText(
            widget.bangumiDetail.evaluate!,
            style: smallTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Text(
            '声优：',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          SelectableText(
            widget.bangumiDetail.actors!,
            style: smallTitle.copyWith(fontSize: 14),
          ),
          if (widget.videoTags is List && widget.videoTags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (widget.videoTags as List)
                  .map(
                    (item) => SearchText(
                      fontSize: 13,
                      text: item['tag_name'],
                      onTap: (_) => Get.toNamed('/searchResult',
                          parameters: {'keyword': item['tag_name']}),
                      onLongPress: (_) => Utils.copyText(item['tag_name']),
                    ),
                  )
                  .toList(),
            )
          ],
        ],
      );
}
