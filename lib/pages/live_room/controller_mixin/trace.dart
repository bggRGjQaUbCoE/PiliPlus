part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveTraceMixin on GetxController, _LiveDataMixin {
  Timer? _liveTraceTimer;
  LiveTraceReq? _liveTraceReq;
  LiveTraceResp? _liveTraceResp;
  int get _liveTraceInterval =>
      _liveTraceResp?.interval ?? LiveTraceResp.kInterval;

  Future<void> _initLiveTraceIfNeeded() async {
    if (isClosed || !isLoaded.value || !heartbeat.isLogin) return;
    try {
      // id
      final ruid = this.ruid!;
      final roomInfo = roomInfoH5.rawValue?.roomInfo;
      if (roomInfo == null) {
        Utils.reportError('liveTrace: null roomInfo');
        return;
      }
      final parentAreaId = roomInfo.parentAreaId!;
      final areaId = roomInfo.areaId!;

      // liveBuvid
      final cookies = await heartbeat.cookieJar.loadForRequest(
        Uri.parse(HttpString.baseUrl),
      );
      final liveBuvid = cookies
          .firstWhereOrNull((cookie) => cookie.name == 'LIVE_BUVID')
          ?.value;
      if (isClosed) return;
      if (liveBuvid == null) {
        Utils.reportError('liveTrace: null liveBuvid');
        return;
      }

      _liveTraceReq = LiveTraceReq(
        parentAreaId: parentAreaId,
        areaId: areaId,
        roomId: roomId,
        liveBuvid: liveBuvid,
        ruid: ruid,
      );
      _startLiveTraceTimer();
    } catch (_) {
      if (kDebugMode) rethrow;
    }
  }

  void _startLiveTraceTimer() {
    if (_liveTraceReq == null || isClosed || _liveTraceTimer != null) {
      return;
    }
    _liveTraceReq!.seqId = 0; // reset
    _onLiveTrace();
    _liveTraceTimer = Timer.periodic(
      Duration(seconds: _liveTraceInterval),
      _onLiveTrace,
    );
  }

  void _stopLiveTraceTimer() {
    _liveTraceTimer?.cancel();
    _liveTraceTimer = null;
  }

  Future<void> _onLiveTrace([_]) async {
    if (kDebugMode) logger.i('liveTraceReq: $_liveTraceReq');
    final res = _liveTraceReq!.seqId == 0
        ? await LiveHttp.liveTraceE(
            traceReq: _liveTraceReq!,
            heartbeat: heartbeat,
          )
        : await LiveHttp.liveTraceX(
            traceReq: _liveTraceReq!,
            traceResp: _liveTraceResp!,
            heartbeat: heartbeat,
          );
    if (isClosed) return;
    if (res case Success(:final response)) {
      if (kDebugMode) logger.i('liveTraceResp: $response');
      // update interval
      final newInterval = response.interval;
      if (_liveTraceInterval != newInterval) {
        _liveTraceTimer?.cancel();
        _liveTraceTimer = Timer.periodic(
          Duration(seconds: newInterval),
          _onLiveTrace,
        );
      }

      _liveTraceResp = response;
    } else {
      Utils.reportError('live trace error: $res');
      _stopLiveTraceTimer();
    }
  }
}
