import 'package:dynamic_layouts/dynamic_layouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveFormRow', () {
    testWidgets('renders Row on wide screens', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: Size(1000, 800)), // Desktop
              child: AdaptiveFormRow(
                label: Text('My Label'),
                input: TextField(),
              ),
            ),
          ),
        ),
      );

      // Verify that it uses a Row layout (Row exists in the tree)
      expect(find.byType(Row), findsWidgets);

      // Specifically look for the Expanded widgets defining the flex
      final expandedWidgets =
          tester.widgetList<Expanded>(find.byType(Expanded));
      expect(expandedWidgets.length, 2);
      expect(expandedWidgets.elementAt(0).flex, 1); // Label flex
      expect(expandedWidgets.elementAt(1).flex, 2); // Input flex
    });

    testWidgets('renders Column on small screens', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: Size(400, 800)), // Mobile
              child: AdaptiveFormRow(
                label: Text('My Label'),
                input: TextField(),
              ),
            ),
          ),
        ),
      );

      // Should render as a column
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      // Label should be above input
      final column = tester.widget<Column>(columnFinder);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      expect(column.children.length, 3); // label, sizedbox, input
    });
  });
}
