import 'package:dynamic_layouts/dynamic_layouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveMasterDetail', () {
    testWidgets('renders split view on large screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(size: Size(1000, 800)), // Desktop
              child: AdaptiveMasterDetail<String>(
                masterBuilder: (context, onSelect) => const Text('MasterPane'),
                detailBuilder: (context, selectedItem, {onBack}) =>
                    Text('Detail: $selectedItem'),
              ),
            ),
          ),
        ),
      );

      // Both panes should be visible immediately
      expect(find.text('MasterPane'), findsOneWidget);
      expect(find.text('Detail: null'), findsOneWidget);
    });

    testWidgets('renders only master view on small screens initially',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)), // Mobile
              child: AdaptiveMasterDetail<String>(
                masterBuilder: (context, onSelect) => const Text('MasterPane'),
                detailBuilder: (context, selectedItem, {onBack}) =>
                    const Text('DetailPane'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('MasterPane'), findsOneWidget);
      expect(find.text('DetailPane'), findsNothing);
    });

    testWidgets('switches to detail view on item select on small screens',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(size: Size(400, 800)), // Mobile
              child: AdaptiveMasterDetail<String>(
                masterBuilder: (context, onSelect) => ElevatedButton(
                  onPressed: () => onSelect('Item 1'),
                  child: const Text('Select Item'),
                ),
                detailBuilder:
                    (context, selectedItem, {VoidCallback? onBack}) => Column(
                  children: [
                    Text('Detail: $selectedItem'),
                    if (onBack != null)
                      ElevatedButton(
                        onPressed: onBack,
                        child: const Text('Back'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select Item'), findsOneWidget);
      expect(find.text('Detail: Item 1'), findsNothing);

      // Tap select
      await tester.tap(find.text('Select Item'));
      await tester.pumpAndSettle();

      // Master should be gone or hidden, Detail is visible
      expect(find.text('Select Item'), findsNothing);
      expect(find.text('Detail: Item 1'), findsOneWidget);

      // Tap back
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(find.text('Select Item'), findsOneWidget);
      expect(find.text('Detail: Item 1'), findsNothing);
    });
  });
}
