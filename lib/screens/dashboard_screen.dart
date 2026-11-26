import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/data/mock_station.dart';
import 'package:mobile_labs/data/power_station.dart';
import 'package:mobile_labs/widgets/battery_indicator.dart';
import 'package:mobile_labs/widgets/energy_flow_card.dart';
import 'package:mobile_labs/widgets/outage_schedule_bar.dart';
import 'package:mobile_labs/widgets/output_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const PowerStation station = MockStation.station;
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerPlan'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BatteryIndicator(percent: station.batteryPercent),
                const SizedBox(height: AppSpacing.md),
                EnergyFlowCard(
                  inputWatts: station.inputWatts,
                  outputWatts: station.outputWatts,
                  consumptionWatts: station.consumptionWatts,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Виходи станції', style: text.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                ...station.outputs.map<Widget>(
                  (OutputPort port) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: OutputCard(
                      name: port.name,
                      subtitle: port.subtitle,
                      icon: port.icon,
                      initiallyOn: port.isOn,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                OutageScheduleBar(outages: station.outages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
