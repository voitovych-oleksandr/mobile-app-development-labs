import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_theme.dart';
import 'package:mobile_labs/data/local_auth_repository.dart';
import 'package:mobile_labs/data/local_outage_repository.dart';
import 'package:mobile_labs/domain/repositories/auth_repository.dart';
import 'package:mobile_labs/domain/repositories/outage_repository.dart';
import 'package:mobile_labs/screens/dashboard_screen.dart';
import 'package:mobile_labs/screens/login_screen.dart';
import 'package:mobile_labs/screens/registration_screen.dart';
import 'package:mobile_labs/screens/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    PowerPlanApp(
      authRepository: LocalAuthRepository(prefs),
      outageRepository: LocalOutageRepository(prefs),
    ),
  );
}

class PowerPlanApp extends StatelessWidget {
  const PowerPlanApp({
    required this.authRepository,
    required this.outageRepository,
    super.key,
  });

  final AuthRepository authRepository;
  final OutageRepository outageRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerPlan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.login,
      routes: <String, WidgetBuilder>{
        AppRoutes.login: (BuildContext context) =>
            LoginScreen(authRepository: authRepository),
        AppRoutes.registration: (BuildContext context) =>
            RegistrationScreen(authRepository: authRepository),
        AppRoutes.dashboard: (BuildContext context) =>
            DashboardScreen(outageRepository: outageRepository),
        AppRoutes.profile: (BuildContext context) =>
            UserProfileScreen(authRepository: authRepository),
      },
    );
  }
}
