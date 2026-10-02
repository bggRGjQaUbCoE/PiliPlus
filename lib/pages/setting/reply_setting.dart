import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/models/reply_settings.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class ReplySetting extends StatefulWidget {
  const ReplySetting({
    super.key,
    this.showAppBar = true,
    this.autoOpenKeywordFilter = false,
  });

  final bool showAppBar;
  final bool autoOpenKeywordFilter;

  @override
  State<ReplySetting> createState() => _ReplySettingState();
}

class _ReplySettingState extends State<ReplySetting> {
  final list = replySettings;
  int _level = Pref.replyMinLevel;

  @override
  void initState() {
    super.initState();
    if (widget.autoOpenKeywordFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || list.isEmpty) {
          return;
        }
        final firstItem = list.first;
        if (firstItem case NormalModel(:final onTap)) {
          onTap?.call(context, () {
            if (mounted) {
              setState(() {});
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: showAppBar ? AppBar(title: const Text('评论区过滤设置')) : null,
      body: ListView(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        children: [
          ...list.map((item) => item.widget),
          _buildLevelSlider(theme),
          ListTile(
            dense: true,
            subtitle: Text(
              '* 屏蔽用户后，该用户发布的评论将不会显示。\n'
              '* 评论区屏蔽用户优先于白名单生效。\n'
              '* 白名单用户与动态流/推荐流共享，白名单优先于带货屏蔽和常规过滤。\n'
              '* 关键词过滤支持正则表达式，多个关键词使用|分隔。\n'
              '* 等级过滤：屏蔽低于所设等级的用户发布的评论，0 为关闭。\n'
              '* 设置立即生效，刷新评论区即可看到过滤结果。',
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSlider(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: const Text('屏蔽低等级用户评论'),
          subtitle: Text(
            _level == 0 ? '已关闭' : '屏蔽 Lv${_level - 1} 及以下的评论',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Lv0'),
              Expanded(
                child: Slider(
                  min: 0,
                  max: 6,
                  divisions: 6,
                  value: _level.toDouble(),
                  label: _level == 0 ? '关闭' : 'Lv$_level',
                  onChanged: (v) {
                    final level = v.round();
                    setState(() => _level = level);
                    Pref.replyMinLevel = level;
                    ReplyGrpc.replyMinLevel = level;
                  },
                ),
              ),
              const Text('Lv6'),
            ],
          ),
        ),
      ],
    );
  }
}
