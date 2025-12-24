import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/common/widgets/avatars.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models_new/followee_votes/vote.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class VotePanel extends StatefulWidget {
  final VoteInfo voteInfo;
  final FutureOr<LoadingState<VoteInfo>> Function(Set<int>, bool) onVote;

  const VotePanel({
    super.key,
    required this.voteInfo,
    required this.onVote,
  });

  @override
  State<VotePanel> createState() => _VotePanelState();
}

class _VotePanelState extends State<VotePanel> {
  late bool anonymous = false;

  late VoteInfo _voteInfo;
  late final RxList<int> groupValue =
      (_voteInfo.myVotes?.toList() ?? <int>[]).obs;
  late var _percentage = _cnt2Percentage(_voteInfo.options);
  late bool _enabled =
      groupValue.isEmpty &&
      _voteInfo.endTime! * 1000 > DateTime.now().millisecondsSinceEpoch;
  late bool _showPercentage = !_enabled;
  late final _maxCnt = _voteInfo.choiceCnt ?? _voteInfo.options.length;
  final isLogin = Accounts.main.isLogin;
  late final Rxn<List<FolloweeVote>> followeeVote = Rxn<List<FolloweeVote>>();

  @override
  void initState() {
    super.initState();
    _voteInfo = widget.voteInfo;
    if (isLogin) {
      DynamicsHttp.followeeVotes(voteId: _voteInfo.voteId).then((res) {
        if (mounted && res.isSuccess) {
          followeeVote.value = res.data;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final usePortrait = size.width < 600 || size.shortestSide >= 600;
    final right = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _enabled
                ? '投票选项'
                : groupValue.isEmpty
                ? '已结束'
                : '已完成',
          ),
          if (_enabled) Obx(() => Text('${groupValue.length} / $_maxCnt')),
        ],
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _voteInfo.type == 1
              ? GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _voteInfo.options.length,
                  gridDelegate: SliverGridDelegateWithExtentAndRatio(
                    maxCrossAxisExtent: 100,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: MediaQuery.textScalerOf(context).scale(50),
                  ),
                  itemBuilder: (context, index) =>
                      _buildPicOptions(index, theme.colorScheme),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _voteInfo.options.length,
                  itemBuilder: (context, index) => _buildOptions(index),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 6),
                ),
        ),
      ),
      if (_enabled) ...[
        _checkBoxes,
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Obx(
            () => OutlinedButton(
              onPressed: groupValue.isNotEmpty
                  ? () async {
                      final res = await widget.onVote(
                        groupValue.toSet(),
                        anonymous,
                      );
                      if (res.isSuccess) {
                        if (mounted) {
                          setState(() {
                            _enabled = false;
                            _showPercentage = true;
                            _voteInfo = res.data;
                            _percentage = _cnt2Percentage(_voteInfo.options);
                          });
                        }
                      } else {
                        res.toast();
                      }
                    }
                  : null,
              child: const Center(child: Text('投票')),
            ),
          ),
        ),
      ],
    ];
    Widget title = Text(
      _voteInfo.title ?? '',
      style: theme.textTheme.titleMedium,
    );
    if (isLogin) {
      title = Row(
        spacing: 3,
        crossAxisAlignment: .start,
        children: [
          Expanded(child: title),
          Obx(() {
            final list = followeeVote.value;
            if (list != null && list.isNotEmpty) {
              return GestureDetector(
                behavior: .opaque,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final colorScheme = ColorScheme.of(context);
                      return AlertDialog(
                        clipBehavior: .hardEdge,
                        title: const Text('关注的人的投票'),
                        contentPadding: const .only(top: 10, bottom: 12),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: .min,
                            children: list
                                .map(
                                  (e) => ListTile(
                                    dense: true,
                                    onTap: () =>
                                        Get.toNamed('/member?mid=${e.mid}'),
                                    leading: NetworkImgLayer(
                                      src: e.face,
                                      width: 40,
                                      height: 40,
                                      type: .avatar,
                                    ),
                                    title: Text.rich(
                                      style: const TextStyle(fontSize: 13),
                                      TextSpan(
                                        children: [
                                          TextSpan(text: e.name),
                                          TextSpan(
                                            text: ' 投给了',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      style: const TextStyle(fontSize: 13),
                                      e.votes
                                          .map(
                                            (vote) => _voteInfo.options
                                                .firstWhereOrNull(
                                                  (e) => e.optIdx == vote,
                                                )
                                                ?.optDesc,
                                          )
                                          .join('、'),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    avatars(
                      colorScheme: theme.colorScheme,
                      users: list.take(3),
                    ),
                    Icon(
                      size: 18,
                      color: theme.colorScheme.outline.withValues(alpha: .7),
                      Icons.keyboard_arrow_right,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      );
    }
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (_voteInfo.desc != null)
          Text(
            _voteInfo.desc!,
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              Text(
                '至 ${DateFormatUtils.format(_voteInfo.endTime, format: DateFormatUtils.longFormatDs)}',
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: NumUtils.numFormat(_voteInfo.joinNum),
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const TextSpan(text: '人参与'),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (usePortrait) ...right,
      ],
    );
    if (!usePortrait) {
      child = Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: right,
            ),
          ),
        ],
      );
    }
    return child;
  }

  Widget get _checkBoxes => Row(
    spacing: 16,
    children: [
      CheckBoxText(
        text: '显示比例',
        selected: _showPercentage,
        onChanged: (value) {
          setState(() {
            _showPercentage = value;
          });
        },
      ),
      CheckBoxText(
        text: '匿名',
        selected: anonymous,
        onChanged: (val) => anonymous = val,
      ),
    ],
  );

  Widget _buildPicOptions(int index, ColorScheme colorScheme) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Builder(
        builder: (context) {
          final opt = _voteInfo.options[index];
          final selected = groupValue.contains(opt.optIdx);
          return InkWell(
            onTap: !_enabled
                ? null
                : () => _onSelected(context, !selected, opt.optIdx!),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: LayoutBuilder(
                        builder: (context, constraints) => NetworkImgLayer(
                          src: opt.imgUrl,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          radius: 0,
                        ),
                      ),
                    ),
                    if (_enabled || selected)
                      Positioned(
                        right: 4,
                        top: 4,
                        width: 20,
                        height: 20,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? colorScheme.primaryContainer
                                : null,
                            border: selected
                                ? null
                                : Border.all(
                                    color: colorScheme.primaryContainer,
                                  ),
                          ),
                          child: selected
                              ? Icon(
                                  size: 15,
                                  Icons.check_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                )
                              : null,
                        ),
                      ),
                    if (_showPercentage) ...[
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -1,
                        child: LinearProgressIndicator(
                          // ignore: deprecated_member_use
                          year2023: true,
                          value: _percentage[index],
                        ),
                      ),
                      PBadge(
                        right: 6,
                        bottom: 8,
                        type: PBadgeType.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        text:
                            '${(_percentage[index] * 100).toStringAsFixed(0)}%',
                      ),
                    ],
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    opt.optDesc!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptions(int index) {
    return Builder(
      builder: (context) {
        final opt = _voteInfo.options[index];
        final selected = groupValue.contains(opt.optIdx);
        return PercentageChip(
          label: opt.optDesc!,
          percentage: _showPercentage ? _percentage[index] : null,
          selected: selected,
          onSelected: !_enabled
              ? null
              : (value) => _onSelected(context, value, opt.optIdx!),
        );
      },
    );
  }

  void _onSelected(BuildContext itemCtx, bool value, int optidx) {
    final bool isMax = groupValue.length >= _maxCnt;
    if (isMax && value && !groupValue.contains(optidx)) {
      groupValue
        ..removeAt(0)
        ..add(optidx);
      setState(() {});
      return;
    }

    if (value) {
      groupValue.add(optidx);
    } else {
      groupValue.remove(optidx);
    }
    (itemCtx as Element).markNeedsBuild();
  }

  static List<double> _cnt2Percentage(List<Option> options) {
    final total = options.fold(0, (sum, opt) => sum + opt.cnt);
    return total == 0
        ? List<double>.filled(options.length, 0)
        : options.map((i) => i.cnt / total).toList(growable: false);
  }
}

class PercentageChip extends StatelessWidget {
  final String label;
  final double? percentage;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const PercentageChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      tooltip: label,
      labelPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      showCheckmark: false,
      clipBehavior: Clip.hardEdge,
      label: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (percentage != null)
            Positioned.fill(
              left: 0,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: ColoredBox(
                  color: selected
                      ? colorScheme.inversePrimary
                      : colorScheme.outlineVariant,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: colorScheme.onPrimaryContainer,
                        ),
                    ],
                  ),
                ),
                if (percentage != null)
                  Text('${(percentage! * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
    );
  }
}

Future showVoteDialog(
  BuildContext context,
  int voteId, [
  int? dynamicId,
]) async {
  final voteInfo = await DynamicsHttp.voteInfo(voteId);
  if (context.mounted) {
    if (voteInfo.isSuccess) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          constraints: const BoxConstraints(
            minWidth: 280,
            maxWidth: 625,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: VotePanel(
              voteInfo: voteInfo.data,
              onVote: (votes, anonymous) => DynamicsHttp.doVote(
                voteId: voteId,
                votes: votes.toList(),
                anonymous: anonymous,
                dynamicId: dynamicId,
              ),
            ),
          ),
        ),
      );
    } else {
      voteInfo.toast();
    }
  }
}
