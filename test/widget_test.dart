import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/main.dart';
import 'package:mobile_labs/screens/login_screen.dart';

void main() {
  testWidgets('Login screen is shown on start', (WidgetTester tester) async {
    await tester.pumpWidget(const PowerPlanApp());

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
