import 'dart:async';
import 'dart:convert';
import 'dart:math' show max, min;

import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/widgets.dart';

abstract final class PlaybackStatsService {
  static const schemaVersion = 3;
  static const _seekThresholdUs = 1000000;
  static const _rewindEligibilityUs = 5000000;

  static final _clock = Stopwatch()..start();
  static Map<String, dynamic>? _stats;
  static Timer? _flushTimer;
  static Future<void> _writeChain = Future.value();
  static bool _dirty = false;
  static AppLifecycleListener? _appLifecycleListener;
  static bool _appForeground = false;
  static int _appLastWallUs = 0;

  static bool _active = false;
  static bool _live = false;
  static bool _playing = false;
  static bool _buffering = false;
  static bool _completedIdle = false;
  static String? _mediaKey;
  static String? _liveUid;
  static String? _videoUpUid;
  static String? _videoUpName;
  static bool _videoUpStartRecorded = false;
  static int _lastWallUs = 0;
  static int _lastPositionUs = 0;
  static int _suppressDiscontinuityUntilUs = 0;
  static int? _pendingPositionUs;
  static double _rate = 1;
  static double _nominalRate = 1;
  static bool _temporaryRate = false;
  static double _defaultRate = 1;
  static _RewindEpisode? _rewind;
  static int _trailingPauseUs = 0;
  static int _trailingNormalPauseUs = 0;
  static int _trailingRewindPauseUs = 0;
  static final Map<String, int> _trailingNormalPauseBySpeed = {};
  static final Map<String, int> _trailingRewindPauseBySpeed = {};

  static void initializeAppLifecycle() {
    _ensureInitialized();
    if (_appLifecycleListener != null) return;
    _appLastWallUs = _clock.elapsedMicroseconds;
    _appForeground = WidgetsBinding.instance.lifecycleState == .resumed;
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: (state) {
        final now = _clock.elapsedMicroseconds;
        _settleAppForeground(now);
        _appForeground = state == .resumed;
        if (!_appForeground) unawaited(flush());
      },
    );
  }

  static void _ensureInitialized() {
    if (_stats != null) return;
    final raw = GStorage.video.get(VideoBoxKey.playbackStats);
    _stats = raw is Map
        ? _stringMap(raw)
        : <String, dynamic>{
            'schemaVersion': schemaVersion,
            'createdAtMs': DateTime.now().millisecondsSinceEpoch,
          };
    _stats!.putIfAbsent(
      'nominalMediaIncludingLongPressUs',
      () => _stats!['nominalMediaUs'] as num? ?? 0,
    );
    _stats!['schemaVersion'] = schemaVersion;
    _flushTimer ??= Timer.periodic(
      const Duration(seconds: 30),
      (_) => flush(),
    );
  }

  static Map<String, dynamic> _stringMap(Map raw) => raw.map(
    (key, value) => MapEntry(
      key.toString(),
      value is Map ? _stringMap(value) : value,
    ),
  );

  static void _add(String key, num value) {
    if (value == 0) return;
    final current = _stats![key] as num? ?? 0;
    _stats![key] = value is double || current is double
        ? current.toDouble() + value
        : current.toInt() + value.toInt();
    _dirty = true;
  }

  static void _settleAppForeground(int now) {
    if (_appForeground) _add('appForegroundUs', max(0, now - _appLastWallUs));
    _appLastWallUs = now;
  }

  static Map<String, dynamic> _map(String key) {
    final current = _stats![key];
    if (current is Map<String, dynamic>) return current;
    final value = current is Map ? _stringMap(current) : <String, dynamic>{};
    _stats![key] = value;
    return value;
  }

  static void _addBucket(String key, String bucket, num value) {
    if (value == 0) return;
    final map = _map(key);
    final current = map[bucket] as num? ?? 0;
    map[bucket] = value is double || current is double
        ? current.toDouble() + value
        : current.toInt() + value.toInt();
    _dirty = true;
  }

  static void _addVideoUp(String key, num value) {
    final uid = _videoUpUid;
    if (uid == null || value == 0) return;
    final byUid = _map('videoByUpUid');
    final item = byUid[uid] is Map
        ? _stringMap(byUid[uid] as Map)
        : <String, dynamic>{};
    if (_videoUpName case final name? when name.isNotEmpty) {
      item['name'] = name;
    }
    item[key] = (item[key] as num? ?? 0) + value;
    final years = item['years'] is Map
        ? _stringMap(item['years'] as Map)
        : <String, dynamic>{};
    final year = DateTime.now().year.toString();
    final yearItem = years[year] is Map
        ? _stringMap(years[year] as Map)
        : <String, dynamic>{};
    yearItem[key] = (yearItem[key] as num? ?? 0) + value;
    years[year] = yearItem;
    item['years'] = years;
    byUid[uid] = item;
    _dirty = true;
  }

  static void _recordVideoUpStart() {
    if (_videoUpUid == null || _videoUpStartRecorded) return;
    _videoUpStartRecorded = true;
    _addVideoUp('openCount', 1);
  }

  static String _speedKey(double speed) {
    final text = speed.toStringAsFixed(2);
    return text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  static void _recordSourceSpeed(double speed, double defaultSpeed) {
    final key = _speedKey(speed);
    _addBucket('sourceSpeedSelections', key, 1);
    if ((speed - defaultSpeed).abs() < 0.001) {
      _addBucket('defaultSpeedSelections', key, 1);
    }
    _stats!['lastSelectedSpeed'] = speed;
    _dirty = true;
  }

  static void openMedia({
    required bool isLive,
    required Duration previousPosition,
    required Duration initialPosition,
    required double speed,
    required double defaultSpeed,
    int? cid,
    int? liveUid,
    int? videoUpUid,
    String? videoUpName,
  }) {
    _ensureInitialized();
    final now = _clock.elapsedMicroseconds;
    if (_active) {
      if (_live) {
        _settleLive(now);
      } else {
        _settleVideo(previousPosition.inMicroseconds, now);
      }
    }

    final nextKey = isLive
        ? 'live:${liveUid ?? 'unknown'}'
        : cid == null
        ? null
        : 'cid:$cid';
    if (nextKey == null) {
      if (_active && !_live) _reclassifyTrailingPauseAsComment();
      _finishRewind(now, completed: false);
      _active = false;
      _mediaKey = null;
      _videoUpUid = null;
      _videoUpName = null;
      _videoUpStartRecorded = false;
      return;
    }

    final sameMedia = _active && _live == isLive && _mediaKey == nextKey;
    if (!sameMedia) {
      if (_active && !_live) _reclassifyTrailingPauseAsComment();
      _finishRewind(now, completed: false);
      if (isLive) {
        _videoUpUid = null;
        _videoUpName = null;
        _videoUpStartRecorded = false;
        _liveUid = liveUid?.toString() ?? 'unknown';
        _add('liveOpenCount', 1);
        final byUid = _map('liveByUid');
        final item = byUid[_liveUid] is Map
            ? _stringMap(byUid[_liveUid] as Map)
            : <String, dynamic>{};
        item['openCount'] = ((item['openCount'] as num?)?.toInt() ?? 0) + 1;
        byUid[_liveUid!] = item;
      } else {
        _liveUid = null;
        _videoUpUid = videoUpUid?.toString();
        _videoUpName = videoUpName;
        _videoUpStartRecorded = false;
        _recordVideoUpStart();
        _add('videoStarts', 1);
        _recordSourceSpeed(speed, defaultSpeed);
      }
    } else if (!isLive && videoUpUid != null) {
      _videoUpUid = videoUpUid.toString();
      _videoUpName = videoUpName ?? _videoUpName;
      _recordVideoUpStart();
    }

    _active = true;
    _live = isLive;
    _mediaKey = nextKey;
    _playing = false;
    _buffering = true;
    _completedIdle = false;
    _rate = speed;
    _nominalRate = speed;
    _temporaryRate = false;
    _defaultRate = defaultSpeed;
    _lastWallUs = now;
    _lastPositionUs = initialPosition.inMicroseconds;
    _pendingPositionUs = _lastPositionUs;
    _suppressDiscontinuityUntilUs = now + _rewindEligibilityUs;
  }

  static void setVideoUpUid({
    required int cid,
    required int? videoUpUid,
    String? videoUpName,
  }) {
    _ensureInitialized();
    if (!_active || _live || _mediaKey != 'cid:$cid' || videoUpUid == null) {
      return;
    }
    _videoUpUid = videoUpUid.toString();
    _videoUpName = videoUpName ?? _videoUpName;
    _recordVideoUpStart();
  }

  static void samplePosition(Duration position) {
    _ensureInitialized();
    if (!_active || _live) return;
    _settleVideo(position.inMicroseconds, _clock.elapsedMicroseconds);
  }

  static void updatePlaying(bool playing, Duration position) {
    _ensureInitialized();
    final now = _clock.elapsedMicroseconds;
    if (_active) {
      if (_live) {
        _settleLive(now);
      } else {
        _settleVideo(position.inMicroseconds, now);
      }
      if (playing != _playing) {
        if (playing) {
          _clearTrailingPause();
          _add('playbackSegments', 1);
        } else if (!_completedIdle) {
          _add('pauseCount', 1);
        }
      }
    }
    if (playing) _completedIdle = false;
    _playing = playing;
  }

  static void updateBuffering(bool buffering, Duration position) {
    _ensureInitialized();
    final now = _clock.elapsedMicroseconds;
    if (_active) {
      if (_live) {
        _settleLive(now);
      } else {
        _settleVideo(position.inMicroseconds, now);
      }
      if (buffering && !_buffering) _add('bufferingCount', 1);
    }
    _buffering = buffering;
  }

  static void changeSpeed(
    double speed,
    Duration position, {
    required bool recordSelection,
    bool temporary = false,
  }) {
    _ensureInitialized();
    if (_active && !_live) {
      _settleVideo(position.inMicroseconds, _clock.elapsedMicroseconds);
      if (recordSelection) {
        final key = _speedKey(speed);
        _addBucket('manualSpeedSelections', key, 1);
        _stats!['lastSelectedSpeed'] = speed;
        _add('rateChangeCount', 1);
        _dirty = true;
      }
    }
    _rate = speed;
    _temporaryRate = temporary;
    if (!temporary) _nominalRate = speed;
  }

  static void seek(
    Duration from,
    Duration to, {
    required bool userInitiated,
  }) {
    _ensureInitialized();
    if (!_active || _live) return;
    final now = _clock.elapsedMicroseconds;
    _settleVideo(from.inMicroseconds, now);
    _completedIdle = false;
    if (userInitiated) {
      _recordSeek(from.inMicroseconds, to.inMicroseconds, now);
    } else {
      _finishRewind(now, completed: false);
    }
    _lastPositionUs = to.inMicroseconds;
    _lastWallUs = now;
    _pendingPositionUs = _lastPositionUs;
    _suppressDiscontinuityUntilUs = now + 2000000;
  }

  static void rebase(Duration position) {
    _ensureInitialized();
    if (!_active || _live) return;
    final now = _clock.elapsedMicroseconds;
    _settleVideo(position.inMicroseconds, now);
    _completedIdle = false;
    _lastPositionUs = position.inMicroseconds;
    _lastWallUs = now;
    _pendingPositionUs = _lastPositionUs;
    _suppressDiscontinuityUntilUs = now + 2000000;
  }

  static void markCompleted(Duration position) {
    _ensureInitialized();
    if (!_active || _live || _completedIdle) return;
    _settleVideo(position.inMicroseconds, _clock.elapsedMicroseconds);
    _reclassifyTrailingPauseAsComment();
    _add('completedVideos', 1);
    _addVideoUp('completedCount', 1);
    _completedIdle = true;
  }

  static void endMedia(Duration position) {
    _ensureInitialized();
    if (!_active) return;
    final now = _clock.elapsedMicroseconds;
    if (_live) {
      _settleLive(now);
    } else {
      _settleVideo(position.inMicroseconds, now);
      _reclassifyTrailingPauseAsComment();
    }
    _finishRewind(now, completed: false);
    _active = false;
    _mediaKey = null;
    _liveUid = null;
    _videoUpUid = null;
    _videoUpName = null;
    _videoUpStartRecorded = false;
    _pendingPositionUs = null;
    unawaited(flush());
  }

  static void endMediaIfMatches({
    required bool isLive,
    required Duration position,
    int? cid,
    int? liveUid,
  }) {
    _ensureInitialized();
    final key = isLive
        ? 'live:${liveUid ?? 'unknown'}'
        : cid == null
        ? null
        : 'cid:$cid';
    if (_active && _live == isLive && _mediaKey == key) {
      endMedia(position);
    }
  }

  static void _settleLive(int now) {
    if (!_active || !_live) return;
    final elapsed = max(0, now - _lastWallUs);
    if (elapsed > 0) {
      _add('liveWatchUs', elapsed);
      final uid = _liveUid;
      if (uid != null) {
        final byUid = _map('liveByUid');
        final item = byUid[uid] is Map
            ? _stringMap(byUid[uid] as Map)
            : <String, dynamic>{};
        item['watchUs'] = ((item['watchUs'] as num?) ?? 0).toInt() + elapsed;
        byUid[uid] = item;
        _dirty = true;
      }
    }
    _lastWallUs = now;
  }

  static void _settleVideo(int positionUs, int now) {
    if (!_active || _live) return;
    final wallUs = max(0, now - _lastWallUs);
    final mediaDeltaUs = positionUs - _lastPositionUs;
    if (_pendingPositionUs case final target?) {
      if (now >= _suppressDiscontinuityUntilUs) {
        _pendingPositionUs = null;
      } else if ((positionUs - target).abs() > _seekThresholdUs) {
        // Some backends briefly publish the pre-seek position. Do not turn
        // that stale sample into a completed rewind or a second seek.
        _lastWallUs = now;
        return;
      } else {
        _pendingPositionUs = null;
      }
    }

    if (_completedIdle) {
      // Waiting on an already completed video is neither playback nor pause.
      _add('commentAreaUs', wallUs);
      _addVideoUp('commentAreaUs', wallUs);
    } else if (_buffering) {
      _add('bufferingUs', wallUs);
      _addVideoUp('bufferingUs', wallUs);
      final rewind = _rewind;
      if (rewind == null) {
        _add('normalBufferingUs', wallUs);
        _addBucket('normalSpeedBufferingUs', _speedKey(_rate), wallUs);
      } else {
        _add('rewindBufferingUs', wallUs);
        _addBucket('rewindSpeedBufferingUs', _speedKey(_rate), wallUs);
        rewind.bufferingUs += wallUs;
      }
    } else if (_playing) {
      _add('activePlaybackUs', wallUs);
      _addVideoUp('activePlaybackUs', wallUs);
      _add('nominalMediaUs', wallUs * _nominalRate);
      _add('nominalMediaIncludingLongPressUs', wallUs * _rate);
      _addBucket('speedActiveUs', _speedKey(_rate), wallUs);
      if (_temporaryRate) {
        _add('longPressActiveUs', wallUs);
        _addBucket('longPressSpeedActiveUs', _speedKey(_rate), wallUs);
      }

      final expectedUs = wallUs * _rate;
      final toleranceUs = max(2000000, expectedUs * 2).round();
      final discontinuity =
          mediaDeltaUs < -_seekThresholdUs ||
          mediaDeltaUs > expectedUs + toleranceUs;
      int mediaAdvanceUs;
      var rewindPlaybackUs = 0;
      var rewindMediaAdvanceUs = 0;
      if (discontinuity) {
        mediaAdvanceUs = now < _suppressDiscontinuityUntilUs
            ? 0
            : min(max(0, mediaDeltaUs), expectedUs.round());
        final rewindPart = _advanceRewind(
          _lastPositionUs,
          _lastPositionUs + mediaAdvanceUs,
          wallUs,
          now,
        );
        rewindPlaybackUs = rewindPart.playbackUs;
        rewindMediaAdvanceUs = rewindPart.mediaAdvanceUs;
        if (now >= _suppressDiscontinuityUntilUs) {
          _add('detectedDiscontinuityCount', 1);
          _recordSeek(_lastPositionUs, positionUs, now);
        }
      } else {
        mediaAdvanceUs = max(0, mediaDeltaUs);
        final rewindPart = _advanceRewind(
          _lastPositionUs,
          positionUs,
          wallUs,
          now,
        );
        rewindPlaybackUs = rewindPart.playbackUs;
        rewindMediaAdvanceUs = rewindPart.mediaAdvanceUs;
      }
      _add('mediaAdvanceUs', mediaAdvanceUs);
      _addVideoUp('mediaAdvanceUs', mediaAdvanceUs);
      _addBucket('speedMediaAdvanceUs', _speedKey(_rate), mediaAdvanceUs);
      _add('rewindPlaybackUs', rewindPlaybackUs);
      _add('rewindMediaAdvanceUs', rewindMediaAdvanceUs);
      _add('normalPlaybackUs', wallUs - rewindPlaybackUs);
      _add('normalMediaAdvanceUs', mediaAdvanceUs - rewindMediaAdvanceUs);
      _addBucket(
        'rewindSpeedActiveUs',
        _speedKey(_rate),
        rewindPlaybackUs,
      );
      _addBucket(
        'rewindSpeedMediaAdvanceUs',
        _speedKey(_rate),
        rewindMediaAdvanceUs,
      );
      _addBucket(
        'normalSpeedActiveUs',
        _speedKey(_rate),
        wallUs - rewindPlaybackUs,
      );
      _addBucket(
        'normalSpeedMediaAdvanceUs',
        _speedKey(_rate),
        mediaAdvanceUs - rewindMediaAdvanceUs,
      );
    } else {
      _add('pausedUs', wallUs);
      _addVideoUp('pausedUs', wallUs);
      _trailingPauseUs += wallUs;
      final rewind = _rewind;
      if (rewind == null) {
        final speed = _speedKey(_rate);
        _add('normalPausedUs', wallUs);
        _addBucket('normalSpeedPausedUs', speed, wallUs);
        _trailingNormalPauseUs += wallUs;
        _trailingNormalPauseBySpeed.update(
          speed,
          (value) => value + wallUs,
          ifAbsent: () => wallUs,
        );
      } else {
        final speed = _speedKey(_rate);
        _add('rewindPausedUs', wallUs);
        _addBucket('rewindSpeedPausedUs', speed, wallUs);
        _trailingRewindPauseUs += wallUs;
        _trailingRewindPauseBySpeed.update(
          speed,
          (value) => value + wallUs,
          ifAbsent: () => wallUs,
        );
        rewind.pausedUs += wallUs;
      }
    }

    _lastWallUs = now;
    _lastPositionUs = positionUs;
  }

  // A trailing pause is provisional: if playback resumes, it remains pause time.
  // Only when this media session ends without any later resume do we
  // retrospectively classify that final pause as comment-area time.
  static void _clearTrailingPause() {
    _trailingPauseUs = 0;
    _trailingNormalPauseUs = 0;
    _trailingRewindPauseUs = 0;
    _trailingNormalPauseBySpeed.clear();
    _trailingRewindPauseBySpeed.clear();
  }

  // Called only when the current CID/BV lifecycle is being finalized.
  // Because updatePlaying(true) clears the trailing-pause accumulator, any
  // duration reaching here is exactly: paused, then never played again.
  static void _reclassifyTrailingPauseAsComment() {
    if (_trailingPauseUs == 0) return;
    _add('pausedUs', -_trailingPauseUs);
    _addVideoUp('pausedUs', -_trailingPauseUs);
    _add('commentAreaUs', _trailingPauseUs);
    _addVideoUp('commentAreaUs', _trailingPauseUs);
    _add('normalPausedUs', -_trailingNormalPauseUs);
    _add('rewindPausedUs', -_trailingRewindPauseUs);
    for (final entry in _trailingNormalPauseBySpeed.entries) {
      _addBucket('normalSpeedPausedUs', entry.key, -entry.value);
    }
    for (final entry in _trailingRewindPauseBySpeed.entries) {
      _addBucket('rewindSpeedPausedUs', entry.key, -entry.value);
    }
    final rewind = _rewind;
    if (rewind != null) {
      rewind.pausedUs = max(0, rewind.pausedUs - _trailingRewindPauseUs);
    }
    _clearTrailingPause();
  }

  static void _recordSeek(int fromUs, int toUs, int now) {
    final delta = toUs - fromUs;
    if (delta.abs() < _seekThresholdUs) return;
    _finishRewind(now, completed: false);
    if (delta > 0) {
      _add('forwardSeekCount', 1);
      _add('forwardSeekUs', delta);
      return;
    }

    final distance = -delta;
    _add('rewindCount', 1);
    _add('rewindUs', distance);
    if (_rate > 1) {
      _add('fastRewindCount', 1);
      _add('fastRewindUs', distance);
    }
    _rewind = _RewindEpisode(
      checkpointUs: fromUs,
      distanceUs: distance,
      startedAtUs: now,
    );
  }

  static ({int playbackUs, int mediaAdvanceUs}) _advanceRewind(
    int fromUs,
    int toUs,
    int activeWallUs,
    int now,
  ) {
    final rewind = _rewind;
    if (rewind == null) return (playbackUs: 0, mediaAdvanceUs: 0);
    if (fromUs >= rewind.checkpointUs) {
      _finishRewind(now, completed: true);
      return (playbackUs: 0, mediaAdvanceUs: 0);
    }
    final mediaAdvanceUs = max(0, toUs - fromUs);
    if (toUs >= rewind.checkpointUs && toUs > fromUs) {
      final fraction = (rewind.checkpointUs - fromUs) / max(1, toUs - fromUs);
      final playbackUs = (activeWallUs * fraction.clamp(0, 1)).round();
      final rewindMediaUs = rewind.checkpointUs - fromUs;
      rewind
        ..activePlaybackUs += playbackUs
        ..mediaAdvanceUs += rewindMediaUs;
      _finishRewind(now, completed: true);
      return (playbackUs: playbackUs, mediaAdvanceUs: rewindMediaUs);
    } else {
      rewind
        ..activePlaybackUs += activeWallUs
        ..mediaAdvanceUs += mediaAdvanceUs;
      return (playbackUs: activeWallUs, mediaAdvanceUs: mediaAdvanceUs);
    }
  }

  static void _finishRewind(int now, {required bool completed}) {
    final rewind = _rewind;
    if (rewind == null) return;
    final eligible =
        completed || now - rewind.startedAtUs >= _rewindEligibilityUs;
    if (eligible) {
      _add('eligibleRewindCount', 1);
      if (completed) {
        _add('completedRewindCount', 1);
        _add('completedRewindUs', rewind.distanceUs);
        _add('completedRewindPlaybackUs', rewind.activePlaybackUs);
        _add('completedRewindMediaAdvanceUs', rewind.mediaAdvanceUs);
        _add('completedRewindPausedUs', rewind.pausedUs);
        _add('completedRewindBufferingUs', rewind.bufferingUs);
      } else {
        _add('abandonedRewindCount', 1);
        _add('abandonedRewindUs', rewind.distanceUs);
        _add('abandonedRewindPlaybackUs', rewind.activePlaybackUs);
        _add('abandonedRewindMediaAdvanceUs', rewind.mediaAdvanceUs);
        _add('abandonedRewindPausedUs', rewind.pausedUs);
        _add('abandonedRewindBufferingUs', rewind.bufferingUs);
      }
    } else {
      _add('shortRewindExitCount', 1);
      _add('shortRewindUs', rewind.distanceUs);
      _add('shortRewindPlaybackUs', rewind.activePlaybackUs);
      _add('shortRewindMediaAdvanceUs', rewind.mediaAdvanceUs);
      _add('shortRewindPausedUs', rewind.pausedUs);
      _add('shortRewindBufferingUs', rewind.bufferingUs);
    }
    _rewind = null;
    _pendingPositionUs = null;
  }

  static Map<String, dynamic> snapshot() {
    _ensureInitialized();
    _settleAppForeground(_clock.elapsedMicroseconds);
    if (_active && _live) _settleLive(_clock.elapsedMicroseconds);
    final raw = jsonDecode(jsonEncode(_stats!)) as Map<String, dynamic>;
    final source = _numericMap(raw['sourceSpeedSelections']);
    final manual = _numericMap(raw['manualSpeedSelections']);
    final selections = <String, num>{...source};
    for (final entry in manual.entries) {
      selections.update(
        entry.key,
        (value) => value + entry.value,
        ifAbsent: () => entry.value,
      );
    }
    final maxCount = selections.values.fold<num>(0, max);
    final last = (raw['lastSelectedSpeed'] as num?)?.toDouble();
    final favorite = selections.entries
        .where((entry) => entry.value == maxCount)
        .map((entry) => double.tryParse(entry.key))
        .whereType<double>()
        .fold<double?>(null, (value, speed) {
          if (last != null && (speed - last).abs() < 0.001) return speed;
          return value ?? speed;
        });

    final active = _number(raw['activePlaybackUs']);
    final media = _number(raw['mediaAdvanceUs']);
    final nominal = _number(raw['nominalMediaUs']);
    final nominalIncludingLongPress = _number(
      raw['nominalMediaIncludingLongPressUs'],
    );
    final eligible = _number(raw['eligibleRewindCount']);
    final completed = _number(raw['completedRewindCount']);
    final rewindMedia = _number(raw['completedRewindUs']);
    final rewindWall = _number(raw['completedRewindPlaybackUs']);
    final normalWall = _number(raw['normalPlaybackUs']);
    final normalMedia = _number(raw['normalMediaAdvanceUs']);
    final allRewindWall = _number(raw['rewindPlaybackUs']);
    final allRewindMedia = _number(raw['rewindMediaAdvanceUs']);
    final rewindObserved =
        allRewindWall +
        _number(raw['rewindPausedUs']) +
        _number(raw['rewindBufferingUs']);
    final completedRewindObserved =
        rewindWall +
        _number(raw['completedRewindPausedUs']) +
        _number(raw['completedRewindBufferingUs']);
    raw['derived'] = {
      'favoriteSpeed': favorite,
      'favoriteSpeedWasDefault':
          favorite != null &&
          (_numericMap(
                    raw['defaultSpeedSelections'],
                  )[_speedKey(favorite)] ??
                  0) >
              0,
      'actualAverageSpeed': active == 0 ? 0 : media / active,
      'nominalAverageSpeed': active == 0 ? 0 : nominal / active,
      'nominalAverageSpeedIncludingLongPress': active == 0
          ? 0
          : nominalIncludingLongPress / active,
      'savedTimeUs': media - active,
      'normalSavedTimeUs': normalMedia - normalWall,
      'rewindSavedTimeUs': allRewindMedia - allRewindWall,
      'rewindCompletionRate': eligible == 0 ? 0 : completed / eligible,
      'rewindEquivalentSpeed': rewindWall == 0 ? 0 : rewindMedia / rewindWall,
      'rewindObservedEquivalentSpeed': completedRewindObserved == 0
          ? 0
          : rewindMedia / completedRewindObserved,
      'normalObservedUs':
          normalWall +
          _number(raw['normalPausedUs']) +
          _number(raw['normalBufferingUs']),
      'rewindObservedUs': rewindObserved,
      'playerObservedUs':
          active + _number(raw['pausedUs']) + _number(raw['bufferingUs']),
      'speedSelectionCounts': selections,
    };
    return raw;
  }

  static Map<String, num> _numericMap(dynamic raw) {
    if (raw is! Map) return {};
    return raw.map(
      (key, value) => MapEntry(key.toString(), value is num ? value : 0),
    );
  }

  static num _number(dynamic value) => value is num ? value : 0;

  static String advancedJson() {
    final data = snapshot();
    final derived = data.remove('derived');
    return const JsonEncoder.withIndent('  ').convert({
      '说明': {
        'schemaVersion': schemaVersion,
        'timeUnit': 'microseconds',
        'savedTime': 'mediaAdvanceUs - activePlaybackUs；不包含快进跳转',
        'normalSavedTime': 'normalMediaAdvanceUs - normalPlaybackUs',
        'rewindSavedTime': 'rewindMediaAdvanceUs - rewindPlaybackUs',
        'actualAverageSpeed': 'mediaAdvanceUs / activePlaybackUs',
        'nominalAverageSpeed':
            'nominalMediaUs / activePlaybackUs；临时长按期间仍按长按前的基础倍速积分',
        'nominalAverageSpeedIncludingLongPress':
            'nominalMediaIncludingLongPressUs / activePlaybackUs',
        'appForegroundTime': 'appForegroundUs；使用单调时钟累计应用处于前台的时间',
        'rewindEquivalentSpeed':
            'completedRewindUs / completedRewindPlaybackUs；分子为原视频时间，分母为实际播放时间',
        'rewindObservedEquivalentSpeed': 'completedRewindUs /（completedRewindPlaybackUs + completedRewindPausedUs + completedRewindBufferingUs）；用于回看包含暂停与缓冲在内的真实时间成本',
        'rewindCompletionRate':
            'completedRewindCount / eligibleRewindCount；完成或倒带后停留至少 5 秒才进入分母',
        'stateAxes': '普通观看／倒带重看 × 播放／暂停／缓冲 × 当前倍速；临时长按、评论区停留、快进跳转、倒带结果以及按视频 UP／年份和直播主播汇总的数据另行保存',
      },
      '原语': data,
      '当前推导值': derived,
    });
  }

  static Future<void> flush() async {
    _ensureInitialized();
    _settleAppForeground(_clock.elapsedMicroseconds);
    if (_active && _live) _settleLive(_clock.elapsedMicroseconds);
    if (!_dirty) return;
    _stats!['updatedAtMs'] = DateTime.now().millisecondsSinceEpoch;
    _dirty = false;
    final value = jsonDecode(jsonEncode(_stats!));
    _writeChain = _writeChain.then(
      (_) => GStorage.video.put(VideoBoxKey.playbackStats, value),
      onError: (_) => GStorage.video.put(VideoBoxKey.playbackStats, value),
    );
    await _writeChain;
  }

  static Future<void> reset() async {
    _ensureInitialized();
    _stats = {
      'schemaVersion': schemaVersion,
      'createdAtMs': DateTime.now().millisecondsSinceEpoch,
    };
    _rewind = null;
    _pendingPositionUs = null;
    _clearTrailingPause();
    _dirty = true;
    _appLastWallUs = _clock.elapsedMicroseconds;
    if (_active) {
      if (_live) {
        _add('liveOpenCount', 1);
        final uid = _liveUid ?? 'unknown';
        _map('liveByUid')[uid] = {'openCount': 1, 'watchUs': 0};
      } else {
        _add('videoStarts', 1);
        _videoUpStartRecorded = false;
        _recordVideoUpStart();
        _recordSourceSpeed(_rate, _defaultRate);
      }
      _lastWallUs = _clock.elapsedMicroseconds;
    }
    await flush();
  }
}

final class _RewindEpisode {
  _RewindEpisode({
    required this.checkpointUs,
    required this.distanceUs,
    required this.startedAtUs,
  });

  final int checkpointUs;
  final int distanceUs;
  final int startedAtUs;
  int activePlaybackUs = 0;
  int mediaAdvanceUs = 0;
  int pausedUs = 0;
  int bufferingUs = 0;
}
