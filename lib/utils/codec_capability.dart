import 'dart:io' show Platform;

import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart'
    show FormatItem, VideoItem;
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:media_kit_video/media_kit_video.dart'
    show
        VideoDecoderKind,
        VideoOutputTarget,
        VideoRouteCapabilities,
        VideoSourceSpec,
        VideoSourceSupport,
        VideoSupport;

/// 视频格式能力判定（不支持显示/不支持硬解的格式置灰）。
///
/// 两轮过滤，判定全部复用 media_kit_video 的
/// [VideoRouteCapabilities.query]（App 侧零平台代码）：
/// 1. 显示轮（全平台）：面板 PQ/DV/HLG 能力（Android/Windows/macOS 有
///    适配器；iOS/Linux 无 → 未知，不置灰）。
/// 2. 解码轮（仅 Android，PC 不做解码过滤）：按 RFC 6381
///    codec 串 + 分辨率查硬件解码器，**只在全部硬件解码器都
///    明确声明不支持该分辨率（或无该编码硬件解码器）时置灰**，
///    帧率不参与判定，profile/level 等声明性校验不参与置灰
///    （厂商表保守会误杀可播流）；
///    DV 串（dvh1，B 站为 profile 8.4 HLG 基层）按 HEVC Main10 基层
///    或原生 DV 解码器任一判定。
///
/// 一切查询失败/未知均按"支持"处理（宁可漏灰不可误灰）。
abstract final class CodecCapability {
  /// fork 的 sources 查询单次上限。
  static const _maxSourcesPerQuery = 128;

  /// 规范化的面板 HDR 类型（1=DV, 2=HDR10(PQ), 3=HLG, 4=HDR10+）。
  /// null = 未知（无适配器/查询失败），空集 = 面板明确无 HDR。
  static Set<int>? _displayHdrTypes;
  static Future<void>? _displayTask;

  /// spec.key → 是否可硬解播放；未写入 = 未知（按可播放处理）。
  static final _decodeVerdicts = <String, bool>{};

  /// 预取面板显示能力（幂等；UI 弹窗与自动选流前调用）。
  static Future<void> ensureDisplayCapability() =>
      _displayTask ??= _loadDisplayCapability();

  static Future<void> _loadDisplayCapability() async {
    try {
      final caps = await VideoRouteCapabilities.query(
        target: const VideoOutputTarget.applicationView(),
      );
      // 未 resolved（无适配器/查询失败/显示切换中）= 未知，不置灰
      _displayHdrTypes = caps.display.resolved ? caps.display.hdrTypes : null;
    } on Exception {
      _displayHdrTypes = null;
    }
  }

  /// 解码轮置灰原因外的尺寸容差：厂商声明表按标准 16:9 档位给出，
  /// 2:1 等宽画幅流的宽度会小幅超出声明（实测 2160×1080 vs 声明
  /// 1920×1080，+12.5%），实际解码负载仍在能力内。对 sizeAndRate
  /// 全挂的流，用 1/1.125 缩放后的尺寸再探一次。
  static const _sizeTolerance = 1.125;

  /// 预取解码能力（仅 Android 真实查询；增量缓存，重复调用近零开销）。
  static Future<void> ensureDecodeSupport(Iterable<VideoItem> items) async {
    if (!Platform.isAndroid) return;
    final specs = <String, VideoSourceSpec>{};
    for (final item in items) {
      final spec = _specOf(item);
      if (spec == null || _decodeVerdicts.containsKey(spec.key)) continue;
      specs[spec.key] = spec;
    }
    final retries = <VideoSourceSpec>[];
    await _queryDecodeSupport(specs.values, retries: retries);
    if (retries.isNotEmpty) {
      await _queryDecodeSupport(
        retries.map(_toleranceSpec),
        tolerance: true,
        retries: retries,
      );
    }
  }

  static Future<void> _queryDecodeSupport(
    Iterable<VideoSourceSpec> specs, {
    bool tolerance = false,
    List<VideoSourceSpec>? retries,
  }) async {
    var pending = specs
        .where((s) => !_decodeVerdicts.containsKey(s.key))
        .toList(growable: false);
    while (pending.isNotEmpty) {
      final batch = pending.take(_maxSourcesPerQuery).toList(growable: false);
      pending = pending.skip(_maxSourcesPerQuery).toList(growable: false);
      try {
        final caps = await VideoRouteCapabilities.query(sources: batch);
        for (final support in caps.sources) {
          VideoSourceSpec source = support.source;
          if (tolerance && retries != null) {
            // 容差探测结果记回原始尺寸的 spec key
            VideoSourceSpec? original;
            for (final s in retries) {
              if (_toleranceSpec(s).key == support.source.key) {
                original = s;
                break;
              }
            }
            source = original ?? support.source;
          }
          final decodable = _decodableAtSize(support);
          if (decodable || tolerance || support.decoders.every(
                (d) => d.kind != VideoDecoderKind.hardware,
              )) {
            _decodeVerdicts[source.key] = decodable;
            if (tolerance && decodable) {
              debugPrint(
                'CodecCapability: decode-tolerance-ok ${source.codec}'
                '@${source.width}x${source.height}',
              );
            } else if (!decodable) {
              debugPrint(
                'CodecCapability: decode-gray ${source.codec}'
                '@${source.width}x${source.height}'
                ' (${support.reason})',
              );
            }
          } else {
            // 首轮因 sizeAndRate 全挂：留待容差复探
            retries?.add(source);
          }
        }
      } on Exception {
        // 查询失败：本批不落缓存，全部按未知（不置灰）
      }
    }
  }

  /// 尺寸容差复探用的缩放规格（编码串与帧率不变）。
  static VideoSourceSpec _toleranceSpec(VideoSourceSpec s) => VideoSourceSpec(
    codec: s.codec,
    width: (s.width! / _sizeTolerance).round(),
    height: (s.height! / _sizeTolerance).round(),
    frameRate: s.frameRate,
  );

  /// 解码轮判定：只按分辨率置灰（帧率不参与判定，规格不传 frameRate，
  /// fork 侧按 isSizeSupported 只判尺寸）。
  ///
  /// fork 的 sources 查询还带 profile/level/format 严格校验——那是为
  /// HDR 路由 fail-closed 设计的；低端机厂商声明的档位表常低于实际
  /// 能力，照搬会误灰实际可播的流（实测 Redmi Note 5A 1080P 被误杀）。
  /// 故仅在 census 完整且全部硬件解码器都明确声明不支持该尺寸/帧率
  /// （或该 MIME 完全无硬件解码器，如无 AV1 硬解）时才判不可播。
  static bool _decodableAtSize(VideoSourceSupport support) {
    if (!support.censusComplete) return true; // 查询不完整 → 按未知不灰
    final hardware = support.decoders
        .where((d) => d.kind == VideoDecoderKind.hardware)
        .toList(growable: false);
    if (hardware.isEmpty) return false;
    for (final decoder in hardware) {
      if (decoder.support != VideoSupport.unsupported) return true;
      if (decoder.reason != 'sizeAndRate') return true;
    }
    return false;
  }

  /// 弹窗前置预取（显示轮 + 解码轮；有缓存时近零开销）。
  static Future<void> ensureSelectionSupport(List<VideoItem> videoList) async {
    await ensureDisplayCapability();
    await ensureDecodeSupport(videoList);
  }

  /// 初始化自动配置的首选解码格式顺序（DV > HEVC > AV1 > AVC）。
  static const _preferCodecOrder = [
    VideoDecodeFormatType.DVH1,
    VideoDecodeFormatType.HEVC,
    VideoDecodeFormatType.AV1,
    VideoDecodeFormatType.AVC,
  ];

  /// 族级能力探测的代表性 codec 串，配合 1080p30 基准规格：
  /// 只判定"有无该编码硬件解码器"（与置灰同规则），具体流在选流时
  /// 仍按各自分辨率/帧率逐条过滤。
  static VideoSourceSpec? _probeSpecOf(VideoDecodeFormatType format) {
    const codecs = {
      VideoDecodeFormatType.DVH1: 'dvh1.08.07',
      VideoDecodeFormatType.HEVC: 'hev1.1.6.L120.90',
      VideoDecodeFormatType.AV1: 'av01.0.08M.08',
      VideoDecodeFormatType.AVC: 'avc1.640032',
    };
    try {
      return VideoSourceSpec(
        codec: codecs[format]!,
        width: 1920,
        height: 1080,
        frameRate: 30,
      );
    } on ArgumentError {
      return null;
    }
  }

  /// 应用初始化时按设备能力自动配置首选解码格式（preferCodecs）：
  /// **仅在设置从未写入过时执行一次**，不覆盖用户手动排序。显示轮排除
  /// SDR 面板的 DV（DV 只出现在 HDR 画质档），解码轮（仅 Android）
  /// 排除无硬件解码器的编码族，其余按 DV > HEVC > AV1 > AVC 写入设置。
  /// 查询失败/未知一律按支持保留（宁可漏配）；全部被排除时不写入。
  static Future<void> autoConfigurePreferCodecs() async {
    if (GStorage.setting.get(SettingBoxKey.preferCodecs) != null) {
      return;
    }
    await ensureDisplayCapability();
    final configured = <VideoDecodeFormatType>[];
    for (final format in _preferCodecOrder) {
      if (format == VideoDecodeFormatType.DVH1 &&
          _displayHdrTypes?.isEmpty == true) {
        continue;
      }
      if (!Platform.isAndroid) {
        configured.add(format);
        continue;
      }
      final spec = _probeSpecOf(format);
      if (spec == null) {
        configured.add(format);
        continue;
      }
      await _queryDecodeSupport([spec]);
      if (_decodeVerdicts[spec.key] ?? true) {
        configured.add(format);
      }
    }
    if (configured.isEmpty) return;
    await GStorage.setting.put(
      SettingBoxKey.preferCodecs,
      configured.map((e) => e.name).toList(),
    );
  }

  static VideoSourceSpec? _specOf(VideoItem item) {
    final codecs = item.codecs;
    if (codecs == null || codecs.isEmpty || codecs.length > 128) return null;
    try {
      return VideoSourceSpec(
        codec: codecs,
        width: item.width,
        height: item.height,
        // 帧率不参与置灰判定（Java 适配器 frameRate==null 时按
        // isSizeSupported 只判尺寸）：50fps 片源在声明 4K30 档位的设备上
        // 会被误灰（BV1Gt26BJEBT dvh1.05.09@4K@50，2026-10-24 用户拍板放开）。
        frameRate: null,
      );
    } on ArgumentError {
      return null;
    }
  }

  /// 解码轮：该流在当前设备是否有硬件解码（unknown → true）。
  /// PC（非 Android）不做解码过滤，恒 true。
  static bool playable(VideoItem item) {
    if (!Platform.isAndroid) return true;
    final spec = _specOf(item);
    if (spec == null) return true;
    return _decodeVerdicts[spec.key] ?? true;
  }

  /// 显示轮 + 解码轮合并的流级判定。
  static bool streamPlayable(VideoItem item) =>
      displaySupports(item.quality) && playable(item);

  /// 该画质档位下可播放的流；全部被过滤时回退原列表（置灰不阻断选流）。
  static List<VideoItem> playableVideosOf(List<VideoItem> items) {
    final filtered = items.where(streamPlayable).toList(growable: false);
    return filtered.isEmpty ? items : filtered;
  }

  /// 能力感知的自动选流：预取能力后过滤候选（acceptQuality 收敛到候选集，
  /// 全部被过滤时回退原列表），委托原版 [VideoUtils.findTargetVideo]。
  static Future<(int, FormatItem, VideoDecodeFormatType, VideoItem)>
  findPlayableTargetVideo(
    List<VideoItem> videoList,
    int preferQuality,
    List<int>? acceptQuality,
    List<FormatItem> supportFormats,
    List<VideoDecodeFormatType> preferCodecs,
  ) async {
    await ensureDisplayCapability();
    await ensureDecodeSupport(videoList);
    final candidates = playableVideosOf(videoList);
    // acceptQuality 可能含已被过滤画质（如 SDR 面板的杜比档），收敛到候选集
    List<int>? effectiveAccept;
    if (acceptQuality != null && !identical(candidates, videoList)) {
      final qaSet = candidates.map((e) => e.id).toSet();
      effectiveAccept = acceptQuality
          .where(qaSet.contains)
          .toList(growable: false);
    }
    return VideoUtils.findTargetVideo(
      candidates,
      preferQuality,
      effectiveAccept ?? acceptQuality,
      supportFormats,
      preferCodecs,
    );
  }

  static bool _has(int type) => _displayHdrTypes?.contains(type) ?? false;

  /// 面板支持 PQ/DV/HLG 任意一种 HDR 能力（HDR10+ 属 PQ 族）。
  static bool get _anyHdrDisplay => _has(1) || _has(2) || _has(3) || _has(4);

  /// 显示轮：面板能否显示该画质（unknown → true；SDR 画质恒 true）。
  ///
  /// HDR 画质（125/126/129 等）只要面板支持 PQ/DV/HLG 任意一种即不置灰，
  /// HDR 格式间的转换由解码库内部处理；仅 SDR 面板
  /// （一种 HDR 能力都没有）才置灰全部 HDR 画质。
  static bool displaySupports(VideoQuality quality) {
    if (_displayHdrTypes == null) return true;
    final isHdrQa = quality.code == VideoQuality.hdr.code ||
        quality.code == VideoQuality.dolbyVision.code ||
        quality.code == VideoQuality.hdrVivid.code;
    if (!isHdrQa) return true;
    return _anyHdrDisplay;
  }

  /// 显示轮置灰原因；支持或未知时返回 null。
  static String? displayUnsupportedReason(VideoQuality quality) =>
      displaySupports(quality) ? null : '显示器不支持HDR显示';

  /// 解码轮置灰原因（格式族级）：一个菜单项可能对应同族多条流
  /// （如 hev1/hvc1），全部流都明确无硬解才置灰；无匹配流时返回 null。
  static String? decodeFormatUnsupportedReason(
    VideoDecodeFormatType format,
    Iterable<VideoItem> videoList,
  ) {
    final items = videoList
        .where(
          (e) =>
              e.codecs != null &&
              VideoDecodeFormatType.fromString(e.codecs!) == format,
        )
        .toList(growable: false);
    if (items.isEmpty || items.any(playable)) return null;
    return '设备无${format.description}硬件解码';
  }

  /// 画质项置灰原因（显示轮 + 解码轮）：
  /// 一个画质项对应多条流（多编码格式），全部流都明确无硬解才置灰；
  /// 该画质无任何流信息（如会员画质）时只看显示轮。返回 null = 不置灰。
  static String? qualityUnsupportedReason(
    VideoQuality quality,
    Iterable<VideoItem> videoList,
  ) {
    final displayReason = displayUnsupportedReason(quality);
    if (displayReason != null) return displayReason;
    final items = videoList
        .where((e) => e.quality.code == quality.code)
        .toList(growable: false);
    if (items.isNotEmpty && items.every((e) => !playable(e))) {
      return '设备无该画质硬件解码';
    }
    return null;
  }
}
