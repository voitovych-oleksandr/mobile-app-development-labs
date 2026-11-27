import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:mobile_labs/domain/repositories/auth_repository.dart';
import 'package:mobile_labs/domain/services/network_service.dart';
import 'package:mobile_labs/domain/validators/validators.dart';
import 'package:mobile_labs/widgets/app_text_field.dart';
import 'package:mobile_labs/widgets/auth_layout.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.authRepository,
    required this.networkService,
    super.key,
  });

  final AuthRepository authRepository;
  final NetworkService networkService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    setState(() {
      _emailError = AuthValidator.email(email);
      _passwordError = AuthValidator.password(password);
    });
    if (_emailError != null || _passwordError != null) return;

    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    try {
      final bool online = await widget.networkService.isOnline();
      if (!mounted) return;
      if (!online) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Немає інтернету. Вхід недоступний.')),
        );
        return;
      }

      await widget.authRepository.signIn(email: email, password: password);
      navigator.pushReplacementNamed(AppRoutes.dashboard);
    } on DomainException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      children: <Widget>[
        AppTextField(
          label: 'Email',
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          errorText: _emailError,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          obscureText: true,
          controller: _passwordController,
          errorText: _passwordError,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Увійти',
          icon: Icons.login,
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pushNamed(AppRoutes.registration),
          child: const Text('Немає акаунта? Зареєструватися'),
        ),
      ],
    );
  }
}
