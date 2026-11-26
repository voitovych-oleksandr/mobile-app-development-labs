import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/data/local_outage_repository.dart';
import 'package:mobile_labs/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('застосунок стартує з екрана входу', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = (await tester.runAsync(
      SharedPreferences.getInstance,
    ))!;

    await tester.pumpWidget(
      PowerPlanApp(
        authRepository: LocalAuthRepository(prefs),
        outageRepository: LocalOutageRepository(prefs),
      ),
    );

    expect(find.text('Увійти'), findsOneWidget);
  });
}
