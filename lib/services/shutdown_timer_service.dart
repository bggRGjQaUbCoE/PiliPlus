// 定时关闭服务
import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/menu_row.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

enum _ShutdownType with EnumWithLabel {
  pause('暂停视频'),
  exit('退出APP')
  ;

  @override
  final String label;
  const _ShutdownType(this.label);
}

final shutdownTimerService = ShutdownTimerService._internal();

class ShutdownTimerService {
  ShutdownTimerService._internal();

  VoidCallback? onPause;
  ValueGetter<bool>? isPlaying;

  Timer? _shutdownTimer;
  bool get isActive => _shutdownTimer?.isActive ?? false;
  int _durationInMinutes = 0;
  _ShutdownType _shutdownType = .pause;

  bool _isWaiting = false;
  bool get isWaiting => _isWaiting;
  bool _waitUntilCompleted = false;

  void _stopTimer() {
    if (_shutdownTimer != null) {
      _shutdownTimer!.cancel();
      _shutdownTimer = null;
    }
  }

  void reset([int durationInMinutes = 0]) {
    _stopTimer();
    _isWaiting = false;
    _durationInMinutes = durationInMinutes;
  }

  void _startShutdownTimer(int durationInMinutes) {
    reset(durationInMinutes);
    if (durationInMinutes == 0) {
      SmartDialog.showToast('取消定时关闭');
      return;
    }
    SmartDialog.showToast('设置 ${_format(durationInMinutes)} 后定时关闭');
    _shutdownTimer = Timer(
      Duration(minutes: durationInMinutes),
      _handleShutdown,
    );
  }

  void _handleShutdown() {
    switch (_shutdownType) {
      case _ShutdownType.pause:
        late final player = PlPlayerController.instance;
        final isPlaying =
            this.isPlaying?.call() ?? player?.playerStatus.isPlaying ?? false;
        if (isPlaying) {
          if (_waitUntilCompleted) {
            _isWaiting = true;
          } else {
            _durationInMinutes = 0;
            (onPause ?? player?.pause)?.call();
            SmartDialog.showToast('定时时间已到，已暂停');
          }
        }
      case _ShutdownType.exit:
        if (_waitUntilCompleted) {
          final isPlaying =
              this.isPlaying?.call() ??
              PlPlayerController.instance?.playerStatus.isPlaying ??
              false;
          if (isPlaying) {
            _isWaiting = true;
            return;
          }
        }
        exit(0);
    }
  }

  void handleWaiting() {
    switch (_shutdownType) {
      case _ShutdownType.pause:
        _isWaiting = false;
        _durationInMinutes = 0;
        SmartDialog.showToast('定时时间已到，已暂停');
      case _ShutdownType.exit:
        exit(0);
    }
  }

  static (int hour, int minute) _parseMinutes(int minutes) =>
      (minutes ~/ 60, minutes % 60);

  static String _format(int minutes) {
    if (minutes == 60) return '60分钟';
    final (int hour, int minute) = _parseMinutes(minutes);
    if (hour > 0 && minute > 0) {
      return '$hour小时$minute分钟';
    } else if (hour > 0) {
      return '$hour小时';
    } else {
      return '$minute分钟';
    }
  }

  void showScheduleExitDialog(
    BuildContext context, {
    required bool isFullScreen,
    bool isLive = false,
  }) {
    const Set<int> scheduleTimeMinutes = {0, 15, 30, 45, 60};
    const TextStyle titleStyle = TextStyle(fontSize: 14);
    if (isLive) {
      _waitUntilCompleted = false;
    }
    PageUtils.showVideoBottomSheet(
      context,
      isFullScreen: () => isFullScreen,
      child: StatefulBuilder(
        builder: (_, setState) {
          final ThemeData theme = Theme.of(context);
          return Theme(
            data: theme,
            child: Padding(
              padding: const .all(12),
              child: Material(
                clipBehavior: .hardEdge,
                color: theme.colorScheme.surface,
                borderRadius: const .all(.circular(12)),
                child: ListView(
                  padding: const .symmetric(vertical: 14),
                  children: [
                    const Center(child: Text('定时关闭', style: titleStyle)),
                    const SizedBox(height: 10),
                    ...{...scheduleTimeMinutes, _durationInMinutes}
                        .sorted((a, b) => a.compareTo(b))
                        .map(
                          (minutes) => ListTile(
                            dense: true,
                            onTap: () {
                              Navigator.pop(context);
                              _startShutdownTimer(minutes);
                            },
                            title: Text(
                              switch (minutes) {
                                0 => '禁用',
                                _ => _format(minutes),
                              },
                              style: titleStyle,
                            ),
                            trailing: _durationInMinutes == minutes
                                ? Icon(
                                    size: 20,
                                    Icons.done,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                          ),
                        ),
                    ListTile(
                      dense: true,
                      onTap: () {
                        final (int hour, int minute) = _parseMinutes(
                          _durationInMinutes,
                        );
                        showTimePicker(
                          context: context,
                          initialEntryMode: .inputOnly,
                          initialTime: TimeOfDay(hour: hour, minute: minute),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          ),
                        ).then((time) {
                          if (time != null) {
                            _startShutdownTimer(time.hour * 60 + time.minute);
                            setState(() {});
                          }
                        });
                      },
                      title: const Text('自定义', style: titleStyle),
                    ),
                    if (!isLive) ...[
                      Builder(
                        builder: (context) {
                          void onChanged([_]) {
                            _waitUntilCompleted = !_waitUntilCompleted;
                            (context as Element).markNeedsBuild();
                          }

                          return ListTile(
                            dense: true,
                            onTap: onChanged,
                            title: const Text('额外等待视频播放完毕', style: titleStyle),
                            trailing: Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: 0.8,
                              child: Switch(
                                value: _waitUntilCompleted,
                                onChanged: onChanged,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 5),
                    Padding(
                      padding: const .only(left: 18),
                      child: Builder(
                        builder: (context) {
                          return Row(
                            spacing: 12,
                            children: [
                              const Text('倒计时结束:', style: titleStyle),
                              ..._ShutdownType.values.map(
                                (e) => ActionRowLineItem(
                                  onTap: () {
                                    _shutdownType = e;
                                    (context as Element).markNeedsBuild();
                                  },
                                  text: ' ${e.label} ',
                                  selectStatus: _shutdownType == e,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
