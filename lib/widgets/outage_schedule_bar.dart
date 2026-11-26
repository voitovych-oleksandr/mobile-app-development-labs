import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_colors.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/data/power_station.dart';

class OutageScheduleBar extends StatelessWidget {
  const OutageScheduleBar({required this.outages, super.key});

  final List<OutageSlot> outages;

  static const List<String> _hourLabels = <String>[
    '00',
    '06',
    '12',
    '18',
    '24',
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Графік відключень', style: text.titleMedium),
            const SizedBox(height: AppSpacing.md),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return _buildBar(constraints.maxWidth);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _hourLabels
                  .map<Widget>(
                    (String hour) => Text(
                      hour,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double width) {
    return SizedBox(
      height: 24,
      width: width,
      child: Stack(
        children: <Widget>[
          const ColoredBox(
            color: AppColors.background,
            child: SizedBox.expand(),
          ),
          for (final OutageSlot slot in outages)
            Positioned(
              left: slot.startHour / 24 * width,
              width: (slot.endHour - slot.startHour) / 24 * width,
              top: 0,
              bottom: 0,
              child: const ColoredBox(color: AppColors.danger),
            ),
        ],
      ),
    );
  }
}
