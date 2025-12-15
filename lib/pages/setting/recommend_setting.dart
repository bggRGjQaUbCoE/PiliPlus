import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/pages/setting/models/recommend_settings.dart';
import 'package:flutter/material.dart' hide ListTile;

class RecommendSetting extends StatefulWidget {
  const RecommendSetting({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<RecommendSetting> createState() => _RecommendSettingState();
}

class _RecommendSettingState extends State<RecommendSetting> {
  final list = recommendSettings;

  @override
  Widget build(BuildContext context) {
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.showAppBar ? AppBar(title: const Text('推荐流设置')) : null,
      body: ListView(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        children: [
          ...list.take(4),
          const Divider(height: 1),
          ...list.skip(4),
          ListTile(
            dense: true,
            subtitle: Text(
              '¹ 由于接口未提供关注信息，无法豁免相关视频中的已关注Up。\n\n'
              '* 其它（如热门视频、手动搜索、链接跳转等）均不受过滤器影响。\n'
              '* 设定较严苛的条件可导致推荐项数锐减或多次请求，请酌情选择。\n'
              '* 后续可能会增加更多过滤条件，敬请期待。',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
