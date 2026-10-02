import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/sliver_wrap.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/blacklist/list.dart';
import 'package:PiliPlus/pages/blacklist/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

enum _BlockType implements EnumWithLabel {
  local('本地'),
  online('在线'),
  ;

  @override
  final String label;

  _BlockType(this.label);
}

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _blackListController = Get.put(BlackListController());
  late EdgeInsets padding;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _BlockType.values.length,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    padding = MediaQuery.viewPaddingOf(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(title: const Text('黑名单管理')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _BlockType.values.map((e) => Tab(text: e.label)).toList(),
          ),
          Expanded(
            child: tabBarView(
              controller: _tabController,
              children: _BlockType.values
                  .map(
                    (e) => switch (e) {
                      _BlockType.local => _local,
                      _BlockType.online => _online,
                    },
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _online {
    return refreshIndicator(
      onRefresh: _blackListController.onRefresh,
      child: CustomScrollView(
        key: const PageStorageKey(_BlockType.online),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ViewSliverSafeArea(
            sliver: Obx(
              () => _buildBody(_blackListController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddMid(String mid) {
    if (mid.isEmpty) return;
    int intMid;
    try {
      intMid = int.parse(mid);
    } catch (e) {
      SmartDialog.showToast(e.toString());
      return;
    }
    _blackListController.blackMids.add(intMid);
    SmartDialog.showToast('屏蔽成功');
    setState(() {});
  }

  void _showAddMidDialog() {
    var text = '';
    showConfirmDialog(
      context: context,
      title: const Text('屏蔽用户'),
      content: TextField(
        autofocus: true,
        textInputAction: .done,
        keyboardType: .number,
        onChanged: (value) => text = value,
        onSubmitted: (value) {
          Get.back();
          _onAddMid(value);
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'UID',
          border: OutlineInputBorder(),
        ),
      ),
      onConfirm: () => _onAddMid(text),
    );
  }

  void _showImportExportDialog() {
    showImportExportDialog<List>(
      context,
      title: '黑名单',
      localFileName: () => 'blackMids',
      onExport: () =>
          Utils.jsonEncoder.convert(_blackListController.blackMids.toList()),
      onImport: (json) {
        final mids = Set<int>.from(json);
        _blackListController.blackMids.addAll(mids);
        setState(() {});
      },
    );
  }

  Widget get _local {
    return ScaffoldLayout(
      fab: Padding(
        padding: .only(
          right: kFloatingActionButtonMargin + padding.right,
          bottom: kFloatingActionButtonMargin + padding.bottom,
        ),
        child: Column(
          spacing: kFloatingActionButtonMargin,
          mainAxisSize: .min,
          children: [
            FloatingActionButton(
              tooltip: '导入/导出',
              onPressed: _showImportExportDialog,
              child: const Icon(Icons.swap_vert, size: 26),
            ),
            FloatingActionButton(
              tooltip: '添加',
              onPressed: _showAddMidDialog,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        key: const PageStorageKey(_BlockType.local),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ViewSliverSafeArea(
            sliver: SliverPadding(
              padding: const .fromLTRB(12, 12, 12, 0),
              sliver: SliverFixedWrap(
                spacing: 8,
                runSpacing: 8,
                mainAxisExtent: 30,
                delegate: SliverChildBuilderDelegate(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  childCount: _blackListController.blackMids.length,
                  (context, index) {
                    final mid = _blackListController.blackMids.elementAt(index);
                    return SearchText(
                      text: mid.toString(),
                      onTap: (mid) => Get.toNamed('/member?mid=$mid'),
                      onLongPress: (_) => showConfirmDialog(
                        context: context,
                        title: const Text('确定移除该用户？'),
                        onConfirm: () {
                          _blackListController.blackMids.remove(mid);
                          setState(() {});
                        },
                      ),
                      height: 1,
                      maxLines: 1,
                      fontSize: 14,
                      overflow: .ellipsis,
                      padding: const .fromLTRB(11, 8, 11, 0),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<BlackListItem>?> loadingState) {
    late final style = TextStyle(color: Theme.of(context).colorScheme.outline);
    return switch (loadingState) {
      Loading() => const SliverPrototypeExtentList(
        prototypeItem: MsgFeedTopSkeleton(),
        delegate: SliverSingleChildDelegate(
          count: 12,
          child: MsgFeedTopSkeleton(),
        ),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == response.length - 1) {
                    _blackListController.onLoadMore();
                  }
                  final item = response[index];
                  return ListTile(
                    visualDensity: .standard,
                    onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                    leading: NetworkImgLayer(
                      width: 45,
                      height: 45,
                      type: ImageType.avatar,
                      src: item.face,
                    ),
                    title: Text(
                      item.uname!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '添加时间: ${DateFormatUtils.format(item.mtime, format: DateFormatUtils.longFormatDs)}',
                      maxLines: 1,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                    dense: true,
                    trailing: TextButton(
                      onPressed: () async {
                        final removed = await _blackListController.onRemove(
                          context,
                          index,
                          item.uname,
                          item.mid,
                        );
                        if (mounted && removed) {
                          if (_blackListController.blackMids.remove(item.mid)) {
                            setState(() {});
                          }
                        }
                      },
                      child: const Text('移除'),
                    ),
                  );
                },
              )
            : HttpError(onReload: _blackListController.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _blackListController.onReload,
      ),
    };
  }
}
