import 'dart:async' show StreamSubscription;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/new_ep.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart'
    hide EpisodeItem;
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart'
    show scrollOffset;
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

const double _itemExtent = 150;

class EpisodePanel extends StatefulWidget {
  const EpisodePanel({
    super.key,
    required this.pgcController,
    required this.showEpisodes,
    required this.onChangeEpisode,
  });

  final ShowEpisodes showEpisodes;
  final PgcIntroController pgcController;
  final OnChangePgcEpisode onChangeEpisode;

  @override
  State<EpisodePanel> createState() => _EpisodePanelState();
}

class _EpisodePanelState extends State<EpisodePanel> {
  int? _seasonId;
  int get _index => _pgcController.episodeIndex;
  bool get _isEpisode => _pgcController.episodeType == .episode;
  double get _scrollOffset => scrollOffset(_index, _itemExtent);
  late NewEp? _newEp;
  late List<EpisodeItem> _episodes;
  late final isPugv = _episodes.first.from == 'pugv';

  late final _pgcController = widget.pgcController;
  late final _videoDetailCtr = _pgcController.videoDetailCtr;
  late final StreamSubscription<int> _listener;
  late final ScrollController _scrollController;

  late final bool _isVip;
  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = .of(context);
  }

  @override
  void didUpdateWidget(EpisodePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initIfNeeded();
  }

  @override
  void dispose() {
    _listener.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initIfNeeded();
    _isVip = Accounts.isVideoVip;

    _scrollController = ScrollController(
      keepScrollOffset: false,
      initialScrollOffset: _scrollOffset,
    );
    _listener = _videoDetailCtr.cid.listen(_onCidChanged);
  }

  (bool seasonChanged, bool dispose) _initIfNeeded() {
    if (_seasonId == _pgcController.seasonId) return const (false, false);
    final item = _pgcController.pgcItem;
    if (!item.hasEpisodes) return const (true, true);
    _seasonId = _pgcController.seasonId;
    _episodes = item.episodes!;
    _newEp = item.newEp;
    return const (true, false);
  }

  void _onCidChanged(int cid) {
    final (bool seasonChanged, bool dispose) = _initIfNeeded();
    if (dispose || !mounted) return;
    setState(() {});
    if (seasonChanged) {
      _scrollController.jumpTo(_scrollOffset);
    } else if (_isEpisode) {
      _scrollController.animateTo(
        _scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _currEpisodeTitle() {
    final currEpisode = _episodes[_index];
    return Text(
      ' 正在播放：${currEpisode.longTitle ?? currEpisode.title}',
      overflow: .ellipsis,
      style: TextStyle(fontSize: 12, color: colorScheme.outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const .only(top: 5, bottom: 3),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const Text('合集 '),
              if (_isEpisode && _index != -1)
                Expanded(child: _currEpisodeTitle()),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(.zero),
                  ),
                  onPressed: () => widget.showEpisodes(type: .pgc),
                  child: Text(
                    _newEp?.desc?.contains('连载') == true
                        ? '连载中，更新至${Utils.isStringNumeric(_newEp!.title!) ? '第${_newEp!.title}话' : '${_newEp!.title}'}'
                        : _newEp?.desc ?? '查看全部',
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
            padding: .zero,
            itemExtent: _itemExtent,
            scrollDirection: .horizontal,
            controller: _scrollController,
            itemCount: _episodes.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    final item = _episodes[index];
    final isCurr = index == _index;
    final hasLongTitle = item.longTitle?.isNotEmpty == true;
    final color = isCurr ? colorScheme.primary : colorScheme.onSurface;
    return Container(
      width: _itemExtent,
      height: 60,
      margin: index != _episodes.length - 1 ? const .only(right: 10) : null,
      child: Material(
        color: colorScheme.onInverseSurface,
        borderRadius: const .all(.circular(6)),
        child: InkWell(
          borderRadius: const .all(.circular(6)),
          onTap: () {
            if (isCurr) return;
            if (item.badge == '会员' && !_isVip) {
              SmartDialog.showToast('需要大会员');
            }
            widget.onChangeEpisode(item, episodeType: .episode);
          },
          child: Padding(
            padding: const .symmetric(vertical: 8, horizontal: 10),
            child: Column(
              spacing: 3,
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        maxLines: hasLongTitle ? 1 : 2,
                        TextSpan(
                          children: [
                            if (isCurr)
                              WidgetSpan(
                                alignment: .middle,
                                child: Padding(
                                  padding: const .only(right: 6),
                                  child: Image.asset(
                                    Assets.livingStatic,
                                    color: colorScheme.primary,
                                    height: 12,
                                    cacheHeight: 12.cacheSize(context),
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
                        SvgPicture.asset(
                          Assets.vipIcon,
                          height: 16,
                          semanticsLabel: "大会员",
                        )
                      else
                        Text(
                          item.badge!,
                          style: TextStyle(
                            fontSize: 11,
                            color: switch (item.badge) {
                              '限免' => colorScheme.freeColor,
                              '预告' => colorScheme.onSurfaceVariant,
                              _ => colorScheme.primary,
                            },
                          ),
                        ),
                    ],
                  ],
                ),
                if (hasLongTitle)
                  Text(
                    isPugv ? item.title! : item.longTitle!,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(fontSize: 13, color: color),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
