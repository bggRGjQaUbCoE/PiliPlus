import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class VotePanel extends StatefulWidget {
  final VoteInfo voteInfo;
  final FutureOr<LoadingState<VoteInfo>> Function(Set<int>, bool) callback;

  const VotePanel({
    super.key,
    required this.voteInfo,
    required this.callback,
  });

  @override
  State<VotePanel> createState() => _VotePanelState();
}

class _VotePanelState extends State<VotePanel> {
  bool anonymity = false;

  late VoteInfo _voteInfo;
  late final RxSet<int> groupValue = (_voteInfo.myVotes?.toSet() ?? {}).obs;
  late var _percentage = _cnt2Percentage(_voteInfo.options);
  late bool _enabled =
      groupValue.isEmpty &&
      _voteInfo.endTime! * 1000 > DateTime.now().millisecondsSinceEpoch;
  late bool _showPercentage = !_enabled;
  late final _maxCnt = _voteInfo.choiceCnt ?? _voteInfo.options.length;

  @override
  void initState() {
    super.initState();
    _voteInfo = widget.voteInfo;
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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _voteInfo.options.length,
          itemBuilder: (context, index) => _buildOptions(index),
        ),
      ),
      if (_enabled) ...[
        _checkBoxs,
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Obx(
            () => OutlinedButton(
              onPressed: groupValue.isNotEmpty
                  ? () async {
                      final res = await widget.callback(
                        groupValue,
                        anonymity,
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
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_voteInfo.title != null)
          Text(_voteInfo.title!, style: theme.textTheme.titleMedium),
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

  Widget get _checkBoxs => Row(
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
        selected: anonymity,
        onChanged: (val) => anonymity = val,
      ),
    ],
  );

  Widget _buildOptions(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Builder(
        builder: (context) {
          final opt = _voteInfo.options[index];
          final selected = groupValue.contains(opt.optIdx);
          return PercentageChip(
            label: opt.optDesc!,
            percentage: _showPercentage ? _percentage[index] : null,
            selected: selected,
            onSelected: !_enabled || (groupValue.length >= _maxCnt && !selected)
                ? null
                : (value) => _onSelected(context, value, opt.optIdx!),
          );
        },
      ),
    );
  }

  void _onSelected(BuildContext context, bool value, int optidx) {
    bool isMax = groupValue.length >= _maxCnt;
    if (value) {
      groupValue.add(optidx);
    } else {
      groupValue.remove(optidx);
    }
    if ((isMax &&
            _maxCnt != _voteInfo.options.length &&
            groupValue.length < _maxCnt) ||
        (groupValue.length >= _maxCnt && _maxCnt < _voteInfo.options.length)) {
      setState(() {});
    } else {
      (context as Element).markNeedsBuild();
    }
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 625),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: VotePanel(
                voteInfo: voteInfo.data,
                callback: (votes, anonymity) => DynamicsHttp.doVote(
                  voteId: voteId,
                  votes: votes.toList(),
                  anonymity: anonymity,
                  dynamicId: dynamicId,
                ),
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
