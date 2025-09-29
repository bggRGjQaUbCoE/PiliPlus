import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/live_dm_silent_type.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/pages/live_dm_block/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class LiveDmBlockPage extends StatefulWidget {
  const LiveDmBlockPage({super.key});

  @override
  State<LiveDmBlockPage> createState() => _LiveDmBlockPageState();
}

class _LiveDmBlockPageState extends State<LiveDmBlockPage> {
  final _controller = Get.put(
    LiveDmBlockController(),
    tag: Utils.generateRandomString(8),
  );
  late bool isPortrait;
  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.sizeOf(context).isPortrait;
    padding = MediaQuery.viewPaddingOf(context);
    final theme = Theme.of(context);
    Widget tabBar = TabBar(
      controller: _controller.tabController,
      tabs: const [
        Tab(text: '关键词'),
        Tab(text: '用户'),
      ],
    );

    Widget view = tabBarView(
      controller: _controller.tabController,
      children: [
        KeepAliveWrapper(
          builder: (context) =>
              Obx(() => _buildKeyword(_controller.keywordList)),
        ),
        KeepAliveWrapper(
          builder: (context) =>
              Obx(() => _buildKeyword(_controller.shieldUserList)),
        ),
      ],
    );

    Widget title = Padding(
      padding: EdgeInsets.only(
        top: isPortrait ? 18 : 0,
        left: isPortrait ? 0 : 12,
        bottom: 12,
      ),
      child: const Text(
        '关键词屏蔽',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );

    Widget left = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '全局屏蔽',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          ..._buildHeader(theme),
          if (isPortrait) title,
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('弹幕屏蔽')),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            isPortrait
                ? ExtendedNestedScrollView(
                    onlyOneScrollInBody: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(child: left),
                        SliverOverlapAbsorber(
                          handle:
                              ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                          sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: CustomSliverPersistentHeaderDelegate(
                              extent: 48,
                              child: tabBar,
                              bgColor: null,
                            ),
                          ),
                        ),
                      ];
                    },
                    body: LayoutBuilder(
                      builder: (context, _) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top:
                                ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context,
                                ).layoutExtent ??
                                0,
                          ),
                          child: view,
                        );
                      },
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: left),
                      VerticalDivider(
                        width: 1,
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title,
                            tabBar,
                            Expanded(child: view),
                          ],
                        ),
                      ),
                    ],
                  ),
            Positioned(
              right: 16,
              bottom: 16 + padding.bottom,
              child: FloatingActionButton(
                tooltip: '添加',
                onPressed: _addShieldKeyword,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyword(List list) {
    if (list.isEmpty) {
      return isPortrait ? errorWidget() : scrollErrorWidget();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: padding.bottom + 100,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: list.indexed.map(
          (e) {
            final item = e.$2;
            return SearchText(
              text: item is ShieldUserList ? item.uname! : item as String,
              onTap: (value) => showConfirmDialog(
                context: context,
                title: '确定删除该规则？',
                onConfirm: () => _controller.onRemove(e.$1, item),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  List<Widget> _buildHeader(ThemeData theme) {
    return [
      const SizedBox(height: 6),
      Obx(
        () {
          final isEnable = _controller.isEnable.value;
          return Row(
            spacing: 10,
            children: [
              Text('屏蔽${isEnable ? '已' : '未'}开启'),
              Transform.scale(
                scale: .8,
                child: Switch(
                  value: isEnable,
                  onChanged: _controller.setEnable,
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 6),
      Obx(
        () {
          final level = _controller.level.value;
          return Row(
            children: [
              const Text('用户等级'),
              Slider(
                min: 0,
                max: 60,
                // ignore: deprecated_member_use
                year2023: true,
                inactiveColor: theme.colorScheme.onInverseSurface,
                padding: const EdgeInsets.only(left: 20, right: 25),
                value: level.toDouble(),
                onChangeStart: (value) => _controller.oldLevel = level,
                onChanged: (value) =>
                    _controller.level.value = value.round().clamp(0, 60),
                onChangeEnd: (value) {
                  if (_controller.oldLevel != level) {
                    _controller.setSilent(
                      LiveDmSilentType.level,
                      level,
                      onError: () =>
                          _controller.level.value = _controller.oldLevel ?? 0,
                    );
                  }
                },
              ),
              Text('$level 以下'),
            ],
          );
        },
      ),
      const SizedBox(height: 20),
      Row(
        spacing: 16,
        children: [
          Obx(() {
            final isEnable = _controller.rank.value == 1;
            return _headerBtn(
              theme,
              isEnable,
              Icons.live_tv,
              '非正式会员',
              () => _controller.setSilent(
                LiveDmSilentType.rank,
                isEnable ? 0 : 1,
              ),
            );
          }),
          Obx(() {
            final isEnable = _controller.verify.value == 1;
            return _headerBtn(
              theme,
              isEnable,
              Icons.smartphone,
              '未绑定手机用户',
              () => _controller.setSilent(
                LiveDmSilentType.verify,
                isEnable ? 0 : 1,
              ),
            );
          }),
        ],
      ),
    ];
  }

  Widget _headerBtn(
    ThemeData theme,
    bool isEnable,
    IconData icon,
    String name,
    VoidCallback onTap,
  ) {
    final color = isEnable
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    Widget top = Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: isEnable
          ? BoxDecoration(
              border: Border.all(color: color),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            )
          : null,
      child: Icon(icon, color: color),
    );

    if (isEnable) {
      top = Stack(
        clipBehavior: Clip.none,
        children: [
          top,
          Positioned(
            right: -6,
            top: -6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  size: 14,
                  Icons.horizontal_rule,
                  color: theme.colorScheme.onError,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        spacing: 5,
        children: [
          top,
          Text(
            name,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  void _addShieldKeyword() {
    bool isKeyword = _controller.tabController.index == 0;
    String value = '';
    showConfirmDialog(
      context: context,
      title: '${isKeyword ? '关键词' : '用户'}屏蔽',
      content: TextFormField(
        autofocus: true,
        initialValue: value,
        onChanged: (val) => value = val,
        decoration: isKeyword ? null : const InputDecoration(hintText: 'UID'),
        keyboardType: isKeyword ? null : TextInputType.number,
        inputFormatters: isKeyword
            ? null
            : [FilteringTextInputFormatter.digitsOnly],
      ),
      onConfirm: () {
        if (value.isNotEmpty) {
          _controller.addShieldKeyword(isKeyword, value);
        }
      },
    );
  }
}
