import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_util/dynamic_util.dart';

void main() {
  testWidgets('AdaptiveValue resolves correctly based on breakpoints',
      (tester) async {
    const value = AdaptiveValue<String>(
      mobile: 'Mobile',
      tablet: 'Tablet',
      desktop: 'Desktop',
    );

    String? resolvedValue;

    Widget buildApp(double screenWidth) {
      return AdaptiveScope(
        config: ScreenConfig(
          designWidth: 375,
          designHeight: 812,
          screenWidth: screenWidth,
          screenHeight: 800,
        ),
        child: Builder(builder: (context) {
          resolvedValue = value.resolve(context);
          return const SizedBox();
        }),
      );
    }

    // Default BreakpointConfig: smallMax = 600, largeMin = 1024

    // Inside mobile boundary
    await tester.pumpWidget(buildApp(300));
    expect(resolvedValue, 'Mobile');

    // Exactly mobile boundary (falls into tablet since small is < 600)
    await tester.pumpWidget(buildApp(600));
    expect(resolvedValue, 'Tablet');

    // Inside tablet boundary
    await tester.pumpWidget(buildApp(800));
    expect(resolvedValue, 'Tablet');

    // Inside desktop boundary (large is > 1024)
    await tester.pumpWidget(buildApp(1025));
    expect(resolvedValue, 'Desktop');
  });

  testWidgets('AdaptiveValue falls back appropriately when slots are missing',
      (tester) async {
    const mobileOnly = AdaptiveValue<String>(mobile: 'MobileOnly');

    String? resolvedValue;

    Widget buildApp(double screenWidth) {
      return AdaptiveScope(
        config: ScreenConfig(
          designWidth: 375,
          designHeight: 812,
          screenWidth: screenWidth,
          screenHeight: 800,
        ),
        child: Builder(builder: (context) {
          resolvedValue = mobileOnly.of(context); // using .of() extension
          return const SizedBox();
        }),
      );
    }

    // Even on desktop, it must fall back to mobile
    await tester.pumpWidget(buildApp(1200));
    expect(resolvedValue, 'MobileOnly');
  });
}
