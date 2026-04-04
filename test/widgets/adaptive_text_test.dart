import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveText', () {
    Widget buildTestApp({
      required Size size,
      required Widget child,
    }) {
      return MediaQuery(
        data: MediaQueryData(size: size),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return child;
            },
          ),
        ),
      );
    }

    testWidgets('renders provided text', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(375, 812),
        child: const AdaptiveText('Hello World'),
      ));

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('applies base font size at 1:1 scale', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(375, 812),
        child: const AdaptiveText(
          'Test',
          baseFontSize: 20,
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, 20.0);
    });

    testWidgets('scales font size with screen', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(750, 1624), // 2× design size
        child: const AdaptiveText(
          'Test',
          baseFontSize: 16,
          maxScaleFactor: 3.0,
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      // scaleText = 2.0, so fontSize = 16 * 2.0 = 32.0
      expect(textWidget.style?.fontSize, 32.0);
    });

    testWidgets('clamps font size at maxScaleFactor', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(750, 1624), // 2× design size
        child: const AdaptiveText(
          'Test',
          baseFontSize: 16,
          maxScaleFactor: 1.5,
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      // scaleText = 2.0, clamped to 16 * 1.5 = 24.0
      expect(textWidget.style?.fontSize, 24.0);
    });

    testWidgets('merges with provided style', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(375, 812),
        child: const AdaptiveText(
          'Styled',
          baseFontSize: 16,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.style?.fontSize, 16.0);
    });

    testWidgets('respects maxLines and overflow', (tester) async {
      await tester.pumpWidget(buildTestApp(
        size: const Size(375, 812),
        child: const AdaptiveText(
          'Long text that might overflow',
          baseFontSize: 14,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });
  });
}
