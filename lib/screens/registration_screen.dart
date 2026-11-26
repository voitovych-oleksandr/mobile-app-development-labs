import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:mobile_labs/domain/repositories/auth_repository.dart';
import 'package:mobile_labs/domain/validators/validators.dart';
import 'package:mobile_labs/widgets/app_text_field.dart';
import 'package:mobile_labs/widgets/auth_layout.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({required this.authRepository, super.key});

  final AuthRepository authRepository;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  bool _isLoading = false;

  bool get _hasErrors =>
      _nameError != null ||
      _emailError != null ||
      _passwordError != null ||
      _confirmError != null;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirm = _confirmController.text;

    setState(() {
      _nameError = AuthValidator.name(name);
      _emailError = AuthValidator.email(email);
      _passwordError = AuthValidator.password(password);
      _confirmError = AuthValidator.confirmPassword(password, confirm);
    });
    if (_hasErrors) return;

    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    try {
      await widget.authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Акаунт створено. Увійдіть у застосунок.'),
        ),
      );
      navigator.pop();
    } on DomainException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      children: <Widget>[
        AppTextField(
          label: "Ім'я",
          icon: Icons.person_outline,
          controller: _nameController,
          errorText: _nameError,
        ),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Підтвердіть пароль',
          icon: Icons.lock_outline,
          obscureText: true,
          controller: _confirmController,
          errorText: _confirmError,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Створити акаунт',
          icon: Icons.person_add,
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Вже є акаунт? Увійти'),
        ),
      ],
    );
  }
}
