import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_colors.dart';
import 'package:mobile_labs/core/app_spacing.dart';

class EnergyFlowCard extends StatelessWidget {
  const EnergyFlowCard({
    required this.inputWatts,
    required this.outputWatts,
    required this.consumptionWatts,
    super.key,
  });

  final int inputWatts;
  final int outputWatts;
  final int consumptionWatts;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _FlowItem(
                icon: Icons.download,
                label: 'Вхід',
                watts: inputWatts,
              ),
            ),
            Expanded(
              child: _FlowItem(
                icon: Icons.upload,
                label: 'Вихід',
                watts: outputWatts,
              ),
            ),
            Expanded(
              child: _FlowItem(
                icon: Icons.home,
                label: 'Споживання',
                watts: consumptionWatts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowItem extends StatelessWidget {
  const _FlowItem({
    required this.icon,
    required this.label,
    required this.watts,
  });

  final IconData icon;
  final String label;
  final int watts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        Text(
          '$watts Вт',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
