import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/bangumi/pgc_index/pgc_index_controller.dart';
import 'package:PiliPlus/pages/bangumi/widgets/bangumi_card_v_pgc_index.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;

import '../../../models/bangumi/pgc_index/condition.dart';

class PgcIndexPage extends StatefulWidget {
  const PgcIndexPage({super.key, this.indexType});

  final int? indexType;

  @override
  State<PgcIndexPage> createState() => _PgcIndexPageState();
}

class _PgcIndexPageState extends State<PgcIndexPage>
    with AutomaticKeepAliveClientMixin {
  late final _ctr = Get.put(
    PgcIndexController(widget.indexType),
    tag: '${widget.indexType}',
  );

  @override
  bool get wantKeepAlive => widget.indexType != null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.indexType == null
        ? Scaffold(
            appBar: AppBar(title: const Text('索引')),
            body: Obx(() => _buildBody(_ctr.conditionState.value)),
          )
        : Obx(() => _buildBody(_ctr.conditionState.value));
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => Builder(builder: (context) {
          Condition data = loadingState.response;
          int count = (data.order?.isNotEmpty == true ? 1 : 0) +
              (data.filter?.length ?? 0);
          if (count == 0) return const SizedBox.shrink();
          return SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                if (widget.indexType != null)
                  SliverToBoxAdapter(child: const SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 200),
                    child: count > 5
                        ? Obx(() => _buildSortWidget(count, data))
                        : _buildSortWidget(count, data),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: StyleString.safeSpace,
                    right: StyleString.safeSpace,
                    top: 12,
                    bottom: MediaQuery.paddingOf(context).bottom + 80,
                  ),
                  sliver: Obx(() => _buildList(_ctr.loadingState.value)),
                ),
              ],
            ),
          );
        }),
      Error() => scrollErrorWidget(
          errMsg: loadingState.errMsg,
          onReload: () {
            _ctr.conditionState.value = LoadingState.loading();
            _ctr.getPgcIndexCondition();
          },
        ),
    };
  }

  Widget _buildSortWidget(count, data) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            count > 5
                ? _ctr.isExpand.value
                    ? count
                    : count ~/ 2
                : count,
            (index) {
              List? item = data.order?.isNotEmpty == true
                  ? index == 0
                      ? data.order
                      : data.filter![index - 1].values
                  : data.filter![index].values;
              return item?.isNotEmpty == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : 10,
                      ),
                      child: SelfSizedHorizontalList(
                        gapSize: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        childBuilder: (childIndex) => Obx(
                          () => SearchText(
                            bgColor: (item[childIndex] is Order
                                        ? _ctr.indexParams['order']
                                        : _ctr.indexParams[data
                                            .filter![
                                                data.order?.isNotEmpty == true
                                                    ? index - 1
                                                    : index]
                                            .field]) ==
                                    (item[childIndex] is Order
                                        ? item[childIndex].field
                                        : item[childIndex].keyword)
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : Colors.transparent,
                            textColor: (item[childIndex] is Order
                                        ? _ctr.indexParams['order']
                                        : _ctr.indexParams[data
                                            .filter![
                                                data.order?.isNotEmpty == true
                                                    ? index - 1
                                                    : index]
                                            .field]) ==
                                    (item[childIndex] is Order
                                        ? item[childIndex].field
                                        : item[childIndex].keyword)
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            text: item[childIndex].name,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            onTap: (_) {
                              String name = item[childIndex] is Order
                                  ? 'order'
                                  : data
                                      .filter![data.order?.isNotEmpty == true
                                          ? index - 1
                                          : index]
                                      .field!;
                              _ctr.indexParams[name] =
                                  (item[childIndex] is Order
                                      ? item[childIndex].field
                                      : item[childIndex].keyword);
                              _ctr.onReload();
                            },
                          ),
                        ),
                        itemCount: item!.length,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          if (count > 5) ...[
            const SizedBox(height: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _ctr.isExpand.value = _ctr.isExpand.value.not;
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _ctr.isExpand.value ? '收起' : '展开',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Icon(
                      _ctr.isExpand.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );

  Widget _buildList(LoadingState<List<dynamic>?> loadingState) {
    return switch (loadingState) {
      Loading() => HttpError(errMsg: '加载中'),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: SliverGridDelegateWithExtentAndRatio(
                mainAxisSpacing: StyleString.cardSpace,
                crossAxisSpacing: StyleString.cardSpace,
                maxCrossAxisExtent: Grid.smallCardWidth / 3 * 2,
                childAspectRatio: 0.75,
                mainAxisExtent: MediaQuery.textScalerOf(context).scale(50),
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    _ctr.onLoadMore();
                  }
                  return BangumiCardVPgcIndex(
                      bangumiItem: loadingState.response![index]);
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(onReload: _ctr.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _ctr.onReload,
        ),
    };
  }
}
