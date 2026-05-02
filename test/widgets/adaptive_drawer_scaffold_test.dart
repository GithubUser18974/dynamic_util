import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_layouts/dynamic_layouts.dart';

void main() {
  group('AdaptiveDrawerScaffold', () {
    testWidgets('shows modal drawer on mobile', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScope(
            config: const ScreenConfig(
              designWidth: 375,
              designHeight: 812,
              screenWidth: 400,
              screenHeight: 800,
            ),
            child: AdaptiveDrawerScaffold(
              appBar: AppBar(title: const Text('Title')),
              drawer: const Drawer(child: Text('DrawerContent')),
              body: const Text('BodyContent'),
            ),
          ),
        ),
      );

      // Verify Row is not used
      expect(find.byType(Row), findsNothing);
      // Verify Scaffold has a drawer
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.drawer, isNotNull);
    });

    testWidgets('shows docked drawer on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScope(
            config: const ScreenConfig(
              designWidth: 375,
              designHeight: 812,
              screenWidth: 1200,
              screenHeight: 800,
            ),
            child: AdaptiveDrawerScaffold(
              appBar: AppBar(title: const Text('Title')),
              drawer: const Drawer(child: Text('DrawerContent')),
              body: const Text('BodyContent'),
            ),
          ),
        ),
      );

      // Verify Row is used for docked drawer
      expect(find.byType(Row), findsOneWidget);
      // Verify Drawer is present in the tree alongside BodyContent
      expect(find.text('DrawerContent'), findsOneWidget);
      expect(find.text('BodyContent'), findsOneWidget);

      // The scaffold itself shouldn't have a drawer property set because it's rendered inline
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.drawer, isNull);
    });
  });
}
