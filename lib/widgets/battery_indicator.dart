import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_colors.dart';
import 'package:mobile_labs/core/app_spacing.dart';

class BatteryIndicator extends StatelessWidget {
  const BatteryIndicator({required this.percent, super.key});

  final int percent;

  Color _colorFor(int value) {
    if (value <= 20) {
      return AppColors.danger;
    }
    if (value <= 50) {
      return AppColors.primary;
    }
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final Color color = _colorFor(percent);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Заряд станції', style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text('$percent%', style: text.displaySmall?.copyWith(color: color)),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: percent / 100,
              color: color,
              backgroundColor: AppColors.background,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}
