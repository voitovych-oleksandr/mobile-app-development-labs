import 'package:material_ui/material_ui.dart';
import 'package:mobile_labs/core/app_routes.dart';
import 'package:mobile_labs/core/app_spacing.dart';
import 'package:mobile_labs/data/mock_station.dart';
import 'package:mobile_labs/data/power_station.dart';
import 'package:mobile_labs/domain/errors/domain_exception.dart';
import 'package:mobile_labs/domain/models/outage_slot.dart';
import 'package:mobile_labs/domain/repositories/outage_repository.dart';
import 'package:mobile_labs/domain/validators/validators.dart';
import 'package:mobile_labs/widgets/app_text_field.dart';
import 'package:mobile_labs/widgets/battery_indicator.dart';
import 'package:mobile_labs/widgets/energy_flow_card.dart';
import 'package:mobile_labs/widgets/outage_schedule_bar.dart';
import 'package:mobile_labs/widgets/output_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.outageRepository, super.key});

  final OutageRepository outageRepository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<OutageSlot> _outages = const <OutageSlot>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<OutageSlot> items = await widget.outageRepository.getAll();
    if (!mounted) return;
    setState(() {
      _outages = items;
      _isLoading = false;
    });
  }

  Future<void> _openForm(OutageSlot? existing) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final OutageSlot? result = await showDialog<OutageSlot>(
      context: context,
      builder: (BuildContext context) => _OutageFormDialog(initial: existing),
    );
    if (result == null) return;

    try {
      if (existing == null) {
        await widget.outageRepository.add(result);
      } else {
        await widget.outageRepository.update(result);
      }
      if (!mounted) return;
      await _load();
    } on DomainException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _delete(OutageSlot slot) async {
    await widget.outageRepository.delete(slot.id);
    if (!mounted) return;
    await _load();
  }

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
                OutageScheduleBar(outages: _outages),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Відключення', style: text.titleMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Додати',
                      onPressed: () => _openForm(null),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_outages.isEmpty)
                  const Text('Записів немає')
                else
                  ..._outages.map<Widget>(
                    (OutageSlot slot) => Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        title: Text(
                          '${slot.startHour}:00 – ${slot.endHour}:00',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Редагувати',
                              onPressed: () => _openForm(slot),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Видалити',
                              onPressed: () => _delete(slot),
                            ),
                          ],
                        ),
                      ),
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

class _OutageFormDialog extends StatefulWidget {
  const _OutageFormDialog({this.initial});

  final OutageSlot? initial;

  @override
  State<_OutageFormDialog> createState() => _OutageFormDialogState();
}

class _OutageFormDialogState extends State<_OutageFormDialog> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text: widget.initial?.startHour.toString() ?? '',
    );
    _endController = TextEditingController(
      text: widget.initial?.endHour.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _save() {
    final int? start = int.tryParse(_startController.text);
    final int? end = int.tryParse(_endController.text);

    if (start == null || end == null) {
      setState(() => _error = 'Введіть години цілими числами');
      return;
    }
    final String? error = OutageValidator.range(start, end);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    Navigator.of(context).pop(
      OutageSlot(
        id:
            widget.initial?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        startHour: start,
        endHour: end,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initial == null ? 'Нове відключення' : 'Редагувати відключення',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppTextField(
            label: 'Початок (година)',
            controller: _startController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Кінець (година)',
            controller: _endController,
            keyboardType: TextInputType.number,
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Зберегти')),
      ],
    );
  }
}
