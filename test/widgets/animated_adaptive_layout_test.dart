import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AnimatedAdaptiveLayout', () {
    testWidgets('transitions smoothly between widgets', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: const AnimatedAdaptiveLayout(
            duration: Duration(milliseconds: 200),
            mobile: Text('Mobile', key: ValueKey('mobile')),
            tablet: Text('Tablet', key: ValueKey('tablet')),
            breakpoints: BreakpointConfig(smallMax: 400, largeMin: 800),
          ),
        ),
      );

      // Initial state: Mobile (screen width is 800 by default in tests?)
      // Wait, let's check what the default screen width is in tests.
      // Usually, it's 800x600.

      // 800 is Tablet (largeMin is 800).
      expect(find.text('Tablet'), findsOneWidget);

      // Change width to 300 (Mobile)
      tester.view.physicalSize = const Size(300, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pump(); // Starts the animation

      // During animation, both (or cross-fade) might be visible
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100)); // Halfway
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200)); // Completed
      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
    });
  });
}
