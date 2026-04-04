import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  testWidgets('AdaptiveGrid adjusts crossAxisCount based on breakpoints', (tester) async {
    Widget buildGrid(double width) {
      return MaterialApp(
        home: AdaptiveScope(
          config: ScreenConfig(
            designWidth: 375,
            designHeight: 812,
            screenWidth: width,
            screenHeight: 812,
          ),
          child: Scaffold(
            body: AdaptiveGrid(
              itemCount: 10,
              crossAxisCount: const AdaptiveValue<int>(
                mobile: 1,
                tablet: 3,
                desktop: 5,
              ),
              itemBuilder: (context, index) => Container(color: Colors.red),
            ),
          ),
        ),
      );
    }

    // 1. Mobile width (falls back to 1 column)
    await tester.pumpWidget(buildGrid(300));
    GridView gridMobile = tester.widget(find.byType(GridView));
    SliverGridDelegateWithFixedCrossAxisCount delegateMobile =
        gridMobile.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegateMobile.crossAxisCount, 1);

    // 2. Tablet width (3 columns)
    await tester.pumpWidget(buildGrid(800));
    GridView gridTablet = tester.widget(find.byType(GridView));
    SliverGridDelegateWithFixedCrossAxisCount delegateTablet =
        gridTablet.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegateTablet.crossAxisCount, 3);

    // 3. Desktop width (5 columns)
    await tester.pumpWidget(buildGrid(1200));
    GridView gridDesktop = tester.widget(find.byType(GridView));
    SliverGridDelegateWithFixedCrossAxisCount delegateDesktop =
        gridDesktop.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegateDesktop.crossAxisCount, 5);
  });
}
