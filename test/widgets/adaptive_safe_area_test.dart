import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveSafeArea', () {
    testWidgets('applies SafeArea on mobile screens', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveSafeArea(
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Verify that SafeArea is in the widget tree
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('bypasses SafeArea on desktop screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdaptiveSafeArea(
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      // Verify that SafeArea is NOT in the widget tree on desktop
      expect(find.byType(SafeArea), findsNothing);
    });
  });
}
