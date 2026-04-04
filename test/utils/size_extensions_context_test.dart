import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  testWidgets(
      'AdaptiveSizeContext extensions scale correctly using AdaptiveScope',
      (tester) async {
    double? resolvedW;
    double? resolvedH;
    double? resolvedSp;

    await tester.pumpWidget(
      AdaptiveScope(
        config: const ScreenConfig(
          designWidth: 100,
          designHeight: 100,
          screenWidth: 200, // scaleWidth = 2.0
          screenHeight: 300, // scaleHeight = 3.0
        ), // scaleText = min(2.0, 3.0) = 2.0
        child: Builder(builder: (context) {
          resolvedW = context.w(50);
          resolvedH = context.h(50);
          resolvedSp = context.sp(50);
          return const SizedBox();
        }),
      ),
    );

    expect(resolvedW, 100.0); // 50 * 2.0
    expect(resolvedH, 150.0); // 50 * 3.0
    expect(resolvedSp, 100.0); // 50 * 2.0
  });
}
