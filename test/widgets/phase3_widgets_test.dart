import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  Widget buildApp(Widget child, {required double screenWidth}) {
    return MaterialApp(
      home: AdaptiveScope(
        config: ScreenConfig(
          designWidth: 375,
          designHeight: 812,
          screenWidth: screenWidth,
          screenHeight: 812,
        ),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('AdaptiveSpacing respects Row/Column parent and scales correctly',
      (tester) async {
    // scaleWidth = 2.0 (750 / 375)
    await tester.pumpWidget(
      buildApp(
        const Row(
          children: [
            AdaptiveSpacing(10), // should be SizedBox(width: 20)
          ],
        ),
        screenWidth: 750,
      ),
    );

    final sizedBoxFinder = find.descendant(
      of: find.byType(AdaptiveSpacing),
      matching: find.byType(SizedBox),
    );
    expect(sizedBoxFinder, findsOneWidget);

    final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
    expect(sizedBox.width, 20.0);
    expect(sizedBox.height, isNull);
  });

  testWidgets('AdaptiveSpacing inside Column uses height', (tester) async {
    // scaleHeight = 1.0 (812 / 812)
    await tester.pumpWidget(
      buildApp(
        const Column(
          children: [
            AdaptiveSpacing(10), // should be SizedBox(height: 10)
          ],
        ),
        screenWidth: 375,
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.descendant(
      of: find.byType(AdaptiveSpacing),
      matching: find.byType(SizedBox),
    ));
    expect(sizedBox.height, 10.0);
    expect(sizedBox.width, isNull);
  });

  testWidgets('AdaptiveWrap switches axes correctly', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const AdaptiveWrap(
          children: [Text('A'), Text('B')],
        ),
        screenWidth: 1025, // Large -> Row
      ),
    );

    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Column), findsNothing);

    await tester.pumpWidget(
      buildApp(
        const AdaptiveWrap(
          children: [Text('A'), Text('B')],
        ),
        screenWidth: 300, // Small -> Column
      ),
    );

    expect(find.byType(Column),
        findsWidgets); // finds Scaffold's internal cols too potentially, but let's check directly:
    final wrapFinder = find.descendant(
        of: find.byType(AdaptiveWrap), matching: find.byType(Column));
    expect(wrapFinder, findsWidgets);
  });

  testWidgets('AdaptiveImage selects correct provider', (tester) async {
    // 1x1 transparent PNG base64
    const p1 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';
    final mobileImg = MemoryImage(
        Uri.parse('data:image/png;base64,$p1').data!.contentAsBytes());
    final desktopImg = MemoryImage(
        Uri.parse('data:image/png;base64,$p1').data!.contentAsBytes());

    final widget = AdaptiveImage(
      mobile: mobileImg,
      desktop: desktopImg,
    );

    await tester.pumpWidget(buildApp(widget, screenWidth: 300)); // Mobile
    final imgMobile = tester.widget<Image>(find.byType(Image));
    expect(imgMobile.image, mobileImg);

    await tester.pumpWidget(buildApp(widget, screenWidth: 1200)); // Desktop
    final imgDesktop = tester.widget<Image>(find.byType(Image));
    expect(imgDesktop.image, desktopImg);
  });
}
