import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io' show File, Platform;
import 'dart:math' as math;
import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:PiliPlus/models/video/play/url.dart' show Volume;
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:ffi/ffi.dart';
import 'package:media_kit/media_kit.dart'
    show Media, Player, PlayerConfiguration, PlayerLog;
// ignore: implementation_imports
import 'package:media_kit/src/player/native/core/native_library.dart'
    show NativeLibrary;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

enum AudioNormalization {
  disable('禁用'),
  // ref https://github.com/KRTirtho/spotube/commit/da10ab2e291d4ba4d3082b9a6ae535639fb8f1b7
  dynaudnorm('预设 dynaudnorm', 'dynaudnorm=g=5:f=250:r=0.9:p=0.5'),
  loudnorm('预设 loudnorm', 'loudnorm=I=-16:LRA=11:TP=-1.5'),
  custom('自定义参数'),
  ;

  final String title;
  final String param;
  const AudioNormalization(this.title, [this.param = '']);

  static String getTitleFromConfig(String config) => switch (config) {
    '0' => disable.title,
    '1' => dynaudnorm.title,
    '2' => loudnorm.title,
    _ => config,
  };

  static String getParamFromConfig(String config) => switch (config) {
    '0' => disable.param,
    '1' => dynaudnorm.param,
    '2' => loudnorm.param,
    _ => config,
  };

  static final loudnormRegExp = RegExp('loudnorm=([^,]+)');

  static String parse(Volume? volume, String param) {
    if (volume != null && volume.isNotEmpty) {
      return param.replaceFirstMapped(
        loudnormRegExp,
        (i) =>
            'loudnorm=${volume.format(
              Map.fromEntries(
                i.group(1)!.split(':').map((item) {
                  final parts = item.split('=');
                  return MapEntry(parts[0].toLowerCase(), num.parse(parts[1]));
                }),
              ),
            )}',
      );
    } else {
      return param.replaceFirst(
        loudnormRegExp,
        AudioNormalization.getParamFromConfig(Pref.fallbackNormalization),
      );
    }
  }
}

mixin AudioNormalizationMixin {
  late final _audioNormalization = Pref.audioNormalization;
  late final enableAudioNormalization =
      Platform.isAndroid && _audioNormalization != '0';
  late final _param = AudioNormalization.getParamFromConfig(
    _audioNormalization,
  );

  static const _kNormalizationKey = 'lavfi-complex';

  Map<String, String>? audioFilterExtras(
    Volume? volume, {
    Map<String, String>? map,
  }) {
    if (!enableAudioNormalization) return map;
    var audioNormalization = AudioNormalization.parse(volume, _param);
    if (audioNormalization.isEmpty) return map;
    audioNormalization = '"[aid1] $audioNormalization [ao]"';
    if (map != null) {
      map[_kNormalizationKey] = audioNormalization;
      return map;
    }
    return {_kNormalizationKey: audioNormalization};
  }

  String? _alimiter;

  /// 当前 libmpv 是否编入了 alimiter：null = 未知（按可用处理），
  /// false = 已确认缺失，全进程回退 mpv 原生 volume。
  ///
  /// 各平台 libmpv 裁剪不同：Android 有 alimiter 无 volume；实测 iOS 的
  /// melodink 构建其 libavfilter 只有 equalizer/overlay 两个滤镜（#3448 的
  /// 回归）。不按平台硬编码，运行时三层探测，任何缺失 alimiter 的构建都
  /// 会回退（响度优先、接受削波，与 #3448 之前行为一致）：
  ///
  /// 1. FFI 直查 libavfilter 滤镜注册表，同步零副作用；
  /// 2. 符号未导出时起临时播放器（`ao=null` 无声输出，不触碰系统音频
  ///    会话）播放生成的静音，逼音频滤镜链立即初始化，从 mpv error 日志
  ///    里找失败证据；
  /// 3. 真实播放期的 error 日志兜底，探测误判时自愈。
  ///
  /// 第 2 层是功能性验证（真的让 mpv 初始化一次滤镜链），而非对二进制
  /// 的结构推断——误判方向（误报可用）可被第 3 层纠正，失败模式收敛。
  ///
  /// 音量偏好 >100% 时会在启动阶段预取（见 [prefetchBoostSupport]）。
  static bool? _boostSupported;
  static bool _probeStarted = false;
  static final Set<AudioNormalizationMixin> _boostWatchers = {};

  StreamSubscription<PlayerLog>? _boostLogSub;
  Player? _boostLogPlayer;
  double _cappedVolume = 1.0;

  /// mpv 的 volume 属性是三次方曲线（`gain = (volume / 100) ^ 3`），且这层
  /// 增益直接乘在 PCM 样值上：200% 就是 8 倍（+18dB），300% 是 27 倍
  /// （+28.6dB）。B 站音频峰值本就接近满刻度，放大后越过 0dBFS 被硬削波，
  /// 听感就是粗糙、发闷、带毛刺。
  ///
  /// 这里让 mpv 的 volume 恒 <= 100，把 >100% 的增益挪进 af 滤镜链，用
  /// alimiter 自身的 level_in 放大、再限幅在 0dBFS 以内。增益按 mpv 原来的
  /// 三次方曲线换算，听感响度与旧版一致，只是不再破音。
  ///
  /// 只用 alimiter 是因为 Android 版 media_kit 自带的 libmpv 只编进了
  /// alimiter / aresample / equalizer / dynaudnorm / loudnorm 几个音频滤镜，
  /// 没有 libavfilter 的 volume 滤镜，用它会导致整条音频链初始化失败（静音）。
  ///
  /// 若该平台的 libmpv 连 alimiter 也没有（af 增益不生效，volume 还被钉在
  /// 100），则回退 mpv 原生 volume——响度优先，接受削波，行为与 #3448 之前
  /// 一致，至少不会静默丢失增益。
  ///
  /// mpv 的 af 链作用在 lavfi-complex（音频归一化）之后、实际输出之前
  /// （见 mpv 手册 --lavfi-complex 一节），两层互不冲突。
  ///
  /// [volume] 为线性倍数，1.0 即 100%
  Future<void>? setVolumeCapped(Player? player, double volume) {
    assert(volume >= 0);
    if (player == null) return null;
    _cappedVolume = volume;
    if (_boostAf(volume) case final boost?) {
      if (_boostSupported == null) {
        _boostSupported = _hasAlimiterByFfi();
        if (_boostSupported == null) {
          _probeAlimiter();
        }
      }
      if (_boostSupported == false) {
        // 该 libmpv 没有 alimiter：af 增益不生效，volume 还被钉在 100，
        // 回到 #3448 之前的原生增益（接受削波，至少响度正确）
        _clearBoostAf(player);
        return player.setVolume(volume * 100);
      }
      // 只要走了 boost 路径就登记（Set 幂等）：即使探测判了可用，L3 出现
      // 矛盾证据时 sweep 也要能清理现场
      _boostWatchers.add(this);
      _watchBoostFailure(player);
      // 拖动音量时增益连续变化，重建滤镜链开销偏大，
      // 增益按 0.5dB 取整，值未变化时跳过
      if (_alimiter != boost) {
        player.setProperty('af', boost);
        _alimiter = boost;
      }
      return player.setVolume(100);
    }
    _clearBoostAf(player);
    return player.setVolume(volume * 100);
  }

  void _clearBoostAf(Player player) {
    if (_alimiter != null) {
      player.setProperty('af', '');
      _alimiter = null;
    }
  }

  /// 启动预取（音量偏好 >100% 时由 main 调用）：FFI 查不到的平台
  /// （Windows）提前在后台跑静音探测，用户点开视频前结果大概率已
  /// 就绪，首次播放无需等待探测。
  static void prefetchBoostSupport() {
    if (_boostSupported != null) return;
    _boostSupported = _hasAlimiterByFfi();
    if (_boostSupported == null) {
      _probeAlimiter();
    }
  }

  /// 直查 libavfilter 的滤镜注册表：`avfilter_get_by_name("alimiter")`
  /// 返回非空即滤镜已编入。
  ///
  /// 符号位置因打包方式而异：Android/Linux 的 ffmpeg 静态链在 libmpv
  /// 里且导出符号（Android 实测 `nm -D` 可见）；melodink/darwin 构建把
  /// ffmpeg 拆成独立的 `Avfilter.framework`（iOS 实测导出该符号）；
  /// Windows 的 libmpv-2.dll 裁剪了 ffmpeg 符号（实测仅导出 mpv API），
  /// 全部查不到时返回 null，交给静音探测。
  static bool? _hasAlimiterByFfi() {
    // NativeLibrary.path 在 MediaKit 未初始化时会 throw，包进 try 兑现
    // 「查不到返回 null」的契约
    try {
      for (final name in [
        NativeLibrary.path,
        'Avfilter.framework/Avfilter',
      ]) {
        try {
          final avfilterGetByName =
              ffi.DynamicLibrary.open(
                name,
              ).lookupFunction<
                ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8>),
                ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8>)
              >('avfilter_get_by_name');
          final filter = 'alimiter'.toNativeUtf8();
          try {
            return avfilterGetByName(filter) != ffi.nullptr;
          } finally {
            malloc.free(filter);
          }
        } catch (_) {}
      }
    } catch (_) {}
    return null;
  }

  /// 静音探测（失败自动重试，同时至多一路在跑）：临时播放器 `ao=null`
  /// 播放生成的极短静音
  /// WAV（untimed 下瞬时完成），音频滤镜链在首帧即初始化——缺 alimiter 的话 lavfi 的 error 日志
  /// 当场出现，不用等真实视频出声。探测与真实播放并行，谁先出结果用谁。
  static Future<void> _probeAlimiter() {
    if (_probeStarted) return Future.value();
    _probeStarted = true;
    return () async {
      Player? probe;
      StreamSubscription<PlayerLog>? logSub;
      StreamSubscription<bool>? completedSub;
      final done = Completer<void>();
      void finish() {
        if (!done.isCompleted) done.complete();
      }

      final timeout = Timer(const Duration(seconds: 2), finish);
      try {
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/pili_alimiter_probe.wav',
        );
        if (!file.existsSync()) {
          await file.writeAsBytes(_silenceWav, flush: true);
        }
        probe = await Player.create(
          configuration: const PlayerConfiguration(
            // 滤镜初始化失败走 error 级日志，至少要收 error 级
            logLevel: .error,
            // untimed：不按实时节流，静音文件瞬时播完
            options: {'ao': 'null', 'untimed': 'yes'},
          ),
        );
        logSub = probe.stream.log.listen(
          (log) {
            if (_isAlimiterFailure(log)) _markBoostUnsupported();
          },
        );
        // completed 流在加载开始/stop/seek 也会发 false，只有 EOF 是 true；
        // 滤镜初始化失败的 error 日志因果上先于 EOF，只在 EOF 收尾
        completedSub = probe.stream.completed.listen(
          (completed) {
            if (completed) finish();
          },
        );
        probe.setProperty(
          'af',
          'lavfi=[alimiter=level_in=1.0:limit=1:level=0]',
        );
        // open 若挂起，靠 2s 超时完成的 done 兜住，探测不会卡死
        await Future.any([probe.open(Media(file.path)), done.future]);
        await done.future;
        // 静音播完且无失败日志，视为可用；万一探测本身没跑起来导致误判，
        // 播放期的日志兜底仍会把状态翻回来
        _boostSupported ??= true;
        _boostWatchers.clear();
      } catch (_) {
        // 探测跑不起来不影响主流程；重置标记，下次需要 boost 时重试
        _probeStarted = false;
      } finally {
        timeout.cancel();
        await logSub?.cancel();
        await completedSub?.cancel();
        probe?.dispose();
      }
    }();
  }

  /// 确认滤镜缺失：全进程记下，并让所有正挂着失效 af 的实例按最近一次
  /// 音量恢复原生增益（`_cappedVolume` 镜像最近请求，重放是幂等的）。
  static void _markBoostUnsupported() {
    if (_boostSupported == false) return;
    _boostSupported = false;
    final watchers = _boostWatchers.toList();
    _boostWatchers.clear();
    for (final watcher in watchers) {
      watcher._fallbackToNativeVolume();
    }
  }

  void _fallbackToNativeVolume() {
    final player = _boostLogPlayer;
    _boostLogSub?.cancel();
    _boostLogSub = null;
    _boostLogPlayer = null;
    _alimiter = null;
    if (player != null) {
      try {
        player
          ..setProperty('af', '')
          ..setVolume(_cappedVolume * 100);
      } catch (_) {}
    }
  }

  /// 播放期兑底：滤镜缺失时 lavfi 初始化失败的 error 日志会带上
  /// 'alimiter' 字样（只有我们自己的 af 串会产生这个词）。即使静音探测
  /// 已判为可用，真实播放中若出现矛盾证据也会翻回并回退。
  void _watchBoostFailure(Player player) {
    if (_boostLogPlayer == player) return;
    _boostLogSub?.cancel();
    _boostLogPlayer = player;
    _boostLogSub = player.stream.log.listen(
      (log) {
        if (_isAlimiterFailure(log)) {
          _markBoostUnsupported();
        }
      },
      // 播放器 dispose 后日志流关闭，清掉本地状态
      onDone: () {
        _boostLogSub = null;
        _boostLogPlayer = null;
        _alimiter = null;
        _boostWatchers.remove(this);
      },
    );
  }

  static bool _isAlimiterFailure(PlayerLog log) =>
      (log.level == 'error' || log.level == 'fatal') &&
      log.text.contains('alimiter');

  /// 0.05s @ 8kHz 单声道 16bit 全零 PCM：音频链在首帧解码时即完成初始
  /// 化，无需播完整个文件，配合 untimed 探测几十毫秒内结束
  static final List<int> _silenceWav = _buildSilenceWav(8000 ~/ 20);

  static List<int> _buildSilenceWav(int samples, {int sampleRate = 8000}) {
    final dataLength = samples * 2;
    final view = Uint8List(44 + dataLength);

    void ascii(int offset, String value) {
      view.setAll(offset, value.codeUnits);
    }

    ascii(0, 'RIFF');
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    ascii(36, 'data');

    ByteData.view(view.buffer)
      ..setUint32(4, 36 + dataLength, Endian.little) // RIFF 块总长
      ..setUint32(16, 16, Endian.little) // fmt 块长度
      ..setUint16(20, 1, Endian.little) // PCM
      ..setUint16(22, 1, Endian.little) // 单声道
      ..setUint32(24, sampleRate, Endian.little)
      ..setUint32(28, sampleRate * 2, Endian.little) // 字节率
      ..setUint16(32, 2, Endian.little) // 块对齐
      ..setUint16(34, 16, Endian.little) // 位深
      ..setUint32(40, dataLength, Endian.little);
    // 采样数据保持全零
    return view;
  }

  /// [volume] > 1.0 时返回防削波的增益滤镜串，否则返回 null。
  ///
  /// level=0 关闭 alimiter 的自动电平（不做归一化），limit=1 即 0dBFS。
  static String? _boostAf(double volume) {
    if (volume <= 1.0) return null;
    // mpv 的音量是三次方曲线：gain = v^3
    final db = (60 * math.log(volume) / math.ln10 * 2).round() / 2;
    final gain = math.pow(10, db / 20).toDouble();
    return 'alimiter=level_in=${gain.toStringAsFixed(3)}:limit=1:level=0';
  }
}
