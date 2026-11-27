import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/data/connectivity_network_service.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/data/local_outage_repository.dart';
import 'package:mobile_labs/data/mqtt_telemetry_source.dart';
import 'package:mobile_labs/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes/memory_session_store.dart';

void main() {
  testWidgets('застосунок стартує з екрана входу', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = (await tester.runAsync(
      SharedPreferences.getInstance,
    ))!;

    await tester.pumpWidget(
      PowerPlanApp(
        authRepository: LocalAuthRepository(prefs, MemorySessionStore()),
        outageRepository: LocalOutageRepository(prefs),
        networkService: ConnectivityNetworkService(),
        telemetrySource: MqttTelemetrySource(),
        initialRoute: AppRoutes.login,
      ),
    );

    expect(find.text('Увійти'), findsOneWidget);
  });
}
