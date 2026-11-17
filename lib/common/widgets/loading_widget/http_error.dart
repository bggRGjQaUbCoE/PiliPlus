import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

class HttpError extends StatelessWidget {
  const HttpError({
    super.key,
    this.isSliver = true,
    this.errMsg,
    this.onReload,
    this.btnText,
    this.safeArea = true,
    this.icon,
    this.fallbackMessage = '没有数据',
  });

  const HttpError.failure({
    Key? key,
    bool isSliver = true,
    String? errMsg,
    VoidCallback? onRetry,
    bool safeArea = true,
  }) : this(
         key: key,
         isSliver: isSliver,
         errMsg: errMsg,
         onReload: onRetry,
         safeArea: safeArea,
         fallbackMessage: '请求失败，请重试',
       );

  const HttpError.empty({
    Key? key,
    bool isSliver = true,
    String message = '暂无内容',
    VoidCallback? onRefresh,
    IconData icon = Icons.inbox_outlined,
    bool safeArea = true,
  }) : this(
         key: key,
         isSliver: isSliver,
         errMsg: message,
         onReload: onRefresh,
         btnText: '刷新',
         icon: icon,
         safeArea: safeArea,
       );

  final bool isSliver;
  final String? errMsg;
  final VoidCallback? onReload;
  final String? btnText;
  final bool safeArea;
  final IconData? icon;
  final String fallbackMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        const SizedBox(height: 40),
        if (icon != null)
          Icon(icon, size: 72, color: theme.colorScheme.onSurfaceVariant)
        else
          SvgPicture.asset(Assets.error, height: 200),
        const SizedBox(height: 30),
        Padding(
          padding: const .symmetric(horizontal: 16, vertical: 5),
          child: SelectionText(
            errMsg ?? fallbackMessage,
            textAlign: .center,
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (onReload != null)
          FilledButton.tonal(
            onPressed: onReload,
            style: FilledButton.styleFrom(
              tapTargetSize: .padded,
              backgroundColor: theme.colorScheme.primary.withAlpha(20),
            ),
            child: Text(
              btnText ?? '点击重试',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        if (safeArea)
          SizedBox(height: 40 + MediaQuery.viewPaddingOf(context).bottom),
      ],
    );

    return isSliver
        ? SliverToBoxAdapter(child: child)
        : SizedBox(width: double.infinity, child: child);
  }
}
