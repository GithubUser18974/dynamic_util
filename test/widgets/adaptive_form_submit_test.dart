import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveFormSubmit', () {
    testWidgets('spans full width on mobile', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveFormSubmit(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(AdaptiveFormSubmit),
        matching: find.byType(SizedBox),
      );

      expect(sizedBoxFinder, findsOneWidget);
      final SizedBox sizedBox = tester.widget(sizedBoxFinder);
      expect(sizedBox.width, double.infinity);
      
      expect(find.byType(Align), findsNothing);
    });

    testWidgets('aligns to end on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveFormSubmit(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      );

      final alignFinder = find.descendant(
        of: find.byType(AdaptiveFormSubmit),
        matching: find.byType(Align),
      );

      expect(alignFinder, findsOneWidget);
      final Align align = tester.widget(alignFinder);
      expect(align.alignment, AlignmentDirectional.centerEnd);

      // Verify no double.infinity SizedBox is used
      final sizedBoxFinder = find.descendant(
        of: find.byType(AdaptiveFormSubmit),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsNothing);
    });
  });
}
