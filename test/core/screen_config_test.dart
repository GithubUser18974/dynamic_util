import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_util/dynamic_util.dart';

void main() {
  group('ScreenConfig', () {
    testWidgets('init sets correct scaling factors for exact design size',
        (tester) async {
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

      final config = ScreenConfig.instance;
      expect(config.screenWidth, 375);
      expect(config.screenHeight, 812);
      expect(config.scaleWidth, 1.0);
      expect(config.scaleHeight, 1.0);
      expect(config.scaleText, 1.0);
    });

    testWidgets('init computes correct factors for larger screen',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 1624)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 375, designHeight: 812);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final config = ScreenConfig.instance;
      expect(config.screenWidth, 750);
      expect(config.screenHeight, 1624);
      expect(config.scaleWidth, 2.0);
      expect(config.scaleHeight, 2.0);
      expect(config.scaleText, 2.0);
    });

    testWidgets('scaleText uses minimum of scaleWidth and scaleHeight',
        (tester) async {
      // Wide screen: width scales more than height
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

      final config = ScreenConfig.instance;
      expect(config.scaleWidth, 2.0);
      expect(config.scaleHeight, 1.0);
      // scaleText should be min(2.0, 1.0) = 1.0
      expect(config.scaleText, 1.0);
    });

    testWidgets('isInitialized returns true after init', (tester) async {
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

      expect(ScreenConfig.isInitialized, isTrue);
    });

    testWidgets('custom design dimensions are stored', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 900)),
          child: Builder(
            builder: (context) {
              ScreenConfig.init(context, designWidth: 400, designHeight: 900);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final config = ScreenConfig.instance;
      expect(config.designWidth, 400);
      expect(config.designHeight, 900);
      expect(config.scaleWidth, 1.0);
      expect(config.scaleHeight, 1.0);
    });
  });
}
