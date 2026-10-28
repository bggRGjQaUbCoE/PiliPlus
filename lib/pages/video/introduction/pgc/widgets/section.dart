import 'dart:async' show StreamSubscription;
import 'dart:math';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/section.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart'
    hide EpisodeItem;
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart'
    show scrollOffset;
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

const double _itemExtent = 140;
const double _itemWidth = _itemExtent + 10;

class SectionPanel extends StatefulWidget {
  const SectionPanel({
    super.key,
    required this.item,
    required this.heroTag,
    required this.pgcController,
    required this.showEpisodes,
    required this.onChangeEpisode,
  });

  final String heroTag;
  final PgcInfoModel item;
  final ShowEpisodes showEpisodes;
  final PgcIntroController pgcController;
  final OnChangePgcEpisode onChangeEpisode;

  @override
  State<SectionPanel> createState() => _SectionPanelState();
}

class _SectionPanelState extends State<SectionPanel> {
  late bool _isSection;
  late int _index;
  double get _scrollOffset => scrollOffset(_index, _itemWidth);
  late List<Section> _sections;
  late List<EpisodeItem> _episodes;

  late final _pgcController = widget.pgcController;
  int get _sectionIndex => _pgcController.sectionIndex;
  late final StreamSubscription<int> _listener;
  late final ScrollController _scrollController;
  late final ListController _sectionListController;
  late final ScrollController _sectionScrollController;
  late final VideoDetailController _videoDetailCtr;

  late final bool _isVip;
  late ColorScheme colorScheme;

  void _init() {
    _sections = widget.item.sections!;
    _episodes = _sections[_sectionIndex].episodes!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = .of(context);
  }

  @override
  void didUpdateWidget(SectionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      _init();
    }
  }

  @override
  void dispose() {
    _listener.cancel();
    _scrollController.dispose();
    _sectionListController.dispose();
    _sectionScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
    _isVip = Accounts.isVideoVip;

    _videoDetailCtr = Get.find<VideoDetailController>(tag: widget.heroTag);
    _updateIndex();
    _scrollController = ScrollController(initialScrollOffset: _scrollOffset);
    _listener = _videoDetailCtr.cid.listen(_onCidChanged);
    _sectionScrollController = ScrollController();
    _sectionListController = ListController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _sectionListController.jumpToItem(
        alignment: 0.25,
        index: _sectionIndex,
        scrollController: _sectionScrollController,
      ),
    );
  }

  void _updateIndex() {
    final cid = _videoDetailCtr.cid.rawValue;
    if (_isSection = _pgcController.episodeType == .section) {
      _index = max(0, _episodes.indexWhere((e) => e.cid == cid));
    } else {
      _index = -1;
    }
  }

  void _onCidChanged(int cid) {
    _updateIndex();
    if (!mounted) return;
    setState(() {});
    if (_isSection) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.animateTo(
          _scrollOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  void _updateSection(int sectionIndex) {
    if (_sectionIndex == sectionIndex) return;
    _pgcController.sectionIndex = sectionIndex;
    _episodes = _sections[sectionIndex].episodes!;
    setState(() {});
    final episode = _episodes.getOrNull(_index);
    if (episode?.cid == _pgcController.cid.rawValue) {
      _scrollController.jumpTo(_scrollOffset);
    } else {
      _scrollController.jumpToTop();
    }
    _sectionListController.animateToItem(
      alignment: 0.25,
      index: () => _sectionIndex,
      scrollController: _sectionScrollController,
      duration: (_) => const Duration(milliseconds: 500),
      curve: (_) => Curves.easeInOut,
    );
  }

  Widget _buildSection(int index) {
    final section = _sections[index];
    return Padding(
      padding: const .only(right: 30),
      child: GestureDetector(
        behavior: .translucent,
        onTap: () => _updateSection(index),
        child: Padding(
          padding: const .symmetric(vertical: 8),
          child: Text(
            section.title ?? (index + 1).toString(),
            style: TextStyle(
              height: 1,
              fontSize: 14,
              color: index == _sectionIndex
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.outline,
            ),
            strutStyle: const .new(leading: 0, height: 1, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        SizedBox(
          height: 30,
          child: CustomScrollView(
            scrollDirection: .horizontal,
            key: const PageStorageKey(Section),
            controller: _sectionScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const .only(right: 50),
                sliver: SuperSliverList.builder(
                  itemCount: _sections.length,
                  listController: _sectionListController,
                  itemBuilder: (context, index) => _buildSection(index),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 108,
          child: ListView.separated(
            padding: .zero,
            scrollDirection: .horizontal,
            controller: _scrollController,
            itemCount: _episodes.length,
            key: const PageStorageKey(_SectionPanelState),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                SizedBox(width: _itemExtent, child: _buildItem(index)),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    final item = _episodes[index];
    final color = item.cid == _pgcController.cid.rawValue
        ? colorScheme.primary
        : colorScheme.onSurface;
    return GestureDetector(
      behavior: .translucent,
      onTap: () {
        if (item.cid == null || item.cid == 0) {
          PiliScheme.videoPush(item.aid, item.bvid);
          return;
        }
        if (item.badge == '会员' && !_isVip) {
          SmartDialog.showToast('需要大会员');
        }
        widget.onChangeEpisode(item, episodeType: .section);
      },
      child: Column(
        spacing: 6,
        crossAxisAlignment: .stretch,
        children: [
          Stack(
            clipBehavior: .none,
            children: [
              NetworkImgLayer(
                src: item.cover,
                height: 82,
                width: _itemExtent,
                borderRadius: Style.borderRadius6,
              ),
              if (item.duration != null)
                PBadge(
                  text: DurationUtils.formatDuration(item.duration! ~/ 1000),
                  right: 4,
                  bottom: 4,
                  type: .gray,
                  size: .small,
                ),
            ],
          ),
          Text(
            item.title!,
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(fontSize: 13, color: color, height: 1),
          ),
        ],
      ),
    );
  }
}
