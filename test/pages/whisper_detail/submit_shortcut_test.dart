import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/text_field.dart';
import 'package:flutter/material.dart' hide EditableText, TextField;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ctrl+Enter submits a multiline rich-text message', (
    tester,
  ) async {
    final controller = RichTextEditingController(
      items: [RichTextItem.fromStart('message')],
    );
    addTearDown(controller.dispose);
    var submitCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RichTextField(
            controller: controller,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            onSubmitted: (_) => submitCount += 1,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(RichTextField));
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.newline);
    expect(submitCount, 0);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.testTextInput.receiveAction(TextInputAction.newline);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    expect(submitCount, 1);
  });
}
