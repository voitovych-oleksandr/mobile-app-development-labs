import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_colors.dart';
import 'package:mobile_labs/core/app_spacing.dart';

class OutputCard extends StatefulWidget {
  const OutputCard({
    required this.name,
    required this.icon,
    required this.subtitle,
    this.initiallyOn = false,
    super.key,
  });

  final String name;
  final IconData icon;
  final String subtitle;
  final bool initiallyOn;

  @override
  State<OutputCard> createState() => _OutputCardState();
}

class _OutputCardState extends State<OutputCard> {
  late bool _isOn = widget.initiallyOn;

  @override
  Widget build(BuildContext context) {
    final Color accent = _isOn ? AppColors.primary : AppColors.textSecondary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Icon(widget.icon, color: accent, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Switch(
              value: _isOn,
              onChanged: (bool value) => setState(() => _isOn = value),
            ),
          ],
        ),
      ),
    );
  }
}
