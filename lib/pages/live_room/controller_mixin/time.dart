part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveTimeMixin on GetxController {
  Timer? _liveTimeTimer;
  late final liveTime = RxnInt();

  void _startLiveTimeTimer() {
    if (isClosed) return;
    if (liveTime.value != null) {
      _liveTimeTimer ??= Timer.periodic(
        const Duration(minutes: 5),
        (_) => liveTime.refresh(),
      );
    }
  }

  void _stopLiveTimeTimer() {
    _liveTimeTimer?.cancel();
    _liveTimeTimer = null;
  }

  Widget get timeWidget => Obx(() {
    final liveTime = this.liveTime.value;
    String text = '';
    if (liveTime != null) {
      final duration = DurationUtils.formatDurationBetween(
        liveTime * 1000,
        DateTime.now().millisecondsSinceEpoch,
      );
      text += duration.isEmpty ? '刚刚开播' : '开播$duration';
    }
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    );
  });
}
