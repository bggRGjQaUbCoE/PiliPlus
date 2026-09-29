import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/follow/child/child_controller.dart';
import 'package:PiliPlus/pages/follow/child/child_view.dart';
import 'package:PiliPlus/pages/follow/controller.dart';
import 'package:PiliPlus/pages/follow_tag_sort/view.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/parse_int.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();

  static void toFollowPage({dynamic mid, String? name}) {
    if (mid == null) return;
    Get.toNamed(
      '/follow',
      arguments: {
        'mid': safeToInt(mid),
        'name': name,
      },
    );
  }
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin, BaseFabMixin, LazyFabMixin {
  final _tag = Utils.generateRandomString(8);
  late final FollowController _followController;

  @override
  void initState() {
    super.initState();
    _followController = Get.put(FollowController(_tag), tag: _tag);
  }

  @override
  bool onNotification(UserScrollNotification notification) {
    if (notification.metrics.axisDirection == .down) {
      return super.onNotification(notification);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return SimpleScaffold(
      appBar: _buildAppBar,
      body: _followController.isOwner
          ? fabAnimWrapper(
              child: Obx(() => _buildBody(_followController.followState.value)),
            )
          : _childPage(),
      fab: _followController.isOwner
          ? SlideTransition(
              position: fabAnimation,
              child: Padding(
                padding: .only(
                  right: kFloatingActionButtonMargin + padding.right,
                  bottom: kFloatingActionButtonMargin + padding.bottom,
                ),
                child: FloatingActionButton.extended(
                  onPressed: _followController.toggleOrderType,
                  icon: const Icon(Icons.format_list_bulleted, size: 20),
                  label: Obx(
                    () => Text(_followController.orderType.value.title),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget get _buildAppBar => AppBar(
    title: _followController.isOwner
        ? Text(L10n.current.contactPageText)
        : Obx(() {
            final name = _followController.name.value;
            if (name != null) {
              return Text(
                L10n.current.followPageBuildAppBarTitle(name),
              );
            }
            return const SizedBox.shrink();
          }),
    actions: _followController.isOwner
        ? [
            IconButton(
              onPressed: () => RequestUtils.createFavTag(
                context,
                _followController.onCreateFavTag,
              ),
              icon: const Icon(Icons.add),
              tooltip: L10n.current.followPageBuildAppBarTooltip,
            ),
            IconButton(
              onPressed: () {
                if (_followController.followState.value is! Success) {
                  return;
                }
                Get.to(FollowTagSortPage(controller: _followController));
              },
              icon: const Icon(Icons.sort),
              tooltip: L10n.current.followPageBuildAppBarTooltip2,
            ),
            IconButton(
              onPressed: () => Get.toNamed(
                '/followSearch',
                arguments: {
                  'mid': _followController.mid,
                },
              ),
              icon: const Icon(Icons.search_outlined),
              tooltip: L10n.current.search,
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Get.toNamed('/blackListPage'),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      const Icon(Icons.block, size: 19),
                      Text(L10n.current.followPageBuildAppBarChildren),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
          ]
        : null,
  );

  Widget _childPage([MemberTagItemModel? item]) => FollowChildPage(
    tag: _tag,
    controller: _followController,
    mid: _followController.mid,
    tagid: item?.tagid,
  );

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => m3eLoading,
      Success() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewSafeArea(
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _followController.tabController,
              tabs: List.generate(_followController.tabs.length, (index) {
                return Obx(() {
                  final item = _followController.tabs[index];
                  int? count = item.count;
                  if (BiliUtils.isCustomFollowTag(item.tagid)) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        _onHandleTag(index, item);
                      },
                      onSecondaryTap: PlatformUtils.isMobile
                          ? null
                          : () => _onHandleTag(index, item),
                      child: Tab(
                        child: Row(
                          children: [
                            Text(
                              '${item.tagid == null ? L10n.current.followChildPageBuildSameFollowingChild : item.name}${count != null ? '($count)' : ''} ',
                            ),
                            const Icon(Icons.menu, size: 18),
                          ],
                        ),
                      ),
                    );
                  }
                  return Tab(
                    text:
                        '${item.tagid == null ? L10n.current.followChildPageBuildSameFollowingChild : item.name}${count != null ? '($count)' : ''}',
                  );
                });
              }),
              onTap: (value) {
                if (!_followController.tabController!.indexIsChanging) {
                  final item = _followController.tabs[value];
                  // if (_isCustomTag(item.tagid)) {
                  //   _onHandleTag(value, item);
                  // }
                  try {
                    Get.find<FollowChildController>(
                      tag: '$_tag${item.tagid}',
                    ).animateToTop();
                  } catch (_) {}
                }
              },
            ),
          ),
          Expanded(
            child: tabBarView(
              controller: _followController.tabController,
              children: _followController.tabs.map(_childPage).toList(),
            ),
          ),
        ],
      ),
      Error() => _childPage(),
    };
  }

  void _onHandleTag(int index, MemberTagItemModel item) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          DialogOption(
            onPressed: () {
              Get.back();
              String tagName = item.name!;
              showConfirmDialog(
                context: context,
                title: Text(L10n.current.followPageOnHandleTagTitle2),
                content: TextFormField(
                  autofocus: true,
                  initialValue: tagName,
                  onChanged: (value) => tagName = value,
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                onConfirm: () {
                  if (tagName.isNotEmpty) {
                    _followController.onUpdateTag(item, tagName);
                  }
                },
              );
            },
            child: Text(
              L10n.current.followPageOnHandleTagChild,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          DialogOption(
            onPressed: () {
              Get.back();
              showConfirmDialog(
                context: context,
                title: Text(L10n.current.followPageOnHandleTagTitle),
                content: Text(L10n.current.followPageOnHandleTagContent),
                onConfirm: () => _followController.onDelTag(index, item.tagid!),
              );
            },
            child: Text(
              L10n.current.followPageOnHandleTagTitle,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
