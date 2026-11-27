import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_theme.dart';
import 'package:mobile_labs/data/connectivity_network_service.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/data/local_outage_repository.dart';
import 'package:mobile_labs/data/mqtt_telemetry_source.dart';
import 'package:mobile_labs/data/secure_session_store.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/domain/repositories/auth_repository.dart';
import 'package:mobile_labs/domain/repositories/outage_repository.dart';
import 'package:mobile_labs/domain/services/network_service.dart';
import 'package:mobile_labs/domain/services/telemetry_source.dart';
import 'package:mobile_labs/screens/dashboard_screen.dart';
import 'package:mobile_labs/screens/login_screen.dart';
import 'package:mobile_labs/screens/registration_screen.dart';
import 'package:mobile_labs/screens/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final LocalAuthRepository authRepository = LocalAuthRepository(
    prefs,
    SecureSessionStore(),
  );

  // Сесію відновлюємо без перевірки мережі: офлайн автологін дозволено.
  final User? restored = await authRepository.restoreSession();

  runApp(
    PowerPlanApp(
      authRepository: authRepository,
      outageRepository: LocalOutageRepository(prefs),
      networkService: ConnectivityNetworkService(),
      telemetrySource: MqttTelemetrySource(),
      initialRoute: restored == null ? AppRoutes.login : AppRoutes.dashboard,
    ),
  );
}

class PowerPlanApp extends StatelessWidget {
  const PowerPlanApp({
    required this.authRepository,
    required this.outageRepository,
    required this.networkService,
    required this.telemetrySource,
    required this.initialRoute,
    super.key,
  });

  final AuthRepository authRepository;
  final OutageRepository outageRepository;
  final NetworkService networkService;
  final TelemetrySource telemetrySource;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerPlan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        AppRoutes.login: (BuildContext context) => LoginScreen(
          authRepository: authRepository,
          networkService: networkService,
        ),
        AppRoutes.registration: (BuildContext context) =>
            RegistrationScreen(authRepository: authRepository),
        AppRoutes.dashboard: (BuildContext context) => DashboardScreen(
          outageRepository: outageRepository,
          networkService: networkService,
          telemetrySource: telemetrySource,
        ),
        AppRoutes.profile: (BuildContext context) =>
            UserProfileScreen(authRepository: authRepository),
      },
    );
  }
}
