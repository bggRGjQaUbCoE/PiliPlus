// =============================================================
// PiliPlus Windows 桌面化 · 主壳顶栏（纯 UI）
// 桌面顶栏（高 48，桌面 + 宽窗口启用）：
//   左：后退（复用 Get.back / canPop，与 Esc 返回一致）；刷新当前主入口
//   中：当前主入口标题（由导航配置提供，仅展示）
//   右：全局搜索框（全应用唯一搜索入口）
//       - 240×34、胶囊圆角 17、5% 填充、放大镜在左、12+18+8 间距
//       - 点击即进入输入状态（不跳页、不新增第二个搜索框）
//       - 回车直接执行搜索；展开时下方显示搜索历史
// 不含窗口管理/业务逻辑。
// =============================================================
import 'package:PiliPlus/common/widgets/desktop/desktop_search_panel.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class DesktopTopBar extends StatefulWidget {
  const DesktopTopBar({
    super.key,
    required this.mainController,
    required this.colorScheme,
    required this.searchPanelOpen,
    this.onOpenSearch,
    this.onCloseSearch,
  });

  /// 顶栏高度
  static const double height = 48;

  /// 顶栏左右内边距
  static const double paddingH = 12;

  /// 搜索框尺寸
  static const double searchWidth = 240;
  static const double searchHeight = 34;
  static const double searchRadius = 17;

  /// 搜索框在顶栏内的上边距（顶栏垂直居中）
  static const double searchTop = (height - searchHeight) / 2;

  final MainController mainController;
  final ColorScheme colorScheme;

  /// 搜索历史面板是否展开（用于同步输入状态）
  final bool searchPanelOpen;

  /// 点击搜索框：进入搜索状态并展开搜索历史
  final VoidCallback? onOpenSearch;

  /// 搜索已执行 / 面板收起：退出输入状态
  final VoidCallback? onCloseSearch;

  @override
  State<DesktopTopBar> createState() => _DesktopTopBarState();
}

class _DesktopTopBarState extends State<DesktopTopBar> {
  final TextEditingController _searchCtr = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void didUpdateWidget(DesktopTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchPanelOpen != oldWidget.searchPanelOpen) {
      if (widget.searchPanelOpen) {
        _searchFocus.requestFocus();
      } else {
        // 收起后恢复原有搜索框外观（回到占位文字）
        _searchFocus.unfocus();
        _searchCtr.clear();
      }
    }
  }

  @override
  void dispose() {
    _searchCtr.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  /// 回车：直接执行搜索（记录历史 + 进入结果页），不经过中间步骤。
  void _submit(String value) {
    widget.onCloseSearch?.call();
    desktopSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DesktopTopBar.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesktopTopBar.paddingH,
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: '后退 (Esc)',
              visualDensity: VisualDensity.compact,
              onPressed:
                  Get.key.currentState != null && Get.key.currentState!.canPop()
                  ? Get.back
                  : null,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
            ),
            IconButton(
              tooltip: '刷新当前页',
              visualDensity: VisualDensity.compact,
              onPressed: () {
                final nav = widget
                    .mainController
                    .navigationBars[widget.mainController.selectedIndex.value];
                if (nav == NavigationBarType.home) {
                  widget.mainController.refreshRecommendations();
                } else if (nav == NavigationBarType.dynamics) {
                  widget.mainController.dynamicController.onRefresh();
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 19),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Obx(
                () => Text(
                  widget.mainController.navigationBars.isEmpty
                      ? ''
                      : widget
                            .mainController
                            .navigationBars[widget
                                .mainController
                                .selectedIndex
                                .value]
                            .label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 唯一搜索框：外观/尺寸与原有搜索框一致（240×34 胶囊），
            // 但内部是一个透明输入层 —— 点击即进入输入状态，回车直接搜索。
            SizedBox(
              width: DesktopTopBar.searchWidth,
              height: DesktopTopBar.searchHeight,
              child: Material(
                borderRadius: BorderRadius.circular(
                  DesktopTopBar.searchRadius,
                ),
                color: widget.colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.05,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _searchFocus.requestFocus();
                    widget.onOpenSearch?.call();
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search_outlined,
                        size: 18,
                        color: widget.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtr,
                          focusNode: _searchFocus,
                          onTap: widget.onOpenSearch,
                          onSubmitted: _submit,
                          textInputAction: TextInputAction.search,
                          cursorColor: widget.colorScheme.primary,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: widget.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: '搜索视频 / UP主 / 番剧',
                            hintStyle: TextStyle(
                              fontSize: 12.5,
                              color: widget.colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
