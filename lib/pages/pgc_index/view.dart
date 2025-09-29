import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/data.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/sort.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_condition/value.dart';
import 'package:PiliPlus/models_new/pgc/pgc_index_result/list.dart';
import 'package:PiliPlus/pages/pgc_index/controller.dart';
import 'package:PiliPlus/pages/pgc_index/widgets/pgc_card_v_pgc_index.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final theme = Theme.of(context);
    return widget.indexType == null
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('索引')),
            body: Obx(() => _buildBody(theme, _ctr.conditionState.value)),
          )
        : Obx(() => _buildBody(theme, _ctr.conditionState.value));
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<PgcIndexConditionData> loadingState,
  ) {
    final padding = MediaQuery.viewPaddingOf(context);
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success(:var response) => Builder(
        builder: (context) {
          int count =
              (response.order?.isNotEmpty == true ? 1 : 0) +
              (response.filter?.length ?? 0);
          if (count == 0) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: CustomScrollView(
              controller: _ctr.scrollController,
              slivers: [
                if (widget.indexType != null)
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    duration: const Duration(milliseconds: 200),
                    child: count > 5
                        ? Obx(() => _buildSortsWidget(theme, count, response))
                        : _buildSortsWidget(theme, count, response),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: StyleString.safeSpace,
                    right: StyleString.safeSpace,
                    top: 12,
                    bottom: padding.bottom + 100,
                  ),
                  sliver: Obx(() => _buildList(_ctr.loadingState.value)),
                ),
              ],
            ),
          );
        },
      ),
      Error(:var errMsg) => scrollErrorWidget(
        errMsg: errMsg,
        onReload: () => _ctr
          ..conditionState.value = LoadingState.loading()
          ..getPgcIndexCondition(),
      ),
    };
  }

  Widget _buildSortWidget(
    ThemeData theme,
    int index,
    PgcIndexConditionData data,
    item,
  ) {
    if (item case PgcConditionOrder e) {
      return Obx(
        () {
          final isCurr = _ctr.indexParams['order'] == e.field;
          return SearchText(
            bgColor: isCurr
                ? theme.colorScheme.secondaryContainer
                : Colors.transparent,
            textColor: isCurr
                ? theme.colorScheme.onSecondaryContainer
                : theme.colorScheme.onSurfaceVariant,
            text: e.name!,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 3,
            ),
            onTap: (_) => _ctr
              ..indexParams['order'] = e.field
              ..onReload(),
          );
        },
      );
    }
    if (item case PgcConditionValue e) {
      final hasOrder = data.order?.isNotEmpty == true;
      if (hasOrder) index -= 1;
      final key = data.filter![index].field!;
      return Obx(
        () {
          final isCurr = _ctr.indexParams[key] == e.keyword;
          return SearchText(
            bgColor: isCurr
                ? theme.colorScheme.secondaryContainer
                : Colors.transparent,
            textColor: isCurr
                ? theme.colorScheme.onSecondaryContainer
                : theme.colorScheme.onSurfaceVariant,
            text: e.name!,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 3,
            ),
            onTap: (_) => _ctr
              ..indexParams[key] = e.keyword
              ..onReload(),
          );
        },
      );
    }
    throw UnsupportedError('${item.runtimeType}');
  }

  Widget _buildSortsWidget(
    ThemeData theme,
    int count,
    PgcIndexConditionData data,
  ) => Column(
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
                  padding: index == 0
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(top: 10),
                  child: SelfSizedHorizontalList(
                    gapSize: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    childBuilder: (childIndex) {
                      return _buildSortWidget(
                        theme,
                        index,
                        data,
                        item[childIndex],
                      );
                    },
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
          onTap: () => _ctr.isExpand.value = !_ctr.isExpand.value,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _ctr.isExpand.value ? '收起' : '展开',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                  ),
                ),
                Icon(
                  _ctr.isExpand.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );

  late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: StyleString.cardSpace,
    crossAxisSpacing: StyleString.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth * 0.6,
    childAspectRatio: 0.75,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(50),
  );

  Widget _buildList(LoadingState<List<PgcIndexItem>?> loadingState) {
    return switch (loadingState) {
      Loading() => linearLoading,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _ctr.onLoadMore();
                  }
                  return PgcCardVPgcIndex(item: response[index]);
                },
                itemCount: response!.length,
              )
            : HttpError(onReload: _ctr.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _ctr.onReload,
      ),
    };
  }
}
