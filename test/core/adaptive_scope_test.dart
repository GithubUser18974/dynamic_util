import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  testWidgets('AdaptiveScope provides valid ScreenConfig to children',
      (tester) async {
    ScreenConfig? extracted;

    await tester.pumpWidget(
      AdaptiveScope(
        config: const ScreenConfig(
          designWidth: 100,
          designHeight: 100,
          screenWidth: 200,
          screenHeight: 300,
        ),
        child: Builder(builder: (context) {
          extracted = AdaptiveScope.maybeOf(context);
          return const SizedBox();
        }),
      ),
    );

    expect(extracted, isNotNull);
    expect(extracted!.designWidth, 100);
    expect(extracted!.screenWidth, 200);
    expect(extracted!.scaleWidth, 2.0); // 200 / 100
    expect(extracted!.scaleHeight, 3.0); // 300 / 100
  });

  testWidgets('AdaptiveScope updates when config changes', (tester) async {
    ScreenConfig? extracted;

    Widget buildApp(double screenWidth) {
      return AdaptiveScope(
        config: ScreenConfig(
          designWidth: 100,
          designHeight: 100,
          screenWidth: screenWidth,
          screenHeight: 200,
        ),
        child: Builder(builder: (context) {
          extracted = AdaptiveScope.of(context);
          return const SizedBox();
        }),
      );
    }

    await tester.pumpWidget(buildApp(100));
    expect(extracted!.screenWidth, 100);

    await tester.pumpWidget(buildApp(200));
    expect(extracted!.screenWidth, 200);
  });

  testWidgets('ScreenConfig.watch generates responsive config', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 2.0;
    // Logical size: 400x300

    ScreenConfig? extracted;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(400, 300)),
        child: Builder(builder: (context) {
          return AdaptiveScope(
            config: ScreenConfig.watch(context,
                designWidth: 200, designHeight: 150),
            child: Builder(builder: (innerContext) {
              extracted = AdaptiveScope.of(innerContext);
              return const SizedBox();
            }),
          );
        }),
      ),
    );

    expect(extracted, isNotNull);
    expect(extracted!.screenWidth, 400);
    expect(extracted!.screenHeight, 300);
    expect(extracted!.scaleWidth, 2.0); // 400 / 200
    expect(extracted!.scaleHeight, 2.0); // 300 / 150

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
