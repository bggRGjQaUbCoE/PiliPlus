import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/common/widgets/scale_app.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// This isolate has no accounts, storage, network requests or media player.
/// UIKit supplies a proxy texture and the phone supplies filtered overlay data.
void runExternalDisplay() {
  ScaledWidgetsFlutterBinding.ensureInitialized();
  runApp(const ExternalDisplayApp());
}

class ExternalDisplayApp extends StatefulWidget {
  const ExternalDisplayApp({super.key});

  @override
  State<ExternalDisplayApp> createState() => _ExternalDisplayAppState();
}

class _ExternalDisplayAppState extends State<ExternalDisplayApp> {
  static const _channel = MethodChannel(
    'com.example.piliplus/external-renderer',
  );
  Map<String, dynamic> _state = {};
  Map<String, dynamic> _options = {};
  DanmakuController<void>? _danmaku;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (!mounted) return;
      switch (call.method) {
        case 'update':
          _update(Map<String, dynamic>.from(call.arguments as Map));
        case 'danmaku':
          if (_state['danmaku'] != true || _state['playing'] != true) return;
          for (final value in call.arguments as List) {
            final item = externalDanmakuItem(
              Map<String, dynamic>.from(value as Map),
            );
            if (item != null) _danmaku?.addDanmaku(item);
          }
        case 'clearDanmaku':
          _danmaku?.clear();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_channel.invokeMethod<void>('ready'));
    });
  }

  void _update(Map<String, dynamic> state) {
    if (WidgetsBinding.instance is ScaledWidgetsFlutterBinding) {
      ScaledWidgetsFlutterBinding.instance.externalDisplayHeight =
          (state['referenceHeight'] as num?)?.toDouble();
    }
    final options = Map<String, dynamic>.from(
      state['danmakuOptions'] as Map? ?? {},
    );
    if (!mapEquals(_options, options)) {
      _options = options;
      _danmaku?.updateOption(externalDanmakuOptions(options));
    }
    if (state['danmaku'] != true || state['textureId'] != _state['textureId']) {
      _danmaku?.clear();
    }
    _state = state;
    _syncPlayback();
    setState(() {});
  }

  void _syncPlayback() {
    if (_state['playing'] == true) {
      _danmaku?.resume();
    } else {
      _danmaku?.pause();
    }
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    _danmaku = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Material(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textureId = (_state['textureId'] as num?)?.toInt() ?? -1;
          final width = (_state['width'] as num?)?.toDouble() ?? 16;
          final height = (_state['height'] as num?)?.toDouble() ?? 9;
          final fitIndex =
              (_state['fit'] as num?)?.toInt() ?? BoxFit.contain.index;
          final fit =
              BoxFit.values[fitIndex.clamp(0, BoxFit.values.length - 1)];
          final size = constraints.biggest;
          // The canvas uses phone-sized logical coordinates on a full-resolution
          // TV surface. Danmaku caches text as bitmaps using MediaQuery's ratio;
          // keep that ratio consistent with the scaled render target.
          final physicalHeight = View.of(context).physicalSize.height;
          final pixelRatio = physicalHeight > 0 && size.height > 0
              ? physicalHeight / size.height
              : MediaQuery.devicePixelRatioOf(context);
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(size: size, devicePixelRatio: pixelRatio),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (textureId >= 0)
                  FittedBox(
                    fit: fit,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: width > 0 ? width : 16,
                      height: height > 0 ? height : 9,
                      child: Transform.flip(
                        flipX: _state['flipX'] == true,
                        flipY: _state['flipY'] == true,
                        child: Texture(textureId: textureId),
                      ),
                    ),
                  ),
                Positioned.fill(
                  top: 4,
                  child: Opacity(
                    opacity: _state['danmaku'] == true
                        ? ((_state['danmakuOpacity'] as num?)?.toDouble() ?? 1)
                              .clamp(0, 1)
                        : 0,
                    child: DanmakuScreen<void>(
                      createdController: (controller) {
                        _danmaku = controller;
                        _syncPlayback();
                      },
                      option: externalDanmakuOptions(_options),
                      size: size,
                    ),
                  ),
                ),
                ExternalDisplaySubtitle(
                  text: _state['subtitleText'] as String? ?? '',
                  style: Map<String, dynamic>.from(
                    _state['subtitleStyle'] as Map? ?? {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

DanmakuOption externalDanmakuOptions(Map<String, dynamic> value) =>
    DanmakuOption(
      fontSize: (value['fontSize'] as num?)?.toDouble() ?? 15,
      fontWeight: (value['fontWeight'] as num?)?.toInt() ?? 4,
      area: (value['area'] as num?)?.toDouble() ?? 1,
      duration: (value['duration'] as num?)?.toDouble() ?? 10,
      staticDuration: (value['staticDuration'] as num?)?.toDouble() ?? 5,
      hideBottom: value['hideBottom'] == true,
      hideScroll: value['hideScroll'] == true,
      hideTop: value['hideTop'] == true,
      hideSpecial: value['hideSpecial'] == true,
      strokeWidth: (value['strokeWidth'] as num?)?.toDouble() ?? 1.5,
      scrollFixedVelocity: value['fixedVelocity'] == true,
      massiveMode: value['massiveMode'] == true,
      static2Scroll: value['static2Scroll'] == true,
      safeArea: true,
      lineHeight: (value['lineHeight'] as num?)?.toDouble() ?? 1.6,
    );

/// The same types and parser used by the phone canvas preserve colored,
/// stationary, scrolling and special danmaku without converting them to subtitles.
DanmakuContentItem<void>? externalDanmakuItem(Map<String, dynamic> value) {
  final text = value['text'] as String? ?? '';
  final color = Color((value['color'] as num?)?.toInt() ?? 0xffffffff);
  final mode = (value['mode'] as num?)?.toInt() ?? 1;
  if (mode == 7) {
    try {
      return SpecialDanmakuContentItem<void>.fromList(
        color,
        (value['fontSize'] as num?)?.toDouble() ?? 25,
        jsonDecode(text.replaceAll('\n', '\\n')) as List,
      );
    } catch (_) {
      return null;
    }
  }
  return DanmakuContentItem<void>(
    text,
    color: color,
    type: switch (mode) {
      4 => DanmakuItemType.bottom,
      5 => DanmakuItemType.top,
      _ => DanmakuItemType.scroll,
    },
    isColorful: value['colorful'] == true,
    selfSend: value['selfSend'] == true,
    count: (value['count'] as num?)?.toInt(),
  );
}

class ExternalDisplaySubtitle extends StatelessWidget {
  const ExternalDisplaySubtitle({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final Map<String, dynamic> style;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final opacity = (style['backgroundOpacity'] as num?)?.toDouble() ?? 0;
    final fontWeight = ((style['fontWeight'] as num?)?.toInt() ?? 4).clamp(
      0,
      8,
    );
    final textStyle = TextStyle(
      height: 1.5,
      fontSize: (style['fontSize'] as num?)?.toDouble() ?? 16,
      letterSpacing: 0.1,
      wordSpacing: 0.1,
      color: Colors.white,
      fontWeight: FontWeight.values[fontWeight],
      backgroundColor: opacity > 0
          ? Colors.black.withValues(alpha: opacity.clamp(0, 1))
          : null,
    );
    Widget line(TextStyle style) => Text(
      text,
      style: style,
      textAlign: TextAlign.center,
      textScaler: TextScaler.noScaling,
    );
    final horizontal = (style['horizontalPadding'] as num?)?.toDouble() ?? 16;
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        bottom: (style['bottomPadding'] as num?)?.toDouble() ?? 24,
      ),
      child: opacity > 0
          ? line(textStyle)
          : Stack(
              children: [
                line(
                  textStyle.copyWith(
                    color: null,
                    foreground: Paint()
                      ..color = Colors.black
                      ..style = PaintingStyle.stroke
                      ..strokeWidth =
                          (style['strokeWidth'] as num?)?.toDouble() ?? 1.5,
                  ),
                ),
                line(textStyle),
              ],
            ),
    );
  }
}
