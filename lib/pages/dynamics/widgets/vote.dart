import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

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
  late final groupValue = _voteInfo.myVotes?.toSet() ?? {};
  late var _percentage = _cnt2Percentage(_voteInfo.options);
  late bool _enabled = groupValue.isEmpty &&
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_voteInfo.title != null)
          Text(_voteInfo.title!, style: theme.textTheme.titleMedium),
        if (_voteInfo.desc != null)
          Text(_voteInfo.desc!, style: theme.textTheme.titleSmall),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              Text(
                '至 ${DateTime.fromMillisecondsSinceEpoch(_voteInfo.endTime! * 1000).toString().substring(0, 19)}',
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Utils.numFormat(_voteInfo.joinNum),
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    const TextSpan(text: '人参与'),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            if (_enabled) Text('${groupValue.length} / $_maxCnt'),
          ],
        ),
        Flexible(fit: FlexFit.loose, child: _buildContext()),
        if (_enabled)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: OutlinedButton(
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
      ],
    );
  }

  List<Widget> get _checkBoxs => [
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
          onChanged: (val) {
            anonymity = val;
          },
        ),
      ];

  Widget _buildOptions(int index) {
    final opt = _voteInfo.options[index];
    final selected = groupValue.contains(opt.optidx);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: PercentageChip(
        label: opt.optdesc!,
        percentage: _showPercentage ? _percentage[index] : null,
        selected: selected,
        onSelected: !_enabled || (groupValue.length >= _maxCnt && !selected)
            ? null
            : (value) => _onSelected(value, opt.optidx!),
      ),
    );
  }

  void _onSelected(bool value, int optidx) {
    if (value) {
      groupValue.add(optidx);
    } else {
      groupValue.remove(optidx);
    }
    setState(() {});
  }

  Widget _buildContext() {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverList.builder(
          itemCount: _voteInfo.options.length,
          itemBuilder: (context, index) => _buildOptions(index),
        ),
        if (_enabled) SliverList.list(children: _checkBoxs)
      ],
    );
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
      clipBehavior: Clip.antiAlias,
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
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (selected)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.check_circle,
                          size: 12,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                  ],
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

Future showVoteDialog(BuildContext context, voteId, [dynamicId]) async {
  final voteInfo = await DynamicsHttp.voteInfo(voteId);
  if (context.mounted) {
    if (voteInfo.isSuccess) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: SizedBox(
                  width: 160,
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
              ));
    } else {
      voteInfo.toast();
    }
  }
}
