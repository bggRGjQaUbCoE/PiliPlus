import 'package:PiliPlus/models/common/pgc_review_type.dart';
import 'package:PiliPlus/pages/pgc_review/child/controller.dart';
import 'package:PiliPlus/pages/pgc_review/child/view.dart';
import 'package:PiliPlus/pages/pgc_review/post/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PgcReviewPage extends StatefulWidget {
  const PgcReviewPage({
    super.key,
    required this.name,
    required this.mediaId,
  });

  final String name;
  final dynamic mediaId;

  @override
  State<PgcReviewPage> createState() => _PgcReviewPageState();
}

class _PgcReviewPageState extends State<PgcReviewPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final _tabController = TabController(
    length: PgcReviewType.values.length,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
              indicatorWeight: 0,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.only(left: 6),
              indicatorPadding: const EdgeInsets.symmetric(
                horizontal: 3,
                vertical: 8,
              ),
              indicator: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: theme.colorScheme.onSecondaryContainer,
              unselectedLabelColor: theme.colorScheme.outline,
              labelStyle:
                  TabBarTheme.of(
                    context,
                  ).labelStyle?.copyWith(fontSize: 13) ??
                  const TextStyle(fontSize: 13),
              dividerColor: Colors.transparent,
              tabs: PgcReviewType.values
                  .map((e) => Tab(text: e.label))
                  .toList(),
              onTap: (index) {
                try {
                  if (!_tabController.indexIsChanging) {
                    final item = PgcReviewType.values[index];
                    Get.find<PgcReviewController>(
                      tag: '${widget.mediaId}${item.name}',
                    ).scrollController.animToTop();
                  }
                } catch (_) {}
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: PgcReviewType.values
                    .map(
                      (e) => PgcReviewChildPage(
                        type: e,
                        name: widget.name,
                        mediaId: widget.mediaId,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
          child: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                clipBehavior: Clip.hardEdge,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      dense: true,
                      title: const Text(
                        '写短评',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Get.back();
                        showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          builder: (context) {
                            return PgcReviewPostPanel(
                              name: widget.name,
                              mediaId: widget.mediaId,
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        '写长评',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () => Get
                        ..back()
                        ..toNamed(
                          '/webview',
                          parameters: {
                            'url':
                                'https://member.bilibili.com/article-text/mobile?theme=${Get.isDarkMode ? 1 : 0}&media_id=${widget.mediaId}',
                          },
                        ),
                    ),
                  ],
                ),
              ),
            ),
            child: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
