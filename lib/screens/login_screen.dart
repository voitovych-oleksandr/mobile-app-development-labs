import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/widgets/app_text_field.dart';
import 'package:mobile_labs/widgets/auth_layout.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      children: <Widget>[
        const AppTextField(
          label: 'Email',
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Увійти',
          icon: Icons.login,
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.registration),
          child: const Text('Немає акаунта? Зареєструватися'),
        ),
      ],
    );
  }
}
