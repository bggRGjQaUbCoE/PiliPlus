import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/skin.dart';
import 'package:PiliPlus/pages/video/interactive/hotspot_choices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Choice _choice(String option, double x, double y, {int? textAlign}) => Choice(
  option: option,
  x: x,
  y: y,
  textAlign: textAlign,
  id: option.codeUnitAt(0),
);

Finder _targetOf(String text) =>
    find.ancestor(of: find.text(text), matching: find.byType(InkWell));

void main() {
  for (final double width in <double>[640, 360]) {
    testWidgets('real home hotspots remain tappable at width $width', (
      WidgetTester tester,
    ) async {
      final node = EdgeInfoData.fromJson(
        jsonDecode(
          File('test/interactive/fixtures/home_hotspot.json')
              .readAsStringSync(),
        ),
      );
      final choices = node.edges!.questions!.single.choices!;
      final selected = <int?>[];
      final rect = Rect.fromLTWH(12, 80, width, width * 480 / 854);
      await tester.pumpWidget(
        MaterialApp(
          home: InteractiveHotspotChoices(
            choices: choices,
            videoRect: rect,
            sourceSize: const Size(854, 480),
            onSelected: (choice) => selected.add(choice.id),
            fallback: const SizedBox(key: Key('fallback')),
          ),
        ),
      );
      expect(find.byKey(const Key('fallback')), findsNothing);
      final targets = <Rect>[];
      for (final choice in choices) {
        expect(find.text(choice.option!), findsOneWidget);
        final target = _targetOf(choice.option!);
        final bounds = tester.getRect(target);
        expect(bounds.left, greaterThanOrEqualTo(rect.left));
        expect(bounds.top, greaterThanOrEqualTo(rect.top));
        expect(bounds.right, lessThanOrEqualTo(rect.right + 0.01));
        expect(bounds.bottom, lessThanOrEqualTo(rect.bottom + 0.01));
        for (final other in targets) {
          expect(bounds.overlaps(other), isFalse);
        }
        targets.add(bounds);
        await tester.tap(target);
      }
      expect(selected, choices.map((choice) => choice.id).toList());
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hotspot y is measured from the bottom of the video', (
    WidgetTester tester,
  ) async {
    const Rect rect = Rect.fromLTWH(0, 0, 400, 200);
    await tester.pumpWidget(
      MaterialApp(
        home: InteractiveHotspotChoices(
          choices: <Choice>[
            _choice('A 顶部', 20, 100),
            _choice('B 底部', 80, 0),
          ],
          videoRect: rect,
          sourceSize: const Size(100, 100),
          onSelected: (_) {},
          fallback: const SizedBox(key: Key('fallback')),
        ),
      ),
    );
    expect(find.byKey(const Key('fallback')), findsNothing);
    final top = tester.getRect(_targetOf('A 顶部'));
    final bottom = tester.getRect(_targetOf('B 底部'));
    // 接口 y = 100（视频高度）贴着画面上沿，y = 0 贴着画面下沿。
    expect(top.top, lessThanOrEqualTo(rect.top + 0.01));
    expect(bottom.bottom, greaterThanOrEqualTo(rect.bottom - 0.01));
    expect(top.center.dy, lessThan(bottom.center.dy));
  });

  testWidgets('hotspot labels use the server skin without an opaque box', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InteractiveHotspotChoices(
          choices: <Choice>[_choice('A 检查收音机', 50, 50, textAlign: 2)],
          videoRect: const Rect.fromLTWH(0, 0, 400, 200),
          sourceSize: const Size(100, 100),
          skin: Skin(
            titleTextColor: 'ffcc00ff',
            titleShadowColor: '00000080',
          ),
          onSelected: (_) {},
          fallback: const SizedBox(key: Key('fallback')),
        ),
      ),
    );
    final Text text = tester.widget<Text>(find.text('A 检查收音机'));
    expect(text.style!.color, const Color(0xFFFFCC00));
    expect(text.style!.shadows, isNotEmpty);
    expect(text.style!.shadows!.single.color, const Color(0x80000000));
    // 无底板：命中区必须是透明 Material，不能有深色背景遮挡画面。
    final Material material = tester.widget<Material>(
      find.ancestor(
        of: find.text('A 检查收音机'),
        matching: find.byType(Material),
      ),
    );
    expect(material.type, MaterialType.transparency);
    expect(material.color, isNull);
  });

  testWidgets('transparent skin color is ignored instead of hiding labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InteractiveHotspotChoices(
          choices: <Choice>[_choice('A', 50, 50)],
          videoRect: const Rect.fromLTWH(0, 0, 400, 200),
          sourceSize: const Size(100, 100),
          skin: Skin(
            titleTextColor: '00000000',
            titleShadowColor: '00000000',
          ),
          onSelected: (_) {},
          fallback: const SizedBox(key: Key('fallback')),
        ),
      ),
    );
    final Text text = tester.widget<Text>(find.text('A'));
    expect(text.style!.color, Colors.white);
    expect(text.style!.shadows, isNull);
  });

  testWidgets('AARRGGBB shadow hex still yields a visible shadow', (
    WidgetTester tester,
  ) async {
    // 真实数据里 Steins Gate 节点下发 "33000000"，按 RRGGBBAA 解释会是全透明，
    // 应回退为 AARRGGBB（20% 黑），与 "00000033" 的观感一致。
    await tester.pumpWidget(
      MaterialApp(
        home: InteractiveHotspotChoices(
          choices: <Choice>[_choice('A', 50, 50)],
          videoRect: const Rect.fromLTWH(0, 0, 400, 200),
          sourceSize: const Size(100, 100),
          skin: Skin(titleShadowColor: '33000000'),
          onSelected: (_) {},
          fallback: const SizedBox(key: Key('fallback')),
        ),
      ),
    );
    final Text text = tester.widget<Text>(find.text('A'));
    expect(text.style!.shadows!.single.color, const Color(0x33000000));
  });

  for (final coordinates in <List<Offset>>[
    <Offset>[const Offset(50, 50), const Offset(50, 50)],
    <Offset>[const Offset(-1, 20), const Offset(90, 80)],
    <Offset>[const Offset(10, 20), const Offset(101, 80)],
    <Offset>[const Offset(10, 20), const Offset(90, 101)],
  ]) {
    testWidgets(
      'invalid or colliding hotspots use accessible fallback $coordinates',
      (
        WidgetTester tester,
      ) async {
        final selected = <String>[];
        final choices = <Choice>[
          _choice('A', coordinates[0].dx, coordinates[0].dy),
          _choice('B', coordinates[1].dx, coordinates[1].dy),
        ];
        await tester.pumpWidget(
          MaterialApp(
            home: InteractiveHotspotChoices(
              choices: choices,
              videoRect: const Rect.fromLTWH(0, 0, 400, 200),
              sourceSize: const Size(100, 100),
              onSelected: (choice) => selected.add(choice.option!),
              fallback: Column(
                key: const Key('fallback'),
                children: choices
                    .map(
                      (choice) => TextButton(
                        onPressed: () => selected.add(choice.option!),
                        child: Text(choice.option!),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
        expect(find.byKey(const Key('fallback')), findsOneWidget);
        await tester.tap(find.text('A'));
        await tester.tap(find.text('B'));
        expect(selected, <String>['A', 'B']);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('hotspots keep labels and independent tap targets', (
    WidgetTester tester,
  ) async {
    final List<String> selected = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 200,
          child: InteractiveHotspotChoices(
            choices: <Choice>[
              _choice('A 入口', 10, 20),
              _choice('B 走廊', 90, 20),
              _choice('C 楼梯', 10, 80),
              _choice('D 回去睡下', 90, 80),
            ],
            videoRect: const Rect.fromLTWH(0, 0, 400, 200),
            sourceSize: const Size(100, 100),
            onSelected: (Choice choice) => selected.add(choice.option!),
            fallback: const SizedBox(key: Key('fallback')),
          ),
        ),
      ),
    );

    for (final String label in <String>[
      'A 入口',
      'B 走廊',
      'C 楼梯',
      'D 回去睡下',
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    // 逐个点击各自的命中区，顺序与标签顺序一致（互不遮挡）。
    for (final String label in <String>[
      'A 入口',
      'B 走廊',
      'C 楼梯',
      'D 回去睡下',
    ]) {
      await tester.tap(_targetOf(label));
      expect(selected.last, label);
    }
    expect(selected, <String>['A 入口', 'B 走廊', 'C 楼梯', 'D 回去睡下']);
  });

  testWidgets('missing pixel coordinates use the bottom-choice fallback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 400,
          height: 200,
          child: InteractiveHotspotChoices(
            choices: <Choice>[
              _choice('A', 20, 20),
              Choice(option: 'B'),
            ],
            videoRect: const Rect.fromLTWH(0, 0, 400, 200),
            sourceSize: const Size(100, 100),
            onSelected: (_) {},
            fallback: const SizedBox(key: Key('fallback')),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('fallback')), findsOneWidget);
    expect(find.text('A'), findsNothing);
  });
}
