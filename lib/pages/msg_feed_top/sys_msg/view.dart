import 'package:PiliPlus/common/skeleton/msg_feed_sys_msg_.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/msg/msg_sys/data.dart';
import 'package:PiliPlus/pages/msg_feed_top/sys_msg/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SysMsgPage extends StatefulWidget {
  const SysMsgPage({super.key});

  @override
  State<SysMsgPage> createState() => _SysMsgPageState();
}

class _SysMsgPageState extends State<SysMsgPage> {
  late final _sysMsgController = Get.put(SysMsgController());
  late final RegExp urlRegExp = RegExp(
    r'#\{([^}]*)\}\{([^}]*)\}|https?:\/\/[^\s/\$.?#].[^\s]*|www\.[^\s/\$.?#].[^\s]*|【(.*?)】|（(\d+)）',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('系统通知')),
      body: refreshIndicator(
        onRefresh: _sysMsgController.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _sysMsgController.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<MsgSysItem>?> loadingState,
  ) {
    late final divider = Divider(
      indent: 72,
      endIndent: 20,
      height: 6,
      color: Colors.grey.withValues(alpha: 0.1),
    );
    return switch (loadingState) {
      Loading() => SliverSafeArea(
        sliver: SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) => const MsgFeedSysMsgSkeleton(),
        ),
      ),
      Success(:var response) =>
        response != null && response.isNotEmpty
            ? SliverList.separated(
                itemCount: response.length,
                itemBuilder: (context, int index) {
                  if (index == response.length - 1) {
                    _sysMsgController.onLoadMore();
                  }
                  final item = response[index];
                  void onLongPress() => showConfirmDialog(
                    context: context,
                    title: '确定删除该通知?',
                    onConfirm: () => _sysMsgController.onRemove(item.id, index),
                  );
                  return ListTile(
                    safeArea: true,
                    onLongPress: onLongPress,
                    onSecondaryTap: Utils.isMobile ? null : onLongPress,
                    title: Text(
                      "${item.title}",
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text.rich(
                          _buildContent(theme, item.content ?? ''),
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${item.timeAt}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 13,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => divider,
              )
            : HttpError(onReload: _sysMsgController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _sysMsgController.onReload,
      ),
    };
  }

  InlineSpan _buildContent(ThemeData theme, String content) {
    final List<InlineSpan> spanChildren = <InlineSpan>[];
    content.splitMapJoin(
      urlRegExp,
      onMatch: (Match match) {
        final matchStr = match[0]!;
        if (matchStr.startsWith('#')) {
          try {
            final url = match[2]!.replaceAll('"', '');
            spanChildren.add(
              TextSpan(
                text: match[1],
                style: TextStyle(color: theme.colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    try {
                      PiliScheme.routePushFromUrl(url);
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    }
                  },
              ),
            );
          } catch (e) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else if (matchStr.startsWith('【')) {
          try {
            final isBV = match[3]!.startsWith('BV');
            final int validAv;
            final String validBv;
            if (isBV) {
              validBv = match[3]!;
              validAv = IdUtils.bv2av(validBv);
            } else {
              validAv = int.parse(match[3]!);
              validBv = IdUtils.av2bv(validAv);
            }
            spanChildren
              ..add(const TextSpan(text: '【'))
              ..add(
                TextSpan(
                  text: match[3],
                  style: TextStyle(color: theme.colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      PiliScheme.videoPush(validAv, validBv);
                    },
                ),
              )
              ..add(const TextSpan(text: '】'));
          } catch (e) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else if (matchStr.startsWith('（')) {
          try {
            final dynId = match[4]!; // check dynId
            spanChildren
              ..add(const TextSpan(text: '（'))
              ..add(
                TextSpan(
                  text: '查看动态',
                  style: TextStyle(color: theme.colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      PageUtils.pushDynFromId(id: dynId).catchError(
                        (err) => SmartDialog.showToast(err.toString()),
                      );
                    },
                ),
              )
              ..add(const TextSpan(text: '）'));
          } catch (e) {
            spanChildren.add(TextSpan(text: matchStr));
          }
        } else {
          spanChildren.add(
            TextSpan(
              text: '\u{1F517}网页链接',
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  PiliScheme.routePushFromUrl(matchStr);
                },
            ),
          );
        }
        return '';
      },
      onNonMatch: (String nonMatchStr) {
        spanChildren.add(
          TextSpan(text: nonMatchStr),
        );
        return '';
      },
    );
    return TextSpan(children: spanChildren);
  }
}
