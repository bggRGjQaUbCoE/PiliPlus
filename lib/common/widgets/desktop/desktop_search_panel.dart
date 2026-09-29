// =============================================================
// PiliPlus Windows 桌面化 · 顶栏搜索历史面板
// 搜索入口只有一处：顶栏那个搜索框（点击后自身进入输入状态）。
// 本面板不含任何输入框，只在搜索框下方展示「搜索历史」：
//   - 两列布局、按搜索时间倒序（最新在最前）
//   - 点击历史词 → 直接执行搜索；Esc / 点击面板外 → 关闭
// 视觉：surfaceContainer 底色 + outlineVariant 描边 + 圆角 8 + 16 内边距
//   + 与桌面 hover 卡片同一套柔和阴影；列表字号 13.5。
// 历史复用既有本地存储（BaseSearchController.historyList），不新增网络请求。
// =============================================================
import 'package:PiliPlus/pages/search/controller.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

// 桌面统一度量（沿用 PC 树 winui_section.dart 中 WinUi 的取值）
const double _radius = 8;
const double _pad = 16;
const double _gap8 = 8;
const double _gap12 = 12;
const double _gap16 = 16;

/// 桌面端统一搜索入口：按既有规则记录历史 → 进入搜索结果页。
/// （与搜索页 `SSearchController.submit()` 使用同一套存储键与倒序规则）
void desktopSearch(String word) {
  final text = word.trim();
  if (text.isEmpty) return;
  final baseCtr = Get.putOrFind(BaseSearchController.new);
  if (baseCtr.recordSearchHistory.value) {
    final list = baseCtr.historyList;
    final index = list.indexOf(text);
    if (index != 0) {
      if (index != -1) list.removeAt(index);
      list.insert(0, text);
      GStorage.historyWord.put('cacheList', list);
    }
  }
  Get.toNamed('/searchResult', parameters: {'keyword': text});
}

class DesktopSearchPanel extends StatelessWidget {
  const DesktopSearchPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  /// 面板宽度（与顶栏搜索框右对齐）
  static const double width = 420;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseCtr = Get.putOrFind(BaseSearchController.new);
    final radius = BorderRadius.circular(_radius);
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): onClose,
      },
      child: GestureDetector(
        // 面板整块吸收点击：点击「搜索历史」区域（含标题、空白、间距）
        // 不会穿透到背景遮罩，因此不会触发「取消搜索」。
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: radius,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: .55),
            ),
            // 与桌面端 hover 卡片使用同一套柔和阴影
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .16),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(_pad, _gap12, _pad, _gap8),
                  child: Text(
                    '搜索历史',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: Obx(() {
                    final list = baseCtr.historyList;
                    if (list.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: _gap16),
                        child: Center(
                          child: Text(
                            '暂无搜索历史',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: _gap8),
                      child: Column(
                        children: [
                          for (var i = 0; i < list.length; i += 2)
                            Row(
                              children: [
                                Expanded(child: _item(list[i])),
                                Expanded(
                                  child: i + 1 < list.length
                                      ? _item(list[i + 1])
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 单条搜索历史：点击直接执行该搜索。
  Widget _item(String word) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius - 2),
        onTap: () {
          onClose();
          desktopSearch(word);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _pad,
            vertical: _gap8,
          ),
          child: Text(
            word,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5),
          ),
        ),
      ),
    );
  }
}
