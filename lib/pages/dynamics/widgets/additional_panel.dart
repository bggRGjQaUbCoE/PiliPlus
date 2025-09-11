import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve/data.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide InkWell;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

Widget addWidget(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required dynamic idStr,
  required DynamicAddModel additional,
}) {
  final type = additional.type;
  late final Color bgColor = floor == 1
      ? theme.dividerColor.withValues(alpha: 0.08)
      : theme.colorScheme.surface;
  late final borderRadius = floor == 1 ? null : StyleString.mdRadius;
  Widget? child;
  try {
    switch (type) {
      // 转发的投稿
      case 'ADDITIONAL_TYPE_UGC':
        final ugc = additional.ugc!;
        child = InkWell(
          borderRadius: borderRadius,
          onTap: ugc.jumpUrl == null
              ? null
              : () => PiliScheme.routePushFromUrl(ugc.jumpUrl!),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                NetworkImgLayer(
                  width: 120,
                  height: 75,
                  src: ugc.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ugc.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ugc.descSecond!,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: theme.textTheme.labelMedium!.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'ADDITIONAL_TYPE_RESERVE':
        final reserve = additional.reserve!;
        if (reserve.state != -1 && reserve.title != null) {
          child = InkWell(
            onTap: () {},
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reserve.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: theme.colorScheme.outline,
                              fontSize: 13,
                            ),
                            children: [
                              if (reserve.desc1?.text?.isNotEmpty == true)
                                TextSpan(
                                  text: reserve.desc1!.text,
                                ),
                              if (reserve.desc2?.text?.isNotEmpty == true)
                                TextSpan(
                                  text: '    ${reserve.desc2!.text}',
                                ),
                              if (reserve.desc3?.text?.isNotEmpty == true) ...[
                                const TextSpan(text: '\n'),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    size: 17,
                                    Icons.card_giftcard,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${reserve.desc3!.text}',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                  recognizer: reserve.desc3!.jumpUrl == null
                                      ? null
                                      : (TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(
                                              '/webview',
                                              parameters: {
                                                'url': reserve.desc3!.jumpUrl!,
                                              },
                                            );
                                          }),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (reserve.button != null) ...[
                    const SizedBox(width: 10),
                    Builder(
                      builder: (context) {
                        final btn = reserve.button!;
                        final isReserved = btn.status == btn.type;
                        final bool canJump = btn.jumpUrl != null;
                        return FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            foregroundColor: canJump
                                ? null
                                : isReserved
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.38,
                                  )
                                : null,
                            backgroundColor: canJump
                                ? null
                                : isReserved
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.12,
                                  )
                                : null,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: canJump
                              ? () => PiliScheme.routePushFromUrl(
                                  btn.jumpUrl!,
                                )
                              : btn.disable == 1
                              ? null
                              : () async {
                                  var res = await DynamicsHttp.dynReserve(
                                    reserveId: reserve.rid,
                                    curBtnStatus: btn.status,
                                    dynamicIdStr: idStr,
                                    reserveTotal: reserve.reserveTotal,
                                  );
                                  if (res['status']) {
                                    DynReserveData data = res['data'];
                                    reserve
                                      ..desc2?.text = data.descUpdate
                                      ..reserveTotal = data.reserveUpdate
                                      ..button!.status = data.finalBtnStatus;
                                    if (context.mounted) {
                                      (context as Element?)?.markNeedsBuild();
                                    }
                                  } else {
                                    SmartDialog.showToast(
                                      res['msg'],
                                    );
                                  }
                                },
                          child: Text(
                            btn.jumpText != null
                                ? btn.jumpText!
                                : isReserved
                                ? btn.checkText!
                                : btn.uncheckText!,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();

      case 'ADDITIONAL_TYPE_UPOWER_LOTTERY':
        final content = additional.upowerLottery!;
        child = InkWell(
          borderRadius: borderRadius,
          onTap: content.jumpUrl == null
              ? null
              : () => PiliScheme.routePushFromUrl(content.jumpUrl!),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: 2,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (content.title?.isNotEmpty == true)
                        Text(content.title!),
                      if (content.hint?.text?.isNotEmpty == true)
                        Text(
                          content.hint!.text!,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (content.desc?.text?.isNotEmpty == true)
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  size: 17,
                                  Icons.card_giftcard,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: ' ${content.desc!.text!}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 13,
                                ),
                                recognizer: content.desc!.jumpUrl == null
                                    ? null
                                    : (TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(
                                            '/webview',
                                            parameters: {
                                              'url': content.desc!.jumpUrl!,
                                            },
                                          );
                                        }),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (content.button != null) ...[
                  const SizedBox(width: 10),
                  FilledButton.tonal(
                    onPressed: content.button!.jumpUrl == null
                        ? null
                        : () => PiliScheme.routePushFromUrl(
                            content.button!.jumpUrl!,
                          ),
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -3,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      content.button!.jumpStyle?.text ??
                          content.button!.check?.text ??
                          '',
                    ),
                  ),
                ],
              ],
            ),
          ),
        );

      // 商品
      case 'ADDITIONAL_TYPE_GOODS':
        final content = additional.goods!;
        if (content.items?.isNotEmpty == true) {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.items!.map((e) {
              return InkWell(
                borderRadius: borderRadius,
                onTap: () => PiliScheme.routePushFromUrl(e.jumpUrl!),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (e.cover?.isNotEmpty == true) ...[
                        NetworkImgLayer(
                          width: 45,
                          height: 45,
                          src: e.cover,
                          radius: 6,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (e.price?.isNotEmpty == true)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${e.price}',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' 起',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (e.jumpDesc?.isNotEmpty == true) ...[
                        const SizedBox(width: 10),
                        FilledButton.tonal(
                          onPressed: () =>
                              PiliScheme.routePushFromUrl(e.jumpUrl!),
                          style: FilledButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            visualDensity: const VisualDensity(
                              horizontal: -2,
                              vertical: -3,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(e.jumpDesc!),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();

      case 'ADDITIONAL_TYPE_VOTE':
        final vote = additional.vote!;
        child = InkWell(
          borderRadius: borderRadius,
          onTap: () => showVoteDialog(
            context,
            vote.voteId!,
            idStr is int
                ? idStr
                : idStr is String
                ? int.parse(idStr)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: floor == 1
                        ? theme.colorScheme.surface
                        : theme.dividerColor.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  width: 70,
                  height: 50,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vote.desc!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${NumUtils.numFormat(vote.joinNum)}人参与',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => showVoteDialog(
                    context,
                    vote.voteId!,
                    idStr is int
                        ? idStr
                        : idStr is String
                        ? int.parse(idStr)
                        : null,
                  ),
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -3,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('参与'),
                ),
              ],
            ),
          ),
        );

      case 'ADDITIONAL_TYPE_COMMON':
        final content = additional.common!;
        child = InkWell(
          borderRadius: borderRadius,
          onTap: content.jumpUrl == null
              ? null
              : () => PiliScheme.routePushFromUrl(content.jumpUrl!),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (content.cover?.isNotEmpty == true) ...[
                  NetworkImgLayer(
                    width: 45,
                    height: 45,
                    src: content.cover,
                    radius: 6,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    spacing: 2,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (content.title?.isNotEmpty == true)
                        Text(content.title!),
                      if (content.desc1?.isNotEmpty == true)
                        Text(
                          content.desc1!,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      if (content.desc2?.isNotEmpty == true)
                        Text(
                          content.desc2!,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                if (content.button?.jumpUrl?.isNotEmpty == true) ...[
                  const SizedBox(width: 10),
                  FilledButton.tonal(
                    onPressed: () => PiliScheme.routePushFromUrl(
                      content.button!.jumpUrl!,
                    ),
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -3,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(content.button!.jumpStyle?.text ?? ''),
                  ),
                ],
              ],
            ),
          ),
        );

      case 'ADDITIONAL_TYPE_MATCH':
        final content = additional.match!;
        child = InkWell(
          borderRadius: borderRadius,
          onTap: content.jumpUrl == null
              ? null
              : () => PiliScheme.routePushFromUrl(content.jumpUrl!),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (content.matchInfo?.title?.isNotEmpty == true)
                      Text(
                        content.matchInfo!.title!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    if (content.matchInfo?.subTitle?.isNotEmpty == true)
                      Text(
                        content.matchInfo!.subTitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                if (content.matchInfo?.leftTeam != null) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NetworkImgLayer(
                        width: 30,
                        height: 30,
                        src: content.matchInfo!.leftTeam!.pic,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        content.matchInfo!.leftTeam!.name!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
                Column(
                  children: [
                    if (content.matchInfo?.centerTop?.isNotEmpty == true)
                      Container(
                        height: 35,
                        alignment: Alignment.center,
                        child: Text(
                          content.matchInfo!.centerTop!.join(' '),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (content.matchInfo?.centerBottom?.isNotEmpty == true)
                      Text(
                        content.matchInfo!.centerBottom!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
                if (content.matchInfo?.rightTeam != null) ...[
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NetworkImgLayer(
                        width: 30,
                        height: 30,
                        src: content.matchInfo!.rightTeam!.pic,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        content.matchInfo!.rightTeam!.name!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                if (content.button case final button?)
                  FilledButton.tonal(
                    onPressed: () =>
                        PiliScheme.routePushFromUrl(button.jumpUrl!),
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -3,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(button.jumpStyle?.text ?? ''),
                  ),
              ],
            ),
          ),
        );
    }
    if (child != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Material(
          borderRadius: borderRadius,
          color: bgColor,
          child: child,
        ),
      );
    } else {
      if (kDebugMode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('additional panel\ntype: $type'),
        );
      }
      return const SizedBox.shrink();
    }
  } catch (e) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        '''
additional panel error
id: $idStr
type: $type
err: $e''',
      ),
    );
  }
}
