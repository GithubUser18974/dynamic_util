import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveKeyboardAvoider', () {
    testWidgets('applies bottom padding equal to viewInsets on mobile',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              viewInsets: EdgeInsets.only(bottom: 250.0), // Simulate keyboard
            ),
            child: AdaptiveKeyboardAvoider(
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsWidgets);

      // Find the specific Padding added by AdaptiveKeyboardAvoider
      final Iterable<Padding> paddings =
          tester.widgetList<Padding>(paddingFinder);
      final hasKeyboardPadding = paddings
          .any((p) => p.padding == const EdgeInsets.only(bottom: 250.0));

      expect(hasKeyboardPadding, isTrue);
    });

    testWidgets('bypasses padding on desktop despite viewInsets',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(1200, 800),
              viewInsets: EdgeInsets.only(bottom: 250.0), // Simulate keyboard
            ),
            child: AdaptiveKeyboardAvoider(
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      // We should NOT find any padding of 250.0 bottom
      final paddingFinder = find.byType(Padding);
      if (paddingFinder.evaluate().isNotEmpty) {
        final Iterable<Padding> paddings =
            tester.widgetList<Padding>(paddingFinder);
        final hasKeyboardPadding = paddings
            .any((p) => p.padding == const EdgeInsets.only(bottom: 250.0));
        expect(hasKeyboardPadding, isFalse);
      } else {
        expect(paddingFinder, findsNothing);
      }
    });
  });
}
