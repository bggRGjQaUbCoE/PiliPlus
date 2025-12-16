import 'package:PiliPlus/pages/fav/pgc/child_view.dart';
import 'package:PiliPlus/pages/fav/pgc/controller.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavPgcPage extends StatefulWidget {
  const FavPgcPage({super.key, required this.type});

  final int type;

  @override
  State<FavPgcPage> createState() => _FavPgcPageState();
}

class _FavPgcPageState extends State<FavPgcPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 1,
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
                  Tab(text: '想看'),
                  Tab(text: '在看'),
                  Tab(text: '看过'),
                ],
                onTap: (index) {
                  try {
                    if (!_tabController.indexIsChanging) {
                      Get.find<FavPgcController>(
                        tag: '${widget.type}${index + 1}',
                      ).scrollController.animToTop();
                    }
                  } catch (_) {}
                },
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     foregroundColor: theme.colorScheme.onSurfaceVariant,
            //     visualDensity:
            //         const VisualDensity(horizontal: -2, vertical: -2),
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   onPressed: () {},
            //   child: const Text('管理'),
            // ),
            // const SizedBox(width: 12),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              3,
              (index) => FavPgcChildPage(
                type: widget.type,
                followStatus: index + 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
