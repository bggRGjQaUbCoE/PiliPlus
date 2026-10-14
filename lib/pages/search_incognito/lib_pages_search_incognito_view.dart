import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/incognito_mode.dart';
import 'package:PiliPlus/pages/search_incognito/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 隐身搜索页：独立搜索历史，不污染账号推荐算法。
class SearchIncognitoPage extends StatefulWidget {
  const SearchIncognitoPage({super.key});

  @override
  State<SearchIncognitoPage> createState() => _SearchIncognitoPageState();
}

class _SearchIncognitoPageState extends State<SearchIncognitoPage> {
  final _controller = Get.put(SearchIncognitoController());

  @override
  void initState() {
    super.initState();
    // 进入隐身搜索页即开启隐身模式
    IncognitoMode.enter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller.textController,
          focusNode: _controller.searchFocusNode,
          autofocus: true,
          textInputAction: .search,
          onSubmitted: _controller.onSubmitted,
          decoration: InputDecoration(
            hintText: '隐身搜索，不留痕迹',
            hintStyle: TextStyle(
              color: theme.colorScheme.outline.withOpacity(0.7),
            ),
            prefixIcon: const Icon(Icons.visibility_off_outlined, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        actions: [
          Obx(
            () => _controller.historyList.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: _controller.onClearHistory,
                    child: const Text('清空'),
                  ),
          ),
        ],
      ),
      body: Obx(
        () {
          final list = _controller.historyList;
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 48,
                    color: theme.colorScheme.outline.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '隐身模式下搜索\n不会影响你的推荐',
                    textAlign: .center,
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final keyword = list[i];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, size: 20),
                title: Text(
                  keyword,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _controller.onDeleteOne(keyword),
                ),
                onTap: () => _controller.onSubmitted(keyword),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // 离开隐身搜索页时关闭隐身模式
    IncognitoMode.exit();
    Get.delete<SearchIncognitoController>();
    super.dispose();
  }
}
