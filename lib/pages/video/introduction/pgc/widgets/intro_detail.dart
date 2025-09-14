import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/page/tabs.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/pgc_review/view.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide TabBarView;
import 'package:get/get.dart';

class PgcIntroPanel extends CommonSlidePage {
  final PgcInfoModel item;
  final List<VideoTagItem>? videoTags;

  const PgcIntroPanel({
    super.key,
    required this.item,
    super.enableSlide = false,
    this.videoTags,
  });

  @override
  State<PgcIntroPanel> createState() => _IntroDetailState();
}

class _IntroDetailState extends State<PgcIntroPanel>
    with TickerProviderStateMixin, CommonSlideMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  final _controller = ScrollController();

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    return CustomTabBarView(
      controller: _tabController,
      physics: const CustomTabBarViewScrollPhysics(),
      bgColor: theme.colorScheme.surface,
      header: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              dividerHeight: 0,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: '详情'),
                Tab(text: '点评'),
              ],
              onTap: (index) {
                if (!_tabController.indexIsChanging) {
                  if (index == 0) {
                    _controller.animToTop();
                  }
                }
              },
            ),
          ),
          iconButton(
            context: context,
            icon: Icons.clear,
            onPressed: Get.back,
            iconSize: 22,
            bgColor: Colors.transparent,
          ),
          const SizedBox(width: 12),
        ],
      ),
      children: [
        KeepAliveWrapper(builder: (context) => buildList(theme)),
        PgcReviewPage(
          name: widget.item.title!,
          mediaId: widget.item.mediaId,
        ),
      ],
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    final TextStyle smallTitle = TextStyle(
      fontSize: 12,
      color: theme.colorScheme.onSurface,
    );
    final TextStyle textStyle = TextStyle(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return ListView(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 14,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
      ),
      children: [
        SelectableText(
          widget.item.title!,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          spacing: 6,
          children: [
            StatWidget(
              type: StatType.play,
              value: widget.item.stat!.view,
            ),
            StatWidget(
              type: StatType.danmaku,
              value: widget.item.stat!.danmaku,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              widget.item.areas!.first.name!,
              style: smallTitle,
            ),
            const SizedBox(width: 6),
            Text(
              widget.item.publish!.pubTimeShow!,
              style: smallTitle,
            ),
            const SizedBox(width: 6),
            Text(
              widget.item.newEp!.desc!,
              style: smallTitle,
            ),
          ],
        ),
        if (widget.item.evaluate?.isNotEmpty == true) ...[
          const SizedBox(height: 20),
          Text(
            '简介：',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          SelectableText(
            widget.item.evaluate!,
            style: textStyle,
          ),
        ],
        if (widget.item.actors?.isNotEmpty == true) ...[
          const SizedBox(height: 20),
          Text(
            '演职人员：',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            widget.item.actors!,
            style: textStyle,
          ),
        ],
        if (widget.videoTags?.isNotEmpty == true) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.videoTags!
                .map(
                  (item) => SearchText(
                    fontSize: 13,
                    text: item.tagName!,
                    onTap: (tagName) => Get.toNamed(
                      '/searchResult',
                      parameters: {'keyword': tagName},
                    ),
                    onLongPress: Utils.copyText,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
