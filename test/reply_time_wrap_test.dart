import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 复现条件（真机实测）：
///   回复头部文本列宽度约 257dp，而
///   「2026-09-25 14:05:44 • IP属地：山东」自然宽度约 319dp。
/// 排版策略：放得下就一行；放不下拆成「时间」+「属地原文」两行。
///
/// 回归点：服务端下发的 location 已经是「IP属地：山东」这种整段文本，
/// 不能自己再拼前缀，否则会重复成「IP属地：IP属地：山东」。
void main() {
  const style = TextStyle(fontSize: 11);
  const time = '2026-09-25 14:05:44';
  // 服务端原样下发的属地文本（已含前缀）
  const serverLocation = 'IP属地：山东';
  const full = '$time • $serverLocation';
  const columnWidth = 257.0;

  double natural(String text, {TextStyle s = style}) {
    final p = TextPainter(
      text: TextSpan(text: text, style: s),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final w = p.width;
    p.dispose();
    return w;
  }

  /// 与 reply_item_grpc.dart `_buildHeader` 中自适应时间行等价
  Widget timeRow(double maxWidth) {
    final location = serverLocation.trim();
    final onOneLine = location.isEmpty || natural(full) <= maxWidth;
    if (onOneLine) {
      return Text(
        location.isEmpty ? time : '$time • $location',
        maxLines: 1,
        softWrap: false,
        style: style,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(time, maxLines: 1, softWrap: false, style: style),
        Text(serverLocation, style: style),
      ],
    );
  }

  testWidgets('真实列宽下走两行分支，属地原文完整且不重复前缀', (tester) async {
    expect(natural(full), greaterThan(columnWidth));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: columnWidth,
            child: Builder(builder: (_) => timeRow(columnWidth)),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text(time), findsOneWidget);
    expect(find.text(serverLocation), findsOneWidget);
    expect(find.text(full), findsNothing);
    // 关键回归：不得出现重复前缀
    expect(find.text('IP属地：$serverLocation'), findsNothing);
    expect(
      find.textContaining('IP属地：IP属地'),
      findsNothing,
      reason: '属地文本不能被拼出重复前缀',
    );
    // 属地未被截断
    expect(
      tester.getSize(find.text(serverLocation)).width,
      closeTo(natural(serverLocation), 0.5),
    );
  });

  testWidgets('列宽足够时单行显示，且只有一份属地文本', (tester) async {
    final wide = natural(full) + 20;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: wide,
            child: Builder(builder: (_) => timeRow(wide)),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text(full), findsOneWidget);
    expect(find.textContaining('IP属地：IP属地'), findsNothing);
    expect(tester.getSize(find.text(full)).height, lessThan(20));
  });

  testWidgets('多种宽度下都不溢出、不重复', (tester) async {
    for (final w in <double>[257.0, 300.0, 340.0]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: w,
              child: Builder(builder: (_) => timeRow(w)),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: 'width=$w 不应溢出');
      expect(
        find.textContaining('IP属地：IP属地'),
        findsNothing,
        reason: 'width=$w 不得重复前缀',
      );
    }
  });
}
