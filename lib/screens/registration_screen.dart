import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/widgets/app_text_field.dart';
import 'package:mobile_labs/widgets/auth_layout.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      children: <Widget>[
        const AppTextField(
          label: "Ім'я",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          label: 'Підтвердіть пароль',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Створити акаунт',
          icon: Icons.person_add,
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(AppRoutes.dashboard),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Вже є акаунт? Увійти'),
        ),
      ],
    );
  }
}
