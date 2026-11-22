import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/main.dart';

void main() {
  testWidgets('Counter increments from input', (WidgetTester tester) async {
    await tester.pumpWidget(const CounterApp());

    expect(find.text('0'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '5');
    await tester.tap(find.text('Застосувати'));
    await tester.pump();

    expect(find.text('5'), findsOneWidget);
  });
}
