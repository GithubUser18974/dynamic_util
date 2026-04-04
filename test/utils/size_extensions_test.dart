import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveSize extensions', () {
    setUp(() {
      // We need to ensure ScreenConfig is initialized before each test.
    });

    testWidgets('.w scales by scaleWidth', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 812)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // scaleWidth = 750 / 375 = 2.0
      expect(100.w, 200.0);
      expect(50.w, 100.0);
      expect(16.5.w, 33.0);
    });

    testWidgets('.h scales by scaleHeight', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 1624)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // scaleHeight = 1624 / 812 = 2.0
      expect(100.h, 200.0);
      expect(50.h, 100.0);
    });

    testWidgets('.sp scales by scaleText (min of width/height)',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 812)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // scaleWidth = 2.0, scaleHeight = 1.0, scaleText = min = 1.0
      expect(16.sp, 16.0);
      expect(24.sp, 24.0);
    });

    testWidgets('works with int and double values', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Scale factors = 1.0
      expect(16.w, 16.0);
      expect(16.0.w, 16.0);
      expect(16.h, 16.0);
      expect(16.0.h, 16.0);
      expect(16.sp, 16.0);
      expect(16.0.sp, 16.0);
    });
  });
}
