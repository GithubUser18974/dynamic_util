import 'package:flutter_test/flutter_test.dart';

import 'package:dynamic_layouts_example/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DemoApp());
    expect(find.text('Overview'), findsWidgets);
  });
}
