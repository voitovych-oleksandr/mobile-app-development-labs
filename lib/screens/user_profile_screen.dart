import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_colors.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/data/mock_station.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: <Widget>[
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 40, color: AppColors.surface),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Іван Петренко',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _ProfileTile(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  value: 'ivan@example.com',
                ),
                _ProfileTile(
                  icon: Icons.bolt,
                  label: 'Станція',
                  value: MockStation.station.name,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Вийти',
                  icon: Icons.logout,
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (Route<dynamic> route) => false,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
