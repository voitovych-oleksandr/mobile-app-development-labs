import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_theme.dart';
import 'package:mobile_labs/screens/dashboard_screen.dart';
import 'package:mobile_labs/screens/login_screen.dart';
import 'package:mobile_labs/screens/registration_screen.dart';
import 'package:mobile_labs/screens/user_profile_screen.dart';

void main() {
  runApp(const PowerPlanApp());
}

class PowerPlanApp extends StatelessWidget {
  const PowerPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerPlan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.login,
      routes: <String, WidgetBuilder>{
        AppRoutes.login: (BuildContext context) => const LoginScreen(),
        AppRoutes.registration: (BuildContext context) =>
            const RegistrationScreen(),
        AppRoutes.dashboard: (BuildContext context) => const DashboardScreen(),
        AppRoutes.profile: (BuildContext context) => const UserProfileScreen(),
      },
    );
  }
}
