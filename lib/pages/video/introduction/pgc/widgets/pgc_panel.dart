import 'dart:async';

import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/new_ep.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart'
    hide EpisodeItem;
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PgcPanel extends StatefulWidget {
  const PgcPanel({
    super.key,
    required this.pages,
    this.cid,
    required this.onChangeEpisode,
    required this.showEpisodes,
    required this.heroTag,
    this.newEp,
  });

  final List<EpisodeItem> pages;
  final int? cid;
  final ValueChanged<BaseEpisodeItem> onChangeEpisode;
  final Function showEpisodes;
  final String heroTag;
  final NewEp? newEp;

  @override
  State<PgcPanel> createState() => _PgcPanelState();
}

class _PgcPanelState extends State<PgcPanel> {
  late int currentIndex;
  final ScrollController listViewScrollCtr = ScrollController();
  // 默认未开通
  late int vipStatus;
  late int cid;
  late final VideoDetailController videoDetailCtr;
  StreamSubscription? _listener;

  @override
  void initState() {
    super.initState();
    cid = widget.cid!;
    currentIndex = widget.pages.indexWhere((e) => e.cid == cid);
    scrollToIndex();

    UserInfoData? userInfo = Pref.userInfoCache;
    vipStatus = userInfo?.vipStatus ?? 0;

    videoDetailCtr = Get.find<VideoDetailController>(tag: widget.heroTag);

    _listener = videoDetailCtr.cid.listen((int p0) {
      cid = p0;
      currentIndex = widget.pages.indexWhere((EpisodeItem e) => e.cid == cid);
      if (!mounted) return;
      setState(() {});
      scrollToIndex();
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    listViewScrollCtr.dispose();
    super.dispose();
  }

  void scrollToIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listViewScrollCtr.animateTo(
        (currentIndex * 150.0).clamp(
          listViewScrollCtr.position.minScrollExtent,
          listViewScrollCtr.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currEpisode = widget.pages[currentIndex];
    final isPugv = currEpisode.from == 'pugv';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('合集 '),
              Expanded(
                child: Text(
                  ' 正在播放：${currEpisode.longTitle ?? currEpisode.title}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => widget.showEpisodes(
                    null,
                    null,
                    widget.pages,
                    videoDetailCtr.bvid,
                    videoDetailCtr.aid,
                    cid,
                  ),
                  child: Text(
                    widget.newEp?.desc?.contains('连载') == true
                        ? '连载中，更新至${Utils.isStringNumeric(widget.newEp!.title!) ? '第${widget.newEp!.title}话' : '${widget.newEp!.title}'}'
                        : widget.newEp?.desc ?? '查看全部',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            controller: listViewScrollCtr,
            scrollDirection: Axis.horizontal,
            itemCount: widget.pages.length,
            itemExtent: 150,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(theme, isPugv, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(ThemeData theme, bool isPugv, int index) {
    final item = widget.pages[index];
    final hasLongTitle = item.longTitle?.isNotEmpty == true;
    final color = index == currentIndex
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    return Container(
      width: 150,
      height: 60,
      margin: EdgeInsets.only(
        right: index == widget.pages.length - 1 ? 0 : 10,
      ),
      child: Material(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          onTap: () {
            if (item.badge == '会员' && vipStatus != 1) {
              SmartDialog.showToast('需要大会员');
            }
            widget.onChangeEpisode(item);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        maxLines: hasLongTitle ? 1 : 2,
                        TextSpan(
                          children: [
                            if (index == currentIndex)
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Image.asset(
                                    'assets/images/live.png',
                                    color: theme.colorScheme.primary,
                                    height: 12,
                                    semanticLabel: "正在播放：",
                                  ),
                                ),
                              ),
                            TextSpan(
                              text: item.title ?? '第${index + 1}话',
                              style: TextStyle(
                                fontSize: 13,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (item.badge?.isNotEmpty == true) ...[
                      const SizedBox(width: 2),
                      if (item.badge == '会员')
                        Image.asset(
                          'assets/images/big-vip.png',
                          height: 16,
                          semanticLabel: "大会员",
                        )
                      else
                        Text(
                          item.badge!,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ],
                ),
                if (hasLongTitle)
                  Text(
                    isPugv ? item.title! : item.longTitle!,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
