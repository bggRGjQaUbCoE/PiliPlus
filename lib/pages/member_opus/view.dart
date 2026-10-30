import 'package:PiliPlus/common/skeleton/space_opus.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show OpusFlowItem;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/member_opus/controller.dart';
import 'package:PiliPlus/pages/member_opus/widgets/collection_item.dart';
import 'package:PiliPlus/pages/member_opus/widgets/space_opus_item_grpc.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MemberOpus extends StatefulWidget {
  const MemberOpus({
    super.key,
    this.isSingle = false,
    required this.heroTag,
    required this.mid,
  });

  final bool isSingle;
  final String? heroTag;
  final int mid;

  @override
  State<MemberOpus> createState() => _MemberOpusState();
}

class _MemberOpusState extends State<MemberOpus>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        BaseFabMixin,
        LazyFabMixin {
  late final MemberOpusController _controller;
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      MemberOpusController(
        mid: widget.mid,
        heroTag: widget.heroTag,
      ),
      tag: widget.heroTag,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = .of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return ScaffoldLayout(
      body: refreshIndicator(
        isClampingScrollPhysics: true,
        onRefresh: _controller.onRefresh,
        child: fabAnimWrapper(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: widget.isSingle ? 12 : 0,
                  left: Style.safeSpace,
                  right: Style.safeSpace,
                  bottom: bottom + 100,
                ),
                sliver: Obx(() => _buildBody(_controller.loadingState.value)),
              ),
            ],
          ),
        ),
      ),
      fab: _controller.filter?.isNotEmpty == true
          ? SlideTransition(
              position: fabAnimation,
              child: Padding(
                padding: .only(
                  right: kFloatingActionButtonMargin,
                  bottom: kFloatingActionButtonMargin + bottom,
                ),
                child: FloatingActionButton.extended(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      clipBehavior: Clip.hardEdge,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      children: _controller.filter!
                          .map(
                            (e) => ListTile(
                              dense: true,
                              onTap: () {
                                if (e == _controller.type.value) {
                                  return;
                                }
                                Get.back();
                                _controller
                                  ..type.value = e
                                  ..onReload();
                              },
                              tileColor: e == _controller.type.value
                                  ? ColorScheme.of(context).onInverseSurface
                                  : null,
                              title: Text(
                                e.text ?? e.tabName!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  icon: const Icon(size: 20, Icons.sort),
                  label: Obx(
                    () {
                      final type = _controller.type.value;
                      return Text(type.text ?? type.tabName!);
                    },
                  ),
                ),
              ),
            )
          : null,
    );
  }

  late final gridDelegate = SliverSimpleGridDelegateWithMaxCrossAxisExtent_(
    maxCrossAxisExtent: Grid.smallCardWidth,
  );

  Widget _buildBody(LoadingState<List<OpusFlowItem>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return SliverMasonryGrid(
          mainAxisSpacing: Style.safeSpace,
          crossAxisSpacing: Style.safeSpace,
          gridDelegate: gridDelegate,
          delegate: const SliverSingleChildDelegate(
            count: 10,
            child: SpaceOpusSkeleton(),
          ),
        );
      case Success(:final response):
        if (response != null && response.isNotEmpty) {
          final child = SliverMasonryGrid(
            mainAxisSpacing: Style.safeSpace,
            crossAxisSpacing: Style.safeSpace,
            gridDelegate: gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == response.length - 1) {
                  _controller.onLoadMore();
                }
                return SpaceOpusItemGrpc(item: response[index]);
              },
              childCount: response.length,
            ),
          );
          if (_controller.collection case final collection?
              when collection.allCollections.isNotEmpty) {
            return SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const .only(bottom: 10),
                    child: Text(
                      collection.title,
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CollectionSection(
                    collection: collection,
                    onCollapse: _controller.onCollapseCollection,
                  ),
                ),
                child,
              ],
            );
          }
          return child;
        }
        return HttpError(onReload: _controller.onReload);
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
