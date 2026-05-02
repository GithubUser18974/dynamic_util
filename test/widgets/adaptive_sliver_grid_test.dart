import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveSliverGrid', () {
    testWidgets('adjusts crossAxisCount based on breakpoints', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AdaptiveScope(
            config: const ScreenConfig(
              designWidth: 375,
              designHeight: 812,
              screenWidth: 400, // Mobile
              screenHeight: 812,
            ),
            child: CustomScrollView(
              slivers: [
                AdaptiveSliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(key: Key('item_$index')),
                    childCount: 10,
                  ),
                  crossAxisCount: const AdaptiveValue<int>(
                    mobile: 1,
                    tablet: 2,
                    desktop: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify grid delegate crossAxisCount is 1
      final SliverGrid grid = tester.widget(find.byType(SliverGrid));
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.crossAxisCount, 1);

      // Change screen width to tablet
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AdaptiveScope(
            config: const ScreenConfig(
              designWidth: 375,
              designHeight: 812,
              screenWidth: 800, // Tablet
              screenHeight: 812,
            ),
            child: CustomScrollView(
              slivers: [
                AdaptiveSliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(key: Key('item_$index')),
                    childCount: 10,
                  ),
                  crossAxisCount: const AdaptiveValue<int>(
                    mobile: 1,
                    tablet: 2,
                    desktop: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final SliverGrid gridTablet = tester.widget(find.byType(SliverGrid));
      final SliverGridDelegateWithFixedCrossAxisCount delegateTablet =
          gridTablet.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegateTablet.crossAxisCount, 2);
    });
  });
}
