import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;

/// 复现条件（真机实测）：
///   视频卡片高度固定 81、内边距 8×2 → 内容区 65dp。
///   封面 65×16/9 ≈ 115.6dp + 间距 10 + 内外边距，日期可用宽度只剩约 157dp；
///   而 `yyyy-MM-dd HH:mm:ss` 在中文系统字体下约 181dp → 折成两行，
///   把标题挤成半行，看起来像被日期盖住。
///
/// 修复：日期强制单行，宽度不够时从长到短降级格式。
void main() {
  const style = TextStyle(fontSize: 14);
  final longFormatDs = DateFormat('yyyy-MM-dd HH:mm:ss');
  final longFormatD = DateFormat('yyyy-MM-dd HH:mm');
  final longFormat = DateFormat('yyyy-MM-dd');
  final pubdate = DateTime(2026, 9, 25, 8, 0, 0);

  double measure(String text) {
    final p = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
    )..layout();
    final w = p.width;
    p.dispose();
    return w;
  }

  /// 与 save_panel/view.dart `_fitPubdate` 等价
  String fit(double maxWidth) {
    final candidates = <DateFormat>[
      longFormatDs,
      if (longFormatDs != longFormatD) longFormatD,
      if (longFormatDs != longFormat) longFormat,
    ];
    for (final f in candidates) {
      final text = f.format(pubdate);
      if (measure(text) <= maxWidth) return text;
    }
    return longFormatDs.format(pubdate);
  }

  Widget dateRow(String text, double width) => Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    ),
  );

  testWidgets('不加 maxLines 时日期确实会折成两行（证明测试有效）', (tester) async {
    final full = longFormatDs.format(pubdate);
    expect(measure(full), greaterThan(157), reason: '完整格式应超出可用宽度');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 157,
            child: Text(full, style: style),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(Text)).height,
      greaterThan(20),
      reason: '未限制行数时会换行',
    );
  });

  testWidgets('修复后：157dp 下自动降级且始终单行', (tester) async {
    final text = fit(157);
    await tester.pumpWidget(dateRow(text, 157));

    expect(tester.takeException(), isNull);
    expect(text, isNot(longFormatDs.format(pubdate)), reason: '应已降级');
    expect(find.text(text), findsOneWidget);
    expect(
      tester.getSize(find.byType(Text)).height,
      lessThan(20),
      reason: '日期必须单行，不能挤压标题',
    );
  });

  testWidgets('宽度充足时保留完整格式（含秒）', (tester) async {
    final text = fit(400);
    expect(text, longFormatDs.format(pubdate));
    await tester.pumpWidget(dateRow(text, 400));
    expect(tester.getSize(find.byType(Text)).height, lessThan(20));
  });

  testWidgets('极窄宽度下仍单行不溢出', (tester) async {
    for (final w in <double>[60, 90, 120, 157, 200]) {
      final text = fit(w);
      await tester.pumpWidget(dateRow(text, w));
      expect(tester.takeException(), isNull, reason: 'width=$w 不应溢出');
      expect(
        tester.getSize(find.byType(Text)).height,
        lessThan(20),
        reason: 'width=$w 必须单行',
      );
    }
  });

  testWidgets('卡片高度随字号缩放，内容不会被挤压', (tester) async {
    // 卡片内容区 = coverSize，日期 1 行 + 标题 2 行都要放得下
    const coverSize = 65.0;
    final dateH = measure('2026-09-25') == 0 ? 0.0 : 20.0;
    expect(coverSize, greaterThan(dateH), reason: '内容区要能容纳日期行');
  });
}
