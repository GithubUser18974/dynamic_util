import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveTextField', () {
    testWidgets('uses spacious padding on mobile', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveTextField(),
          ),
        ),
      );

      final TextField textField = tester.widget(find.byType(TextField));
      final InputDecoration decoration = textField.decoration!;

      expect(decoration.isDense, isFalse);
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      );
    });

    testWidgets('uses dense padding on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveTextField(),
          ),
        ),
      );

      final TextField textField = tester.widget(find.byType(TextField));
      final InputDecoration decoration = textField.decoration!;

      expect(decoration.isDense, isTrue);
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      );
    });

    testWidgets('creates TextFormField when using .form constructor',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveTextField.form(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
