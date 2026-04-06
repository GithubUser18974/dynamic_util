import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveScope Constraints', () {
    testWidgets(
        'maxContentWidth centers and constrains child when screen is wider',
        (tester) async {
      const maxWidth = 600.0;
      const screenWidth = 1000.0;

      tester.view.physicalSize = const Size(screenWidth, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        AdaptiveScope(
          config: const ScreenConfig(
            designWidth: 375,
            designHeight: 812,
            screenWidth: screenWidth,
            screenHeight: 812,
          ),
          maxContentWidth: maxWidth,
          child: Container(
            key: const Key('child'),
            color: const Color(0xFFFF0000),
          ),
        ),
      );

      final RenderBox renderBox =
          tester.renderObject(find.byKey(const Key('child')));

      // Verification
      expect(renderBox.size.width, maxWidth);

      // Ensure it is centered
      final offset = renderBox.localToGlobal(Offset.zero);
      expect(offset.dx, (screenWidth - maxWidth) / 2);
    });

    testWidgets(
        'does not constrain child when screen is narrower than maxContentWidth',
        (tester) async {
      const maxWidth = 1000.0;
      const screenWidth = 800.0;

      tester.view.physicalSize = const Size(screenWidth, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        AdaptiveScope(
          config: const ScreenConfig(
            designWidth: 375,
            designHeight: 812,
            screenWidth: screenWidth,
            screenHeight: 600,
          ),
          maxContentWidth: maxWidth,
          child: Container(
            key: const Key('child'),
            color: const Color(0xFFFF0000),
          ),
        ),
      );

      final RenderBox renderBox =
          tester.renderObject(find.byKey(const Key('child')));
      expect(renderBox.size.width, screenWidth);
    });
  });
}
