import 'package:PiliPlus/pages/fav/note/child_view.dart';
import 'package:PiliPlus/pages/fav/note/controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavNotePage extends StatefulWidget {
  const FavNotePage({super.key});

  @override
  State<FavNotePage> createState() => _FavNotePageState();
}

class _FavNotePageState extends State<FavNotePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                dividerHeight: 0,
                indicatorWeight: 0,
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 8,
                ),
                indicator: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    TabBarTheme.of(
                      context,
                    ).labelStyle?.copyWith(fontSize: 14) ??
                    const TextStyle(fontSize: 14),
                labelColor: theme.colorScheme.onSecondaryContainer,
                unselectedLabelColor: theme.colorScheme.outline,
                tabs: const [
                  Tab(text: '未发布笔记'),
                  Tab(text: '公开笔记'),
                ],
                onTap: (index) {
                  try {
                    if (!_tabController.indexIsChanging) {
                      Get.find<FavNoteController>(
                        tag: index == 0 ? 'false' : 'true',
                      ).scrollController.animToTop();
                    }
                  } catch (_) {}
                },
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     foregroundColor: theme.colorScheme.onSurfaceVariant,
            //     visualDensity: VisualDensity.compact,
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   onPressed: () async {
            //     final favNoteController = Get.find<FavNoteController>(
            //         tag: _tabController.index == 0 ? 'false' : 'true');
            //     if (favNoteController.enableMultiSelect.value) {
            //       favNoteController.onDisable();
            //     } else {
            //       if (favNoteController.loadingState.value.isSuccess &&
            //           favNoteController.loadingState.value.data?.isNotEmpty ==
            //               true) {
            //         favNoteController.enableMultiSelect.value = true;
            //       }
            //     }
            //   },
            //   child: const Text('管理'),
            // ),
            // const SizedBox(width: 12),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              FavNoteChildPage(isPublish: false),
              FavNoteChildPage(isPublish: true),
            ],
          ),
        ),
      ],
    );
  }
}
