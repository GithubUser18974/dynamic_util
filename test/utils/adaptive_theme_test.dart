import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  testWidgets('AdaptiveTheme scales typography and icons correctly',
      (tester) async {
    ThemeData? scaledTheme;

    await tester.pumpWidget(
      AdaptiveScope(
        config: const ScreenConfig(
          designWidth: 100, // so if screenWidth is 200, scaleWidth is 2.0
          designHeight: 100, // if screenHeight is 200, scaleHeight is 2.0
          screenWidth: 200,
          screenHeight: 200,
        ), // scaleText = min(2.0, 2.0) = 2.0
        child: Builder(builder: (context) {
          final baseTheme = ThemeData(
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 10.0),
              bodySmall: TextStyle(fontSize: 5.0),
            ),
            iconTheme: const IconThemeData(size: 20.0),
          );

          scaledTheme = AdaptiveTheme.scale(context, base: baseTheme);
          return const SizedBox();
        }),
      ),
    );

    expect(scaledTheme, isNotNull);

    // Check typography scaling (x 2.0)
    expect(scaledTheme!.textTheme.displayLarge?.fontSize, 20.0);
    expect(scaledTheme!.textTheme.bodySmall?.fontSize, 10.0);

    // Check icon theme scaling (x 2.0)
    expect(scaledTheme!.iconTheme.size, 40.0);
  });
}
