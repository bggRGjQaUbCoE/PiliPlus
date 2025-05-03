import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class VotePanel extends StatefulWidget {
  final VoteInfo voteInfo;
  final FutureOr<LoadingState<VoteInfo>> Function(Set<int>, bool) callback;
  final bool embedded;

  const VotePanel({
    super.key,
    required this.voteInfo,
    required this.callback,
    this.embedded = false,
  });

  @override
  State<VotePanel> createState() => _VotePanelState();
}

class _VotePanelState extends State<VotePanel> {
  bool anonymity = false;

  late VoteInfo _voteInfo;
  late final bool _embedded;
  late final groupValue = _voteInfo.myVotes?.toSet() ?? {};
  late var _percentage = _cnt2Percentage(_voteInfo.options);
  late bool _enabled = groupValue.isEmpty &&
      _voteInfo.endTime! * 1000 > DateTime.now().millisecondsSinceEpoch;
  late bool _showPercentage = !_enabled;
  late final _maxCnt = _voteInfo.choiceCnt ?? _voteInfo.options.length;

  late final _selectedNum = ValueNotifier(groupValue.length);
  late final _canVote = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _voteInfo = widget.voteInfo;
    _embedded = widget.embedded || widget.voteInfo.options.length < 5;
  }

  @override
  void dispose() {
    _selectedNum.dispose();
    _canVote.dispose();
    super.dispose();
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '至 ${DateTime.fromMillisecondsSinceEpoch(_voteInfo.endTime! * 1000).toString().substring(0, 19)}',
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _voteInfo.joinNum.toString(),
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    TextSpan(text: '人参与'),
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
            ValueListenableBuilder(
              valueListenable: _selectedNum,
              builder: (_, val, __) => Text('$val / $_maxCnt'),
            ),
          ],
        ),
        if (_embedded)
          _buildContext()
        else
          Flexible(fit: FlexFit.loose, child: _buildContext()),
        if (_enabled)
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: ValueListenableBuilder(
              valueListenable: _canVote,
              builder: (_, val, __) => OutlinedButton(
                onPressed: val
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
                          SmartDialog.showToast((res as Error).errMsg);
                        }
                      }
                    : null,
                child: const Center(child: Text('投票')),
              ),
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
        // TODO 转发到动态
      ];

  Widget _buildOptions(int index) {
    final opt = _voteInfo.options[index];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: PercentageChip<int>(
          label: opt.optdesc!,
          value: opt.optidx!,
          groupValue: groupValue,
          disabled: groupValue.length >= _maxCnt,
          percentage: _showPercentage ? _percentage[index] : null,
          callback: _enabled ? _toggleSelection : null,
        ));
  }

  Widget _buildContext() {
    return _embedded
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(_voteInfo.options.length, _buildOptions),
              if (_enabled) ..._checkBoxs,
            ],
          )
        : CustomScrollView(
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

  bool _toggleSelection(bool val) {
    _selectedNum.value = groupValue.length;
    _canVote.value = groupValue.isNotEmpty;
    if (groupValue.length >= _maxCnt ||
        (!val && groupValue.length + 1 == _maxCnt)) {
      setState(() {});
      return true;
    }
    return false;
  }
}

class PercentageChip<T> extends StatefulWidget {
  final String label;
  final T value;
  final Set<T> groupValue;
  final double? percentage;
  final bool disabled;
  final bool? Function(bool)? callback;

  const PercentageChip({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    this.disabled = false,
    this.percentage,
    this.callback,
  });

  @override
  State<PercentageChip<T>> createState() => _PercentageChipState<T>();
}

class _PercentageChipState<T> extends State<PercentageChip<T>> {
  late Set<T> groupValue;

  @override
  void initState() {
    super.initState();
    groupValue = widget.groupValue;
  }

  bool get selected => groupValue.contains(widget.value);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      labelPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      showCheckmark: false,
      clipBehavior: Clip.antiAlias,
      label: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (widget.percentage != null)
            Positioned.fill(
              left: 0,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.percentage,
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
                    Text(widget.label),
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
                if (widget.percentage != null)
                  Text('${(widget.percentage! * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: widget.disabled && (!selected || widget.callback == null)
          ? null
          : (value) {
              value
                  ? groupValue.add(widget.value)
                  : groupValue.remove(widget.value);
              if (widget.callback?.call(value) == true) setState(() {});
            },
    );
  }
}

// class VoteCard extends StatefulWidget {
//   final int voteId;
//   final bool isSliver;

//   const VoteCard(this.voteId, {super.key, this.isSliver = false});

//   @override
//   State<VoteCard> createState() => _VoteCardState();
// }

// class _VoteCardState extends State<VoteCard> {
//   late Future<LoadingState<VoteInfo>> _futureBuilderFuture;

//   @override
//   void initState() {
//     super.initState();
//     _futureBuilderFuture = getInfo();
//   }

//   Future<LoadingState<VoteInfo>> getInfo() =>
//       DynamicsHttp.voteInfo(widget.voteId);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _futureBuilderFuture,
//         builder: (context, snapshot) => switch (snapshot.data) {
//               Success(response: final res) => VotePanel(
//                   embedded: true,
//                   voteInfo: res,
//                   callback: (votes, anonymity) => DynamicsHttp.doVote(
//                         voteId: widget.voteId,
//                         votes: votes.toList(),
//                         anonymity: anonymity,
//                       )),
//               Error(errMsg: final msg) => HttpError(
//                   isSliver: widget.isSliver,
//                   errMsg: msg,
//                   onReload: () {
//                     setState(() {
//                       _futureBuilderFuture = getInfo();
//                     });
//                   }),
//               _ => const SizedBox.shrink()
//             });
//   }
// }

Future showVoteDialog(BuildContext context, int voteId,
    [int? dynamicId]) async {
  final voteInfo = await DynamicsHttp.voteInfo(voteId);
  if (context.mounted) {
    if (voteInfo.isSuccess) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: SizedBox(
                  width: 120,
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
      SmartDialog.showToast((voteInfo as Error).errMsg);
    }
  }
}
